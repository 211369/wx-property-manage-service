package com.zyd.shiro.business.vo;

import lombok.Data;

@Data
public class OrderConditionVO {

    private String orderId;

    private String custId;

    private Integer status;

    private String moneyNeed;

    private String moneyReal;

    private Integer payType;

    private Integer gasType;

    private String dateTime;

    private String staffId;

}
