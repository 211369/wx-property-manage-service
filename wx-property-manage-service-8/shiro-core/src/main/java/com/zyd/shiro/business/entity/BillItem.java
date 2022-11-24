package com.zyd.shiro.business.entity;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class BillItem {

    private String costId;

	private String orderId;
	
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

    private Integer isTimeChange;

    private String carId;

    private String orginTime;

    private String licensePlateNo;

    private BigDecimal before = new BigDecimal(0);

    private BigDecimal now = new BigDecimal(0);

    private BigDecimal after = new BigDecimal(0);

    private Integer billType;
}
