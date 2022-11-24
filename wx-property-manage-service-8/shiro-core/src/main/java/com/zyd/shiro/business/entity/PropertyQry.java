package com.zyd.shiro.business.entity;

import com.zyd.shiro.framework.object.BaseConditionVO;
import lombok.Data;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;


@Data
public class PropertyQry extends BaseConditionVO {

    private String houseId;

    private String carId="";

    private String costId;

    private String village;

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

    private String costTypeClass;

    private String costTypeSection;

    private BigDecimal unit;

    private String carNo;

    private String beginTime;

    private String endTime;
    
    private String payType;
    
    private String checkFlag;
    
    private String checkBeginTime;

    private String checkEndTime;

    private String licensePlateNo;

    //false查物业费，true查车位费
    private boolean flag;
    //入住时间
    private String checkInTime;
}
