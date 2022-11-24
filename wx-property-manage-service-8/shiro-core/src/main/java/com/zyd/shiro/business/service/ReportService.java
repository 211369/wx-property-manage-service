package com.zyd.shiro.business.service;

import com.github.pagehelper.PageInfo;
import com.zyd.shiro.business.entity.*;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

public interface ReportService {
    Map<String,AccountReceiveRes> queryReceive(AccountReceiveReq accountReceiveReq) throws ParseException;
    List<Deposit> advanceQuery(Deposit deposit) throws ParseException;
    PageInfo<Deposit> advanceQueryPage(Deposit deposit) throws ParseException;
    List<ReportDTO> debtQuery(Deposit deposit);
    PageInfo<Deposit> debtQueryPage(Deposit deposit);
    PageInfo<Deposit> queryRefundPage(Deposit deposit);
    List<Deposit> queryRefund(Deposit deposit);
    PageInfo<HouseBillDTO> queryHouseBill(AccountReceiveReq qry);
    List<HouseBillDTO> queryHouseBillAll(AccountReceiveReq qry);
    void houseBillForJob() throws ParseException;
    PageInfo<BillDetailDTO> queryDailyPage(PropertyQryBill qry) throws ParseException;
    Map<String,Map<String, BigDecimal>> queryMonthly(PropertyQryBill qry) throws ParseException;
    List<CollectionRate> queryCollectionRate(AccountReceiveReq qry) throws ParseException;
    PageInfo<CarBillDTO> queryCarBill(AccountReceiveReq qry) throws ParseException;
    List<CarBillDTO> queryCarBillAll(AccountReceiveReq qry) throws ParseException;
    PageInfo<HouseBill> queryEarnestPage(AccountReceiveReq qry);
    List<HouseBill> queryEarnestAll(AccountReceiveReq qry);
}
