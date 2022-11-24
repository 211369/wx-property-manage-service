package com.zyd.shiro.controller;

import com.github.pagehelper.PageInfo;
import com.zyd.shiro.business.entity.BillInfo;
import com.zyd.shiro.business.entity.PropertyQryBill;
import com.zyd.shiro.business.service.ConfigService;
import com.zyd.shiro.business.service.ReceiptService;
import lombok.extern.slf4j.Slf4j;

import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 收据换发票
 */
@RestController
@Slf4j
public class ReceiptController {
    @Autowired
    private ReceiptService receiptService;
    
    @Autowired
    private ConfigService configService;
    
    /**
     * 查询换票记录
     * @param qry
     * @return
     */
    @PostMapping("/bill/queryReceiptInfo")
    public ResponseEntity<PageInfo<BillInfo>> queryReceiptInfo(@RequestBody PropertyQryBill qry){
    	Long userId = (Long)SecurityUtils.getSubject().getPrincipal();
        List<String> villages = configService.queryVillageByUserId(userId);
        if (villages.size() != 0){
        	qry.setUserId(userId);
        }
    	PageInfo<BillInfo> result = receiptService.queryReceiptInfo(qry);
        return ResponseEntity.status(HttpStatus.OK).body(result);
    }
    
    /**
     * 发票兑换
     * @param bill
     * @return
     */
    @PostMapping("/bill/exchange")
    public ResponseEntity<Map<String,Object>> updateCheckFlag(@RequestBody BillInfo bill){
    	log.info("订单号："+bill.getOrderId()+"-----执行换票");
    	Map<String,Object> result = receiptService.updateExchangeFlag(bill);
        return ResponseEntity.status(HttpStatus.OK).body(result);
    }

}
