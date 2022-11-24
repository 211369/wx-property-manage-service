package com.zyd.shiro.controller;

import com.github.pagehelper.PageInfo;
import com.zyd.shiro.business.entity.*;
import com.zyd.shiro.business.service.ReportService;
import lombok.extern.slf4j.Slf4j;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

/**
 * 报表管理
 */
@RestController
@Slf4j
public class ReportController {
    
    @Autowired
    private ReportService reportService;

    /**
     * 金佳开始
     */

    /**
     * 应收统计报表
     * @param qry
     * @return
     */
    @PostMapping("/report/arQuery")
    public ResponseEntity<Map<String,AccountReceiveRes>> arQuery(@RequestBody AccountReceiveReq qry) throws ParseException {
        Map<String,AccountReceiveRes> map = reportService.queryReceive(qry);
        return ResponseEntity.status(HttpStatus.OK).body(map);
    }

    /**
     * 预收统计明细
     * @param qry
     * @return
     */
    @PostMapping("/report/advanceQuery")
    public ResponseEntity<List<Deposit>> advanceQuery(@RequestBody Deposit qry) throws ParseException {
        List<Deposit> list = reportService.advanceQuery(qry);
        return ResponseEntity.status(HttpStatus.OK).body(list);
    }

    /**
     * 预收统计明细（分页）
     * @param qry
     * @return
     */
    @PostMapping("/report/advanceQueryPage")
    public ResponseEntity<PageInfo<Deposit>> advanceQueryPage(@RequestBody Deposit qry) throws ParseException {
        PageInfo<Deposit> list = reportService.advanceQueryPage(qry);
        return ResponseEntity.status(HttpStatus.OK).body(list);
    }

    /**
     * 欠费统计明细
     * @param qry
     * @return
     */
    @PostMapping("/report/debtQuery")
    public ResponseEntity<List<ReportDTO>> debtQuery(@RequestBody Deposit qry){
        List<ReportDTO> list = reportService.debtQuery(qry);
        return ResponseEntity.status(HttpStatus.OK).body(list);
    }

    /**
     * 欠费统计明细（分页）
     * @param qry
     * @return
     */
    @PostMapping("/report/debtQueryPage")
    public ResponseEntity<PageInfo<Deposit>> debtQueryPage(@RequestBody Deposit qry){
        PageInfo<Deposit> list = reportService.debtQueryPage(qry);
        return ResponseEntity.status(HttpStatus.OK).body(list);
    }

    /**
     * 退费统计明细（分页）
     * @param qry
     * @return
     */
    @PostMapping("/report/queryRefundPage")
    public ResponseEntity<PageInfo<Deposit>> queryRefundPage(@RequestBody Deposit qry){
        PageInfo<Deposit> list = reportService.queryRefundPage(qry);
        return ResponseEntity.status(HttpStatus.OK).body(list);
    }

    /**
     * 退费统计明细
     * @param qry
     * @return
     */
    @PostMapping("/report/queryRefund")
    public ResponseEntity<List<Deposit>> queryRefund(@RequestBody Deposit qry){
        List<Deposit> list = reportService.queryRefund(qry);
        return ResponseEntity.status(HttpStatus.OK).body(list);
    }

    /**
     * 金佳结束
     */

    /**
     * 联创开始
     */

    /**
     * 一览表(分页)
     * @param qry
     * @return
     */
    @PostMapping("/report/queryHouseBillPage")
    public ResponseEntity<PageInfo<HouseBillDTO>> queryHouseBill(@RequestBody AccountReceiveReq qry){
        PageInfo<HouseBillDTO> list = reportService.queryHouseBill(qry);
        return ResponseEntity.status(HttpStatus.OK).body(list);
    }

    /**
     * 一览表(不分页)
     * @param qry
     * @return
     */
    @PostMapping("/report/queryHouseBillAll")
    public ResponseEntity<List<HouseBillDTO>> queryHouseBillAll(@RequestBody AccountReceiveReq qry){
        List<HouseBillDTO> list = reportService.queryHouseBillAll(qry);
        return ResponseEntity.status(HttpStatus.OK).body(list);
    }

    /**
     * 日报表（分页）
     * @param qry
     * @return
     */
    @PostMapping("/report/queryDailyPage")
    public ResponseEntity<PageInfo<BillDetailDTO>> queryDailyPage(@RequestBody PropertyQryBill qry) throws ParseException {
        PageInfo<BillDetailDTO> result = reportService.queryDailyPage(qry);
        return ResponseEntity.status(HttpStatus.OK).body(result);
    }

    /**
     * 日报表（不分页）
     * @param qry
     * @return
     */
    @PostMapping("/report/queryDailyAll")
    public ResponseEntity<PageInfo<BillDetailDTO>> queryDailyAll(@RequestBody PropertyQryBill qry) throws ParseException {
        qry.setPageSize(99999);
        PageInfo<BillDetailDTO> result = reportService.queryDailyPage(qry);
        return ResponseEntity.status(HttpStatus.OK).body(result);
    }

    /**
     * 月报表
     * @param qry
     * @return
     */
    @PostMapping("/report/queryMonthly")
    public ResponseEntity<Map<String,Map<String, BigDecimal>>> queryMonthly(@RequestBody PropertyQryBill qry) throws ParseException {
        Map<String,Map<String, BigDecimal>> result = reportService.queryMonthly(qry);
        return ResponseEntity.status(HttpStatus.OK).body(result);
    }

    /**
     * 收缴率报表
     * @param qry
     * @return
     */
    @PostMapping("/report/queryCollectionRate")
    public ResponseEntity<List<CollectionRate>> queryCollectionRate(@RequestBody AccountReceiveReq qry) throws ParseException {
        List<CollectionRate> result = reportService.queryCollectionRate(qry);
        return ResponseEntity.status(HttpStatus.OK).body(result);
    }

    /**
     * 车位费报表(分页)
     * @param qry
     * @return
     */
    @PostMapping("/report/queryCarBillPage")
    public ResponseEntity<PageInfo<CarBillDTO>> queryCarBillPage(@RequestBody AccountReceiveReq qry) throws ParseException {
        PageInfo<CarBillDTO> list = reportService.queryCarBill(qry);
        return ResponseEntity.status(HttpStatus.OK).body(list);
    }

    /**
     * 车位费报表(不分页)
     * @param qry
     * @return
     */
    @PostMapping("/report/queryCarBillAll")
    public ResponseEntity<List<CarBillDTO>> queryCarBillAll(@RequestBody AccountReceiveReq qry) throws ParseException {
        List<CarBillDTO> list = reportService.queryCarBillAll(qry);
        return ResponseEntity.status(HttpStatus.OK).body(list);
    }

    /**
     * 保证金报表(分页)
     * @param qry
     * @return
     */
    @PostMapping("/report/queryEarnestPage")
    public ResponseEntity<PageInfo<HouseBill>> queryEarnestPage(@RequestBody AccountReceiveReq qry) throws ParseException {
        PageInfo<HouseBill> list = reportService.queryEarnestPage(qry);
        return ResponseEntity.status(HttpStatus.OK).body(list);
    }

    /**
     * 保证金报表(不分页)
     * @param qry
     * @return
     */
    @PostMapping("/report/queryEarnestAll")
    public ResponseEntity<List<HouseBill>> queryEarnestAll(@RequestBody AccountReceiveReq qry) throws ParseException {
        List<HouseBill> list = reportService.queryEarnestAll(qry);
        return ResponseEntity.status(HttpStatus.OK).body(list);
    }

    /**
     * 联创结束
     */

}
