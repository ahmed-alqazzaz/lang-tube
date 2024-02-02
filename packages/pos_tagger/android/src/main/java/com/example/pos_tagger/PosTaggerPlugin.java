package com.example.pos_tagger;

import android.content.Context;
import android.os.StrictMode;

import androidx.annotation.NonNull;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** PosTaggerPlugin */
public class PosTaggerPlugin implements FlutterPlugin, MethodCallHandler {
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "pos_tagger");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (!call.method.equals("posTag")) {
      result.notImplemented();
    }
    String text = call.argument("text");
    String modelPath = call.argument("modelPath");
    if (text == null || modelPath == null) {
      result.error("INVALID_INPUT", "Input is null", null);
    }
    List<List<String>>  tags = PosTagger.getInstance(modelPath).evaluate(text);
    JSONArray jsonArray = new JSONArray();
    for (List<String> tag : tags) {
      jsonArray.put(new JSONArray(tag));
    }

    result.success(jsonArray.toString());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
