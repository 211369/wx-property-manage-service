package com.zyd.shiro.business.entity;

import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;


@Data
public class CollectionRate {
    private int year;

    private BigDecimal shouldMoney = new BigDecimal(0);

    private BigDecimal receiveMoney = new BigDecimal(0);

    private BigDecimal unReceiveMoney = new BigDecimal(0);

    private String remark;

    private String rate;
}
