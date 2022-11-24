package com.zyd.shiro.business.entity;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class Charge {

    private String costId;

    private String costName;

    private String costType;

    private String costTypeClass;

    private String costTypeSection;

    private String beginTime;

    private String endTime;

    private BigDecimal unit;

    private Double totalMoney;

    private String carNo;

    private String licensePlateNo;

}
