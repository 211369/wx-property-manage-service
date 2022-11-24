package com.zyd.shiro.business.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zyd.shiro.business.entity.*;
import com.zyd.shiro.business.service.BillService;
import com.zyd.shiro.persistence.mapper.BillMapper;

import lombok.extern.slf4j.Slf4j;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@Slf4j
public class BillServiceImpl implements BillService {
    @Autowired
    private BillMapper payMapper;
	
	@Override
	public PageInfo<BillDetailDTO> queryFinancial(PropertyQryBill qry) {
		if(null != qry.getEndTime()){
			qry.setEndTime(getNextDay(qry.getEndTime()));
		}
		if(null != qry.getCheckEndTime()){
			qry.setCheckEndTime(getNextDay(qry.getCheckEndTime()));
		}
		// TODO Auto-generated method stub
		List<BillDetailDTO> result = new ArrayList<BillDetailDTO>();
		PageHelper.startPage(qry.getPageNumber(), qry.getPageSize());
		List<BillDetailDTO> bills = payMapper.queryBillInfo(qry);
		PageHelper.clearPage();
		if(bills != null && bills.size() > 0) {
			for(BillDetailDTO info1 : bills) {
				BillDetailDTO dto = new BillDetailDTO();
				BillInfo info = info1.getBillInfo();
				dto.setBillInfo(info);
				Map<String,List<BillItem>> map = new HashMap<>();
				if(StringUtils.isBlank(qry.getCostType())) {
					List<String> costType = payMapper.queryCostType(info.getOrderId());					
					if(costType !=null && costType.size() > 0) {
						for(int i=0;i<costType.size();i++) {
							List<BillItem> items =  payMapper.queryBillItem(info.getOrderId(),costType.get(i));
							if(items != null && items.size()>0) {
								map.put(costType.get(i), items);
							}	
						}
					}
				}else {
					List<BillItem> items =  payMapper.queryBillItem(info.getOrderId(),qry.getCostType());
					map.put(qry.getCostType(), items);
				}
				
				dto.setItems(map);
				result.add(dto);
			}		
		}
		PageInfo<BillDetailDTO> bean = new PageInfo<BillDetailDTO>(bills);
		bean.setList(result);
		return bean;
	}

	@Override
	public List<BillExcel> queryFinancialAll(PropertyQryBill qry) {
		return payMapper.queryFinancialAll(qry);
	}

	@Override
	public Map<String,Object> updateCheckFlag(BillInfo bill) {
		Map<String,Object> map = new HashMap<>();
	    try {
	    	bill.setCheckTime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
	    	log.info("修改对账状态：" + bill.getOrderId());
	    	payMapper.updateCheckFlag(bill);
	        map.put("code",200);
	        map.put("msg","修改成功");
	    } catch (Exception e) {
	        log.error("错误信息：",e);
	        map.put("code",500);
	        map.put("msg","修改失败");
	    }
	    return map;
	}

	@Override
	public Map<String, Object> queryCheckedCount(Long userId, PropertyQryBill qry) {
		if(null != qry.getEndTime()){
			qry.setEndTime(getNextDay(qry.getEndTime()));
		}
		if(null != qry.getCheckEndTime()){
			qry.setCheckEndTime(getNextDay(qry.getCheckEndTime()));
		}
		Map<String, Object> allMap = payMapper.queryCheckedCount(userId, qry);
		Map<String, Object> checkedMap = new HashMap<>();
		if(null == qry.getCheckFlag()){
			qry.setCheckFlag("1");
		}
		if ("0".equals(qry.getCheckFlag())){
			checkedMap.put("sum",0);
			checkedMap.put("count",0);
		}else {
			checkedMap = payMapper.queryCheckedCount(userId, qry);
		}
		checkedMap.put("allSum",allMap.get("sum"));
		return checkedMap;
	}

	@Override
	public Map<String, Object> queryCheckedAll(PropertyQryBill qry) {
		if(null != qry.getEndTime()){
			qry.setEndTime(getNextDay(qry.getEndTime()));
		}
		if(null != qry.getCheckEndTime()){
			qry.setCheckEndTime(getNextDay(qry.getCheckEndTime()));
		}
		Map<String, Object> allMap = payMapper.queryCheckedAll(qry);
		Map<String, Object> checkedMap = new HashMap<>();
		if(null == qry.getCheckFlag()){
			qry.setCheckFlag("1");
		}
		if ("0".equals(qry.getCheckFlag())){
			checkedMap.put("sum",0);
			checkedMap.put("count",0);
		}else {
			checkedMap = payMapper.queryCheckedAll(qry);
		}
		checkedMap.put("allSum",allMap.get("sum"));
		return checkedMap;
	}


