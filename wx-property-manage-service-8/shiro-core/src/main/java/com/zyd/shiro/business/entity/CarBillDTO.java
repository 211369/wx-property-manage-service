package com.zyd.shiro.business.entity;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class CarBillDTO {

    private String village;

    private String building;

    private String location;

    private String room;

    private String costName;

    private String costType;

    private String costTypeClass;

    private String costTypeSection;

    private BigDecimal unit;

    private String carNo;

    private String licensePlateNo;

    private String beginTime;

    private String endTime;

    private String payTime;

    private BigDecimal paySum = new BigDecimal(0);
}
