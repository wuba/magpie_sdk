package com.wuba.magpie.containers;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.idlefish.flutterboost.containers.BoostFlutterActivity;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;

/**
 * create by hxin on 2019-12-06
 */
public class MagpieOriginalFlutterActivity extends FlutterActivity {

    // Default configuration.
    protected static final String DEFAULT_BACKGROUND_MODE = BoostFlutterActivity.BackgroundMode.opaque.name();

    protected static final String EXTRA_BACKGROUND_MODE = "background_mode";
    protected static final String EXTRA_DESTROY_ENGINE_WITH_ACTIVITY = "destroy_engine_with_activity";


    protected static final String EXTRA_URL = "url";
    protected static final String EXTRA_PARAMS = "params";


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    public static Intent createDefaultIntent(@NonNull Context launchContext) {
        return withNewEngine().build(launchContext);
    }

    public static MagpieEngineIntentBuilder withNewEngine(Class<? extends MagpieOriginalFlutterActivity> activityClass) {
        return new MagpieEngineIntentBuilder(activityClass);
    }

    public static class MagpieEngineIntentBuilder {

        private final Class<? extends MagpieOriginalFlutterActivity> activityClass;
        private String backgroundMode = DEFAULT_BACKGROUND_MODE;
        private String url = "";
        private Map params = new HashMap();

        protected MagpieEngineIntentBuilder(@NonNull Class<? extends MagpieOriginalFlutterActivity> activityClass) {
            this.activityClass = activityClass;
        }

        public MagpieEngineIntentBuilder url(@NonNull String url) {
            this.url = url;
            return this;
        }

        public MagpieEngineIntentBuilder params(@NonNull Map params) {
            this.params = params;
            return this;
        }


        public MagpieEngineIntentBuilder backgroundMode(@NonNull BackgroundMode backgroundMode) {
            this.backgroundMode = backgroundMode.name();
            return this;
        }


        public Intent build(@NonNull Context context) {

            SerializableMap serializableMap = new SerializableMap();
            serializableMap.setMap(params);

            return new Intent(context, activityClass)
                    .putExtra(EXTRA_BACKGROUND_MODE, backgroundMode)
                    .putExtra(EXTRA_DESTROY_ENGINE_WITH_ACTIVITY, false)
                    .putExtra(EXTRA_URL, url)
                    .putExtra(EXTRA_PARAMS, serializableMap);
        }

    }

    public static class SerializableMap implements Serializable {

        private Map<String, Object> map;

        public Map<String, Object> getMap() {
            return map;
        }

        public void setMap(Map<String, Object> map) {
            this.map = map;
        }
    }


    /**
     * The mode of the background of a {@code FlutterActivity}, either opaque or transparent.
     */
    public enum BackgroundMode {
        /**
         * Indicates a FlutterActivity with an opaque background. This is the default.
         */
        opaque,
        /**
         * Indicates a FlutterActivity with a transparent background.
         */
        transparent
    }



}
