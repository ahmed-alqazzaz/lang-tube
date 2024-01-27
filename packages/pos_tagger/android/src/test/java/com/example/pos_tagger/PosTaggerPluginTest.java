package com.example.pos_tagger;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doAnswer;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import org.junit.Test;
import org.mockito.invocation.InvocationOnMock;
import org.mockito.stubbing.Answer;

import java.util.HashMap;
import java.util.Map;

public class PosTaggerPluginTest {
  @Test
  public void onMethodCall_getPlatformVersion_returnsExpectedValue() {
    PosTaggerPlugin plugin = new PosTaggerPlugin();

    final MethodCall call = new MethodCall("getPlatformVersion", null);
    MethodChannel.Result mockResult = mock(MethodChannel.Result.class);
    plugin.onMethodCall(call, mockResult);

    Map<String, Object> args = new HashMap<>();
    args.put("input", "hello world");
    final MethodCall call2 = new MethodCall("splitter", args);
    MethodChannel.Result mockResult2 = mock(MethodChannel.Result.class);

    // Print the result when the success method is called
    doAnswer(new Answer<Void>() {
      public Void answer(InvocationOnMock invocation) {
        Object[] args = invocation.getArguments();
        System.out.println("splitter result: " + args[0]);
        return null;
      }
    }).when(mockResult2).success(any());

    plugin.onMethodCall(call2, mockResult2);

    verify(mockResult).success("Android " + android.os.Build.VERSION.RELEASE);

    // Test for posTag method
    final MethodCall call3 = new MethodCall("posTag", args);
    MethodChannel.Result mockResult3 = mock(MethodChannel.Result.class);

    // Print the result when the success method is called
    doAnswer(new Answer<Void>() {
      public Void answer(InvocationOnMock invocation) {
        Object[] args = invocation.getArguments();
        System.out.println("posTag result: " + args[0]);
        return null;
      }
    }).when(mockResult3).success(any());

    plugin.onMethodCall(call3, mockResult3);

    verify(mockResult3).success("POS tagging completed");
  }
}
