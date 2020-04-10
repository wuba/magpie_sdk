package com.wuba.magpie;

import android.app.Application;
import android.content.Context;
import android.support.annotation.NonNull;


import com.idlefish.flutterboost.FlutterBoost;
import com.idlefish.flutterboost.interfaces.INativeRouter;
import com.wuba.magpie.interfaces.IFlutterMagpie;
import com.wuba.magpie.vo.FlutterAction;

import java.io.Serializable;
import java.util.Map;

import io.flutter.embedding.android.FlutterView;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.plugin.common.MethodChannel;

/**
 * FlutterBoost包装类
 * create by hxin on 2019-12-06
 */
public class Magpie implements IFlutterMagpie {

    public static String MAGPIE_DATA = "__magpie_data__";
    public static String MAGPIE_ACTION = "__magpie_action__";
    public static String MAGPIE_NOTIFICATION = "__magpie_notification__";


    static Magpie sInstance = null;

    private Magpie(){

    }

    public static Magpie getInstance() {
        if (sInstance == null) {
            sInstance = new Magpie();
        }
        return sInstance;
    }

    /**
     * 注册native方法，提供给dart侧数据
     */
    public Magpie addFlutterAction(FlutterAction vo) {
        MagpieFlutterActionRegister.getInstance().addAction(vo);
        return this;
    }

    public void init(com.wuba.magpie.MagpiePlatform platform) {
        FlutterBoost.instance().init(platform);
    }

    public void invokeMethod(final String name, Serializable args, MethodChannel.Result result) {
        MagpiePlugin.singleton().invokeMethod(name,args,result);
    }

    @Deprecated
    public static void init(Context context){
        // Instantiate a FlutterEngine.
        FlutterEngine flutterEngine = new FlutterEngine(context);

        // Start executing Dart code to pre-warm the FlutterEngine.
        flutterEngine.getDartExecutor().executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
        );

        // Cache the FlutterEngine to be used by FlutterActivity.
        FlutterEngineCache
                .getInstance()
                .put("my_engine_id", flutterEngine);
    }

    public static class MagpieConfigBuilder extends FlutterBoost.ConfigBuilder{

        public MagpieConfigBuilder(Application app, INativeRouter router) {
            super(app, router);
        }

        public MagpieConfigBuilder renderMode(FlutterView.RenderMode renderMode) {
            this.renderMode = renderMode;
            return this;
        }

        public MagpieConfigBuilder dartEntrypoint(@NonNull String dartEntrypoint) {
            this.dartEntrypoint = dartEntrypoint;
            return this;
        }

        public MagpieConfigBuilder initialRoute(@NonNull String initialRoute) {
            this.initialRoute = initialRoute;
            return this;
        }

        public MagpieConfigBuilder isDebug(boolean isDebug) {
            this.isDebug = isDebug;
            return this;
        }

        public MagpieConfigBuilder whenEngineStart(int whenEngineStart) {
            this.whenEngineStart = whenEngineStart;
            return this;
        }

        public MagpieConfigBuilder whenEngineDestory(int whenEngineDestory) {
            this.whenEngineDestory = whenEngineDestory;
            return this;
        }

        public MagpieConfigBuilder lifecycleListener(FlutterBoost.BoostLifecycleListener lifecycleListener) {
            this.lifecycleListener = lifecycleListener;
            return this;
        }

//        public MagpieConfigBuilder pluginsRegister(FlutterBoost.BoostPluginsRegister boostPluginsRegister) {
//            this.boostPluginsRegister = boostPluginsRegister;
//            return this;
//        }

        public MagpiePlatform build() {

            MagpiePlatform platform = new MagpiePlatform() {

                public Application getApplication() {
                    return MagpieConfigBuilder.this.mApp;
                }

                public boolean isDebug() {

                    return MagpieConfigBuilder.this.isDebug;
                }

                @Override
                public String initialRoute() {
                    return MagpieConfigBuilder.this.initialRoute;
                }

                public void openContainer(Context context, String url, Map<String, Object> urlParams,
                                          int requestCode, Map<String, Object> exts) {
                    MagpieConfigBuilder.this.router.openContainer(context, url, urlParams, requestCode, exts);
                }


                public int whenEngineStart() {
                    return MagpieConfigBuilder.this.whenEngineStart;
                }


                public FlutterView.RenderMode renderMode() {
                    return MagpieConfigBuilder.this.renderMode;
                }
            };

            platform.lifecycleListener = MagpieConfigBuilder.this.lifecycleListener;
            return platform;

        }

    }

    public interface MagpieLifecycleListener extends FlutterBoost.BoostLifecycleListener {



    }
}
