package com.zyd.shiro.business.entity;

import lombok.Data;

import java.util.Date;


@Data
public class Car {
    private String carId;

    private String houseId;

    private String costId;

    private String carNo;

    private String licensePlateNo;

    private Date updateTime;
}
