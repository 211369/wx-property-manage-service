package com.zyd.shiro.business.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zyd.shiro.business.entity.BillInfo;
import com.zyd.shiro.business.entity.PropertyQryBill;
import com.zyd.shiro.business.service.ReceiptService;
import com.zyd.shiro.persistence.mapper.ReceiptMapper;

import lombok.extern.slf4j.Slf4j;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@Slf4j
public class ReceiptServiceImpl implements ReceiptService {
    @Autowired
    private ReceiptMapper mapper;
	
	@Override
	public PageInfo<BillInfo> queryReceiptInfo(PropertyQryBill qry) {
		// TODO Auto-generated method stub
		PageHelper.startPage(qry.getPageNumber(), qry.getPageSize());
		List<BillInfo> bills = mapper.queryReceiptInfo(qry);
		PageHelper.clearPage();
		PageInfo bean = new PageInfo(bills);
	    bean.setList(bills);
	    return bean;
	}  

	@Override
	public Map<String,Object> updateExchangeFlag(BillInfo bill) {
		// TODO Auto-generated method stub
		
		Map<String,Object> map = new HashMap<>();
	    try {
	    	bill.setReceiptTime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
	    	log.info("修改换票状态：" + bill.getOrderId());
	    	mapper.updateExchangeFlag(bill);
	        map.put("code",200);
	        map.put("msg","修改成功");
	    } catch (Exception e) {
	        log.error("错误信息：",e);
	        map.put("code",500);
	        map.put("msg","修改失败");
	    }
	    return map;
	}

}
