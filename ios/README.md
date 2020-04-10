
# 平台工程加入Magpie SDK 依赖
## 设置环境变量
平台工程的Podfile中需在target ‘***’ do 前面加上以下代码(1 = debug  0 = release)

    ENV['debug'] = '1'

或者 在 pod intall的前面加上参数

    env debug=0 pod install

## 集成Magpie SDK

Podfile中需在target ‘***’ do 后面加入

### 源码

    pod 'MagpieBridge', :path => 'magpie/ios/source'

### 静态库

    pod 'MagpieBridge', :path => 'magpie/ios/lib'
## 集成Flutter SDK

Podfile中需在target ‘***’ do 后面加入

    pod 'Flutter', :path => 'magpie/ios/flutter'

## 依赖配置

使用Magpie 头文件的的Pod需在Podspec中加入依赖

    *.dependency 'MagpieBridge'

使用Flutter 头文件的的Pod需在Podspec中加入依赖

    *.dependency 'Flutter'

## 架构

### MagpieBridge.a.
支持 x86_64 armv7 arm64

### Flutter.framework
release支持 armv7 arm64
debug支持 x86_64 armv7 arm64

# SDK结构

- MagpieBridge.a 静态库文件
- MagpieBridge.podspec podsepc文件
- Headers
- README.MD 说明

# 平台工程要求
## App.framework文件说明
- App 库文件
- Info.plist
- flutter_assets 资源目录
- isolate_snapshot_data debug模式下用于加速isolate启动
- kernel_blob.bin debug模式下Dart代码产物
- vm_snapshot_data debug模式下用于加速dart vm启动

## 环境
App.framework必须与Flutter.framework保持环境一致

## 集成
本工程提供了demo的debug环境的app.framework，Podfile中需在target ‘***’ do 后面加入

     pod 'FlutterBusiness', :path => 'magpie/ios/product'
    
## 调试

debug模式下可通过attach命令调试Dart代码
1.安装iOS app并运行。
2.在Dart侧运行Flutter attach（建议使用IDE的attach功能）
3.输入R后进入Flutter页面
4.输入 r: hotreload R: hotrestart

## Podspec配置
s.vendored_frameworks = ‘App.framework’


# 功能详解

## 基本功能

### 实现MagpiePlatform协议

	@protocol MagpiePlatform <NSObject>
	@optional
	/**
	 * Dart代码入口，默认为main()
	 */
	- (NSString *)entryForDart;

	/**
	 * Dart业务资源文件
	 * Bundle中必须有info.plist ,其中必须有 key:@"FLTAssetsPath"，value为flutter_assets目录在bundle中的位置，例: @"/flutter_assets"
	 */
	- (NSBundle *)dartBundle;

	@required

	/**
	 * Dart的页面打开能力依赖这个实现
	 *
	 * @param url 打开的页面资源定位符
	 * @param urlParams 传人页面的参数;
	 * @param exts 额外参数
	 * @param completion 打开页面的即时回调，页面一旦打开即回调
	 */
	- (void)open:(NSString *)url
   	urlParams:(NSDictionary *)urlParams
    exts:(NSDictionary *)exts
	  completion:(void (^)(BOOL finished))completion;

	/**
	 * 关闭页面
	 *
	 * @param uid 关闭的页面唯一ID符
	 * @param result 页面要返回的结果，open方法参数resultCallback的回调参数
	 * @param exts 额外参数
	 * @param completion 关闭页面的即时回调，页面一旦关闭即回调
	 */
	- (void)close:(NSString *)uid
	   result:(NSDictionary *)result
     exts:(NSDictionary *)exts
	   completion:(void (^)(BOOL finished))completion;
	@end

### 初始化引擎,应在使用Flutter之前调用

	+ (void)startFlutterWithPlatform:(id<MagpiePlatform>)platform onStart:(void (^)(FlutterEngine *engine))callback;

platform需要遵循<MagpiePlatform>协议。

### Flutter engine是否已初始化

	+ (BOOL)isRunning;

### 向Dart发送事件

	+ (void)sendEvent:(NSString *)eventName params:(NSDictionary *)params;

### 向Dart发送数据请求

	+ (void)obtainData:(NSString *)key params:(NSDictionary *)params completion:(FlutterResult )result;

### 设置来自Dart数据请求的响应回调

	+ (void)setDataRequestHandler:(MagpieCallBack)handler;

### 设置来自Dart日志请求的响应回调

+ (void)setLogHandler:(MagpieVoidCallBack)handler;

## 混合栈路由

### 初始化Futter的载体页

	+ (FlutterViewController <MagpieContainer> *)flutterViewController;

### Flutter engine当前持有的载体页

	+ (FlutterViewController <MagpieContainer> *)currentViewController;

### 打开新页面

	+ (void)open:(NSString *)url urlParams:(NSDictionary *)urlParams exts:(NSDictionary *)exts onPageFinished:(void (^)(NSDictionary *result))resultCallback completion:(void (^)(BOOL finished))completion;
具体的路由操作需要由实现了MagpiePlatform协议的对象实施。

### 关闭页面

	+ (void)close:(NSString *)uniqueId result:(NSDictionary *)resultData exts:(NSDictionary *)exts completion:(void (^)(BOOL finished))completion;

## Module注册

注册Module的类需要遵循<MagpieBridgeProtocol>协议。

### 自动注册Module

	MAGPIE_EXPORT_MODULE(name)
### 自动注册Action实现

	MAGPIE_EXPORT_METHOD(action)
### 手动注册Module

	@synthesize params;
	@synthesize result;
	+ (void)load{
	    [MagpieBridge registerModule:@"testModule" forClass:self];
	}

### 手动注册Action实现

	- (void)magpie_action{
	    //Do Something
	}

# 其他

具体API的使用见DEMO
