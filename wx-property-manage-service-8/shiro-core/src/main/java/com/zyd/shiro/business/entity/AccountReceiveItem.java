package com.zyd.shiro.business.entity;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class AccountReceiveItem {

    private String orderId;

    private String houseId;

    private String payTime;

    private String costType;

    private String costName;

    private BigDecimal pay;

    private BigDecimal unit;

    private String costTypeSection;

    private String costTypeClass;

    private String beginTime;

    private String endTime;

    private String carNo;

    private Double roomArea;

    private Integer billType;
}
