package com.wuba.magpie.vo;

/**
 * 注册实体
 * create by huangxin on 2019-12-02
 */
public class FlutterAction extends BaseAction {

    private String module;//一级类目标识
    private Class clz; //类类型
    private String method; //类方法

    public FlutterAction() {
    }

    public FlutterAction(String module, Class clz, String method) {
        this.module = module;
        this.clz = clz;
        this.method = method;
    }

    public String getModule() {
        return module;
    }

    public void setModule(String module) {
        this.module = module;
    }

    public Class getClz() {
        return clz;
    }

    public void setClz(Class clz) {
        this.clz = clz;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }


}
