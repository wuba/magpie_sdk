import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magpie/magpie_bridge.dart';
import 'package:magpie/pub_plugins/flutter_boost/support/logger.dart';
import 'platform_view.dart';
import 'package:magpie/magpie.dart';

class FirstRouteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Open second route'),
          onPressed: () {
            print("open second page!");
            Magpie.singleton.open("second").then((Map value) {
              print(
                  "call me when page is finished. did recieve second route result $value");
            });
          },
        ),
      ),
    );
  }
}

class SecondRouteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to first route when tapped.

            BoostContainerSettings settings =
                BoostContainer.of(context).settings;
            Magpie.singleton.close(settings.uniqueId,
                result: {"result": "data from second"});
          },
          child: Text('Go back with result!'),
        ),
      ),
    );
  }
}

class TabRouteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tab Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Magpie.singleton.open("second");
          },
          child: Text('Open second route'),
        ),
      ),
    );
  }
}

class PlatformRouteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Platform Route"),
      ),
      body: Center(
        child: RaisedButton(
          child: TextView(),
          onPressed: () {
            print("open second page!");
            Magpie.singleton.open("second").then((Map value) {
              print(
                  "call me when page is finished. did recieve second route result $value");
            });
          },
        ),
      ),
    );
  }
}

class FlutterRouteWidget extends StatefulWidget {
  FlutterRouteWidget({this.params, this.message});
  final Map params;
  final String message;

  @override
  _FlutterRouteWidgetState createState() => _FlutterRouteWidgetState();
}

class _FlutterRouteWidgetState extends State<FlutterRouteWidget> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String message = widget.message;
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        textTheme: new TextTheme(title: TextStyle(color: Colors.black)),
        title: Text('This is a flutter activity'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                child: Text(
                  message ?? "params:${widget.params}",
                  style: TextStyle(fontSize: 28.0, color: Colors.blue),
                ),
                alignment: AlignmentDirectional.center,
              ),
//                Expanded(child: Container()),
              const CupertinoTextField(
                prefix: Icon(
                  CupertinoIcons.person_solid,
                  color: CupertinoColors.lightBackgroundGray,
                  size: 28.0,
                ),
                padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
                clearButtonMode: OverlayVisibilityMode.editing,
                textCapitalization: TextCapitalization.words,
                autocorrect: false,
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 0.0, color: CupertinoColors.inactiveGray)),
                ),
                placeholder: 'Name',
              ),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Color(0xFFF59A23),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Text(
                      'open native page',
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                    )),

                ///后面的参数会在native的IPlatform.startActivity方法回调中拼接到url的query部分。
                ///例如：sample://nativePage?aaa=bbb
                onTap: () =>
                    Magpie.singleton.open("native://nativePage", urlParams: {
                  "query": {"aaa": "bbb"}
                }).then((result){
                      assert(result == null || result is Map);
                      Map params = result;
                      if(params == null){
                        params = Map();
                      }
                      showMyCupertinoDialog(context, "", params);
                      Logger.log("native页面返回数据："+params.toString());
                    }),
              ),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Color(0xFFF59A23),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Text(
                      'open flutter page',
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                    )),

                ///后面的参数会在native的IPlatform.startActivity方法回调中拼接到url的query部分。
                ///例如：sample://nativePage?aaa=bbb
                onTap: () =>
                    Magpie.singleton.open("sample://flutterPage", urlParams: {
                  "query": {"aaa": "bbb"}
                }).then((result){
                      assert(result == null || result is Map);
                      Map params = result;
                      if(params == null){
                        params = Map();
                      }
                      showMyCupertinoDialog(context, "", params);
                      Logger.log("flutter页面返回数据："+params.toString());
                    }),
              ),
              Platform.isAndroid
                  ? InkWell(
                      child: Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Color(0xFFF59A23),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: Text(
                            'open flutter fragment page',
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                          )),
                      onTap: () =>
                          Magpie.singleton.open("sample://flutterFragmentPage"),
                    )
                  : new Container(),
              InkWell(
                  child: Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFF59A23),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: Text(
                        'sendDataRequestToNative',
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                      )),
                  onTap: () => MagpieBridge.singleton.sendDataRequestToNative(
                          'getDeviceInfo', {'param': '1'},
                          (name, params) async {
                        showMyCupertinoDialog(context, name, params);
                      })),
              InkWell(
                  child: Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFF59A23),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: Text(
                        'sendActionToNativeWithCallBack',
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                      )),
                  onTap: () => MagpieBridge.singleton
                          .sendActionToNativeWithCallBack(
                              'testModule', 'uploadLog', {'ccc': 'ddd'},
                              (name, params) async {
                        showMyCupertinoDialog(context, name, params);
                      })),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Color(0xFFF59A23),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Text(
                      'sendNotificationToNative',
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                    )),
                onTap: () => MagpieBridge.singleton
                    .sendNotificationToNative('notification', {'aaa': 'bbb'}),
              ),
              InkWell(
                  child: Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFF59A23),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: Text(
                        'sendDataRequestToNative1',
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                      )),
                  onTap: () => MagpieBridge.singleton.sendDataRequestToNative(
                      'do_action', {"path":"getUserInfo","jumpParameter":{"key1":"value1"}},
                          (name, params) async {
                        showMyCupertinoDialog(context, name, params);
                      })),
//                InkWell(
//                  child: Container(
//                      padding: const EdgeInsets.all(8.0),
//                      margin: const EdgeInsets.all(8.0),
//                      decoration: BoxDecoration(
//                        color: Color(0xFFF59A23),
//                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                      ),
//                      child: Text(
//                        'sendLogToNative',
//                        style: TextStyle(fontSize: 18.0, color: Colors.black),
//                      )),
//                  onTap: () =>  MagpieBridge.singleton.sendLogToNative('testLog', {'source':'flutter'},null),
//                ),
            ],
          ),
        ),
      ),
    );
  }
}

void showMyCupertinoDialog(BuildContext context, String name, Map params) {
  showCupertinoDialog(
      context: context,
      builder: (context) {
        return new CupertinoAlertDialog(
          title: new Text(name),
          content: new Text(name + params.toString()),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop("点击了确定");
              },
              child: new Text("确认"),
            ),
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop("点击了取消");
              },
              child: new Text("取消"),
            ),
          ],
        );
      });
}

class PushWidget extends StatefulWidget {
  @override
  _PushWidgetState createState() => _PushWidgetState();
}

class _PushWidgetState extends State<PushWidget> {
  VoidCallback _backPressedListenerUnsub;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

//    if (_backPressedListenerUnsub == null) {
//      _backPressedListenerUnsub =
//          BoostContainer.of(context).addBackPressedListener(() {
//        if (BoostContainer.of(context).onstage &&
//            ModalRoute.of(context).isCurrent) {
//          Navigator.pop(context);
//        }
//      });
//    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _backPressedListenerUnsub?.call();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterRouteWidget(message: "Pushed Widget");
  }
}
