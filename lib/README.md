# 如何使用Magpie SDK Dart.
## SDK结构
- pub_plugins 内置插件
    - flutter_boost 载体页的三方实现
- magpie.dart 页面导航功能类
- magpie_bridge.dart Dart->Native通信类与协议
## 集成方法

### 通过Pubspec集成
在Dart工程的pubspec文件中添加：

    dependencies:   
     magpie:     
     path: [magpie本地/远程路径]

或者：

    dependencies:   
     magpie:     
     git:
       url: https://github.com/wuba/magpie.git

### 直接集成
将magpie lib内文件加入现有Dart工程中

## 功能详解

### 基本功能
消息传递 

    /*
    通用消息的回调
    @param name 消息名称
    @param params 参数
    */
    typedef Future<dynamic> MagpieCallBack(String name, Map params);

    /*
    通用Native消息监听的回调
    @param name 消息名称
    @param params 参数
    */
    typedef Future<dynamic> MagpieListener(String name, Map params);

    /*
    Dart侧向Native发送数据获取消息
    @param name 消息名称
    @param params 参数
    @param callBack Native侧返回数据的回调
    */
    void sendDataRequestToNative(String name, Map params,MagpieCallBack callBack)

    /*
    Dart侧向Native发送埋点消息
    @param name 消息名称
    @param params 参数
    @param callBack Native侧的回调
    */
    void sendLogToNative(String name, Map params,MagpieCallBack callBack)

    /*
    Dart侧向Native发送全局通知消息
    @param name 消息名称
    @param params 参数
    */
    void sendNotificationToNative(String name, Map params)


    /*
    Dart侧向Native发送事件消息
    @param module 事件模块名
    @param name 消息名称
    @param params 参数
    */
    void sendActionToNative(String module,String name, Map params)

    /*
    Dart侧向Native发送事件消息，并接受回调
    @param module 事件模块名
    @param name 消息名称
    @param params 参数
    @param callBack Native侧返回事件结果的回调
    */
    void sendActionToNativeWithCallBack(String module,String name, Map params ,MagpieCallBack callBack)


    /*
    注册接收Native侧数据的监听回调
    @param listener 接受Native侧数据的监听回调
    */
    VoidCallback addDataListener(MagpieListener listener)

 
    /*
    添加Native的事件监听回调
    @param name 事件名称
@param listener 监听Native事件的监听回调
*/
VoidCallback addNativeActionListener(String name, MagpieListener listener)

    /*
    添加其他类型Native消息监听
    @param name 监听的消息类型名称
    @param listener 接受Native消息的回调
    */
    VoidCallback addPrivateListener(String name,MagpieListener listener)


    /*
    Dart侧向Native侧发送其他消息，并接收回调
    @param messageType 消息类型
    @param name 消息名称
    @param params 参数
    @param callBack 消息接收回调
    @param module (选填参数，接收方所属的Native的模块)
    */
    void sendMessageToNativeWithCallBack(String messageType,String name, Map params ,MagpieCallBack callBack,String module)

 
载体页导航

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
    typedef Widget MagepiePageBuilder(String pageName, Map params, String uniqueId)

    /**
    * 注册默认的页面组件
    * @param builder 页面组件的构造函数
    */
    void registerDefaultPageBuilder(MagepiePageBuilder builder)

    /**
    * 注册所有的页面组件
    * @param builders 所有页面组件的构造函数 （key:页面名称 value:页面组件的构造函数）
    */
    void registerPageBuilders(Map<String, MagepiePageBuilder> builders)

    /**
    * 打开一个页面
    * @param url 页面路由协议
    * @param urlParams 页面路由参数
    * @param exts 拓展参数
    * @disc 路由参数将透传至Native侧，将由Native根据页面路由协议中的页面名称信息，打开新的载体页，并将对应的页面名，参数传递到新的Dart页面组件中进行页面初始化
    */
    Future<Map<dynamic,dynamic>> open(String url,{Map<dynamic,dynamic> urlParams,Map<dynamic,dynamic> exts})

    /**
    * 关闭指定id的页面
    * @param id 页面实例的唯一id
    * @param result 页面的结果数据信息
    * @param exts 拓展参数
    * @disc 相关参数将传至Native侧
    */
    Future<bool> close(String id,{Map<dynamic,dynamic> result,Map<dynamic,dynamic> exts})

    /**
    * 关闭当前页面
    * @param result 页面的结果数据信息
    * @param exts 拓展参数
    * @disc 相关参数将传至Native侧
    */
    Future<bool> closeCurrent({Map<String,dynamic> result,Map<String,dynamic> exts})


    /**
    * 注册页面组件生命周期回调
    * @param observer 页面组件生命周期回调
    */
    VoidCallback addContainerObserver(MagepiePageObserver observer)

    /**
    * 注册载体页生命周期回调
    * @param observer 载体页生命周期回调
    */
    VoidCallback addBoostContainerLifeCycleObserver(MagepiePageLifeCycleObserver observer)

 
### 其他
具体API的使用见DEMO工程.
