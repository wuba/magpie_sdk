package com.wuba.magpie;

import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.alibaba.fastjson.JSON;
import com.idlefish.flutterboost.Debuger;
import com.idlefish.flutterboost.FlutterBoostPlugin;
import com.wuba.magpie.vo.FlutterResultVo;

import java.io.Serializable;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import rx.Observable;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;

/**
 * create by hxin on 2019-12-06
 */
public class MagpiePlugin  {

    private static String TAG = "MagpiePlugin";

    private static MagpiePlugin sInstance;
    private final MethodChannel mMagpieMethodChannel;
    private final Set<MethodChannel.MethodCallHandler> mMagpieMethodCallHandlers = new HashSet<>();

    public static MagpiePlugin singleton() {
        if (sInstance == null) {
            throw new RuntimeException("MagpiePlugin not register yet");
        }

        return sInstance;
    }

    public static void registerWith(PluginRegistry.Registrar registrar) {
        //if(sInstance == null) {
            sInstance = new MagpiePlugin(registrar);
        //}
        FlutterBoostPlugin.registerWith(registrar);
    }

    private MagpiePlugin(PluginRegistry.Registrar registrar) {
        mMagpieMethodChannel = new MethodChannel(registrar.messenger(), "magpie_channel");
        setMagpieMethodCallHandler();
    }

    public void setMagpieMethodCallHandler() {

        mMagpieMethodChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall methodCall, @NonNull MethodChannel.Result result) {
                Object[] handlers;
                synchronized (mMagpieMethodCallHandlers) {
                    handlers = mMagpieMethodCallHandlers.toArray();
                }

                for (Object o : handlers) {
                    ((MethodChannel.MethodCallHandler) o).onMethodCall(methodCall, result);
                }
            }
        });
        addMagpieMethodCallHandler(new MagPieMethodHandler());
    }

    public void addMagpieMethodCallHandler(MethodChannel.MethodCallHandler handler) {
        synchronized (mMagpieMethodCallHandlers) {
            mMagpieMethodCallHandlers.add(handler);
        }
    }

    public void invokeMethod(final String name, Serializable args, MethodChannel.Result result) {
        if ("__event__".equals(name)) {
            Debuger.exception("method name should not be __event__");
        }

        mMagpieMethodChannel.invokeMethod(name, args, result);
    }

    /**
     * 从native端获取数据
     */
    class MagPieMethodHandler implements MethodChannel.MethodCallHandler {

        @Override
        public void onMethodCall(@NonNull MethodCall methodCall, @NonNull MethodChannel.Result result) {
            String method = "";
            String name = "";
            String module = "";
            try {
                // TODO
                //Log.d(TAG, "方法执行线程name：" + Thread.currentThread().getName());
                method = methodCall.method;
                Log.d(TAG, "接收方法名称：" + method);
                if(Magpie.MAGPIE_DATA.equals(method)) {

                    dealAction(method,name,module,methodCall,result);

                } else if(Magpie.MAGPIE_ACTION.equals(method)) {

                    dealAction(method,name,module,methodCall,result);

                } else if(Magpie.MAGPIE_NOTIFICATION.equals(method)) {

                    dealAction(method,name,module,methodCall,result);

                }
//                else if("__magpie_log__".equals(method)) {
//                    //dealAction(method,"receiveLog",module,methodCall,result);
//                }
            } catch (Exception e) {
                e.printStackTrace();
                result.error("通道:"+ method+" module:" + module
                        +" name:" + name + "处理异常", e.getMessage(), e);
            }
        }
    }

    private void dealAction (String method,String name,String module,
                            MethodCall methodCall,final MethodChannel.Result result) {
        if(TextUtils.isEmpty(name)) {
            name = methodCall.argument("name");
        }
        if(TextUtils.isEmpty(module)) {
            module = methodCall.argument("module");
        }
        Log.d(TAG, "接收参数方法名name：" + name);
        Log.d(TAG, "接收参数module：" + module);
        if(TextUtils.isEmpty(name)) {
            return;
        }

        if(!MagpieFlutterActionRegister.getInstance().hasNativeModuleAndroidMthod(module,name)) {
            return;
        }
        Map<String, Object> params = methodCall.argument("params");
        Log.d(TAG, "接收方法参数params：" + (params != null ? JSON.toJSONString(params):""));
        Object obj = MagpieFlutterActionRegister.getInstance().invokeNativeMethod(name,params,result);
        if(result == null) {
            return;
        }
        if(obj instanceof FlutterResultVo) {
            result.success(((FlutterResultVo)obj).getResult());
            Log.d(TAG, "返回数据：" + JSON.toJSONString(((FlutterResultVo)obj)));
        } else if(obj instanceof Observable) {
            Observable<FlutterResultVo> ob = (Observable<FlutterResultVo>)obj;
            ob.observeOn(AndroidSchedulers.mainThread()).subscribe(new Subscriber<FlutterResultVo>() {
                @Override
                public void onCompleted() {

                }

                @Override
                public void onError(Throwable e) {
                    result.error("close page error", e.getMessage(), e);
                }

                @Override
                public void onNext(FlutterResultVo vo) {
                    Log.d(TAG, "方法call执行线程name：" + Thread.currentThread().getName());
                    Log.d(TAG, "RX返回数据："+JSON.toJSONString(vo));
                    result.success(vo.getResult());
                }
            });
        }

    }
}
