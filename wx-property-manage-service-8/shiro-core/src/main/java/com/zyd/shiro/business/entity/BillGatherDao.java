package com.zyd.shiro.business.entity;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class BillGatherDao {

    private String costName;

    private String costTypeSection;

    private BigDecimal pay;

    private String orderId;

    private int payType;

    private String remark;

}
