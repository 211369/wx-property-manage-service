package com.zyd.shiro.business.entity;

import lombok.Data;

import java.io.Serializable;

@Data
public class OrderResult implements Serializable {

    private String outTradeId;

    private String traceNo;

    private String totalFee;

    private String transStatus;

    private String transDatetime;

    private String channelType;

    private String WEB_CHN;

    private String remark;

    private String sign;
}
