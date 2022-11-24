package com.zyd.shiro.business.entity;

import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;


@Data
public class Config {

    private String costId;

    private String village;

    private String costName;

    private String costType;

    private String costTypeClass;

    private String costTypeSection;

    private BigDecimal unit;

    private int delFlag = 1;

    private Date updateTime;

    private String mark;
}