	@Override
	public List<Map<String, Object>> queryCheckedAllCount(Long userId, PropertyQryBill qry) {
		if(null != qry.getEndTime()){
			qry.setEndTime(getNextDay(qry.getEndTime()));
		}
		if(null != qry.getCheckEndTime()){
			qry.setCheckEndTime(getNextDay(qry.getCheckEndTime()));
		}
		List<Map<String, Object>> allMap = payMapper.queryCheckedAllCount(userId, qry);
//		List<Map<String, Object>> checkedMap = new ArrayList<>();
//		if(null == qry.getCheckFlag()){
//			qry.setCheckFlag("1");
//		}
//		if ("0".equals(qry.getCheckFlag())){
////			checkedMap.put("sum",0);
////			checkedMap.put("count",0);
//			checkedMap.add(new HashMap<>());
//		}else {
//			checkedMap = payMapper.queryCheckedAllCount(userId, qry);
//		}
////		checkedMap.put("allSum",allMap.get("sum"));
		return allMap;
	}

	@Override
	public List<Map<String, Object>> queryCheckedAllAll(PropertyQryBill qry) {
		if(null != qry.getEndTime()){
			qry.setEndTime(getNextDay(qry.getEndTime()));
		}
		if(null != qry.getCheckEndTime()){
			qry.setCheckEndTime(getNextDay(qry.getCheckEndTime()));
		}
		List<Map<String, Object>> allMap = payMapper.queryCheckedAllAll(qry);
//		List<Map<String, Object>>  checkedMap = new ArrayList<>();
//		if(null == qry.getCheckFlag()){
//			qry.setCheckFlag("1");
//		}
//		if ("0".equals(qry.getCheckFlag())){
////			checkedMap.put("sum",0);
////			checkedMap.put("count",0);
//			checkedMap.add(new HashMap<>());
//		}else {
//			checkedMap = payMapper.queryCheckedAllAll(qry);
//		}
////		checkedMap.put("allSum",allMap.get("sum"));
		return allMap;
	}

