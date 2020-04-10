package com.wuba.magpie_example.vo;

/**
 * create by huangxin on 2019-12-02
 */
public class User {

    private String uid;
    private String userName;

    public User() {
    }

    public User(String uid, String userName) {
        this.uid = uid;
        this.userName = userName;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }
}
