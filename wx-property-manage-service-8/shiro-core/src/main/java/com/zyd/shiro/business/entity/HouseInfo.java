package com.zyd.shiro.business.entity;

import com.zyd.shiro.framework.object.BaseConditionVO;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;


@Data
public class HouseInfo extends BaseConditionVO {

    private String houseId;

    private String village;

    private String building;

    private String location;

    private String room;

    private Double roomArea;

    private String ownerName;

    private String ownerPhone;

    private String idCardNo;

    private String reservePhone;

    private Date updateTime;
    //入住时间
    private String checkInTime;

    private BigDecimal charge;
}
