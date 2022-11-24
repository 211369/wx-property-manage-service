package com.zyd.shiro.business.entity;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class AccountReceiveRes {
    //预收
    private BigDecimal advanceMoney = new BigDecimal("0");

    private Integer advanceNum = 0;

    //欠收
    private BigDecimal debtMoney = new BigDecimal("0");

    private Integer debtNum = 0;

    //当收
    private BigDecimal receivedMoney = new BigDecimal("0");

    private Integer receivedNum = 0;

    //应收
    private BigDecimal receiveMoney = new BigDecimal("0");

    private Integer receiveNum = 0;

    //退
    private BigDecimal refundMoney = new BigDecimal("0");

    private Integer refundNum = 0;

    //本期收入=预+当+欠-退
    private BigDecimal realMoney = new BigDecimal("0");

    private Integer realNum = 0;

    //收缴率（不含欠）
    private String noDebtPercent;

    //收缴率（含欠）
    private String receivedPercent;
}
