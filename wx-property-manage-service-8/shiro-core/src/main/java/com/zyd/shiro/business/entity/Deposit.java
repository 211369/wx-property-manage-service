package com.zyd.shiro.business.entity;

import com.zyd.shiro.framework.object.BaseConditionVO;
import lombok.Data;

import java.util.List;
import java.util.Objects;

@Data
public class Deposit extends BaseConditionVO {
    private String houseId;

    private String village;

    private List<String> villageList;

    private String building;

    private String location;

    private String room;

    private Double roomArea;

    private String ownerName;

    private String ownerPhone;

    private String idCardNo;

    private String reservePhone;

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

    private String payTime;

    private int status;

    private int payType;

    private int billType;

    private String refundType;

    private int refundFlag;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        if (!super.equals(o)) return false;
        Deposit deposit = (Deposit) o;
        return Objects.equals(houseId, deposit.houseId) &&
                Objects.equals(village, deposit.village) &&
                Objects.equals(building, deposit.building) &&
                Objects.equals(location, deposit.location) &&
                Objects.equals(room, deposit.room) &&
                Objects.equals(roomArea, deposit.roomArea) &&
                Objects.equals(ownerName, deposit.ownerName) &&
                Objects.equals(ownerPhone, deposit.ownerPhone) &&
                Objects.equals(idCardNo, deposit.idCardNo) &&
                Objects.equals(reservePhone, deposit.reservePhone) &&
                Objects.equals(costId, deposit.costId) &&
                Objects.equals(costName, deposit.costName) &&
                Objects.equals(beginTime, deposit.beginTime) &&
                Objects.equals(endTime, deposit.endTime) &&
                Objects.equals(unit, deposit.unit) &&
                Objects.equals(area, deposit.area) &&
                Objects.equals(pay, deposit.pay) &&
                Objects.equals(costType, deposit.costType) &&
                Objects.equals(costTypeClass, deposit.costTypeClass) &&
                Objects.equals(costTypeSection, deposit.costTypeSection) &&
                Objects.equals(carId, deposit.carId) &&
                Objects.equals(licensePlateNo, deposit.licensePlateNo);
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), houseId, village, building, location, room, roomArea, ownerName, ownerPhone, idCardNo, reservePhone, costId, costName, beginTime, endTime, unit, area, pay, costType, costTypeClass, costTypeSection, carId, licensePlateNo);
    }
}
