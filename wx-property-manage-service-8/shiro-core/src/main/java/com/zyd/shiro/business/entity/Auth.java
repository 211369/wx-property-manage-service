package com.zyd.shiro.business.entity;

import lombok.Data;

@Data
public class Auth {

    private String encryptedData;

    private String iv;

    private String code;

    private String openId;
}
