package com.fetchpixelcolor;

import androidx.annotation.NonNull;

import android.net.Uri;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.util.Base64;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.module.annotations.ReactModule;

import java.io.File;

@ReactModule(name = FetchPixelColorModule.NAME)
public class FetchPixelColorModule extends ReactContextBaseJavaModule {
  public static final String NAME = "FetchPixelColor";

  public FetchPixelColorModule(ReactApplicationContext reactContext) {
    super(reactContext);
  }

  @Override
  @NonNull
  public String getName() {
    return NAME;
  }

  @ReactMethod
  public void init(String encodedImage, Callback callback) {
    try {
      final byte[] decodedString = Base64.decode(encodedImage, Base64.DEFAULT);
      this.bitmap = BitmapFactory.decodeByteArray(decodedString, 0, decodedString.length);

      callback.invoke(null, true);
    } catch (Exception e) {
      callback.invoke(e.getMessage());
    }
  }

  @ReactMethod
  public void getRGB(int x, int y, Callback callback) {
    try {
      final int pixel = this.bitmap.getPixel(x, y);

      final int red = Color.red(pixel);
      final int green = Color.green(pixel);
      final int blue = Color.blue(pixel);

      final WritableArray result = new WritableNativeArray();
      result.pushInt(red);
      result.pushInt(green);
      result.pushInt(blue);

      callback.invoke(null, result);
    } catch (Exception e) {
      callback.invoke(e.getMessage());
    }
  }

  // Example method
  // See https://reactnative.dev/docs/native-modules-android
  @ReactMethod
  public void multiply(double a, double b, Promise promise) {
    promise.resolve(a * b);
  }
}
