# magpie android sdk 接入文档:

## maven配置

``` java
//rootProject/build.gradle
allprojects {
    repositories {
        maven { url "https://dl.bintray.com/hxingood123/magpie/" }
        maven { url "https://dl.bintray.com/hxingood123/flutter/" }
    }
}
```

## 设置jdk

``` java
android {
    compileOptions {
        sourceCompatibility 1.8
        targetCompatibility 1.8
    }
}
```

## 添加依赖

``` java
//rootProject/app/build.gradle
dependencies {
    //在开发初期可以依赖此带有空flutter载体页的aar包进行hot reload，方便开发调试, 当调试通过，去掉依赖即可
    debugImplementation 'com.wuba.magpie:magpie_flutter_debug_default:0.0.1'
    //magpie Android SDK debug
    debugImplementation 'com.wuba.magpie:magpie_debug:0.0.1'
    //magpie Android SDK release
    releaseImplementation 'com.wuba.magpie:magpie_release:0.0.1'
}
```

#flutter
``` java
-keep class io.flutter.app.** {*;}
-keep class io.flutter.plugin.** {*;}
-keep class io.flutter.util.** {*;}
-keep class io.flutter.view.** {*;}
-keep class io.flutter.** {*;}
-keep class io.flutter.plugins.** {*;}
-keep class io.flutter.embedding.engine.plugins.** {*;}
```

## 使用方法

Magpie SDK初始化
``` java
        /**
         * magpie SDK初始化
         */
        MagpiePlatform platform = new Magpie
                .MagpieConfigBuilder(this,new MagpieRouter())
                .isDebug(true)
                .whenEngineStart(FlutterBoost.ConfigBuilder.FLUTTER_ACTIVITY_CREATED)
                .renderMode(FlutterView.RenderMode.texture)
                .lifecycleListener(new MagpieLifecycleListener())
                .build();
        Magpie.getInstance().init(platform);
        
        public class MagpieRouter implements IMagpienativeRouter {
        
                @Override
                public void openContainer(Context context, String url, Map<String, Object> urlParams,
                                          int requestCode, Map<String, Object> exts) {
                    // 业务接入自己的路由跳转框架处理逻辑，参考example下的PageRouter
                    String assembleUrl= Utils.assembleUrl(url,urlParams);
                    PageRouter.openPageByUrl(context,assembleUrl, urlParams);
                }
            }
        
        public class MagpieLifecycleListener implements Magpie.MagpieLifecycleListener {
    
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
```
初始化完毕，接下来你需要查看example下的MainActivity、PageRouter相关类来完成最终的路由跳转

## 协议注册相关demo:
1. native侧页面跳转协议相关注册见example下的PageRouter类，需接入方自行实现协议已满足各接入方现有协议框架
2. dart侧页面跳转协议注册见main.dart文件Magpie.singleton.registerPageBuilders方法，需要与native协议对应
3. 注册完两端路由，即可使用路由进行跳转，native->flutter如下：

路由页面跳转,完整代码请查看example中的MainActivity:
``` java
            case R.id.open_flutter_page:
                PageRouter.openPageByUrl(MainActivity.this,PageRouter.FLUTTER_PAGE_URL,params);
                break;
            case R.id.open_flutter_fragment_page:
                PageRouter.openPageByUrl(MainActivity.this,PageRouter.FLUTTER_FRAGMENT_PAGE_URL,params);
                break;

            case R.id.open_native_page:
                PageRouter.openPageByUrl(MainActivity.this,PageRouter.NATIVE_PAGE_URL,params);
                break;
```

## 数据及方法通信相关demo：
1. native侧在MyApplicatio中注册需要提供给dart侧的native方法用于调用native侧方法及数据，见FlutterActionRegister类实现
2. dart侧demo入口在example.lib下的main.dart文件中的方法如下：
   1. sendDataRequestToNative 
   2. sendNotificationToNative
   3. sendActionToNativeWithCallBack 
  
# 说明：
可以直接在项目根目录下，运行命令flutter build aar生成aar包


