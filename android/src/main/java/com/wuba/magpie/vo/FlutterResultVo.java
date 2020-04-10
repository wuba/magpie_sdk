package com.wuba.magpie.vo;

import java.util.Map;

/**
 * create by huangxin on 2019-12-02
 */
public class FlutterResultVo {

    private Map<String, Object> result;

    public FlutterResultVo() {
    }

    public FlutterResultVo(Map<String, Object> result) {
        this.result = result;
    }

    public Map<String, Object> getResult() {
        return result;
    }

    public void setResult(Map<String, Object> result) {
        this.result = result;
    }
}
