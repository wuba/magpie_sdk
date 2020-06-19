package com.wuba.magpie;

import android.app.Application;
import android.content.Context;


import androidx.annotation.NonNull;

import com.idlefish.flutterboost.Debuger;
import com.idlefish.flutterboost.FlutterBoost;
import com.wuba.magpie.interfaces.IFlutterMagpie;
import com.wuba.magpie.interfaces.IMagpienativeRouter;
import com.wuba.magpie.interfaces.MagpieLifecycleListener;
import com.wuba.magpie.vo.FlutterAction;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.Map;

import io.flutter.embedding.android.FlutterView;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.FlutterJNI;
import io.flutter.embedding.engine.FlutterShellArgs;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.embedding.engine.loader.FlutterLoader;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.view.FlutterMain;

/**
 * magpie门面类
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

//    @Deprecated
//    public static void init(Context context){
//        // Instantiate a FlutterEngine.
//        FlutterEngine flutterEngine = new FlutterEngine(context);
//
//        // Start executing Dart code to pre-warm the FlutterEngine.
//        flutterEngine.getDartExecutor().executeDartEntrypoint(
//                DartExecutor.DartEntrypoint.createDefault()
//        );
//
//        // Cache the FlutterEngine to be used by FlutterActivity.
//        FlutterEngineCache
//                .getInstance()
//                .put("my_engine_id", flutterEngine);
//    }

    public static class MagpieConfigBuilder{

        public static final String DEFAULT_DART_ENTRYPOINT = "main";
        public static final String DEFAULT_INITIAL_ROUTE = "/";
        public static int IMMEDIATELY = 0;          //立即启动引擎

        public static int ANY_ACTIVITY_CREATED = 1; //当有任何Activity创建时,启动引擎

        public static int FLUTTER_ACTIVITY_CREATED = 2; //当有flutterActivity创建时,启动引擎


        public static int APP_EXit = 0; //所有flutter Activity destory 时，销毁engine
        public static int All_FLUTTER_ACTIVITY_DESTROY = 1; //所有flutter Activity destory 时，销毁engine

        private String dartEntrypoint = DEFAULT_DART_ENTRYPOINT;
        private String initialRoute = DEFAULT_INITIAL_ROUTE;
        private int whenEngineStart = ANY_ACTIVITY_CREATED;
        private int whenEngineDestory = APP_EXit;


        private boolean isDebug = false;

        private FlutterView.RenderMode renderMode = FlutterView.RenderMode.texture;

        private Application mApp;

        private IMagpienativeRouter router = null;

        private MagpieLifecycleListener lifecycleListener;

        public MagpieConfigBuilder(Application app, IMagpienativeRouter router) {
            this.router = router;
            this.mApp = app;
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

        public MagpieConfigBuilder lifecycleListener(MagpieLifecycleListener lifecycleListener) {
            this.lifecycleListener = lifecycleListener;
            return this;
        }

//        public MagpieConfigBuilder pluginsRegister(FlutterBoost.BoostPluginsRegister boostPluginsRegister) {
//            this.boostPluginsRegister = boostPluginsRegister;
//            return this;
//        }

        public MagpiePlatform build() {

            MagpiePlatform platform = new MagpiePlatform() {


                @Override
                public Application getApplication() {
                    return MagpieConfigBuilder.this.mApp;
                }

                @Override
                public void openContainer(Context context, String url, Map<String, Object> urlParams,
                                          int requestCode, Map<String, Object> exts) {
                    MagpieConfigBuilder.this.router.openContainer(context, url, urlParams, requestCode, exts);
                }

                @Override
                public int whenEngineStart() {
                    return MagpieConfigBuilder.this.whenEngineStart;
                }

                @Override
                public FlutterView.RenderMode renderMode() {
                    return MagpieConfigBuilder.this.renderMode;
                }

                @Override
                public boolean isDebug() {
                    return MagpieConfigBuilder.this.isDebug;
                }

                @Override
                public String dartEntrypoint() {
                    return MagpieConfigBuilder.this.dartEntrypoint;
                }

                @Override
                public String initialRoute() {
                    return MagpieConfigBuilder.this.initialRoute;
                }
            };

            platform.lifecycleListener = MagpieConfigBuilder.this.lifecycleListener;
            return platform;

        }
    }

//    public void doInitialFlutter() {
//        if (engineProvider() != null) {
//            return;
//        }
//
//        if (((MagpiePlatform)platform()).lifecycleListener1 != null) {
//            ((MagpiePlatform)platform()).lifecycleListener1.beforeCreateEngine();
//        }
//        FlutterEngine flutterEngine = createEngine();
//        if (((MagpiePlatform)platform()).lifecycleListener1 != null) {
//            ((MagpiePlatform)platform()).lifecycleListener1.onEngineCreated();
//        }
//        if (flutterEngine.getDartExecutor().isExecutingDart()) {
//            return;
//        }
//
//        if (platform().initialRoute() != null) {
//            flutterEngine.getNavigationChannel().setInitialRoute(platform().initialRoute());
//        }
//        DartExecutor.DartEntrypoint entrypoint = new DartExecutor.DartEntrypoint(
//                FlutterMain.findAppBundlePath(),
//                platform().dartEntrypoint()
//        );
//
//        flutterEngine.getDartExecutor().executeDartEntrypoint(entrypoint);
//    }

//    private FlutterEngine createEngine() {
//        if (engineProvider() == null) {
//            FlutterMain.startInitialization(platform().getApplication());
//            FlutterShellArgs flutterShellArgs = new FlutterShellArgs(new String[0]);
//            FlutterMain.ensureInitializationComplete(
//                    platform().getApplication().getApplicationContext(), flutterShellArgs.toArray());
//            FlutterEngine mEngine = new FlutterEngine(platform().getApplication()
//                    .getApplicationContext(),FlutterLoader.getInstance(),
//                    new FlutterJNI(),null,false);
//            try {
//                Field f = FlutterBoost.instance().getClass().getDeclaredField("mEngine");
//                f.setAccessible(true);
//                f.set(f,mEngine);
//            } catch (NoSuchFieldException e) {
//                e.printStackTrace();
//            } catch (IllegalAccessException e) {
//                e.printStackTrace();
//            }
//            registerPlugins(engineProvider());
//        }
//        return engineProvider();
//    }
//
//    private void registerPlugins(FlutterEngine engine) {
//        try {
//            Class<?> generatedPluginRegistrant = Class.forName("io.flutter.plugins.GeneratedPluginRegistrant");
//            Method registrationMethod = generatedPluginRegistrant.getDeclaredMethod("registerWith", FlutterEngine.class);
//            registrationMethod.invoke(null, engine);
//        } catch (Exception e) {
//            Debuger.exception(e);
//        }
//    }


}
