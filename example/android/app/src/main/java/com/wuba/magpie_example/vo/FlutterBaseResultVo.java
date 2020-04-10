package com.wuba.magpie_example.vo;

/**
 * 返回实体，两侧自行约定
 * create by huangxin on 2019-12-04
 */
public class FlutterBaseResultVo {

    private int resultCode;
    private String msg;
    private Object resultObj;

    public int getResultCode() {
        return resultCode;
    }

    public void setResultCode(int resultCode) {
        this.resultCode = resultCode;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Object getResultObj() {
        return resultObj;
    }

    public void setResultObj(Object resultObj) {
        this.resultObj = resultObj;
    }
}
