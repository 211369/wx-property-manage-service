package com.zyd.shiro.business.entity;

import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
public class ChargeDTO {

    private HouseInfo houseInfo;

    private List<Charge> chargeList;

}
