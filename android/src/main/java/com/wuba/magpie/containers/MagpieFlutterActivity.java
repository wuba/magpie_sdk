package com.wuba.magpie.containers;

import android.os.Bundle;

import androidx.annotation.Nullable;

import com.idlefish.flutterboost.containers.BoostFlutterActivity;

/**
 * create by huangxin on 2019-12-06
 */
public class MagpieFlutterActivity extends BoostFlutterActivity {

    public static final String EXTRA_PARAMS = "params";

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    public static NewEngineIntentBuilder withNewEngine() {
        return new NewEngineIntentBuilder(MagpieFlutterActivity.class);
    }


}
