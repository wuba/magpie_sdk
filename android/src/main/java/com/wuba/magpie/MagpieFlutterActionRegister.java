package com.wuba.magpie;

import android.text.TextUtils;


import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.Map;

import com.wuba.magpie.interfaces.ABSFlutterDataProvider;
import com.wuba.magpie.vo.FlutterAction;
import com.wuba.magpie.vo.FlutterResultVo;

import rx.Observable;

/**
 * flutter获取native数据action注册
 * create by huangxin on 2019-12-02
 */
public class MagpieFlutterActionRegister<T> {

    private static String TAG = "MagpieFlutterActionRegister";

    public Map<String, FlutterAction> mActionsClassMap = new HashMap<>();

    public HashMap<String, T> mActionsImpMap = new HashMap<>(); //缓存

    private static class SingleTon {

        private static final MagpieFlutterActionRegister INSTANCE = new MagpieFlutterActionRegister();
    }

    private MagpieFlutterActionRegister() {

    }

    public static MagpieFlutterActionRegister getInstance() {
        return SingleTon.INSTANCE;
    }

    /**
     * 内置协议
     */
    public static void internalProtocol() {

        //MagpieFlutterActionRegister.getInstance().addAction(ABSFlutterDataProvider.getNotificationAction());

    }

    public MagpieFlutterActionRegister addAction(FlutterAction vo) {

        if(vo == null ||TextUtils.isEmpty(vo.getModule()) || vo.getClz() == null
                || TextUtils.isEmpty(vo.getMethod())) {
            throw new RuntimeException("参数不能为空");
        }

        Method m = getMethod(vo.getClz(),vo.getMethod());
        Class<?>[] classes = m.getParameterTypes();

        if (Map.class != classes[0]) {
            throw new RuntimeException("方法:"+vo.getMethod()
                    +"参数类型错误,必须为Map<String,Object>类型");
        }

        Class<?> returnClass = m.getReturnType();
        Type type = m.getGenericReturnType();

        if(returnClass != Observable.class
                && returnClass != FlutterResultVo.class
                && returnClass != void.class) {
            throw new RuntimeException("方法:"+vo.getMethod()+"返回类型错误,必须为NativeBaseResultVo" +
                    "或者Observable<FlutterResultVo>类型");
        }

        if(returnClass == Observable.class) {
            if(type instanceof ParameterizedType) {
                ParameterizedType pt = (ParameterizedType) type;
                Class<?> genericClazz = (Class<?>)pt.getActualTypeArguments()[0];
                if(genericClazz != FlutterResultVo.class) {
                    throw new RuntimeException("方法:"+vo.getMethod()+
                            "参数类型错误,必须为Observable<FlutterResultVo>类型");
                }
            }
        }

        if(!this.mActionsClassMap.containsKey(vo.getMethod())) {
            this.mActionsClassMap.put(vo.getMethod(), vo);
        } else {
            throw new RuntimeException("action:"+vo.getMethod()+"已注册");
        }
        return this;
    }

    public MagpieFlutterActionRegister removeAction(String methodName) {
        if(this.mActionsClassMap.containsKey(methodName)) {
            this.mActionsClassMap.remove(methodName);
        }
        return this;
    }

    public Method getMethod(Class provider, String method) {
        Method[] methods = provider.getDeclaredMethods();
        for (Method m : methods) {
            if (m.getName().equals(method)) {
                return m;
            }
        }
        return null;
    }

    /**
     * @param module
     * @return
     */
    public boolean hasNativeModuleAndroidMthod(String module,String method) {
        if(mActionsClassMap.get(method) == null) {
            return false;
        }
        if(TextUtils.isEmpty(mActionsClassMap.get(method).getModule())) {
            return false;
        }
        return true;
    }

    /**
     * 判断方法名字
     * @param method
     * @return
     */
    public boolean hasNativeMethod(String method) {
        return mActionsClassMap.containsKey(method);
    }

    public Class getClass(String method) {
        return mActionsClassMap.get(method).getClz();
    }

    public Object invokeNativeMethod(String method, Map<String,Object> paramMap) {
        Object provider = null;
        try {
            Class providerClz = getClass(method);
            provider = providerClz.newInstance();
            Method m = providerClz.getMethod(method,Map.class);
            //Method m = getMethod(providerClz,method);
            Object obj = m.invoke(provider,paramMap);
            return obj;
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void clearAllActions(){
        mActionsClassMap.clear();
        //mActionsImpMap.clear();
    }

}
