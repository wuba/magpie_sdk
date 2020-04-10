package com.wuba.magpie_example;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Toast;

import com.alibaba.fastjson.JSON;
import com.wuba.magpie.Magpie;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends AppCompatActivity implements View.OnClickListener {

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        getWindow().setBackgroundDrawableResource(R.color.white);
        super.onCreate(savedInstanceState);
        //Magpie.init(this);
        setContentView(R.layout.native_page);
        // 设置文字是否黑色
        View decorView = getWindow().getDecorView();
        int option = View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR;
        decorView.setSystemUiVisibility(option);
        //StatusBarUtil.darkMode(this, true);
        View open_flutter_page = findViewById(R.id.open_flutter_page);
        View open_flutter_fragment_page = findViewById(R.id.open_flutter_fragment_page);
        View open_native_page = findViewById(R.id.open_native_page);
        //View get_dart_data = findViewById(R.id.get_dart_data);
        open_flutter_page.setOnClickListener(this);
        open_flutter_fragment_page.setOnClickListener(this);
        open_native_page.setOnClickListener(this);
        //get_dart_data.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        HashMap params = new HashMap();
        params.put("name","张三");
        switch (v.getId()) {

            case R.id.open_flutter_page:
                PageRouter.openPageByUrl(MainActivity.this,PageRouter.FLUTTER_PAGE_URL,params);
//                startActivity(MagpieOriginalFlutterActivity.createDefaultIntent(MainActivity.this));
                break;
            case R.id.open_flutter_fragment_page:
                PageRouter.openPageByUrl(MainActivity.this,PageRouter.FLUTTER_FRAGMENT_PAGE_URL,params);
                break;

            case R.id.open_native_page:
                PageRouter.openPageByUrl(MainActivity.this,PageRouter.NATIVE_PAGE_URL,params);
                break;

//            case R.id.get_dart_data:
//                HashMap<String, Object> args = new HashMap<>();
//                args.put("name", "李四");
//                args.put("params", params);
//                Magpie.getInstance().invokeMethod(Magpie.MAGPIE_DATA, args, new MethodChannel.Result() {
//                    @Override
//                    public void success(@Nullable Object result) {
//                        Toast.makeText(MyApplication.instance.getApplicationContext(),
//                                JSON.toJSONString(result),Toast.LENGTH_LONG).show();
//                    }
//
//                    @Override
//                    public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
//                        Toast.makeText(MyApplication.instance.getApplicationContext(),
//                                errorMessage + " errorDetails:" + JSON.toJSONString(errorDetails),Toast.LENGTH_LONG).show();
//                    }
//
//                    @Override
//                    public void notImplemented() {
//                        Toast.makeText(MyApplication.instance.getApplicationContext(),
//                                "notImplemented",Toast.LENGTH_LONG).show();
//                    }
//                });
//                break;

        }

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }


}
