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
    val app = reactApplicationContext.applicationContext as android.app.Application
    this.reactApplicationContext.currentActivity?.let {
      Recaptcha.getTasksClient(app, siteKey)
        .addOnSuccessListener(it) { client ->
          this.recaptchaTasksClient = client
          promise.resolve(null)
        }
        .addOnFailureListener { e ->
          promise.reject(e)
        }
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
    }
  }

  companion object {
    const val NAME = "TurboGoogleRecaptcha"
  }
}
