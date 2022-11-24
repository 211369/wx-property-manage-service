package com.zyd.shiro.business.entity;

import lombok.Data;

import java.math.BigDecimal;


@Data
public class BillExcel {

    //业主相关
    private String village;

    private String building;

    private String location;

    private String room;

    private Double roomArea;

    private String ownerName;

    private String ownerPhone;

    private String idCardNo;

    private String reservePhone;

    private String checkInTime;

    //订单相关
    private String orderId;

    private BigDecimal paySum;

    private String payTime;

    private int checkFlag;

    private String checkTime;

    private int payType;

    private String receiptType;

    private String receiptTime;

    private int isExchange;

    private String receiptCode;

    private String remark;

    private int refundFlag;

    private Integer billType;

    //订单明细相关
    private String costName;

    private String beginTime;

    private String endTime;

    private Double unit;

    private Double area;

    private Double discount;

    private String discountRate;

    private Double pay;

    private String costType;

    private String costTypeClass;

    private String costTypeSection;

    private String carNo;

    private String licensePlateNo;
}
