package com.zyd.shiro.business.service;

import com.github.pagehelper.PageInfo;
import com.zyd.shiro.business.entity.*;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ChargeService {

    List<String> queryBuildingByVillage(String village);

    List<String> queryHouse(String village, String building,String location);

    HouseInfo queryHouseInfo(String village, String building,String location,String room);

    ChargeDTO queryCharge(String village, String building,String location, String room,int year);

    Map<String,Object> pay(PayDTO payDTO);

    void notifyOrder(OrderResult orderResult);

    List<String> queryLocationByVillageBuilding(String village, String building);




    Double countRefundMoney(BillItem billItem);

    Map<String, Object> refund(BillInfo billInfo);

    Map<String, Object> depositRefund(BillInfo billInfo,BillItem billItem);

    BillInfoDTO queryBill(String village, String building, String location, String room, Integer page, Integer pageSize);

    Double countPay(BillItem billItem);

    PageInfo<Deposit> queryDeposit(Deposit deposit);

    PageInfo<Deposit> queryRefundList(Deposit deposit);

    List<ChargeDTO> queryBind(String phone);
    void addBind(String phone, String houseId);
    void deleteBind(String phone, String houseId);

    Map<String, String> getAuth(String code);

    String saveAuth(Auth auth);
}
