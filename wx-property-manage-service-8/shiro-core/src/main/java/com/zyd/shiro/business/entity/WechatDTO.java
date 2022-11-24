package com.zyd.shiro.business.entity;

import lombok.Data;

@Data
public class WechatDTO {

    private String openId;

    private String orderId;

    private Double money;
}
