package com.zyd.shiro.persistence.mapper;

import com.zyd.shiro.business.entity.*;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ReportMapper {
    List<AccountReceiveItem> queryReceive(AccountReceiveReq accountReceiveReq);
    List<AccountReceiveItem> queryShould(AccountReceiveReq accountReceiveReq);
    List<Deposit> advanceQuery(Deposit deposit);
    List<Deposit> debtQuery(Deposit deposit);
    List<Deposit> queryRefund(Deposit deposit);
    List<HouseBill> queryHouseBill(String village);
    List<BillItem> queryDetails(PropertyQryBill qry);
    void deleteHouseBill(@Param("year") int year, @Param("village") String village);
    void addHouseBill(@Param("list") List<HouseBillDTO> list,@Param("year") int year);
    List<HouseBillDTO> queryHouseBillDetail(@Param("year") int year, @Param("village") String village);
    List<CarBill> queryCarBill(String village);
    List<HouseBill> queryEarnest(String village);
}
