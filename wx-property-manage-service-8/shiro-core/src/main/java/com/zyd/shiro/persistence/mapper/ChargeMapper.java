package com.zyd.shiro.persistence.mapper;

import com.zyd.shiro.business.entity.BillInfo;
import com.zyd.shiro.business.entity.BillItem;
import com.zyd.shiro.business.entity.Charge;
import com.zyd.shiro.business.entity.Deposit;
import com.zyd.shiro.business.entity.HouseInfo;
import com.zyd.shiro.persistence.beans.SysVillage;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChargeMapper {

    List<String> queryBuildingByVillage(String village);

    List<String> queryHouse(@Param("village") String village, @Param("building") String building, @Param("location") String location);

    HouseInfo queryHouseInfo(@Param("village") String village, @Param("building") String building,
                             @Param("location") String location, @Param("room") String room);

    List<Charge> queryCharge(String houseId);

    void insertBillInfo(BillInfo billInfo);

    void updateConfig(@Param("houseId") String houseId, @Param("costId") String costId, @Param("carId") String carId, @Param("day") String day, @Param("updateTime") String updateTime);

    void deleteConfig(@Param("houseId") String houseId, @Param("costId") String costId, @Param("carId") String carId);

    void insertBillItem(BillItem billItem);

    List<String> queryLocationByVillageBuilding(@Param("village") String village, @Param("building") String building);


    void updateBillInfo(@Param("orderId") String orderId, @Param("status") Integer status, @Param("outTradeId") String outTradeId);

    void updateBillRefund(@Param("orderId") String orderId, @Param("refundFlag") Integer refundFlag);

    void deleteBillRefund(@Param("orderId") String orderId);

    List<BillInfo> queryBill(@Param("village") String village, @Param("building") String building,
                             @Param("location") String location, @Param("room") String room);

    String queryCarId(@Param("carNo") String carNo, @Param("houseId") String houseId, @Param("costId") String costId);

    List<BillItem> queryItemById(String orderId);

    BillInfo queryBillInfoById(String orderId);

    Charge queryEffectiveTime(@Param("houseId") String houseId, @Param("carId") String carId, @Param("costId") String costId);

    String queryNameById(Long userId);

    void insertConfig(@Param("houseId") String houseId, @Param("costId") String costId, @Param("carId") String carId,
                      @Param("beginDate") String beginDate, @Param("endDate") String endDate, @Param("updateTime") String updateTime);

    int existBill(@Param("houseId") String houseId, @Param("orderId") String orderId, @Param("bill") BillItem billItem);

    String getOutTradeId(@Param("orderId") String orderId);

    List<Deposit> queryDeposit(Deposit deposit);

    List<Deposit> queryRefundList(Deposit deposit);

    List<String> getVillage(String username);

    List<HouseInfo> queryBind(String phone);

    void addBind(@Param("phone") String phone, @Param("houseId") String houseId);

    void deleteBind(@Param("phone") String phone, @Param("houseId") String houseId);


    String queryPhone(String openid);

    void saveAuth(@Param("phone") String result, @Param("openId") String openId);

    SysVillage queryShopIdByHouseId(String houseId);
}