	@Override
	public Map<String,List<BillGather>> queryGather(PropertyQryBill qry) {
		Map<String,List<BillGather>> resMap = new HashMap<>();
		//查询收入汇总明细
		qry.setBillType(0);
		List<BillGatherDao> inList = payMapper.queryGather(qry);
		Map<String,BillGather> inMap = new HashMap<>();
		Map<String,String> mixMap = new HashMap<>();
		for(BillGatherDao billGatherDao:inList){
			String key = billGatherDao.getCostName()+billGatherDao.getCostTypeSection();
			if (inMap.containsKey(key)){
				BillGather billGather = inMap.get(key);
				//计算每种付款类型的金额
				countPay(billGather,billGatherDao,mixMap);
			}else {
				inMap.put(key, new BillGather());
				BillGather billGather = inMap.get(key);
				//计算每种付款类型的金额
				countPay(billGather,billGatherDao,mixMap);
			}
		}
		List<BillGather> inResList = new ArrayList<>();
		BillGather inSum = new BillGather();
		inSum.setCostName("收款总计");
		//查询收款项行总计
		for (BillGather billGather:inMap.values()) {
			billGather.setPerSum(billGather.getQrCode().add(billGather.getCash()).add(billGather.getCard()));
			inResList.add(billGather);
			//收款总计
			inSum.setQrCode(inSum.getQrCode().add(billGather.getQrCode()));
			inSum.setCash(inSum.getCash().add(billGather.getCash()));
			inSum.setCard(inSum.getCard().add(billGather.getCard()));
			inSum.setPerSum(inSum.getPerSum().add(billGather.getPerSum()));
		}
		//混合支付处理
		BillGather mix = new BillGather();
		mix.setCostName("混合支付");
		for(String remark : mixMap.values()){
			String[] remarks = remark.split("，");
			BigDecimal qrCode = new BigDecimal(remarks[0].substring(4,remarks[0].length()-1));
			mix.setQrCode(mix.getCard().add(qrCode));
			BigDecimal cash = new BigDecimal(remarks[1].substring(4,remarks[1].length()-1));
			mix.setCash(mix.getCash().add(cash));
			BigDecimal card = new BigDecimal(remarks[2].substring(4,remarks[2].length()-1));
			mix.setCard(mix.getCard().add(card));
		}
		//混合支付行统计
		mix.setPerSum(mix.getQrCode().add(mix.getCash()).add(mix.getCard()));
		inResList.add(mix);
		//收款总计
		inSum.setQrCode(inSum.getQrCode().add(mix.getQrCode()));
		inSum.setCash(inSum.getCash().add(mix.getCash()));
		inSum.setCard(inSum.getCard().add(mix.getCard()));
		inSum.setPerSum(inSum.getPerSum().add(mix.getPerSum()));
		inResList.add(inSum);
		//查询退款汇总明细
		qry.setBillType(1);
		List<BillGatherDao> outList = payMapper.queryGather(qry);
		Map<String,BillGather> outMap = new HashMap<>();
		for(BillGatherDao billGatherDao:outList){
			String key = billGatherDao.getCostName()+billGatherDao.getCostTypeSection();
			if (outMap.containsKey(key)){
				BillGather billGather = outMap.get(key);
				//计算每种退款类型的金额
				countPay(billGather,billGatherDao,mixMap);
			}else {
				outMap.put(key, new BillGather());
				BillGather billGather = outMap.get(key);
				//计算每种退款类型的金额
				countPay(billGather,billGatherDao,mixMap);
			}
		}
		List<BillGather> outResList = new ArrayList<>();
		BillGather outSum = new BillGather();
		outSum.setCostName("退款总计");
		//查询退款项行总计
		for (BillGather billGather:outMap.values()) {
			billGather.setPerSum(billGather.getQrCode().add(billGather.getCash()).add(billGather.getCard()));
			outResList.add(billGather);
			//退款总计
			outSum.setQrCode(outSum.getQrCode().add(billGather.getQrCode()));
			outSum.setCash(outSum.getCash().add(billGather.getCash()));
			outSum.setCard(outSum.getCard().add(billGather.getCard()));
			outSum.setPerSum(outSum.getPerSum().add(billGather.getPerSum()));
		}
		outResList.add(outSum);
		//全部总计
		BillGather sum = new BillGather();
		sum.setCostName("总计");
		sum.setQrCode(inSum.getQrCode().subtract(outSum.getQrCode()));
		sum.setCash(inSum.getCash().subtract(outSum.getCash()));
		sum.setCard(inSum.getCard().subtract(outSum.getCard()));
		sum.setPerSum(inSum.getPerSum().subtract(outSum.getPerSum()));
		List<BillGather> sumList = new ArrayList<>();
		sumList.add(sum);
		//整理返回对象
		resMap.put("收款",inResList);
		resMap.put("退款",outResList);
		resMap.put("总计",sumList);
		return resMap;
	}

	//计算每种付款类型的金额
	private void countPay(BillGather billGather,BillGatherDao billGatherDao,Map<String,String> mixMap){
		billGather.setCostName(billGatherDao.getCostName());
		billGather.setCostTypeSection(billGatherDao.getCostTypeSection());
		switch (billGatherDao.getPayType()){
			case 0:
				billGather.setQrCode(billGather.getQrCode().add(billGatherDao.getPay()));
				break;
			case 1:
				billGather.setCash(billGather.getCash().add(billGatherDao.getPay()));
				break;
			case 2:
				billGather.setCard(billGather.getCard().add(billGatherDao.getPay()));
				break;
			case 3:
				mixMap.put(billGatherDao.getOrderId(),billGatherDao.getRemark());
				break;
			default:
				break;
		}
	}

	public String getNextDay(String day){
		SimpleDateFormat dft = new SimpleDateFormat("yyyy-MM-dd");
		String nextDay = null;
		try {
			Date temp = dft.parse(day);
			Calendar cld = Calendar.getInstance();
			cld.setTime(temp);
			cld.add(Calendar.DATE, 1);
			temp = cld.getTime();
			//获得下一天日期字符串
			nextDay = dft.format(temp);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return nextDay;
	}

}
