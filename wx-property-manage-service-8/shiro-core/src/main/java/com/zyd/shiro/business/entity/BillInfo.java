package com.zyd.shiro.business.entity;

import java.math.BigDecimal;
import java.util.List;

import lombok.Data;

@Data
public class BillInfo {

	private String orderId;
    
    private String houseId;

    private BigDecimal paySum;

    private String payTime;

    private int checkFlag;

    private String checkTime;

    private int payType;

    private int billType;

    private Integer status;
    
    private String house;
    
    private String ownerName;
    
    private String ownerPhone;

    private String receiveName;

    private List<BillItem> billItemList;

    private String receiptType;
    
    private String receiptTime;
    
    private int isExchange;
    
    private String receiptCode;

    private String remark;

    private int refundFlag;

    private String outTradeId;

}
