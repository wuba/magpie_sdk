library magpie;
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:magpie/pub_plugins/flutter_boost/flutter_boost.dart';


class MagepiePageInfos {
  final String uniqueId;
  final String name;
  final Map params;
  final WidgetBuilder builder;
  const MagepiePageInfos(
      {this.uniqueId = 'default',
      this.name = 'default',
      this.params,
      this.builder});
}

enum MagepiePageOperation { Push, Onstage, Pop, Remove, Unkown}
enum MagepiePageLifeCycle {Init, Appear, WillDisappear, Disappear, Destroy, Background, Foreground, Unkown}
/**
 * 页面组件生命周期回调
 * @param operation 页面组件当前操作类型
 * @param infos 当前页面信息
 */
typedef MagepiePageObserver = void Function(MagepiePageOperation operation, MagepiePageInfos infos);
/**
 * 载体页生命周期回调
 * @param state 载体页当前状态
 * @param infos 当前页面信息
 */
typedef MagepiePageLifeCycleObserver = void Function(MagepiePageLifeCycle state, MagepiePageInfos infos);
/**
 * 页面组件构造函数
 * @param 页面名称
 * @param 参数
 * @param 页面实例的唯一标识
 */
typedef Widget MagepiePageBuilder(String pageName, Map<String, dynamic> params, String uniqueId);

class Magpie {

  static final Magpie _instance = Magpie();
  static Magpie get singleton => _instance;

  static TransitionBuilder init(
      {TransitionBuilder builder,
        PrePushRoute prePush,
        PostPushRoute postPush}) {
    return FlutterBoost.init(builder: builder,prePush: prePush,postPush: postPush);
  }

  /**
   * 向载体页注册默认的页面组件
   * @param builder 页面组件的构造函数
   */
  void registerDefaultPageBuilder(MagepiePageBuilder builder) {
    FlutterBoost.singleton.registerDefaultPageBuilder((pageName,params,uniqueId){
      return builder(pageName,params,uniqueId);
    });
    // ContainerCoordinator.singleton.registerDefaultPageBuilder(builder);
  }

  /**
  * 注册所有的页面组件
  * @param builders 所有页面组件的构造函数 （key:页面名称 value:页面组件的构造函数）
  */
  void registerPageBuilders(Map<String, MagepiePageBuilder> builders) {
    Map<String, PageBuilder> flutterBuilders = Map();
    builders.forEach((String key,MagepiePageBuilder builder){
      flutterBuilders[key]=(pageName,params,uniqueId){
        return builder(pageName,params,uniqueId);
      };
    });
    FlutterBoost.singleton.registerPageBuilders(flutterBuilders);
  }
  /**
   * 打开一个新的页面
   * @param url 页面路由协议
   * @param urlParams 页面路由参数
   * @param exts 拓展参数
   * @disc 路由参数将透传至Native侧，将由Native根据页面路由协议中的页面名称信息，打开新的载体页，并将对应的页面名，参数传递到新的Dart页面组件中进行页面初始化
   */
  Future<Map<dynamic,dynamic>> open(String url,{Map<String,dynamic> urlParams,Map<String,dynamic> exts}){
    return FlutterBoost.singleton.open(url,urlParams:urlParams, exts:exts);
  }
  /**
   * 关闭指定id的页面
   * @param id 页面实例的唯一id
   * @param result 页面的结果数据信息
   * @param exts 拓展参数
   * @disc 相关参数将传至Native侧
   */
  Future<bool> close(String id,{Map<String,dynamic> result,Map<String,dynamic> exts}){
    return FlutterBoost.singleton.close(id,result:result, exts:exts);
  }
  /**
   * 关闭当前页面
   * @param result 页面的结果数据信息
   * @param exts 拓展参数
   * @disc 相关参数将传至Native侧
   */
  Future<bool> closeCurrent({Map<String,dynamic> result,Map<String,dynamic> exts}) {
    return FlutterBoost.singleton.closeCurrent(result:result, exts:exts);
  }

  /**
   * 注册页面组件生命周期回调
   * @param observer 页面组件生命周期回调
   */
  VoidCallback addContainerObserver(MagepiePageObserver observer){
    return FlutterBoost.singleton.addContainerObserver((ContainerOperation operation, BoostContainerSettings settings){
      MagepiePageOperation mOperation;
      switch (operation) {
        case ContainerOperation.Onstage:
          mOperation = MagepiePageOperation.Onstage;
          break;
        case ContainerOperation.Push:
          mOperation = MagepiePageOperation.Push;
          break;
        case ContainerOperation.Pop:
          mOperation = MagepiePageOperation.Pop;
          break;
        case ContainerOperation.Remove:
          mOperation = MagepiePageOperation.Remove;
          break;
        default:
          mOperation = MagepiePageOperation.Unkown;
      }
      MagepiePageInfos infos = MagepiePageInfos(
        uniqueId: settings.uniqueId,
        name: settings.name,
        params: settings.params,
        builder: settings.builder
      );
      observer(mOperation,infos);
    });
  }
  /**
   * 注册载体页生命周期回调
   * @param observer 载体页生命周期回调
   */
  VoidCallback addBoostContainerLifeCycleObserver(MagepiePageLifeCycleObserver observer){
    return FlutterBoost.singleton.addBoostContainerLifeCycleObserver((ContainerLifeCycle state, BoostContainerSettings settings){
      MagepiePageLifeCycle mState;
      switch (state) {
        case ContainerLifeCycle.Appear:
          mState = MagepiePageLifeCycle.Appear;
          break;
        case ContainerLifeCycle.Background:
          mState = MagepiePageLifeCycle.Background;
          break;
        case ContainerLifeCycle.Destroy:
          mState = MagepiePageLifeCycle.Destroy;
          break;
        case ContainerLifeCycle.Disappear:
          mState = MagepiePageLifeCycle.Disappear;
          break;
        case ContainerLifeCycle.Foreground:
          mState = MagepiePageLifeCycle.Foreground;
          break;
        case ContainerLifeCycle.Init:
          mState = MagepiePageLifeCycle.Init;
          break;
        case ContainerLifeCycle.WillDisappear:
          mState = MagepiePageLifeCycle.WillDisappear;
          break;
        default:
          mState = MagepiePageLifeCycle.Unkown;
      }

      MagepiePageInfos infos = MagepiePageInfos(
        uniqueId: settings.uniqueId,
        name: settings.name,
        params: settings.params,
        builder: settings.builder
      );
      observer(mState,infos);
    });
  }

}




