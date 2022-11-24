package com.zyd.shiro.business.entity;

import lombok.Data;

import java.util.List;

@Data
public class HouseBill {

    private String houseId;

    private String village;

    private String building;

    private String location;

    private String room;

    private Double roomArea;

    private String ownerName;

    private String beginTime;

    private List<Config> configs;

    private List<BillExcel> billInfos;
}
