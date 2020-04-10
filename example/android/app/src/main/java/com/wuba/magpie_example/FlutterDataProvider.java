package com.wuba.magpie_example;

import android.util.Log;
import android.widget.Toast;

import com.alibaba.fastjson.JSON;
import com.wuba.magpie.interfaces.ABSFlutterDataProvider;
import com.wuba.magpie.vo.FlutterAction;
import com.wuba.magpie.vo.FlutterResultVo;
import com.wuba.magpie_example.vo.FlutterBaseResultVo;
import com.wuba.magpie_example.vo.User;

import java.util.HashMap;
import java.util.Map;

import rx.Observable;
import rx.functions.Func1;
import rx.schedulers.Schedulers;

/**
 * native向dart侧的数据提供者
 * create by hxin on 2019-12-02
 */
public class FlutterDataProvider extends ABSFlutterDataProvider {

    private static String TAG = "FlutterDataProvider";

    /**
     * 获取用户信息
     * @return
     */
    public static FlutterAction getUserInfoAction() {
        return new FlutterAction("common", FlutterDataProvider.class,"getUserInfo");
    }

    /**
     * 获取设备信息
     * @return
     */
    public static FlutterAction getRXDeviceInfoAction() {
        return new FlutterAction("common", FlutterDataProvider.class,"getDeviceInfo");
    }

    /**
     * 获取请求头信息
     * @return
     */
    public static FlutterAction getHttpHeaderAction() {
        return new FlutterAction("common", FlutterDataProvider.class,"getHttpHeader");
    }

    /**
     * 上传日志
     * @return
     */
    public static FlutterAction getUploadLogAction() {
        return new FlutterAction("testModule", FlutterDataProvider.class,"uploadLog");
    }

    /**
     * 上传日志
     * @return
     */
    public static FlutterAction getNotificationAction() {
        return new FlutterAction("common", FlutterDataProvider.class,"notification");
    }




    /**
     * 获取用户信息
     * @param paramMap dart传过来的参数，两端自行约定
     * @return "key"为map的的键，两端自行约定
     */
    public FlutterResultVo getUserInfo(Map<String,Object> paramMap) {
        Log.d("FlutterDataProvider","FlutterDataProvider.testKey接收参数："+JSON.toJSONString(paramMap));
        FlutterResultVo nativeResult = new FlutterResultVo();
        User user = new User("123456","hxin");
        FlutterBaseResultVo flutterBaseResultVo = new FlutterBaseResultVo();
        flutterBaseResultVo.setResultCode(0);
        flutterBaseResultVo.setMsg("获取用信息成功");
        flutterBaseResultVo.setResultObj(user);
        Map<String,Object> userMap = new HashMap<>();
        userMap.put("key", JSON.toJSONString(flutterBaseResultVo));
        nativeResult.setResult(userMap);
        return nativeResult;
    }

    /**
     * 异步方式获取设备信息
     * @param paramMap dart传过来的参数，两端自行约定
     * @return "key"为map的的键，两端自行约定
     */
    public Observable<FlutterResultVo> getDeviceInfo(Map<String,Object> paramMap) {
        Observable<FlutterResultVo> ob =
                Observable.just(new FlutterResultVo())
                        .observeOn(Schedulers.io())
                        .map(new Func1<FlutterResultVo, FlutterResultVo>() {
                            @Override
                            public FlutterResultVo call(FlutterResultVo nativeResult) {
                                Log.d(TAG, "方法getRXDeviceInfo执行线程name：" + Thread.currentThread().getName());
                                Map<String,Object> userMap = new HashMap<>();
                                FlutterBaseResultVo flutterBaseResultVo = new FlutterBaseResultVo();
                                flutterBaseResultVo.setResultCode(0);
                                flutterBaseResultVo.setMsg("获取设备信息成功");
                                flutterBaseResultVo.setResultObj("123456789");
                                userMap.put(RESULT_KEY, JSON.toJSONString(flutterBaseResultVo));
                                nativeResult.setResult(userMap);
                                return nativeResult;
                            }
                        });
        return ob;

    }

    /**
     * 获取httpHeader
     * @param paramMap
     * @return
     */
    public FlutterResultVo getHttpHeader(Map<String,Object> paramMap) {
        // TODO
        return null;
    }

    /**
     * 上传日志
     * @param paramMap
     */
    public FlutterResultVo uploadLog(Map<String,Object> paramMap) {

        // TODO 上传 业务侧实现
        Log.d(TAG,"日志上传");
        Toast.makeText(MyApplication.instance.getApplicationContext(),
                JSON.toJSONString(paramMap),Toast.LENGTH_LONG).show();
        FlutterResultVo flutterResultVo = new FlutterResultVo();
        Map<String,Object> map = new HashMap<>();
        FlutterBaseResultVo flutterBaseResultVo = new FlutterBaseResultVo();
        flutterBaseResultVo.setResultCode(0);
        flutterBaseResultVo.setMsg("上传成功");
        flutterBaseResultVo.setResultObj("");
        map.put(RESULT_KEY, JSON.toJSONString(flutterBaseResultVo));
        flutterResultVo.setResult(map);
        return flutterResultVo;
    }

    public void notification(Map<String,Object> paramMap) {
        Toast.makeText(MyApplication.instance.getApplicationContext(),
                "开始发送广播",Toast.LENGTH_LONG).show();
    }


}
