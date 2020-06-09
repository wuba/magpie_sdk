package com.wuba.magpie.interfaces;


import android.content.Context;


import com.idlefish.flutterboost.interfaces.INativeRouter;

import java.util.Map;

/**
 * create by huangxin on 2019-12-06
 */
public interface IMagpienativeRouter {

    public void openContainer(Context context, String url,
                              Map<String,Object> urlParams,
                              int requestCode, Map<String,Object> exts);

}
