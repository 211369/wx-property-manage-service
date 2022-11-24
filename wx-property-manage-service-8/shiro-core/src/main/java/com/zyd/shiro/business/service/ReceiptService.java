package com.zyd.shiro.business.service;

import java.util.Map;

import com.github.pagehelper.PageInfo;
import com.zyd.shiro.business.entity.BillInfo;
import com.zyd.shiro.business.entity.PropertyQryBill;

public interface ReceiptService {
			
	PageInfo<BillInfo> queryReceiptInfo(PropertyQryBill qry);
	
	Map<String,Object> updateExchangeFlag(BillInfo bill);
	
}
