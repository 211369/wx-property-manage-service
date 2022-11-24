package com.zyd.shiro.persistence.mapper;

import org.springframework.stereotype.Repository;

import com.zyd.shiro.business.entity.BillInfo;
import com.zyd.shiro.business.entity.PropertyQryBill;

import java.util.List;

@Repository
public interface ReceiptMapper {
		
	List<BillInfo> queryReceiptInfo(PropertyQryBill qry);
	
    void updateExchangeFlag(BillInfo bill);
        
}
