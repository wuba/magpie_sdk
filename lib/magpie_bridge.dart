import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';
export 'package:magpie/pub_plugins/flutter_boost/flutter_boost.dart';


typedef Future<dynamic> MagpieMethodHandler(MethodCall call);
typedef Future<dynamic> MagpieCallBack(String name, Map params);
typedef Future<dynamic> MagpieListener(String name, Map params);


class MagpieBridge {
  static final MagpieBridge _magpie = MagpieBridge();
  static MagpieBridge get singleton => _magpie;

  final MethodChannel _methodChannel = MethodChannel("magpie_channel");
  final Map<String, List<MagpieListener>> _actionListeners = Map();
  final Map<String, MagpieListener> _privateListeners = Map();

  MagpieBridge() {
    _methodChannel.setMethodCallHandler((MethodCall call){
      Future result = Future.value();
      if (call.method == "__magpie_event__") {
        String name = call.arguments["name"];
        Map arg = call.arguments["params"];
        List<MagpieListener> list = _actionListeners[name];
        if (list != null) {
          for (MagpieListener listener in list) {
            listener(name, arg);
          }
        }
      } else if (call.method == "__magpie_data__"){
        String name = call.arguments["name"];
        Map arg = call.arguments["params"];
        MagpieListener listener = _privateListeners['__magepie_data__'];
        if (listener != null) {
          result = Future.value(listener(name, arg));
        }
      }
    return result;
    });
  }

  /*
    Dart侧向Native发送数据获取消息
    @param name 消息名称
    @param params 参数
    @param callBack Native侧返回数据的回调
  */
  Future<T> sendDataRequestToNative<T>(String name, Map params,MagpieCallBack callBack){
    this.sendMessageToNativeWithCallBack('__magpie_data__', name, params, callBack,null);
  }
  /*
    Dart侧向Native发送埋点消息
    @param name 消息名称
    @param params 参数
    @param callBack Native侧的回调
  */
  Future<T> sendLogToNative<T>(String name, Map params,MagpieCallBack callBack){
    this.sendMessageToNativeWithCallBack('__magpie_log__', name, params, callBack,null);
  }
  /*
    Dart侧向Native发送全局通知消息
    @param name 消息名称
    @param params 参数
  */
  Future<T> sendNotificationToNative<T>(String name, Map params){
    this.sendMessageToNativeWithCallBack('__magpie_notification__', name, params, null,null);
  }
  /*
    Dart侧向Native发送事件消息
    @param module 事件模块名
    @param name 消息名称
    @param params 参数
  */
  Future<T> sendActionToNative<T>(String module,String name, Map params){
    this.sendMessageToNativeWithCallBack('__magpie_action__', name, params, null, null);
  }
  /*
    Dart侧向Native发送事件消息，并接受回调
    @param module 事件模块名
    @param name 消息名称
    @param params 参数
    @param callBack Native侧返回事件结果的回调
  */
  Future<T> sendActionToNativeWithCallBack<T>(String module,String name, Map params ,MagpieCallBack callBack){
    this.sendMessageToNativeWithCallBack('__magpie_action__', name, params, callBack, module);
  }
  /*
    注册接收Native侧数据的监听回调
    @param listener 接受Native侧数据的监听回调
  */
  VoidCallback addDataListener(MagpieListener listener) {
    this.addPrivateListener('__magepie_data__', listener);
  }
  /*
    添加Native的事件监听回调
    @param name 事件名称
    @param listener 监听Native事件的监听回调
  */
  VoidCallback addNativeActionListener(String name, MagpieListener listener) {
    assert(name != null && listener != null);
    List<MagpieListener> list = _actionListeners[name];
    if (list == null) {
      list = List();
      _actionListeners[name] = list;
    }
    list.add(listener);
    return () {
      list.remove(listener);
    };
  }
  /*
    添加其他类型Native消息监听
    @param name 监听的消息类型名称
    @param listener 接受Native消息的回调
  */
  VoidCallback addPrivateListener(String name,MagpieListener listener) {
    assert(listener != null);
    _privateListeners[name] = listener;
    return () {
      _privateListeners.remove(name);
    };
  }

  /*
    Dart侧向Native侧发送其他消息，并接收回调
    @param messageType 消息类型
    @param name 消息名称
    @param params 参数
    @param callBack 消息接收回调
    @param module (选填参数，接收方所属的Native的模块)
  */
  Future<T> sendMessageToNativeWithCallBack<T>(String messageType,String name, Map params ,MagpieCallBack callBack,String module){
    if (name == null) {
      return null;
    }
    Map action = Map();
    action["name"] = name;
    if (params == null) {
      action["params"] = Map();
    }else{
      action["params"] = params;
    }
    if (module == null) {
      action["module"] = 'common';
    }else{
      action["module"] = module;
    }
    if(callBack == null){
      return _methodChannel.invokeMethod<T>(messageType, action);
    }else{
      _methodChannel.invokeMethod(messageType, action).then((result){
        assert(result == null || result is Map);
        Map params = result;
        if(params == null){
          params = Map();
        }
        callBack(name,params);
      });
      return null;
    }
  }
}