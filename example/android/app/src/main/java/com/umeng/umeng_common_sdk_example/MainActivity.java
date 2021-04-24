package com.umeng.umeng_common_sdk_example;

import android.os.Bundle;

import io.flutter.embedding.android.FlutterActivity;
import com.umeng.analytics.MobclickAgent;
import com.umeng.commonsdk.UMConfigure;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        UMConfigure.init(this, "5e3f96f3cb23d2a070000048", "Umeng", UMConfigure.DEVICE_TYPE_PHONE, null);
        UMConfigure.setLogEnabled(true);
        com.umeng.umeng_common_sdk.UmengCommonSdkPlugin.setContext(this);
        android.util.Log.i("UMLog", "onCreate@MainActivity");
    }

    @Override
    protected void onPause() {
        super.onPause();
        MobclickAgent.onPause(this);
        android.util.Log.i("UMLog", "onPause@MainActivity");
    }

    @Override
    protected void onResume() {
        super.onResume();
        MobclickAgent.onResume(this);
        android.util.Log.i("UMLog", "onResume@MainActivity");
    }
}
