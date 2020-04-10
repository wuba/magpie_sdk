# magpie

magpie是一个flutter plugin,内部已为开发者集成了flutter engine等相关必要库，native开发同学无需安装flutter SDK；
magpie还内置包装了[FlutterBoost](https://github.com/alibaba/flutter_boost)路由及页面生命周期管理功能，新增了native与dart侧常用的一些通信能力，
提供协议动态注册等常用功能。     
(A Native-Futter hybrid development solution. Native developers do not need 
to install FlutterSDK. This Flutter plugin provides general capabilities such as routing management
 and dynamic protocol registration.）

## 目录结构

    -  lib
    -  ios      - source         Magpie iOS SDK 源码 , 可通过Pod集成
                - flutter        Flutter Engine , 可通过Pod集成
                - lib            Magpie iOS SDK 静态库，可通过Pod集成
                - lib_project    Magpie iOS SDK静态库编译工程
                - product        iOS debug demo app.framework 
    -  android                   Magpie android SDK源码，可通过gradle集成
    -  example  - android        android 示例工程 
                - ios            iOS 示例工程
                - lib            Dart 示例工程
                        
                 
## magpie版本说明
magpei plugin基于v1.12.13-hotfixes
如果你是native开发同学，那么可以不用安装flutter SDK，magpie内部已集成flutter engine等相关必要库

## 安装

### Dart代码的集成和使用
[Dart集成Magpie Plugin详见这里。](./lib/README.md)

### iOS代码集成和使用
[iOS集成MagpieBridge SDK详见这里。](./ios/README.md)

### Android代码集成和使用
[Android集成Magpie SDK详见这里。](./android/README.md)

## Examples
更详细的使用例子请参考example

## LICENSE
[BSD 3-Clause "New" or "Revised" License](LICENSE.md)


## 问题反馈

## 关于我们


## 致谢
我们在页面栈管理和路由功能上直接使用了FlutterBoost。FlutterBoost经历过长期的实践检验，提供的能力满足了我们这方面的所有需求。感谢FlutterBoost提供了这么优秀的能力。
