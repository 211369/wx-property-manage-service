package com.zyd.shiro.business.service;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.PageInfo;
import com.zyd.shiro.business.entity.*;

public interface BillService {

	PageInfo<BillDetailDTO> queryFinancial(PropertyQryBill qry);

	List<BillExcel> queryFinancialAll(PropertyQryBill qry);
	
	Map<String,Object> updateCheckFlag(BillInfo bill);

	Map<String,Object> queryCheckedCount(Long userId, PropertyQryBill qry);
	
	Map<String,Object> queryCheckedAll(PropertyQryBill qry);

	Map<String,List<BillGather>> queryGather(PropertyQryBill qry);

	List<Map<String, Object>> queryCheckedAllCount(Long userId, PropertyQryBill qry);

	List<Map<String, Object>> queryCheckedAllAll(PropertyQryBill qry);
}
