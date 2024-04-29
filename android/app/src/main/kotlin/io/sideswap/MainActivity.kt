package io.sideswap

import android.os.Build
import android.os.Bundle
import android.security.keystore.KeyProperties
import androidx.annotation.NonNull
import androidx.biometric.BiometricManager
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.security.KeyStore
import java.util.concurrent.Executor
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.IvParameterSpec
import kotlin.concurrent.thread
import kotlin.system.exitProcess

class MainActivity : FlutterFragmentActivity() {
    init {
        System.loadLibrary("sideswap_client");
    }

    private external fun bleThread()

    private val ANDROID_KEY_STORE = "AndroidKeyStore";

    private val CHANNEL = "app.sideswap.io/encryption"

    private val ERROR_OTHER = "other";
    private val ERROR_NEGATIVE = "negative";

    private lateinit var executor: Executor

    val SPEC_KEY_TYPE = KeyProperties.KEY_ALGORITHM_AES
    val SPEC_BLOCK_MODE = KeyProperties.BLOCK_MODE_CBC
    val SPEC_PADDING = KeyProperties.ENCRYPTION_PADDING_PKCS7

    val SPEC_CIPHER = "$SPEC_KEY_TYPE/$SPEC_BLOCK_MODE/$SPEC_PADDING"

    override fun onCreate(savedInstanceState: Bundle?) {
        thread(start = true) {
            bleThread()
        }

        // Aligns the Flutter view vertically with the window.
        WindowCompat.setDecorFitsSystemWindows(window, false)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Disable the Android splash screen fade out animation to avoid
            // a flicker before the similar frame is drawn in Flutter.
            splashScreen.setOnExitAnimationListener { splashScreenView -> splashScreenView.remove() }
        }

        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        executor = ContextCompat.getMainExecutor(this)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "canAuthenticate" -> {
                    val value = BiometricManager.from(applicationContext).canAuthenticate() == BiometricManager.BIOMETRIC_SUCCESS;
                    result.success(value)
                }
                "encryptBiometric" -> {
                    val data = call.arguments as ByteArray;
                    processBiometric(Cipher.ENCRYPT_MODE, result, data)
                }
                "decryptBiometric" -> {
                    val data = call.arguments as ByteArray;
                    processBiometric(Cipher.DECRYPT_MODE, result, data)
                }
                "encryptFallback" -> {
                    val data = call.arguments as ByteArray;
                    processFallback(Cipher.ENCRYPT_MODE, result, data)
                }
                "decryptFallback" -> {
                    val data = call.arguments as ByteArray;
                    processFallback(Cipher.DECRYPT_MODE, result, data)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onDestroy() {
        // This will terminate flutter but not the process itself.
        // So when the app is restored old FFI will crash as Flutter port will be closed now.
        // Terminating the process as workaround.
        super.onDestroy()
        exitProcess(0)
    }

    private fun getSecretKey(keyName: String, authenticationRequired: Boolean): SecretKey {
        val keyStore = KeyStore.getInstance(ANDROID_KEY_STORE)

        // Before the keystore can be accessed, it must be loaded.
        keyStore.load(null)

        var key = keyStore.getKey(keyName, null)

        if (key == null) {
            val keyGenParameterSpec = android.security.keystore.KeyGenParameterSpec.Builder(
                    keyName,
                    KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT)
                    .setBlockModes(SPEC_BLOCK_MODE)
                    .setEncryptionPaddings(SPEC_PADDING)
                    .setUserAuthenticationRequired(authenticationRequired);
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N && authenticationRequired) {
                keyGenParameterSpec.setInvalidatedByBiometricEnrollment(false)
            };

            val keyGenerator = KeyGenerator.getInstance(
                    KeyProperties.KEY_ALGORITHM_AES, ANDROID_KEY_STORE)
            keyGenerator.init(keyGenParameterSpec.build())
            key = keyGenerator.generateKey()
        }

        return key as SecretKey
    }

    private fun getSecretKeyMain(): SecretKey {
        return getSecretKey("MAIN_KEY", true);
    }

    private fun getSecretKeyFallback(): SecretKey {
        return getSecretKey("FALLBACK_KEY", false);
    }

    private fun getCipher(): Cipher {
        return Cipher.getInstance(SPEC_CIPHER)
    }

    private fun processBiometric(opmode: Int, chan: MethodChannel.Result, inData: ByteArray) {
        val key = getSecretKeyMain();

        val cipher = getCipher()

        var inDataWithoutIv = inData;
        if (opmode == Cipher.ENCRYPT_MODE) {
            cipher.init(opmode, key)
        } else {
            val iv = inData.take(cipher.blockSize).toByteArray()
            cipher.init(opmode, key, IvParameterSpec(iv))
            inDataWithoutIv = inData.drop(cipher.blockSize).toByteArray()
        }

        val biometricPrompt = BiometricPrompt(this, executor,
                object : BiometricPrompt.AuthenticationCallback() {
                    override fun onAuthenticationError(errorCode: Int,
                                                       errString: CharSequence) {
                        super.onAuthenticationError(errorCode, errString)
                        if (errorCode == BiometricPrompt.ERROR_NEGATIVE_BUTTON) {
                            chan.error(ERROR_NEGATIVE, errString.toString(), null);
                        } else {
                            chan.error(ERROR_OTHER, errString.toString(), null);
                        }
                    }

                    override fun onAuthenticationSucceeded(
                            result: BiometricPrompt.AuthenticationResult) {
                        super.onAuthenticationSucceeded(result)
                        val outData = result.cryptoObject!!.cipher!!.doFinal(
                                inDataWithoutIv)
                        if (opmode == Cipher.ENCRYPT_MODE) {
                            chan.success(cipher.iv.plus(outData))
                        } else {
                            chan.success(outData)
                        }
                    }

                    override fun onAuthenticationFailed() {
                        // Called when wrong fingerprint detected
                        super.onAuthenticationFailed()
                    }
                });

        val promptInfo = BiometricPrompt.PromptInfo.Builder()
                .setTitle("Biometric authentication")
                .setSubtitle("Unlock wallet using your biometric credentials")
                .setNegativeButtonText("Cancel")
                .setConfirmationRequired(true)
                .build()

        biometricPrompt.authenticate(promptInfo, BiometricPrompt.CryptoObject(cipher))
    }

    private fun processFallback(opmode: Int, chan: MethodChannel.Result, inData: ByteArray) {
        val key = getSecretKeyFallback();
        val cipher = getCipher()

        if (opmode == Cipher.ENCRYPT_MODE) {
            cipher.init(Cipher.ENCRYPT_MODE, key)
            val outData = cipher.doFinal(inData)
            chan.success(cipher.iv.plus(outData))
        } else {
            val iv = inData.take(cipher.blockSize).toByteArray()
            val encrypted = inData.drop(cipher.blockSize).toByteArray()
            cipher.init(opmode, key, IvParameterSpec(iv))
            val outData = cipher.doFinal(encrypted)
            chan.success(outData)
        }
    }
}
