plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") apply false
}

val flavor: String by extra

android {
    namespace = "io.sideswap"
    // permission_handler_android 14.0.0 compiles against 37, and Gradle refuses to
    // build a plugin whose compileSdk exceeds the app's. Flutter 3.47 still defaults
    // `flutter.compileSdkVersion` to 36, so pin it here until it catches up.
    // targetSdk deliberately stays on the Flutter default — this is a compile-time
    // bump, not an opt-in to Android 17 runtime behaviour.
    //
    // `compileSdkMinor` is not optional here: API 37 ships only as minor-versioned
    // platforms (android-37.0, android-37.1), so `compileSdk = 37` alone resolves to
    // the hash string `android-37`, which no longer exists, and Gradle fails with
    // "Failed to find target with hash string 'android-37'". Minor 0 is deliberate --
    // android-37.0 is the platform Gradle provisions by itself, so no build machine
    // needs a manual `sdkmanager` step.
    compileSdk = 37
    compileSdkMinor = 0

    // AGP 9 removed the global `android.defaults.buildfeatures.buildconfig` flag
    // (default is now false); opt the app module back in per-module instead.
    buildFeatures {
        buildConfig = true
    }

    // JNA + the prebuilt .so files require extracted (not compressed-in-APK)
    // native libs. AGP 9 forbids android:extractNativeLibs in the manifest;
    // express the same intent here instead.
    packaging {
        jniLibs {
            useLegacyPackaging = true
        }
    }

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    lint {
        disable.add("InvalidPackage")
    }

    defaultConfig {
        applicationId = "io.sideswap"
        multiDexEnabled = true
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        getByName("debug") {
            // A project-owned debug key, so a build from CI and a build from a
            // developer machine sign identically and can replace each other on
            // a device. Without it every runner generates a fresh key and every
            // install needs an uninstall first.
            //
            // These credentials are the Android defaults and are not a secret:
            // a debug key signs nothing that is distributed.
            // See docs/adr/0015-github-actions-builds.md decision 8.
            storeFile = file("debug.keystore")
            storePassword = "android"
            keyAlias = "androiddebugkey"
            keyPassword = "android"
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")

            // Keep disabled android build will crash with "java.lang.UnsatisfiedLinkError: Can't obtain peer field ID for class com.sun.jna.Pointer"
            isMinifyEnabled = false
            isShrinkResources = false
        }
        debug {}
    }

    flavorDimensions += "base"
    productFlavors {
        create("full") {
            dimension = "base"
            flutter.target = "lib/main_mobile.dart"
            extra["flavor"] = "base"
        }
        create("fdroid") {
            dimension = "base"
            flutter.target = "lib/main_fdroid.dart"
            extra["flavor"] = "fdroid"
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation("androidx.window:window:1.0.0")
    implementation("androidx.window:window-java:1.0.0")

    implementation("androidx.biometric:biometric:1.1.0")
    implementation("androidx.fragment:fragment-ktx:1.6.2")
    implementation("net.java.dev.jna:jna:5.17.0@aar")
    implementation("androidx.core:core-splashscreen:1.0.1")

    if (getGradle().getStartParameter().getTaskRequests().toString().contains("Full")) {
        "fullImplementation"("com.google.firebase:firebase-messaging:25.0.0")
        "fullImplementation"(platform("com.google.firebase:firebase-bom:34.1.0"))
        "fullImplementation"("com.google.firebase:firebase-analytics")
    }
}
