package com.wuba.magpie.interfaces;

import android.widget.Toast;

import com.alibaba.fastjson.JSON;
import com.wuba.magpie.vo.FlutterAction;

import java.util.Map;

/**
 * create by huangxin on 2019-12-03
 */
public abstract class ABSFlutterDataProvider {

    public static String RESULT_KEY = "key";

//    /**
//     *
//     * @return
//     */
//    public static FlutterAction getNotificationAction() {
//        return new FlutterAction("common", ABSFlutterDataProvider.class,"notification");
//    }
//
//
//    /**
//     * 接收dart消息，发送广播
//     * @param paramMap
//     */
//    public void notification(Map<String,Object> paramMap) {
//
//        Toast.makeText(MyApplication.getInstance.getApplicationContext(),
//                JSON.toJSONString(paramMap),Toast.LENGTH_LONG).show();
//
//    }

}
