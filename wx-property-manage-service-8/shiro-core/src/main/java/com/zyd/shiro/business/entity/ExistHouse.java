package com.zyd.shiro.business.entity;

import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;
import java.util.Objects;


@Data
public class ExistHouse {

    private String houseId;

    private String village;

    private String building;

    private String location;

    private String room;
    //入住时间
    private String checkInTime;

    private String costId;

    private String costName;

    private String costType;

    private String carId="";

    private String carNo="";

    private String beginTime;

    private String endTime;

    private Date updateTime;

    private String costTypeClass;

    private String costTypeSection;

    private Integer payFlag;

    private String licensePlateNo;

    private Double unit;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ExistHouse that = (ExistHouse) o;
        return Objects.equals(village, that.village) &&
                Objects.equals(building, that.building) &&
                Objects.equals(location, that.location) &&
                Objects.equals(room, that.room) &&
                Objects.equals(costName, that.costName) &&
                Objects.equals(costType, that.costType) &&
                Objects.equals(carNo, that.carNo)&&
                Objects.equals(costTypeClass, that.costTypeClass) &&
                Objects.equals(costTypeSection, that.costTypeSection)&&
                Objects.equals(unit, that.unit);
    }

    @Override
    public int hashCode() {
        return Objects.hash(village, building, location, room, costName,
                costType, carNo, costTypeClass, costTypeSection, unit);
    }
}
