plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") apply false
}

val flavor: String by extra

android {
    namespace = "io.sideswap"
    compileSdk = flutter.compileSdkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    kotlin {
        sourceSets {
            main {
                kotlin.srcDirs("src/main/kotlin")
            }
        }
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

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    implementation("androidx.window:window:1.0.0")
    implementation("androidx.window:window-java:1.0.0")

    implementation("androidx.biometric:biometric:1.1.0")
    implementation("androidx.fragment:fragment-ktx:1.6.2")
    implementation("net.java.dev.jna:jna:5.14.0@aar")

    if (getGradle().getStartParameter().getTaskRequests().toString().contains("Full")) {
        "fullImplementation"("com.google.firebase:firebase-messaging:23.4.1")
        "fullImplementation"(platform("com.google.firebase:firebase-bom:32.7.2"))
        "fullImplementation"("com.google.firebase:firebase-analytics-ktx")
    }
}
