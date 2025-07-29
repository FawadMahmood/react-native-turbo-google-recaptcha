package com.turbogooglerecaptcha

import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.annotations.ReactModule
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.recaptcha.Recaptcha;
import com.google.android.recaptcha.RecaptchaAction;
import com.google.android.recaptcha.RecaptchaTasksClient;

@ReactModule(name = TurboGoogleRecaptchaModule.NAME)
class TurboGoogleRecaptchaModule(reactContext: ReactApplicationContext) :
  NativeTurboGoogleRecaptchaSpec(reactContext) {

  private var siteKey: String? = null
  private var recaptchaTasksClient: RecaptchaTasksClient? = null

  override fun getName(): String {
    return NAME
  }

  override fun initRecaptcha(siteKey: String, promise: Promise) {
    this.siteKey = siteKey
    val app = reactApplicationContext.applicationContext as? android.app.Application
      ?: return promise.reject("NoApplicationContext", "Application context is not available")
    val activity = this.reactApplicationContext.currentActivity
    if (activity == null) {
      promise.reject("NoCurrentActivity", "Current activity is not available")
      return
    }
    Recaptcha.getTasksClient(app, siteKey)
      .addOnSuccessListener(activity) { client ->
        this.recaptchaTasksClient = client
        promise.resolve(null)
      }
      .addOnFailureListener { e ->
        promise.reject(e)
      }
  }

  private fun initializeRecaptchaAndGetToken(siteKey: String, activity: android.app.Activity, promise: Promise) {
    val app = reactApplicationContext.applicationContext as? android.app.Application
      ?: return promise.reject("NoApplicationContext", "Application context is not available")
    Recaptcha.getTasksClient(app, siteKey)
      .addOnSuccessListener(activity) { newClient ->
        this.recaptchaTasksClient = newClient
        newClient.executeTask(RecaptchaAction.LOGIN)
          .addOnSuccessListener(activity) { token ->
            promise.resolve(token)
          }
          .addOnFailureListener { e ->
            promise.reject(e)
          }
      }
      .addOnFailureListener { e ->
        promise.reject(e)
      }
  }

  override fun getToken(promise: Promise) {
    val client = recaptchaTasksClient
    val activity = this.reactApplicationContext.currentActivity
    if (client != null && activity != null) {
      client.executeTask(RecaptchaAction.LOGIN)
        .addOnSuccessListener(activity) { token ->
          promise.resolve(token)
        }
        .addOnFailureListener { e ->
          promise.reject(e)
        }
    } else if (siteKey != null && activity != null) {
      initializeRecaptchaAndGetToken(siteKey!!, activity, promise)
    } else {
      promise.reject("RecaptchaNotInitialized", "Recaptcha client is not initialized and siteKey is missing. Call initRecaptcha first.")
    }
  }

  companion object {
    const val NAME = "TurboGoogleRecaptcha"
  }
}
