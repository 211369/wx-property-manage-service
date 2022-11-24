package com.zyd.shiro.business.entity;

import lombok.Data;

import java.math.BigDecimal;


@Data
public class PropertyExcel {

    private String village;

    private String building;

    private String location;

    private String room;

    private Double roomArea;

    private String ownerName;

    private String ownerPhone;

    private String idCardNo;

    private String reservePhone;
    //入住时间
    private String checkInTime;

    private String costName;

    private String costType;

    private String costTypeClass;

    private String costTypeSection;

    private BigDecimal unit;

    private String carNo;

    private String beginTime;

    private String endTime;

    private String licensePlateNo;
}
