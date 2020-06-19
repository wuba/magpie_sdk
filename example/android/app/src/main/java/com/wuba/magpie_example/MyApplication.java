package com.wuba.magpie_example;

import android.app.Application;
import android.content.Context;

import com.wuba.magpie.Magpie;
import com.wuba.magpie.MagpiePlatform;
import com.wuba.magpie.MagpieUtils;
import com.wuba.magpie.interfaces.IMagpienativeRouter;
import com.wuba.magpie.interfaces.MagpieLifecycleListener;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.android.FlutterView;


public class MyApplication extends Application {

    public static MyApplication instance;

    @Override
    public void onCreate() {
        super.onCreate();
        instance = this;

        /**
         * magpie初始化
         */
        MagpiePlatform platform = new Magpie
                .MagpieConfigBuilder(this,new MagpieRouter())
                .isDebug(true)
                .whenEngineStart(Magpie.MagpieConfigBuilder.FLUTTER_ACTIVITY_CREATED)
                .renderMode(FlutterView.RenderMode.texture)
                .lifecycleListener(new LifecycleListener())
                .build();

        Magpie.getInstance().init(platform);
        Magpie.getInstance()
                .addFlutterAction(FlutterDataProvider.getUserInfoAction())
                .addFlutterAction(FlutterDataProvider.getHttpHeaderAction())
                .addFlutterAction(FlutterDataProvider.getRXDeviceInfoAction())
                .addFlutterAction(FlutterDataProvider.getUploadLogAction())
                .addFlutterAction(FlutterDataProvider.getNotificationAction());


    }

    public class MagpieRouter implements IMagpienativeRouter {

        @Override
        public void openContainer(Context context, String url, Map<String, Object> urlParams,
                                  int requestCode, Map<String, Object> exts) {
            // 业务接入自己的路由跳转框架处理逻辑
            String assembleUrl= MagpieUtils.assembleUrl(url,urlParams);
            PageRouter.openPageByUrl(context,assembleUrl, (HashMap)urlParams);
        }
    }

    public class LifecycleListener implements MagpieLifecycleListener {

        @Override
        public void beforeCreateEngine() {

        }

        @Override
        public void onEngineCreated() {

        }

        @Override
        public void onPluginsRegistered() {

        }

        @Override
        public void onEngineDestroy() {

        }
    }
}
