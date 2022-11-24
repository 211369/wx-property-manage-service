package com.zyd.shiro.business.entity;

import com.zyd.shiro.framework.object.BaseConditionVO;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
public class PropertyQryBill extends BaseConditionVO {
	
	private Long userId;
	
	private String orderId;

    private String village;

    private List<String> villages;

    private String building;

    private String location;

    private String room;

    private Double roomArea;

    private String ownerName;

    private String ownerPhone;

    private String idCardNo;

    private String reservePhone;

    private String costName;

    private String costType;

    private BigDecimal unit;

    private String carNo;

    private String beginTime;

    private String endTime;
    
    private String payType;
    
    private String checkFlag;
    
    private String checkBeginTime;

    private String checkEndTime;

    //false查物业费，true查车位费
    private boolean flag;
    
    private String receiptType;
    
    private String receiptTime;
    
    private String isExchange;
    //入住时间
    private String checkInTime;

    private Integer billType;

}
