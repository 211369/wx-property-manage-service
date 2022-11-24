package com.zyd.shiro.persistence.mapper;

import com.zyd.shiro.business.entity.*;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface BillMapper {
		
	List<BillDetailDTO> queryBillInfo(PropertyQryBill qry);

    List<BillExcel> queryFinancialAll(PropertyQryBill qry);
	
	List<String> queryCostType(String orderId);
    
	List<BillItem> queryBillItem(@Param("orderId") String orderId,@Param("costType") String costType);
	
    void updateCheckFlag(BillInfo bill);
    
    Map<String,Object> queryCheckedCount(@Param("userId") Long userId,@Param("qry") PropertyQryBill qry);
    
    Map<String,Object> queryCheckedAll(PropertyQryBill qry);

    List<Map<String, Object>>  queryCheckedAllCount(@Param("userId") Long userId,@Param("qry") PropertyQryBill qry);

    List<Map<String, Object>>  queryCheckedAllAll(PropertyQryBill qry);

    List<BillGatherDao> queryGather(PropertyQryBill qry);
}
