package com.zyd.shiro.business.entity;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class HouseBillDTO {

    private String houseId;

    private String village;

    private String building;

    private String location;

    private String room;

    private BigDecimal roomArea;

    private String ownerName;

    private BigDecimal monthMoney;

    private BigDecimal yearMoney;

    private BigDecimal shouldMoney = new BigDecimal(0);

    private String payTime;

    private String beginTime;

    private String endTime;

    private BigDecimal receiveMoney = new BigDecimal(0);

    private BigDecimal unReceiveMoney = new BigDecimal(0);

    private String discount;

    private String remark;
}
