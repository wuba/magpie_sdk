import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magpie/magpie.dart';
import 'package:magpie/pub_plugins/flutter_boost/support/logger.dart';
import 'simple_page_widgets.dart';
import 'package:magpie/magpie_bridge.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Magpie.singleton.registerPageBuilders({
      'flutterFragment': (String pageName, Map<String, dynamic> params, String _) =>
          FragmentRouteWidget(params),
      'flutterPage': (String pageName, Map<String, dynamic> params, String _) {
        print("flutterPage params:$params");
        return FlutterRouteWidget(params:params);
      },
    });
    //
    MagpieBridge.singleton.addDataListener((name, params) async {
      var a = "来自Dart的数据 Name = $name , Key = ${params.keys.first}";
      return a;
    });

    MagpieBridge.singleton.addNativeActionListener('EventTest',
        (name, params) async {
      var a = "来自Dart的Event $name key = " + params.keys.first;
      return a;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'magpie example',
        builder: Magpie.init(postPush: _onRoutePushed),
        home: Container(color:Colors.white));
  }

  void _onRoutePushed(
      String pageName,
      String uniqueId,
      Map<String, dynamic> params,
      Route<dynamic> route,
      Future<dynamic> _,
      ) {}
}

class FragmentRouteWidget extends StatelessWidget {
  final Map params;

  FragmentRouteWidget(this.params);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('This is a flutter fragment'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: Text(
              params['tag'] ?? '',
              style: TextStyle(fontSize: 28.0, color: Colors.red),
            ),
            alignment: AlignmentDirectional.center,
          ),
          //Expanded(child: Container()),
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
            onTap: () => Magpie.singleton.open("sample://flutterPage"),
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
            onTap: () =>
                Magpie.singleton.open("native://nativePage",
                  urlParams: {"query": {"aaa": "bbb"}}, exts:{"exts":"hello"}).then((result){
                  assert(result == null || result is Map);
                  Map params = result;
                  if(params == null){
                    params = Map();
                  }
                  Logger.log("哈哈哈哈哈"+params.toString());
                }),
          ),
        ],
      ),
    );
  }
}




