package com.zyd.shiro.controller;

import com.github.pagehelper.PageInfo;
import com.zyd.shiro.business.entity.*;
import com.zyd.shiro.business.service.ConfigService;
import com.zyd.shiro.business.service.BillService;
import lombok.extern.slf4j.Slf4j;

import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 财务管理
 */
@RestController
@Slf4j
public class BillController {
    @Autowired
    private BillService billService;
    
    @Autowired
    private ConfigService configService;
    
    /**
     * 财务管理列表查询
     * @param qry
     * @return
     */
    @PostMapping("/bill/queryFinancial")
    public ResponseEntity<PageInfo<BillDetailDTO>> queryFinancial(@RequestBody PropertyQryBill qry){
        qry.setBillType(0);
    	Long userId = (Long)SecurityUtils.getSubject().getPrincipal();
        List<String> villages = configService.queryVillageByUserId(userId);
        if (villages.size() != 0){
        	qry.setUserId(userId);
        }
    	PageInfo<BillDetailDTO> result = billService.queryFinancial(qry);
        return ResponseEntity.status(HttpStatus.OK).body(result);
    }

    /**
     * 财务管理列表查询（不分页）
     * @param qry
     * @return
     */
    @PostMapping("/bill/queryFinancialAll")
    public ResponseEntity<List<BillExcel>> queryFinancialAll(@RequestBody PropertyQryBill qry){
        List<BillExcel> result = billService.queryFinancialAll(qry);
        return ResponseEntity.status(HttpStatus.OK).body(result);
    }

    /**
     * 财务管理汇总查询
     * @param qry
     * @return
     */
    @PostMapping("/bill/queryGather")
    public ResponseEntity<Map<String,List<BillGather>>> queryGather(@RequestBody PropertyQryBill qry){
        Map<String,List<BillGather>> result = billService.queryGather(qry);
        return ResponseEntity.status(HttpStatus.OK).body(result);
    }
    
    /**
     * 对账
     * @param bill
     * @return
     */
    @PostMapping("/bill/checkBill")
    public ResponseEntity<Map<String,Object>> updateCheckFlag(@RequestBody BillInfo bill){
        if(1 == bill.getCheckFlag()){
            log.info("订单号："+bill.getOrderId()+"房屋编号："+bill.getHouseId()+"-----执行对账");
        }else {
            log.info("订单号："+bill.getOrderId()+"房屋编号："+bill.getHouseId()+"-----执行撤销对账");
        }
    	Map<String,Object> result = billService.updateCheckFlag(bill);
        return ResponseEntity.status(HttpStatus.OK).body(result);
    }
    
    /**
     * 已对账金额、笔数统计
     * @return
     */
    @PostMapping("/bill/queryCheckedCount")
    public ResponseEntity<Map<String,Object>> queryCheckedCount(@RequestBody PropertyQryBill qry){
    	Map<String,Object> result = new HashMap<String,Object>();
    	Long userId = (Long)SecurityUtils.getSubject().getPrincipal();
        List<String> villages = configService.queryVillageByUserId(userId);
        if (villages.size() == 0){
        	result = billService.queryCheckedAll(qry);
        }else {
        	result = billService.queryCheckedCount(userId,qry);
        }
        return ResponseEntity.status(HttpStatus.OK).body(result);
    }

    /**
     * 已对账金额、笔数统计
     * @return
     */
    @PostMapping("/bill/queryCheckedAllCount")
    public ResponseEntity<List<Map<String, Object>>> queryCheckedAllCount(@RequestBody PropertyQryBill qry){
        List<Map<String, Object>> result = new ArrayList<>();
        Long userId = (Long)SecurityUtils.getSubject().getPrincipal();
        List<String> villages = configService.queryVillageByUserId(userId);
        if (villages.size() == 0){
            result = billService.queryCheckedAllAll(qry);
        }else {
            result = billService.queryCheckedAllCount(userId,qry);
        }
        return ResponseEntity.status(HttpStatus.OK).body(result);
    }

}
