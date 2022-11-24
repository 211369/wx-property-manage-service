package com.zyd.shiro.business.entity;

import lombok.Data;

import java.util.List;

@Data
public class ReportDTO {

    private HouseInfo houseInfo;

    private List<Deposit> deposits;

}
