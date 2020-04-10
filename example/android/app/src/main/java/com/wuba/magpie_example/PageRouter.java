package com.wuba.magpie_example;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.util.Log;


import com.wuba.magpie.containers.MagpieFlutterActivity;

import java.util.HashMap;
import java.util.Map;

/**
 * 业务侧路由 demo
 */
public class PageRouter {

    //flutter page页面路由表
    public final static Map<String, String> flutterPageNameMap = new HashMap<String, String>() {{

        put("sample://flutterPage", "flutterPage");
        put("sample://youLiaodemoPage", "youLiaodemoPage");
    }};

    public static final String FLUTTER_PAGE_URL = "sample://flutterPage";
    public static final String NATIVE_PAGE_URL = "sample://nativePage";
    public static final String NATIVE_PAGE_URL1 = "native://nativePage";
    public static final String FLUTTER_FRAGMENT_PAGE_URL = "sample://flutterFragmentPage";

    public static final String youLiaodemoPage = "sample://youLiaodemoPage";

    public static boolean openPageByUrl(Context context, String url, HashMap params) {
        return openPageByUrl(context, url, params, 0);
    }

    /**
     * 具体路由分发，业务侧实现
     * @param context
     * @param url
     * @param params
     * @param requestCode
     * @return
     */
    public static boolean openPageByUrl(Context context, String url, HashMap params, int requestCode) {

        String path = url.split("\\?")[0];

        Log.i("openPageByUrl","path=" + path + "------" + "url=" + flutterPageNameMap.get(path));

        try {
            if (flutterPageNameMap.containsKey(path)) {
                //跳转flutter页面，携带参数
                Intent intent = MagpieFlutterActivity
                        .withNewEngine()
                        .url(flutterPageNameMap.get(path))
                        .params(params)
                        .backgroundMode(MagpieFlutterActivity.BackgroundMode.opaque)
                        .build(context);
                if(context instanceof Activity){
                    Activity activity=(Activity)context;
                    activity.startActivityForResult(intent,requestCode);
                }else{
                    context.startActivity(intent);
                }
                return true;
            } else if (url.startsWith(FLUTTER_FRAGMENT_PAGE_URL)) {
                //跳转native下的子flutter页面
                Intent intent = new Intent(context, FlutterFragmentPageActivity.class);
                intent.putExtra(MagpieFlutterActivity.EXTRA_PARAMS,params);
                context.startActivity(intent);
                return true;
            } else if (url.startsWith(NATIVE_PAGE_URL)) {

                //跳转native页面
                Intent intent = new Intent(context, NativePageActivity.class);
                intent.putExtra(MagpieFlutterActivity.EXTRA_PARAMS,params);
                context.startActivity(new Intent(context, NativePageActivity.class));
                return true;
            } else if(url.startsWith(NATIVE_PAGE_URL1)) {

                //跳转native页面
                Intent intent = new Intent(context, NativePageActivity.class);
                intent.putExtra(MagpieFlutterActivity.EXTRA_PARAMS,params);
                context.startActivity(intent);
                return true;
            }

            return false;

        } catch (Throwable t) {
            return false;
        }
    }
}
