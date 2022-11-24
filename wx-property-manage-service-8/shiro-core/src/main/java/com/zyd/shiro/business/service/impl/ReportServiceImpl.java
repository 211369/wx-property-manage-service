package com.zyd.shiro.business.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zyd.shiro.business.entity.*;
import com.zyd.shiro.business.service.ReportService;
import com.zyd.shiro.persistence.mapper.ConfigMapper;
import com.zyd.shiro.persistence.mapper.ReportMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
@Transactional
@Slf4j
public class ReportServiceImpl implements ReportService {
    @Autowired
    private ReportMapper reportMapper;
    @Autowired
    private BillServiceImpl billService;
    @Autowired
    private ConfigMapper configMapper;

    @Override
    public Map<String,AccountReceiveRes> queryReceive(AccountReceiveReq accountReceiveReq) throws ParseException {
        Map<String,AccountReceiveRes> resMap = new HashMap<>();
        if ("物业费".equals(accountReceiveReq.getCostType())) {
            String payBegin = accountReceiveReq.getPayBegin();
            String payEnd = accountReceiveReq.getPayEnd();
            //查询缴费订单
            accountReceiveReq.setBillType(0);
            //查询时用下一个月的查
            accountReceiveReq.setPayEnd(getNextMonth(payEnd));
            List<AccountReceiveItem> items = reportMapper.queryReceive(accountReceiveReq);
            accountReceiveReq.setPayEnd(payEnd);
            //计算金额用的map
            Map<String, BigDecimal> advanceMap = new HashMap<>();
            Map<String, BigDecimal> debtMap = new HashMap<>();
            Map<String, BigDecimal> receivedMap = new HashMap<>();
            //计算数量用的map
            Map<String, Set<String>> advNumMap = new HashMap<>();
            Map<String, Set<String>> debNumMap = new HashMap<>();
            Map<String, Set<String>> redNumMap = new HashMap<>();
            Map<String, Set<String>> refNumMap = new HashMap<>();
            Map<String, Set<String>> recNumMap = new HashMap<>();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
            //遍历缴费订单
            for (AccountReceiveItem item : items) {
                //判断数量用的主键
                String houseId = item.getHouseId();
                if (sdf.parse(payBegin).after(sdf.parse(item.getBeginTime()))) {
                    int debMonth;
                    //缴纳的欠费结束月份早于筛选开始月份特殊处理
                    if(getBetweenMonth(item.getEndTime(),payBegin)>2){
                        debMonth = getBetweenMonth(item.getBeginTime(), item.getEndTime());
                    }else {
                        debMonth = getBetweenMonth(item.getBeginTime(), payBegin) - 1;
                    }
                    int allMonth = getBetweenMonth(item.getBeginTime(), item.getEndTime());
                    BigDecimal debMoney = new BigDecimal(debMonth).divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP).multiply(item.getPay()).setScale(6, BigDecimal.ROUND_HALF_UP);
                    //欠收map有无类型判断
                    if (debtMap.containsKey(item.getCostName())) {
                        //欠收算金额
                        BigDecimal money = debtMap.get(item.getCostName()).add(debMoney);
                        debtMap.put(item.getCostName(), money);
                        //欠收算数量
                        Set<String> set = debNumMap.get(item.getCostName());
                        set.add(houseId);
                        debNumMap.put(item.getCostName(), set);
                    } else {
                        //欠收算金额
                        debtMap.put(item.getCostName(), debMoney);
                        //欠收算数量
                        Set<String> set = new HashSet<>();
                        set.add(houseId);
                        debNumMap.put(item.getCostName(), set);
                    }
                    if (sdf.parse(payEnd).before(sdf.parse(item.getEndTime()))) {
                        int advMonth = getBetweenMonth(payEnd, item.getEndTime()) - 1;
                        BigDecimal advMoney = new BigDecimal(advMonth).divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP).multiply(item.getPay()).setScale(6, BigDecimal.ROUND_HALF_UP);
                        //预收map有无类型判断
                        if (advanceMap.containsKey(item.getCostName())) {
                            //预收算金额
                            BigDecimal money = advanceMap.get(item.getCostName()).add(advMoney);
                            advanceMap.put(item.getCostName(), money);
                            //预收算数量
                            Set<String> set = advNumMap.get(item.getCostName());
                            set.add(houseId);
                            advNumMap.put(item.getCostName(), set);
                        } else {
                            //预收算金额
                            advanceMap.put(item.getCostName(), advMoney);
                            //预收算数量
                            Set<String> set = new HashSet<>();
                            set.add(houseId);
                            advNumMap.put(item.getCostName(), set);
                        }
                        int redMonth = getBetweenMonth(payBegin, payEnd);
                        BigDecimal redMoney = new BigDecimal(redMonth).divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP).multiply(item.getPay()).setScale(6, BigDecimal.ROUND_HALF_UP);
                        //当收map有无类型判断
                        if (receivedMap.containsKey(item.getCostName())) {
                            //当收算金额
                            BigDecimal money = receivedMap.get(item.getCostName()).add(redMoney);
                            receivedMap.put(item.getCostName(), money);
                            //当收算数量
                            Set<String> set = redNumMap.get(item.getCostName());
                            set.add(houseId);
                            redNumMap.put(item.getCostName(), set);
                        } else {
                            //当收算金额
                            receivedMap.put(item.getCostName(), redMoney);
                            //当收算数量
                            Set<String> set = new HashSet<>();
                            set.add(houseId);
                            redNumMap.put(item.getCostName(), set);
                        }
                    } else {
                        int redMonth;
                        //缴纳的欠费结束月份早于筛选开始月份特殊处理
                        if(getBetweenMonth(item.getEndTime(),payBegin)>2){
                            redMonth = 0;
                        }else {
                            redMonth = getBetweenMonth(payBegin, item.getEndTime());
                        }
                        BigDecimal redMoney = new BigDecimal(redMonth).divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP).multiply(item.getPay()).setScale(6, BigDecimal.ROUND_HALF_UP);
                        //当收map有无类型判断
                        if (receivedMap.containsKey(item.getCostName())) {
                            //当收算金额
                            BigDecimal money = receivedMap.get(item.getCostName()).add(redMoney);
                            receivedMap.put(item.getCostName(), money);
                            //当收算数量
                            Set<String> set = redNumMap.get(item.getCostName());
                            set.add(houseId);
                            redNumMap.put(item.getCostName(), set);
                        } else {
                            //当收算金额
                            receivedMap.put(item.getCostName(), redMoney);
                            //当收算数量
                            Set<String> set = new HashSet<>();
                            set.add(houseId);
                            redNumMap.put(item.getCostName(), set);
                        }
                    }
                    continue;
                } else if (sdf.parse(payEnd).before(sdf.parse(item.getEndTime()))) {
                    int advMonth;
                    //缴纳的预收开始月份晚于筛选结束月份特殊处理
                    if(getBetweenMonth(payEnd,item.getBeginTime())>2){
                        advMonth = getBetweenMonth(item.getBeginTime(), item.getEndTime());
                    }else {
                        advMonth = getBetweenMonth(payEnd, item.getEndTime()) - 1;
                    }
                    int allMonth = getBetweenMonth(item.getBeginTime(), item.getEndTime());
                    BigDecimal advMoney = new BigDecimal(advMonth).divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP).multiply(item.getPay()).setScale(6, BigDecimal.ROUND_HALF_UP);
                    //预收map有无类型判断
                    if (advanceMap.containsKey(item.getCostName())) {
                        //预收算金额
                        BigDecimal money = advanceMap.get(item.getCostName()).add(advMoney);
                        advanceMap.put(item.getCostName(), money);
                        //预收算数量
                        Set<String> set = advNumMap.get(item.getCostName());
                        set.add(houseId);
                        advNumMap.put(item.getCostName(), set);
                    } else {
                        //预收算金额
                        advanceMap.put(item.getCostName(), advMoney);
                        //预收算数量
                        Set<String> set = new HashSet<>();
                        set.add(houseId);
                        advNumMap.put(item.getCostName(), set);
                    }
                    int redMonth;
                    //缴纳的预收开始月份晚于筛选结束月份特殊处理
                    if(getBetweenMonth(payEnd,item.getBeginTime())>2){
                        redMonth = 0;
                    }else {
                        redMonth = getBetweenMonth(item.getBeginTime(), payEnd);
                    }
                    BigDecimal redMoney = new BigDecimal(redMonth).divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP).multiply(item.getPay()).setScale(6, BigDecimal.ROUND_HALF_UP);
                    //当收map有无类型判断
                    if (receivedMap.containsKey(item.getCostName())) {
                        //当收算金额
                        BigDecimal money = receivedMap.get(item.getCostName()).add(redMoney);
                        receivedMap.put(item.getCostName(), money);
                        //当收算数量
                        Set<String> set = redNumMap.get(item.getCostName());
                        set.add(houseId);
                        redNumMap.put(item.getCostName(), set);
                    } else {
                        //当收算金额
                        receivedMap.put(item.getCostName(), redMoney);
                        //当收算数量
                        Set<String> set = new HashSet<>();
                        set.add(houseId);
                        redNumMap.put(item.getCostName(), set);
                    }
                    continue;
                } else {
                    BigDecimal redMoney = item.getPay();
                    //当收map有无类型判断
                    if (receivedMap.containsKey(item.getCostName())) {
                        //当收算金额
                        BigDecimal money = receivedMap.get(item.getCostName()).add(redMoney);
                        receivedMap.put(item.getCostName(), money);
                        //当收算数量
                        Set<String> set = redNumMap.get(item.getCostName());
                        set.add(houseId);
                        redNumMap.put(item.getCostName(), set);
                    } else {
                        //当收算金额
                        receivedMap.put(item.getCostName(), redMoney);
                        //当收算数量
                        Set<String> set = new HashSet<>();
                        set.add(houseId);
                        redNumMap.put(item.getCostName(), set);
                    }
                }
            }
            //查询应收
            BigDecimal recSum = new BigDecimal("0");
            List<AccountReceiveItem> recs = reportMapper.queryShould(accountReceiveReq);
            int recMonth = getBetweenMonth(payBegin, payEnd);
            for (AccountReceiveItem rec : recs) {
                //判断数量用的主键
                String houseId = rec.getHouseId();
                //结果map有无类型判断
                if (resMap.containsKey(rec.getCostName())) {
                    //应收算金额
                    BigDecimal recMoney = resMap.get(rec.getCostName()).getReceiveMoney();
                    resMap.get(rec.getCostName()).setReceiveMoney(recMoney.add(rec.getUnit().multiply(new BigDecimal(rec.getRoomArea())).multiply(new BigDecimal(recMonth)).setScale(2, BigDecimal.ROUND_HALF_UP)));
                    //应收算数量
                    Set<String> set = new HashSet<>();
                    if (null != recNumMap.get(rec.getCostName())) {
                        set.addAll(recNumMap.get(rec.getCostName()));
                    }
                    set.add(houseId);
                    recNumMap.put(rec.getCostName(), set);
                } else {
                    //应收算金额
                    AccountReceiveRes res = new AccountReceiveRes();
                    res.setReceiveMoney(rec.getUnit().multiply(new BigDecimal(rec.getRoomArea())).multiply(new BigDecimal(recMonth)).setScale(2, BigDecimal.ROUND_HALF_UP));
                    resMap.put(rec.getCostName(), res);
                    //应收算数量
                    Set<String> set = new HashSet<>();
                    set.add(houseId);
                    recNumMap.put(rec.getCostName(), set);
                }
                recSum = recSum.add(rec.getUnit().multiply(new BigDecimal(rec.getRoomArea())).multiply(new BigDecimal(recMonth)).setScale(2, BigDecimal.ROUND_HALF_UP));
            }
            //查询退费
            BigDecimal refSum = new BigDecimal("0");
            accountReceiveReq.setBillType(1);
            List<AccountReceiveItem> refunds = reportMapper.queryReceive(accountReceiveReq);
            for (AccountReceiveItem refund : refunds) {
                //判断数量用的主键
                String houseId = refund.getHouseId();
                //结果map有无类型判断
                if (resMap.containsKey(refund.getCostName())) {
                    //退费算金额
                    BigDecimal refundMoney = resMap.get(refund.getCostName()).getRefundMoney();
                    resMap.get(refund.getCostName()).setRefundMoney(refundMoney.add(refund.getPay()));
                    //退费算数量
                    Set<String> set = new HashSet<>();
                    if (null != refNumMap.get(refund.getCostName())) {
                        set.addAll(refNumMap.get(refund.getCostName()));
                    }
                    set.add(houseId);
                    refNumMap.put(refund.getCostName(), set);
                } else {
                    //退费算金额
                    AccountReceiveRes res = new AccountReceiveRes();
                    res.setRefundMoney(refund.getPay());
                    resMap.put(refund.getCostName(), res);
                    //退费算数量
                    Set<String> set = new HashSet<>();
                    set.add(houseId);
                    refNumMap.put(refund.getCostName(), set);
                }
                refSum = refSum.add(refund.getPay());
            }
            //遍历预收金额
            BigDecimal advSum = new BigDecimal("0");
            for (Map.Entry entry : advanceMap.entrySet()) {
                //结果map有无类型判断
                if (resMap.containsKey(entry.getKey())) {
                    resMap.get(entry.getKey().toString()).setAdvanceMoney(new BigDecimal(entry.getValue().toString()).setScale(2, BigDecimal.ROUND_HALF_UP));
                } else {
                    AccountReceiveRes res = new AccountReceiveRes();
                    res.setAdvanceMoney(new BigDecimal(entry.getValue().toString()).setScale(2, BigDecimal.ROUND_HALF_UP));
                    resMap.put(entry.getKey().toString(), res);
                }
                advSum = advSum.add(resMap.get(entry.getKey().toString()).getAdvanceMoney());
            }
            //遍历预收数量
            for (Map.Entry entry : advNumMap.entrySet()) {
                Set<String> set = (Set<String>) entry.getValue();
                //结果map有无类型判断
                if (resMap.containsKey(entry.getKey())) {
                    resMap.get(entry.getKey().toString()).setAdvanceNum(set.size());
                } else {
                    AccountReceiveRes res = new AccountReceiveRes();
                    res.setAdvanceNum(set.size());
                    resMap.put(entry.getKey().toString(), res);
                }
            }
            //遍历欠收金额
            BigDecimal debSum = new BigDecimal("0");
            for (Map.Entry entry : debtMap.entrySet()) {
                //结果map有无类型判断
                if (resMap.containsKey(entry.getKey())) {
                    resMap.get(entry.getKey().toString()).setDebtMoney(new BigDecimal(entry.getValue().toString()).setScale(2, BigDecimal.ROUND_HALF_UP));
                } else {
                    AccountReceiveRes res = new AccountReceiveRes();
                    res.setDebtMoney(new BigDecimal(entry.getValue().toString()).setScale(2, BigDecimal.ROUND_HALF_UP));
                    resMap.put(entry.getKey().toString(), res);
                }
                debSum = debSum.add(resMap.get(entry.getKey().toString()).getDebtMoney());
            }
            //遍历欠收数量
            for (Map.Entry entry : debNumMap.entrySet()) {
                Set<String> set = (Set<String>) entry.getValue();
                //结果map有无类型判断
                if (resMap.containsKey(entry.getKey())) {
                    resMap.get(entry.getKey().toString()).setDebtNum(set.size());
                } else {
                    AccountReceiveRes res = new AccountReceiveRes();
                    res.setDebtNum(set.size());
                    resMap.put(entry.getKey().toString(), res);
                }
            }
            //遍历当收金额
            BigDecimal redSum = new BigDecimal("0");
            for (Map.Entry entry : receivedMap.entrySet()) {
                //结果map有无类型判断
                if (resMap.containsKey(entry.getKey())) {
                    resMap.get(entry.getKey().toString()).setReceivedMoney(new BigDecimal(entry.getValue().toString()).setScale(2, BigDecimal.ROUND_HALF_UP));
                } else {
                    AccountReceiveRes res = new AccountReceiveRes();
                    res.setReceivedMoney(new BigDecimal(entry.getValue().toString()).setScale(2, BigDecimal.ROUND_HALF_UP));
                    resMap.put(entry.getKey().toString(), res);
                }
                redSum = redSum.add(resMap.get(entry.getKey().toString()).getReceivedMoney());
            }
            //遍历当收数量
            for (Map.Entry entry : redNumMap.entrySet()) {
                Set<String> set = (Set<String>) entry.getValue();
                //结果map有无类型判断
                if (resMap.containsKey(entry.getKey())) {
                    resMap.get(entry.getKey().toString()).setReceivedNum(set.size());
                } else {
                    AccountReceiveRes res = new AccountReceiveRes();
                    res.setReceivedNum(set.size());
                    resMap.put(entry.getKey().toString(), res);
                }
            }
            //遍历应收数量
            for (Map.Entry entry : recNumMap.entrySet()) {
                Set<String> set = (Set<String>) entry.getValue();
                //结果map有无类型判断
                if (resMap.containsKey(entry.getKey())) {
                    resMap.get(entry.getKey().toString()).setReceiveNum(set.size());
                } else {
                    AccountReceiveRes res = new AccountReceiveRes();
                    res.setReceiveNum(set.size());
                    resMap.put(entry.getKey().toString(), res);
                }
            }
            //遍历退款数量
            for (Map.Entry entry : refNumMap.entrySet()) {
                Set<String> set = (Set<String>) entry.getValue();
                //结果map有无类型判断
                if (resMap.containsKey(entry.getKey())) {
                    resMap.get(entry.getKey().toString()).setRefundNum(set.size());
                } else {
                    AccountReceiveRes res = new AccountReceiveRes();
                    res.setRefundNum(set.size());
                    resMap.put(entry.getKey().toString(), res);
                }
            }
            //计算实收金额
            BigDecimal realSum = new BigDecimal("0");
            for (Map.Entry entry : resMap.entrySet()) {
                String costName = entry.getKey().toString();
                AccountReceiveRes res = resMap.get(costName);
                //预+当+欠-退
                res.setRealMoney(res.getReceivedMoney().add(res.getAdvanceMoney()).add(res.getDebtMoney()).subtract(res.getRefundMoney()));
                realSum = realSum.add(res.getRealMoney());
                //计算实收数量
                Set<String> set = new HashSet<>();
                if (null != advNumMap.get(costName)) {
                    set.addAll(advNumMap.get(costName));
                }
                if (null != redNumMap.get(costName)) {
                    set.addAll(redNumMap.get(costName));
                }
                if (null != debNumMap.get(costName)) {
                    set.addAll(debNumMap.get(costName));
                }
                res.setRealNum(set.size());
            }
            //计算收缴率（不含欠）
            for (Map.Entry entry : resMap.entrySet()) {
                String costName = entry.getKey().toString();
                AccountReceiveRes res = resMap.get(costName);
                //预+当/应保留四位
                String noDebtPercent = "0.00%";
                if (!res.getReceiveMoney().equals(BigDecimal.ZERO)) {
                    noDebtPercent = (res.getReceivedMoney().add(res.getAdvanceMoney())).divide(res.getReceiveMoney(), 4, BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal("100")).setScale(2, BigDecimal.ROUND_HALF_UP) + "%";
                }
                res.setNoDebtPercent(noDebtPercent);
            }
            //计算收缴率（含欠）
            for (Map.Entry entry : resMap.entrySet()) {
                String costName = entry.getKey().toString();
                AccountReceiveRes res = resMap.get(costName);
                //预+当+欠/应保留四位
                String receivedPercent = "0.00%";
                if (!res.getReceiveMoney().equals(BigDecimal.ZERO)) {
                    receivedPercent = (res.getReceivedMoney().add(res.getAdvanceMoney()).add(res.getDebtMoney())).divide(res.getReceiveMoney(), 4, BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal("100")).setScale(2, BigDecimal.ROUND_HALF_UP) + "%";
                }
                res.setReceivedPercent(receivedPercent);
            }
            //总计
            AccountReceiveRes res = new AccountReceiveRes();
            res.setRealMoney(realSum);
            res.setRefundMoney(refSum);
            res.setReceivedMoney(redSum);
            res.setDebtMoney(debSum);
            res.setAdvanceMoney(advSum);
            res.setReceiveMoney(recSum);
            //预+当+欠/应保留四位
            String receivedPercent = "0.00%";
            if (!res.getReceiveMoney().equals(BigDecimal.ZERO)) {
                receivedPercent = (res.getReceivedMoney().add(res.getAdvanceMoney()).add(res.getDebtMoney())).divide(res.getReceiveMoney(), 4, BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal("100")).setScale(2, BigDecimal.ROUND_HALF_UP) + "%";
            }
            res.setReceivedPercent(receivedPercent);
            //预+当/应保留四位
            String noDebtPercent = "0.00%";
            if (!res.getReceiveMoney().equals(BigDecimal.ZERO)) {
                noDebtPercent = (res.getReceivedMoney().add(res.getAdvanceMoney())).divide(res.getReceiveMoney(), 4, BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal("100")).setScale(2, BigDecimal.ROUND_HALF_UP) + "%";
            }
            res.setNoDebtPercent(noDebtPercent);
            resMap.put("总计", res);
        }else if("车位费".equals(accountReceiveReq.getCostType())){
            String payBegin = accountReceiveReq.getPayBegin();
            String payEnd = accountReceiveReq.getPayEnd();
            //查询缴费订单
            accountReceiveReq.setBillType(0);
            //查询时用下一个月的查
            accountReceiveReq.setPayEnd(getNextMonth(payEnd));
            List<AccountReceiveItem> items = reportMapper.queryReceive(accountReceiveReq);
            accountReceiveReq.setPayEnd(payEnd);
            //计算金额用的map
            Map<String, BigDecimal> advanceMap = new HashMap<>();
            Map<String, BigDecimal> debtMap = new HashMap<>();
            Map<String, BigDecimal> receivedMap = new HashMap<>();
            //计算数量用的map
            Map<String, Set<String>> advNumMap = new HashMap<>();
            Map<String, Set<String>> debNumMap = new HashMap<>();
            Map<String, Set<String>> redNumMap = new HashMap<>();
            Map<String, Set<String>> refNumMap = new HashMap<>();
            Map<String, Set<String>> recNumMap = new HashMap<>();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
            //遍历缴费订单
            for (AccountReceiveItem item : items) {
                //车位费精确到天的特殊处理算前一个月
                if(item.getEndTime().length()>7||item.getEndTime().length()>7){
                    item.setEndTime(getBeforeMonth(getNextDay(item.getEndTime())));
                    item.setBeginTime(item.getBeginTime().substring(0,7));
                }
                //判断数量用的主键
                String carNo = item.getCarNo();
                if (sdf.parse(payBegin).after(sdf.parse(item.getBeginTime()))) {
                    int debMonth;
                    //缴纳的欠费结束月份早于筛选开始月份特殊处理
                    if(getBetweenMonth(item.getEndTime(),payBegin)>2){
                        debMonth = getBetweenMonth(item.getBeginTime(), item.getEndTime());
                    }else {
                        debMonth = getBetweenMonth(item.getBeginTime(), payBegin)-1;
                    }
                    int allMonth = getBetweenMonth(item.getBeginTime(), item.getEndTime());
                    BigDecimal debMoney = new BigDecimal(debMonth).divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP).multiply(item.getPay()).setScale(6, BigDecimal.ROUND_HALF_UP);
                    //欠收map有无类型判断
                    if (debtMap.containsKey(item.getCostTypeSection())) {
                        //欠收算金额
                        BigDecimal money = debtMap.get(item.getCostTypeSection()).add(debMoney);
                        debtMap.put(item.getCostTypeSection(), money);
                        //欠收算数量
                        Set<String> set = debNumMap.get(item.getCostTypeSection());
                        set.add(carNo);
                        debNumMap.put(item.getCostTypeSection(), set);
                    } else {
                        //欠收算金额
                        debtMap.put(item.getCostTypeSection(), debMoney);
                        //欠收算数量
                        Set<String> set = new HashSet<>();
                        set.add(carNo);
                        debNumMap.put(item.getCostTypeSection(), set);
                    }
                    if (sdf.parse(payEnd).before(sdf.parse(item.getEndTime()))) {
                        int advMonth = getBetweenMonth(payEnd, item.getEndTime())-1;
                        BigDecimal advMoney = new BigDecimal(advMonth).divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP).multiply(item.getPay()).setScale(6, BigDecimal.ROUND_HALF_UP);
                        //预收map有无类型判断
                        if (advanceMap.containsKey(item.getCostTypeSection())) {
                            //预收算金额
                            BigDecimal money = advanceMap.get(item.getCostTypeSection()).add(advMoney);
                            advanceMap.put(item.getCostTypeSection(), money);
                            //预收算数量
                            Set<String> set = advNumMap.get(item.getCostTypeSection());
                            set.add(carNo);
                            advNumMap.put(item.getCostTypeSection(), set);
                        } else {
                            //预收算金额
                            advanceMap.put(item.getCostTypeSection(), advMoney);
                            //预收算数量
                            Set<String> set = new HashSet<>();
                            set.add(carNo);
                            advNumMap.put(item.getCostTypeSection(), set);
                        }
                        int redMonth = getBetweenMonth(payBegin, payEnd);
                        BigDecimal redMoney = new BigDecimal(redMonth).divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP).multiply(item.getPay()).setScale(6, BigDecimal.ROUND_HALF_UP);
                        //当收map有无类型判断
                        if (receivedMap.containsKey(item.getCostTypeSection())) {
                            //当收算金额
                            BigDecimal money = receivedMap.get(item.getCostTypeSection()).add(redMoney);
                            receivedMap.put(item.getCostTypeSection(), money);
                            //当收算数量
                            Set<String> set = redNumMap.get(item.getCostTypeSection());
                            set.add(carNo);
                            redNumMap.put(item.getCostTypeSection(), set);
                        } else {
                            //当收算金额
                            receivedMap.put(item.getCostTypeSection(), redMoney);
                            //当收算数量
                            Set<String> set = new HashSet<>();
                            set.add(carNo);
                            redNumMap.put(item.getCostTypeSection(), set);
                        }
                    } else {
                        int redMonth;
                        //缴纳的欠费结束月份早于筛选开始月份特殊处理
                        if(getBetweenMonth(item.getEndTime(),payBegin)>2){
                            redMonth = 0;
                        }else {
                            redMonth = getBetweenMonth(payBegin, item.getEndTime());
                        }
                        BigDecimal redMoney = new BigDecimal(redMonth).divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP).multiply(item.getPay()).setScale(6, BigDecimal.ROUND_HALF_UP);
                        //当收map有无类型判断
                        if (receivedMap.containsKey(item.getCostTypeSection())) {
                            //当收算金额
                            BigDecimal money = receivedMap.get(item.getCostTypeSection()).add(redMoney);
                            receivedMap.put(item.getCostTypeSection(), money);
                            //当收算数量
                            Set<String> set = redNumMap.get(item.getCostTypeSection());
                            set.add(carNo);
                            redNumMap.put(item.getCostTypeSection(), set);
                        } else {
                            //当收算金额
                            receivedMap.put(item.getCostTypeSection(), redMoney);
                            //当收算数量
                            Set<String> set = new HashSet<>();
                            set.add(carNo);
                            redNumMap.put(item.getCostTypeSection(), set);
                        }
                    }
                    continue;
                } else if (sdf.parse(payEnd).before(sdf.parse(item.getEndTime()))) {
                    int advMonth;
                    //缴纳的预收开始月份晚于筛选结束月份特殊处理
                    if(getBetweenMonth(payEnd,item.getBeginTime())>2){
                        advMonth = getBetweenMonth(item.getBeginTime(), item.getEndTime());
                    }else {
                        advMonth = getBetweenMonth(payEnd, item.getEndTime())-1;
                    }
                    int allMonth = getBetweenMonth(item.getBeginTime(), item.getEndTime());
                    BigDecimal advMoney = new BigDecimal(advMonth).divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP).multiply(item.getPay()).setScale(6, BigDecimal.ROUND_HALF_UP);
                    //预收map有无类型判断
                    if (advanceMap.containsKey(item.getCostTypeSection())) {
                        //预收算金额
                        BigDecimal money = advanceMap.get(item.getCostTypeSection()).add(advMoney);
                        advanceMap.put(item.getCostTypeSection(), money);
                        //预收算数量
                        Set<String> set = advNumMap.get(item.getCostTypeSection());
                        set.add(carNo);
                        advNumMap.put(item.getCostTypeSection(), set);
                    } else {
                        //预收算金额
                        advanceMap.put(item.getCostTypeSection(), advMoney);
                        //预收算数量
                        Set<String> set = new HashSet<>();
                        set.add(carNo);
                        advNumMap.put(item.getCostTypeSection(), set);
                    }int redMonth;
                    //缴纳的预收开始月份晚于筛选结束月份特殊处理
                    if(getBetweenMonth(payEnd,item.getBeginTime())>2){
                        redMonth = 0;
                    }else {
                        redMonth = getBetweenMonth(item.getBeginTime(), payEnd);
                    }
                    BigDecimal redMoney = new BigDecimal(redMonth).divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP).multiply(item.getPay()).setScale(6, BigDecimal.ROUND_HALF_UP);
                    //当收map有无类型判断
                    if (receivedMap.containsKey(item.getCostTypeSection())) {
                        //当收算金额
                        BigDecimal money = receivedMap.get(item.getCostTypeSection()).add(redMoney);
                        receivedMap.put(item.getCostTypeSection(), money);
                        //当收算数量
                        Set<String> set = redNumMap.get(item.getCostTypeSection());
                        set.add(carNo);
                        redNumMap.put(item.getCostTypeSection(), set);
                    } else {
                        //当收算金额
                        receivedMap.put(item.getCostTypeSection(), redMoney);
                        //当收算数量
                        Set<String> set = new HashSet<>();
                        set.add(carNo);
                        redNumMap.put(item.getCostTypeSection(), set);
                    }
                    continue;
                } else {
                    BigDecimal redMoney = item.getPay();
                    //当收map有无类型判断
                    if (receivedMap.containsKey(item.getCostTypeSection())) {
                        //当收算金额
                        BigDecimal money = receivedMap.get(item.getCostTypeSection()).add(redMoney);
                        receivedMap.put(item.getCostTypeSection(), money);
                        //当收算数量
                        Set<String> set = redNumMap.get(item.getCostTypeSection());
                        set.add(carNo);
                        redNumMap.put(item.getCostTypeSection(), set);
                    } else {
                        //当收算金额
                        receivedMap.put(item.getCostTypeSection(), redMoney);
                        //当收算数量
                        Set<String> set = new HashSet<>();
                        set.add(carNo);
                        redNumMap.put(item.getCostTypeSection(), set);
                    }
                }
            }
            //查询应收
            BigDecimal recSum = new BigDecimal("0");
            List<AccountReceiveItem> recs = reportMapper.queryShould(accountReceiveReq);
            int recMonth = getBetweenMonth(payBegin, payEnd);
            for (AccountReceiveItem rec : recs) {
                //判断数量用的主键
                String carNo = rec.getCarNo();
                //结果map有无类型判断
                if (resMap.containsKey(rec.getCostTypeSection())) {
                    //应收算金额
                    BigDecimal recMoney = resMap.get(rec.getCostTypeSection()).getReceiveMoney();
                    resMap.get(rec.getCostTypeSection()).setReceiveMoney(recMoney.add(rec.getUnit().multiply(new BigDecimal(rec.getRoomArea())).multiply(new BigDecimal(recMonth)).setScale(2, BigDecimal.ROUND_HALF_UP)));
                    //应收算数量
                    Set<String> set = new HashSet<>();
                    if (null != recNumMap.get(rec.getCostTypeSection())) {
                        set.addAll(recNumMap.get(rec.getCostTypeSection()));
                    }
                    set.add(carNo);
                    recNumMap.put(rec.getCostTypeSection(), set);
                } else {
                    //应收算金额
                    AccountReceiveRes res = new AccountReceiveRes();
                    res.setReceiveMoney(rec.getUnit().multiply(new BigDecimal(rec.getRoomArea())).multiply(new BigDecimal(recMonth)).setScale(2, BigDecimal.ROUND_HALF_UP));
                    resMap.put(rec.getCostTypeSection(), res);
                    //应收算数量
                    Set<String> set = new HashSet<>();
                    set.add(carNo);
                    recNumMap.put(rec.getCostTypeSection(), set);
                }
                recSum = recSum.add(rec.getUnit().multiply(new BigDecimal(rec.getRoomArea())).multiply(new BigDecimal(recMonth)).setScale(2, BigDecimal.ROUND_HALF_UP));
            }
            //查询退费
            BigDecimal refSum = new BigDecimal("0");
            accountReceiveReq.setBillType(1);
            List<AccountReceiveItem> refunds = reportMapper.queryReceive(accountReceiveReq);
            for (AccountReceiveItem refund : refunds) {
                //判断数量用的主键
                String carNo = refund.getCarNo();
                //结果map有无类型判断
                if (resMap.containsKey(refund.getCostTypeSection())) {
                    //退费算金额
                    BigDecimal refundMoney = resMap.get(refund.getCostTypeSection()).getRefundMoney();
                    resMap.get(refund.getCostTypeSection()).setRefundMoney(refundMoney.add(refund.getPay()));
                    //退费算数量
                    Set<String> set = new HashSet<>();
                    if (null != refNumMap.get(refund.getCostTypeSection())) {
                        set.addAll(refNumMap.get(refund.getCostTypeSection()));
                    }
                    set.add(carNo);
                    refNumMap.put(refund.getCostTypeSection(), set);
                } else {
                    //退费算金额
                    AccountReceiveRes res = new AccountReceiveRes();
                    res.setRefundMoney(refund.getPay());
                    resMap.put(refund.getCostTypeSection(), res);
                    //退费算数量
                    Set<String> set = new HashSet<>();
                    set.add(carNo);
                    refNumMap.put(refund.getCostTypeSection(), set);
                }
                refSum = refSum.add(refund.getPay());
            }
            //遍历预收金额
            BigDecimal advSum = new BigDecimal("0");
            for (Map.Entry entry : advanceMap.entrySet()) {
                //结果map有无类型判断
                if (resMap.containsKey(entry.getKey())) {
                    resMap.get(entry.getKey().toString()).setAdvanceMoney(new BigDecimal(entry.getValue().toString()).setScale(2, BigDecimal.ROUND_HALF_UP));
                } else {
                    AccountReceiveRes res = new AccountReceiveRes();
                    res.setAdvanceMoney(new BigDecimal(entry.getValue().toString()).setScale(2, BigDecimal.ROUND_HALF_UP));
                    resMap.put(entry.getKey().toString(), res);
                }
                advSum = advSum.add(resMap.get(entry.getKey().toString()).getAdvanceMoney());
            }
            //遍历预收数量
            for (Map.Entry entry : advNumMap.entrySet()) {
                Set<String> set = (Set<String>) entry.getValue();
                //结果map有无类型判断
                if (resMap.containsKey(entry.getKey())) {
                    resMap.get(entry.getKey().toString()).setAdvanceNum(set.size());
                } else {
                    AccountReceiveRes res = new AccountReceiveRes();
                    res.setAdvanceNum(set.size());
                    resMap.put(entry.getKey().toString(), res);
                }
            }
            //遍历欠收金额
            BigDecimal debSum = new BigDecimal("0");
            for (Map.Entry entry : debtMap.entrySet()) {
                //结果map有无类型判断
                if (resMap.containsKey(entry.getKey())) {
                    resMap.get(entry.getKey().toString()).setDebtMoney(new BigDecimal(entry.getValue().toString()).setScale(2, BigDecimal.ROUND_HALF_UP));
                } else {
                    AccountReceiveRes res = new AccountReceiveRes();
                    res.setDebtMoney(new BigDecimal(entry.getValue().toString()).setScale(2, BigDecimal.ROUND_HALF_UP));
                    resMap.put(entry.getKey().toString(), res);
                }
                debSum = debSum.add(resMap.get(entry.getKey().toString()).getDebtMoney());
            }
            //遍历欠收数量
            for (Map.Entry entry : debNumMap.entrySet()) {
                Set<String> set = (Set<String>) entry.getValue();
                //结果map有无类型判断
                if (resMap.containsKey(entry.getKey())) {
                    resMap.get(entry.getKey().toString()).setDebtNum(set.size());
                } else {
                    AccountReceiveRes res = new AccountReceiveRes();
                    res.setDebtNum(set.size());
                    resMap.put(entry.getKey().toString(), res);
                }
            }
            //遍历当收金额
            BigDecimal redSum = new BigDecimal("0");
            for (Map.Entry entry : receivedMap.entrySet()) {
                //结果map有无类型判断
                if (resMap.containsKey(entry.getKey())) {
                    resMap.get(entry.getKey().toString()).setReceivedMoney(new BigDecimal(entry.getValue().toString()).setScale(2, BigDecimal.ROUND_HALF_UP));
                } else {
                    AccountReceiveRes res = new AccountReceiveRes();
                    res.setReceivedMoney(new BigDecimal(entry.getValue().toString()).setScale(2, BigDecimal.ROUND_HALF_UP));
                    resMap.put(entry.getKey().toString(), res);
                }
                redSum = redSum.add(resMap.get(entry.getKey().toString()).getReceivedMoney());
            }
            //遍历当收数量
            for (Map.Entry entry : redNumMap.entrySet()) {
                Set<String> set = (Set<String>) entry.getValue();
                //结果map有无类型判断
                if (resMap.containsKey(entry.getKey())) {
                    resMap.get(entry.getKey().toString()).setReceivedNum(set.size());
                } else {
                    AccountReceiveRes res = new AccountReceiveRes();
                    res.setReceivedNum(set.size());
                    resMap.put(entry.getKey().toString(), res);
                }
            }
            //遍历应收数量
            for (Map.Entry entry : recNumMap.entrySet()) {
                Set<String> set = (Set<String>) entry.getValue();
                //结果map有无类型判断
                if (resMap.containsKey(entry.getKey())) {
                    resMap.get(entry.getKey().toString()).setReceiveNum(set.size());
                } else {
                    AccountReceiveRes res = new AccountReceiveRes();
                    res.setReceiveNum(set.size());
                    resMap.put(entry.getKey().toString(), res);
                }
            }
            //遍历退款数量
            for (Map.Entry entry : refNumMap.entrySet()) {
                Set<String> set = (Set<String>) entry.getValue();
                //结果map有无类型判断
                if (resMap.containsKey(entry.getKey())) {
                    resMap.get(entry.getKey().toString()).setRefundNum(set.size());
                } else {
                    AccountReceiveRes res = new AccountReceiveRes();
                    res.setRefundNum(set.size());
                    resMap.put(entry.getKey().toString(), res);
                }
            }
            //计算实收金额
            BigDecimal realSum = new BigDecimal("0");
            for (Map.Entry entry : resMap.entrySet()) {
                String costName = entry.getKey().toString();
                AccountReceiveRes res = resMap.get(costName);
                //预+当+欠-退
                res.setRealMoney(res.getReceivedMoney().add(res.getAdvanceMoney()).add(res.getDebtMoney()).subtract(res.getRefundMoney()));
                realSum = realSum.add(res.getRealMoney());
                //计算实收数量
                Set<String> set = new HashSet<>();
                if (null != advNumMap.get(costName)) {
                    set.addAll(advNumMap.get(costName));
                }
                if (null != redNumMap.get(costName)) {
                    set.addAll(redNumMap.get(costName));
                }
                if (null != debNumMap.get(costName)) {
                    set.addAll(debNumMap.get(costName));
                }
                res.setRealNum(set.size());
            }
            //计算收缴率（不含欠）
            for (Map.Entry entry : resMap.entrySet()) {
                String costName = entry.getKey().toString();
                AccountReceiveRes res = resMap.get(costName);
                //预+当/应保留四位
                String noDebtPercent = "0.00%";
                if (!res.getReceiveMoney().equals(BigDecimal.ZERO)) {
                    noDebtPercent = (res.getReceivedMoney().add(res.getAdvanceMoney())).divide(res.getReceiveMoney(), 4, BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal("100")).setScale(2, BigDecimal.ROUND_HALF_UP) + "%";
                }
                res.setNoDebtPercent(noDebtPercent);
            }
            //计算收缴率（含欠）
            for (Map.Entry entry : resMap.entrySet()) {
                String costName = entry.getKey().toString();
                AccountReceiveRes res = resMap.get(costName);
                //预+当+欠/应保留四位
                String receivedPercent = "0.00%";
                if (!res.getReceiveMoney().equals(BigDecimal.ZERO)) {
                    receivedPercent = (res.getReceivedMoney().add(res.getAdvanceMoney()).add(res.getDebtMoney())).divide(res.getReceiveMoney(), 4, BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal("100")).setScale(2, BigDecimal.ROUND_HALF_UP) + "%";
                }
                res.setReceivedPercent(receivedPercent);
            }
            //总计
            AccountReceiveRes res = new AccountReceiveRes();
            res.setRealMoney(realSum);
            res.setRefundMoney(refSum);
            res.setReceivedMoney(redSum);
            res.setDebtMoney(debSum);
            res.setAdvanceMoney(advSum);
            res.setReceiveMoney(recSum);
            //预+当+欠/应保留四位
            String receivedPercent = "0.00%";
            if (!res.getReceiveMoney().equals(BigDecimal.ZERO)) {
                receivedPercent = (res.getReceivedMoney().add(res.getAdvanceMoney()).add(res.getDebtMoney())).divide(res.getReceiveMoney(), 4, BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal("100")).setScale(2, BigDecimal.ROUND_HALF_UP) + "%";
            }
            res.setReceivedPercent(receivedPercent);
            //预+当/应保留四位
            String noDebtPercent = "0.00%";
            if (!res.getReceiveMoney().equals(BigDecimal.ZERO)) {
                noDebtPercent = (res.getReceivedMoney().add(res.getAdvanceMoney())).divide(res.getReceiveMoney(), 4, BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal("100")).setScale(2, BigDecimal.ROUND_HALF_UP) + "%";
            }
            res.setNoDebtPercent(noDebtPercent);
            resMap.put("总计", res);
        }
        return resMap;
    }

    @Override
    public List<Deposit> advanceQuery(Deposit deposit) throws ParseException {
        List<Deposit> list = new ArrayList<>();
        //查询时间范围内全量已完成的缴费订单明细
        deposit.setBillType(0);
        String payEnd = deposit.getEndTime();
        //查询时结束时间算下一个月
        deposit.setEndTime(getNextMonth(payEnd));
        List<Deposit> deposits = reportMapper.advanceQuery(deposit);
        //还原结束时间方便后续判断
        deposit.setEndTime(payEnd);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
        for (Deposit dep:deposits) {
            //车位费精确到天的特殊处理算前一个月
            if(dep.getEndTime().length()>7){
                dep.setEndTime(getBeforeMonth(getNextDay(dep.getEndTime())));
            }
            //判断预收
            if(sdf.parse(payEnd).before(sdf.parse(dep.getEndTime()))){
                list.add(dep);
            }
        }
        return list;
    }

    @Override
    public PageInfo<Deposit> advanceQueryPage(Deposit deposit) throws ParseException {
        List<Deposit> list = new ArrayList<>();
        //分页
        PageHelper.startPage(deposit.getPageNumber(), deposit.getPageSize());
        //查询时间范围内全量已完成的缴费订单明细
        deposit.setBillType(0);
        String payEnd = deposit.getEndTime();
        //查询时结束时间算下一个月
        deposit.setEndTime(getNextMonth(payEnd));
        List<Deposit> deposits = reportMapper.advanceQuery(deposit);
        //还原结束时间方便后续判断
        deposit.setEndTime(payEnd);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
        for (Deposit dep:deposits) {
            //车位费精确到天的特殊处理算前一个月
            if(dep.getEndTime().length()>7){
                dep.setEndTime(getBeforeMonth(getNextDay(dep.getEndTime())));
            }
            //判断预收
            if(sdf.parse(payEnd).before(sdf.parse(dep.getEndTime()))){
                list.add(dep);
            }
        }
        PageInfo bean = new PageInfo(list);
        return bean;
    }

    @Override
    public List<ReportDTO> debtQuery(Deposit deposit) {
        //查询全量
        List<Deposit> deposits = reportMapper.debtQuery(deposit);
        //按照房屋封装
        Map<HouseInfo,List<Deposit>> depMap = new HashMap<>();
        for (Deposit dep:deposits) {
            HouseInfo houseInfo = new HouseInfo();
            houseInfo.setHouseId(dep.getHouseId());
            houseInfo.setVillage(dep.getVillage());
            houseInfo.setBuilding(dep.getBuilding());
            houseInfo.setLocation(dep.getLocation());
            houseInfo.setRoom(dep.getRoom());
            houseInfo.setRoomArea(dep.getRoomArea());
            houseInfo.setOwnerName(dep.getOwnerName());
            houseInfo.setOwnerPhone(dep.getOwnerPhone());
            if(depMap.containsKey(houseInfo)){
                depMap.get(houseInfo).add(dep);
            }else {
                List<Deposit> depositList = new ArrayList<>();
                depositList.add(dep);
                depMap.put(houseInfo,depositList);
            }
        }
        List<ReportDTO> list = new ArrayList<>();
        //特殊处理欠费结束时间算前一个月
        String endMonth = getBeforeMonth(deposit.getBeginTime());
        //遍历每一户
        for (Map.Entry entry : depMap.entrySet()) {
            HouseInfo houseInfo = (HouseInfo)entry.getKey();
            BigDecimal roomArea = new BigDecimal(houseInfo.getRoomArea().toString());
            ReportDTO reportDTO = new ReportDTO();
            reportDTO.setHouseInfo(houseInfo);
            List<Deposit> newDeposit = new ArrayList<>();
            List<Deposit> depositList = (List<Deposit>)entry.getValue();
            //计算每一个项目的欠费金额
            for (Deposit d : depositList) {
                String costType = d.getCostType();
                String beginTime = d.getBeginTime();
                BigDecimal unit = new BigDecimal(d.getUnit().toString());
                BigDecimal total;
                Integer betweenMonth;
                //物业费计算方式
                if("物业费".equals(costType)){
                    betweenMonth = getBetweenMonth(beginTime,endMonth);
                    if(betweenMonth<=0){
                        continue;
                    }
                    //面积*单价*月份
                    total = roomArea.multiply(new BigDecimal(betweenMonth.toString())).multiply(unit).setScale(2,BigDecimal.ROUND_UP);
                //车位费计算方式
                }else if("车位费".equals(costType)){
                    betweenMonth = getBetweenMonth(beginTime,endMonth);
                    if(beginTime.length()>7||endMonth.length()>7){
                        betweenMonth += 1;
                    }
                    if(betweenMonth<=0){
                        continue;
                    }
                    //面积*单价
                    total = new BigDecimal(betweenMonth.toString()).multiply(unit).setScale(2,BigDecimal.ROUND_UP);
                }else {
                    total = unit;
                }
                d.setPay(total.doubleValue());
                newDeposit.add(d);
            }
            reportDTO.setDeposits(newDeposit);
            list.add(reportDTO);
        }
        return list;
    }

    @Override
    public PageInfo<Deposit> debtQueryPage(Deposit deposit) {
        //查询全量
        List<Deposit> deposits = reportMapper.debtQuery(deposit);
        //按照房屋封装
        Map<HouseInfo,List<Deposit>> depMap = new HashMap<>();
        Set<HouseInfo> houseInfos = new HashSet<>();
        for (Deposit dep:deposits) {
            HouseInfo houseInfo = new HouseInfo();
            houseInfo.setHouseId(dep.getHouseId());
            houseInfo.setVillage(dep.getVillage());
            houseInfo.setBuilding(dep.getBuilding());
            houseInfo.setLocation(dep.getLocation());
            houseInfo.setRoom(dep.getRoom());
            houseInfo.setRoomArea(dep.getRoomArea());
            houseInfo.setOwnerName(dep.getOwnerName());
            houseInfo.setOwnerPhone(dep.getOwnerPhone());
            houseInfos.add(houseInfo);
            if(depMap.containsKey(houseInfo)){
                depMap.get(houseInfo).add(dep);
            }else {
                List<Deposit> depositList = new ArrayList<>();
                depositList.add(dep);
                depMap.put(houseInfo,depositList);
            }
        }
        //特殊处理欠费结束时间算前一个月
        String endMonth = getBeforeMonth(deposit.getBeginTime());
        List<ReportDTO> list = new ArrayList<>();
        int start = (deposit.getPageNumber()-1)*deposit.getPageSize();
        int end = deposit.getPageNumber()*deposit.getPageSize();
        int index = 0;
        //遍历每一户
        for (HouseInfo houseInfo:houseInfos) {
            //手动分页
            if(start>index){
                index += 1;
                continue;
            }else if (start<=index && index<end){
                index += 1;
                BigDecimal roomArea = new BigDecimal(houseInfo.getRoomArea().toString());
                ReportDTO reportDTO = new ReportDTO();
                reportDTO.setHouseInfo(houseInfo);
                List<Deposit> newDeposit = new ArrayList<>();
                List<Deposit> depositList = depMap.get(houseInfo);
                //计算每一个项目的欠费金额
                for (Deposit d : depositList) {
                    String costType = d.getCostType();
                    String beginTime = d.getBeginTime();
                    BigDecimal unit = new BigDecimal(d.getUnit().toString());
                    BigDecimal total;
                    Integer betweenMonth;
                    //物业费计算方式
                    if("物业费".equals(costType)){
                        betweenMonth = getBetweenMonth(beginTime,endMonth);
                        if(betweenMonth<=0){
                            continue;
                        }
                        //面积*单价*月份
                        total = roomArea.multiply(new BigDecimal(betweenMonth.toString())).multiply(unit).setScale(2,BigDecimal.ROUND_UP);
                    //车位费计算方式
                    }else if("车位费".equals(costType)){
                        betweenMonth = getBetweenMonth(beginTime,endMonth);
                        if(beginTime.length()>7||endMonth.length()>7){
                            betweenMonth += 1;
                        }
                        if(betweenMonth<=0){
                            continue;
                        }
                        //面积*单价
                        total = new BigDecimal(betweenMonth.toString()).multiply(unit).setScale(2,BigDecimal.ROUND_UP);
                    }else {
                        total = unit;
                    }
                    d.setPay(total.doubleValue());
                    newDeposit.add(d);
                }
                reportDTO.setDeposits(newDeposit);
                list.add(reportDTO);
            }else {
                break;
            }
        }
        //分页信息填入
        PageInfo bean = new PageInfo(list);
        bean.setTotal(houseInfos.size());
        bean.setPageNum(deposit.getPageNumber());
        bean.setPages((houseInfos.size()+deposit.getPageSize()-1)/deposit.getPageSize());
        return bean;
    }

    @Override
    public PageInfo<Deposit> queryRefundPage(Deposit deposit) {
        List<Deposit> list = new ArrayList<>();
        PageInfo bean = new PageInfo(list);
        PageHelper.startPage(deposit.getPageNumber(), deposit.getPageSize());
        list = reportMapper.queryRefund(deposit);
        bean.setList(list);
        bean = new PageInfo(list);
        return bean;
    }

    @Override
    public List<Deposit> queryRefund(Deposit deposit) {
        return reportMapper.queryRefund(deposit);
    }

    @Override
    public PageInfo<HouseBillDTO> queryHouseBill(AccountReceiveReq qry){
        PageHelper.startPage(qry.getPageNumber(), qry.getPageSize());
        List<HouseBillDTO> resList = reportMapper.queryHouseBillDetail(
                Integer.parseInt(qry.getPayBegin().substring(0,4)),qry.getVillage());
        PageInfo bean = new PageInfo(resList);
        bean.setList(resList);
        return bean;
    }

    @Override
    public List<HouseBillDTO> queryHouseBillAll(AccountReceiveReq qry){
        List<HouseBillDTO> resList = reportMapper.queryHouseBillDetail(
                Integer.parseInt(qry.getPayBegin().substring(0,4)),qry.getVillage());
        return resList;
    }

    @Override
    public void houseBillForJob() throws ParseException {
        int yearEnd = Calendar.getInstance().get(Calendar.YEAR);
        int yearBegin = yearEnd-3;
        List<String> villages = configMapper.queryVillage();
        for (int i = yearBegin; i <= yearEnd; i++) {
            AccountReceiveReq qry = new AccountReceiveReq();
            qry.setPayBegin(i+"-01");
            qry.setPayEnd(i+"-12");
            for (String village:villages){
                qry.setVillage(village);
                List<HouseBill> list = reportMapper.queryHouseBill(qry.getVillage());
                List<HouseBillDTO> resList = exchangeHouseBill(list,qry);
                reportMapper.deleteHouseBill(i,village);
                reportMapper.addHouseBill(resList,i);
            }
        }

    }

    //对象转换
    public List<HouseBillDTO> exchangeHouseBill(List<HouseBill> houseBills,AccountReceiveReq qry) throws ParseException {
        List<HouseBillDTO> resList = new ArrayList<>();
        for (HouseBill houseBill:houseBills) {
            HouseBillDTO houseBillDTO = new HouseBillDTO();
            houseBillDTO.setHouseId(houseBill.getHouseId());
            houseBillDTO.setVillage(houseBill.getVillage());
            houseBillDTO.setBuilding(houseBill.getBuilding());
            houseBillDTO.setLocation(houseBill.getLocation());
            houseBillDTO.setRoom(houseBill.getRoom());
            BigDecimal roomArea = new BigDecimal(houseBill.getRoomArea().toString());
            houseBillDTO.setRoomArea(roomArea);
            houseBillDTO.setOwnerName(houseBill.getOwnerName());
            //计算物业单价之和
            BigDecimal unitSum = new BigDecimal(0);
            for (Config config:houseBill.getConfigs()){
                unitSum = unitSum.add(config.getUnit());
            }
            //计算月管理费面积*单价保留两位只入不舍
            houseBillDTO.setMonthMoney(unitSum.multiply(roomArea).setScale(2,BigDecimal.ROUND_UP));
            //计算年管理费面积*单价*12保留两位只入不舍
            houseBillDTO.setYearMoney(unitSum.multiply(roomArea).multiply(new BigDecimal(12)).setScale(2,BigDecimal.ROUND_UP));
            if (null == houseBill.getBillInfos() || houseBill.getBillInfos().size() == 0){
                //没有缴费历史的情况
                houseBillDTO.setBeginTime(houseBill.getBeginTime());
                if(getBetweenMonth(qry.getPayEnd(),houseBill.getBeginTime())>=0){
                    //缴费开始时间在查询年份之后的情况
                    houseBillDTO.setShouldMoney(new BigDecimal(0));
                }else if (getBetweenMonth(houseBill.getBeginTime(),qry.getPayBegin())>=1){
                    //缴费开始时间在查询年份之前的情况
                    houseBillDTO.setShouldMoney(houseBillDTO.getYearMoney());
                }else {
                    //缴费开始时间在查询年份中间的情况
                    BigDecimal month = new BigDecimal(getBetweenMonth(houseBill.getBeginTime(),qry.getPayEnd()));
                    houseBillDTO.setShouldMoney(unitSum.multiply(roomArea).multiply(month).setScale(2,BigDecimal.ROUND_UP));
                }
            }else {
                Date qryBeginTime = new SimpleDateFormat("yyyy-MM").parse(qry.getPayBegin());
                Date qryEndTime = new SimpleDateFormat("yyyy-MM").parse(qry.getPayEnd());
                //有缴费历史的情况
                //订单中最早的缴费开始时间
                String earliestTime = houseBill.getBillInfos().get(0).getBeginTime();
                if(getBetweenMonth(qry.getPayEnd(),houseBill.getBeginTime())>=0){
                    //缴费开始时间在查询年份之后的情况
                    if(getBetweenMonth(earliestTime,qry.getPayBegin())>=1){
                        //最早缴费开始时间在查询年份之前的情况
                        houseBillDTO.setBeginTime(qry.getPayBegin());
                        houseBillDTO.setShouldMoney(houseBillDTO.getYearMoney());
                        for(BillExcel billExcel:houseBill.getBillInfos()){
                            Date billBeginTime = new SimpleDateFormat("yyyy-MM").parse(billExcel.getBeginTime());
                            Date billEndTime = new SimpleDateFormat("yyyy-MM").parse(billExcel.getEndTime());
                            if(billBeginTime.compareTo(qryBeginTime)<=0 && billEndTime.compareTo(qryEndTime)<=0 && billEndTime.compareTo(qryBeginTime)>0){
                                //订单开始时间小于等于查询开始时间，订单结束时间小于查询结束时间，订单结束时间大于查询开始时间
                                houseBillDTO.setPayTime(houseBillDTO.getPayTime()+","+billExcel.getPayTime());
                                if (null != billExcel.getDiscount() && billExcel.getDiscount()>0){
                                    houseBillDTO.setDiscount(houseBillDTO.getDiscount()+","+billExcel.getDiscount());
                                }
                                int realMonth = getBetweenMonth(qry.getPayBegin(),billExcel.getEndTime());
                                int allMonth = getBetweenMonth(billExcel.getBeginTime(),billExcel.getEndTime());
                                BigDecimal receiveMoney = new BigDecimal(realMonth).divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP).multiply(billExcel.getPaySum()).setScale(6, BigDecimal.ROUND_HALF_UP);
                                houseBillDTO.setReceiveMoney(houseBillDTO.getReceiveMoney().add(receiveMoney));
                                continue;
                            }else if (billBeginTime.compareTo(qryBeginTime)>=0 && billEndTime.compareTo(qryEndTime)<=0){
                                //订单开始时间大于查询开始时间，订单结束时间小于查询结束时间
                                houseBillDTO.setPayTime(houseBillDTO.getPayTime()+","+billExcel.getPayTime());
                                if (null != billExcel.getDiscount() && billExcel.getDiscount()>0){
                                    houseBillDTO.setDiscount(houseBillDTO.getDiscount()+","+billExcel.getDiscount());
                                }
                                houseBillDTO.setReceiveMoney(houseBillDTO.getReceiveMoney().add(billExcel.getPaySum()));
                                continue;
                            }else if (billBeginTime.compareTo(qryBeginTime)>=0 && billEndTime.compareTo(qryEndTime)>=0 && billBeginTime.compareTo(qryEndTime)<0){
                                //订单开始时间大于查询开始时间，订单结束时间大于查询结束时间，订单开始时间小于查询结束时间
                                houseBillDTO.setPayTime(houseBillDTO.getPayTime()+","+billExcel.getPayTime());
                                if (null != billExcel.getDiscount() && billExcel.getDiscount()>0){
                                    houseBillDTO.setDiscount(houseBillDTO.getDiscount()+","+billExcel.getDiscount());
                                }
                                int realMonth = getBetweenMonth(billExcel.getBeginTime(),qry.getPayEnd());
                                int allMonth = getBetweenMonth(billExcel.getBeginTime(),billExcel.getEndTime());
                                BigDecimal receiveMoney = new BigDecimal(realMonth).divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP).multiply(billExcel.getPaySum()).setScale(6, BigDecimal.ROUND_HALF_UP);
                                houseBillDTO.setReceiveMoney(houseBillDTO.getReceiveMoney().add(receiveMoney));
                                continue;
                            }else if (billBeginTime.compareTo(qryBeginTime)<0 && billEndTime.compareTo(qryEndTime)>0 && billEndTime.compareTo(qryBeginTime)>0){
                                //订单开始时间小于查询开始时间，订单结束时间大于查询结束时间
                                houseBillDTO.setPayTime(houseBillDTO.getPayTime()+","+billExcel.getPayTime());
                                if (null != billExcel.getDiscount() && billExcel.getDiscount()>0){
                                    houseBillDTO.setDiscount(houseBillDTO.getDiscount()+","+billExcel.getDiscount());
                                }
                                int realMonth = getBetweenMonth(qry.getPayBegin(),qry.getPayEnd());
                                int allMonth = getBetweenMonth(billExcel.getBeginTime(),billExcel.getEndTime());
                                BigDecimal receiveMoney = new BigDecimal(realMonth).divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP).multiply(billExcel.getPaySum()).setScale(6, BigDecimal.ROUND_HALF_UP);
                                houseBillDTO.setReceiveMoney(houseBillDTO.getReceiveMoney().add(receiveMoney));
                                continue;
                            }
                        }
                    }else if (getBetweenMonth(qry.getPayEnd(),earliestTime)>=0){
                        //最早缴费开始时间在查询年份之后的情况
                        resList.add(houseBillDTO);
                        continue;
                    }else {
                        //最早缴费开始时间在查询年份中间的情况
                        houseBillDTO.setBeginTime(earliestTime);
                        int realMonth = getBetweenMonth(earliestTime,qry.getPayEnd());
                        houseBillDTO.setShouldMoney(houseBillDTO.getMonthMoney().multiply(new BigDecimal(realMonth)));
                        for(BillExcel billExcel:houseBill.getBillInfos()){
                            Date billBeginTime = new SimpleDateFormat("yyyy-MM").parse(billExcel.getBeginTime());
                            Date billEndTime = new SimpleDateFormat("yyyy-MM").parse(billExcel.getEndTime());
                            if (billBeginTime.compareTo(qryBeginTime)>=0 && billEndTime.compareTo(qryEndTime)<=0){
                                //订单开始时间大于查询开始时间，订单结束时间小于查询结束时间
                                houseBillDTO.setPayTime(houseBillDTO.getPayTime()+","+billExcel.getPayTime());
                                if (null != billExcel.getDiscount() && billExcel.getDiscount()>0){
                                    houseBillDTO.setDiscount(houseBillDTO.getDiscount()+","+billExcel.getDiscount());
                                }
                                houseBillDTO.setReceiveMoney(houseBillDTO.getReceiveMoney().add(billExcel.getPaySum()));
                                continue;
                            }else if (billBeginTime.compareTo(qryBeginTime)>=0 && billEndTime.compareTo(qryEndTime)>=0 && billBeginTime.compareTo(qryEndTime)<0){
                                //订单开始时间大于查询开始时间，订单结束时间大于查询结束时间，订单开始时间小于查询结束时间
                                houseBillDTO.setPayTime(houseBillDTO.getPayTime()+","+billExcel.getPayTime());
                                if (null != billExcel.getDiscount() && billExcel.getDiscount()>0){
                                    houseBillDTO.setDiscount(houseBillDTO.getDiscount()+","+billExcel.getDiscount());
                                }
                                realMonth = getBetweenMonth(billExcel.getBeginTime(),qry.getPayEnd());
                                int allMonth = getBetweenMonth(billExcel.getBeginTime(),billExcel.getEndTime());
                                BigDecimal receiveMoney = new BigDecimal(realMonth).divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP).multiply(billExcel.getPaySum()).setScale(6, BigDecimal.ROUND_HALF_UP);
                                houseBillDTO.setReceiveMoney(houseBillDTO.getReceiveMoney().add(receiveMoney));
                                continue;
                            }
                        }
                    }
                }else if (getBetweenMonth(houseBill.getBeginTime(),qry.getPayBegin())>=1){
                    //缴费开始时间在查询年份之前的情况
                    houseBillDTO.setBeginTime(qry.getPayBegin());
                    houseBillDTO.setShouldMoney(houseBillDTO.getYearMoney());
                }else {
                    //缴费开始时间在查询年份中间的情况
                    if(getBetweenMonth(earliestTime,qry.getPayBegin())>=1){
                        //最早缴费开始时间在查询年份之前的情况
                        houseBillDTO.setBeginTime(qry.getPayBegin());
                        houseBillDTO.setShouldMoney(houseBillDTO.getYearMoney());
                        for(BillExcel billExcel:houseBill.getBillInfos()){
                            Date billBeginTime = new SimpleDateFormat("yyyy-MM").parse(billExcel.getBeginTime());
                            Date billEndTime = new SimpleDateFormat("yyyy-MM").parse(billExcel.getEndTime());
                            if(billBeginTime.compareTo(qryBeginTime)<=0 && billEndTime.compareTo(qryEndTime)<=0){
                                houseBillDTO.setPayTime(houseBillDTO.getPayTime()+","+billExcel.getPayTime());
                                if (null != billExcel.getDiscount() && billExcel.getDiscount()>0){
                                    houseBillDTO.setDiscount(houseBillDTO.getDiscount()+","+billExcel.getDiscount());
                                }
                                int realMonth = getBetweenMonth(qry.getPayBegin(),billExcel.getEndTime());
                                int allMonth = getBetweenMonth(billExcel.getBeginTime(),billExcel.getEndTime());
                                BigDecimal receiveMoney = new BigDecimal(realMonth).divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP).multiply(billExcel.getPaySum()).setScale(6, BigDecimal.ROUND_HALF_UP);
                                houseBillDTO.setReceiveMoney(houseBillDTO.getReceiveMoney().add(receiveMoney));
                            }
                        }
                    }else {
                        //最早缴费开始时间在查询年份中间的情况
                        houseBillDTO.setBeginTime(earliestTime);
                        int realMonth = getBetweenMonth(earliestTime,qry.getPayEnd());
                        houseBillDTO.setShouldMoney(houseBillDTO.getMonthMoney().multiply(new BigDecimal(realMonth)));
                        for(BillExcel billExcel:houseBill.getBillInfos()){
                            houseBillDTO.setPayTime(houseBillDTO.getPayTime()+","+billExcel.getPayTime());
                            if (null != billExcel.getDiscount() && billExcel.getDiscount()>0){
                                houseBillDTO.setDiscount(houseBillDTO.getDiscount()+","+billExcel.getDiscount());
                            }
                            houseBillDTO.setReceiveMoney(houseBillDTO.getReceiveMoney().add(billExcel.getPaySum()));
                        }
                    }
                }
            }
            //去除前五位null和逗号
            if (null != houseBillDTO.getPayTime() && houseBillDTO.getPayTime().length()>0){
                String newPayTime = houseBillDTO.getPayTime().substring(5);
                houseBillDTO.setPayTime(newPayTime);
                if (null != houseBillDTO.getDiscount() && houseBillDTO.getDiscount().length()>0){
                    String newDiscount = houseBillDTO.getDiscount().substring(5);
                    houseBillDTO.setDiscount(newDiscount);
                }
            }
            //金额保留两位四舍五入
            houseBillDTO.setMonthMoney(houseBillDTO.getMonthMoney().setScale(2,BigDecimal.ROUND_HALF_UP));
            houseBillDTO.setYearMoney(houseBillDTO.getYearMoney().setScale(2,BigDecimal.ROUND_HALF_UP));
            houseBillDTO.setShouldMoney(houseBillDTO.getShouldMoney().setScale(2,BigDecimal.ROUND_HALF_UP));
            houseBillDTO.setReceiveMoney(houseBillDTO.getReceiveMoney().setScale(2,BigDecimal.ROUND_HALF_UP));
            houseBillDTO.setUnReceiveMoney(houseBillDTO.getShouldMoney().subtract(houseBillDTO.getReceiveMoney()).setScale(2,BigDecimal.ROUND_HALF_UP));
            resList.add(houseBillDTO);
        }
        return resList;
    }

    @Override
    public PageInfo<BillDetailDTO> queryDailyPage(PropertyQryBill qry) throws ParseException {
        PageInfo<BillDetailDTO> bills = billService.queryFinancial(qry);
        String year = qry.getBeginTime().substring(0,4);
        Date nowBegin = new SimpleDateFormat("yyyy-MM").parse(year+"-01");
        Date nowEnd = new SimpleDateFormat("yyyy-MM").parse(year+"-12");
        for (BillDetailDTO billDetailDTO:bills.getList()){
            for (List<BillItem> billItems:billDetailDTO.getItems().values()){
                for (BillItem billItem:billItems) {
                    count(billItem,nowBegin,nowEnd,year);
                }
            }
        }
        return bills;
    }

    //计算预收欠收当收
    public boolean count(BillItem billItem,Date nowBegin,Date nowEnd,String year) throws ParseException {
        if (null != billItem.getBeginTime() && !"".equals(billItem.getBeginTime())){
            if (billItem.getEndTime().length()>7){
                billItem.setEndTime(getNextDay(billItem.getEndTime()));
            }
            Date billBegin = new SimpleDateFormat("yyyy-MM").parse(billItem.getBeginTime());
            Date billEnd = new SimpleDateFormat("yyyy-MM").parse(billItem.getEndTime());
            if(billBegin.compareTo(nowBegin)<=0 && billEnd.compareTo(nowEnd)<=0 && billEnd.compareTo(nowBegin)>0){
                //订单开始时间小于查询开始时间，订单结束时间小于查询结束时间，订单结束时间大于查询开始时间
                int nowMonth = getBetweenMonth(year+"-01",billItem.getEndTime());
                int beforeMonth;
                if (billItem.getEndTime().length()>7) {
                    beforeMonth = getBetweenMonth(billItem.getBeginTime(), year + "-01");
                }else {
                    beforeMonth = getBetweenMonth(billItem.getBeginTime(), year + "-01")-1;
                }
                int allMonth = getBetweenMonth(billItem.getBeginTime(),billItem.getEndTime());
                BigDecimal before = new BigDecimal(beforeMonth)
                        .divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP)
                        .multiply(new BigDecimal(billItem.getPay().toString()))
                        .setScale(6, BigDecimal.ROUND_HALF_UP);
                BigDecimal now = new BigDecimal(nowMonth)
                        .divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP)
                        .multiply(new BigDecimal(billItem.getPay().toString()))
                        .setScale(6, BigDecimal.ROUND_HALF_UP);
                billItem.setBefore(before.setScale(2,BigDecimal.ROUND_HALF_UP));
                billItem.setNow(now.setScale(2,BigDecimal.ROUND_HALF_UP));
                return true;
            }else if (billBegin.compareTo(nowBegin)>=0 && billEnd.compareTo(nowEnd)<=0){
                //订单开始时间大于查询开始时间，订单结束时间小于查询结束时间
                billItem.setNow(new BigDecimal(billItem.getPay().toString()).setScale(2,BigDecimal.ROUND_HALF_UP));
                return true;
            }else if (billBegin.compareTo(nowBegin)>=0 && billEnd.compareTo(nowEnd)>=0 && billBegin.compareTo(nowEnd)<0){
                //订单开始时间大于查询开始时间，订单结束时间大于查询结束时间，订单开始时间小于查询结束时间
                int nowMonth = getBetweenMonth(billItem.getBeginTime(),year+"-12");
                int afterMonth = getBetweenMonth(year+"-12",billItem.getEndTime());
                int allMonth = getBetweenMonth(billItem.getBeginTime(),billItem.getEndTime());
                BigDecimal after = new BigDecimal(afterMonth)
                        .divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP)
                        .multiply(new BigDecimal(billItem.getPay().toString()))
                        .setScale(6, BigDecimal.ROUND_HALF_UP);
                BigDecimal now = new BigDecimal(nowMonth)
                        .divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP)
                        .multiply(new BigDecimal(billItem.getPay().toString()))
                        .setScale(6, BigDecimal.ROUND_HALF_UP);
                billItem.setAfter(after.setScale(2,BigDecimal.ROUND_HALF_UP));
                billItem.setNow(now.setScale(2,BigDecimal.ROUND_HALF_UP));
                return true;
            }else if (billBegin.compareTo(nowBegin)<0 && billEnd.compareTo(nowEnd)>0){
                //订单开始时间小于查询开始时间，订单结束时间大于查询结束时间
                int beforeMonth;
                if (billItem.getEndTime().length()>7) {
                    beforeMonth = getBetweenMonth(billItem.getBeginTime(), year + "-01");
                }else {
                    beforeMonth = getBetweenMonth(billItem.getBeginTime(), year + "-01")-1;
                }
                int nowMonth = getBetweenMonth(year+"-01",year+"-12");
                int afterMonth = getBetweenMonth(year+"-12",billItem.getEndTime());
                int allMonth = getBetweenMonth(billItem.getBeginTime(),billItem.getEndTime());
                BigDecimal before = new BigDecimal(beforeMonth)
                        .divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP)
                        .multiply(new BigDecimal(billItem.getPay().toString()))
                        .setScale(6, BigDecimal.ROUND_HALF_UP);
                BigDecimal after = new BigDecimal(afterMonth)
                        .divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP)
                        .multiply(new BigDecimal(billItem.getPay().toString()))
                        .setScale(6, BigDecimal.ROUND_HALF_UP);
                BigDecimal now = new BigDecimal(nowMonth)
                        .divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP)
                        .multiply(new BigDecimal(billItem.getPay().toString()))
                        .setScale(6, BigDecimal.ROUND_HALF_UP);
                billItem.setAfter(after.setScale(2,BigDecimal.ROUND_HALF_UP));
                billItem.setBefore(before.setScale(2,BigDecimal.ROUND_HALF_UP));
                billItem.setNow(now.setScale(2,BigDecimal.ROUND_HALF_UP));
                return true;
            }else if (billEnd.compareTo(nowBegin)<0){
                //订单结束时间小于查询开始时间
                billItem.setBefore(new BigDecimal(billItem.getPay().toString()).setScale(2,BigDecimal.ROUND_HALF_UP));
            }else if (billBegin.compareTo(nowEnd)>0){
                //订单开始时间大于查询结束时间
                billItem.setAfter(new BigDecimal(billItem.getPay().toString()).setScale(2,BigDecimal.ROUND_HALF_UP));
            }
        }
        return true;
    }

    @Override
    public Map<String, Map<String, BigDecimal>> queryMonthly(PropertyQryBill qry) throws ParseException {
        String year = qry.getBeginTime().substring(0,4);
        Date nowBegin = new SimpleDateFormat("yyyy-MM").parse(year+"-01");
        Date nowEnd = new SimpleDateFormat("yyyy-MM").parse(year+"-12");
        List<Config> configs = configMapper.queryByVillage(qry.getVillage());
        Map<String,BigDecimal> configMap = new HashMap<>();
        for(Config config:configs){
            String key = config.getCostType()
                    +config.getCostTypeClass()
                    +config.getCostName()
                    +config.getCostTypeSection();
            if ("物业费".equals(config.getCostType())||"车位费".equals(config.getCostType())){
                configMap.put(key+"("+year+"年前+)",new BigDecimal(0));
                configMap.put(key+"("+year+"年+)",new BigDecimal(0));
                configMap.put(key+"("+year+"年后+)",new BigDecimal(0));
                configMap.put(key+"("+year+"年前-)",new BigDecimal(0));
                configMap.put(key+"("+year+"年-)",new BigDecimal(0));
                configMap.put(key+"("+year+"年后-)",new BigDecimal(0));
            }else {
                configMap.put(key+"(+)",new BigDecimal(0));
                configMap.put(key+"(-)",new BigDecimal(0));
            }
        }
        Map<String,Map<String,BigDecimal>> monthMap = new HashMap<>();
        for (int i = 1; i <= 12; i++) {
            Map<String,BigDecimal> subMap = new HashMap<>();
            for (String key:configMap.keySet()){
                subMap.put(key,new BigDecimal(0));
            }
            String beginTime = year+"-"+ StringUtils.leftPad(i+"",2,"0");
            String endTime = getNextMonth(beginTime);
            qry.setBeginTime(beginTime);
            qry.setEndTime(endTime);
            List<BillItem> billItems = reportMapper.queryDetails(qry);
            for (BillItem billItem:billItems) {
                String key = billItem.getCostType()
                        +billItem.getCostTypeClass()
                        +billItem.getCostName()
                        +billItem.getCostTypeSection();
                if ("物业费".equals(billItem.getCostType())||"车位费".equals(billItem.getCostType())){
                    if (0 == billItem.getBillType()){
                        //收款
                        count(billItem,nowBegin,nowEnd,year);
                        subMap.put(key+"("+year+"年前+)",subMap.get(key+"("+year+"年前+)").add(billItem.getBefore()));
                        subMap.put(key+"("+year+"年+)",subMap.get(key+"("+year+"年+)").add(billItem.getNow()));
                        subMap.put(key+"("+year+"年后+)",subMap.get(key+"("+year+"年后+)").add(billItem.getAfter()));
                    }else {
                        //退款
                        count(billItem,nowBegin,nowEnd,year);
                        subMap.put(key+"("+year+"年前-)",subMap.get(key+"("+year+"年前-)").subtract(billItem.getBefore()));
                        subMap.put(key+"("+year+"年-)",subMap.get(key+"("+year+"年-)").subtract(billItem.getNow()));
                        subMap.put(key+"("+year+"年后-)",subMap.get(key+"("+year+"年后-)").subtract(billItem.getAfter()));
                    }
                }else {
                    if (0 == billItem.getBillType()){
                        //收款
                        try {
                            subMap.put(key + "(+)", subMap.get(key + "(+)").add(new BigDecimal(billItem.getPay().toString())));
                        }catch (Exception e){
                            log.info("11111");
                        }
                    }else {
                        //退款
                        subMap.put(key+"(-)",subMap.get(key+"(-)").subtract(new BigDecimal(billItem.getPay().toString())));
                    }
                }
            }
            BigDecimal subSum = new BigDecimal(0);
            for (BigDecimal b:subMap.values()) {
                subSum = subSum.add(b);
            }
            subMap.put("合计",subSum);
            monthMap.put(i+"月份",subMap);
        }
        configMap.put("合计",new BigDecimal(0));
        for (Map.Entry<String,BigDecimal> entry:configMap.entrySet()) {
            String key = entry.getKey();
            BigDecimal sum = entry.getValue();
            for (Map<String, BigDecimal> map : monthMap.values()) {
                sum = sum.add(map.get(key));
            }
            configMap.put(key,sum);
        }
        monthMap.put("合计",configMap);
        return monthMap;
    }

    @Override
    public List<CollectionRate> queryCollectionRate(AccountReceiveReq qry) throws ParseException {
        List<CollectionRate> resList = new ArrayList<>();
        int yearBegin = Integer.parseInt(qry.getPayBegin().substring(0,4));
        int yearEnd = Integer.parseInt(qry.getPayEnd().substring(0,4));
        for (int i = yearBegin; i <=yearEnd ; i++) {
            CollectionRate collectionRate = new CollectionRate();
            List<HouseBillDTO> houseBillDTOS = reportMapper.queryHouseBillDetail(i,qry.getVillage());
            for (HouseBillDTO houseBillDTO:houseBillDTOS) {
                collectionRate.setShouldMoney(collectionRate.getShouldMoney().add(houseBillDTO.getShouldMoney()));
                collectionRate.setReceiveMoney(collectionRate.getReceiveMoney().add(houseBillDTO.getReceiveMoney()));
                collectionRate.setUnReceiveMoney(collectionRate.getUnReceiveMoney().add(houseBillDTO.getUnReceiveMoney()));
            }
            collectionRate.setYear(i);
            if (collectionRate.getShouldMoney().compareTo(new BigDecimal(0))!=0){
                collectionRate.setRate(collectionRate.getReceiveMoney()
                        .divide(collectionRate.getShouldMoney(), 4, BigDecimal.ROUND_HALF_UP)
                        .multiply(new BigDecimal("100")).setScale(2, BigDecimal.ROUND_HALF_UP) + "%");
            }else {
                collectionRate.setRate("0.00%");
            }
            resList.add(collectionRate);
        }
        return resList;
    }

    @Override
    public PageInfo<CarBillDTO> queryCarBill(AccountReceiveReq qry) throws ParseException {
        PageHelper.startPage(qry.getPageNumber(), qry.getPageSize());
        List<CarBill> list = reportMapper.queryCarBill(qry.getVillage());
        List<CarBillDTO> resList = exchangeCarBill(list,qry);
        PageInfo bean = new PageInfo(list);
        bean.setList(resList);
        return bean;
    }

    @Override
    public List<CarBillDTO> queryCarBillAll(AccountReceiveReq qry) throws ParseException {
        List<CarBill> list = reportMapper.queryCarBill(qry.getVillage());
        List<CarBillDTO> resList = exchangeCarBill(list,qry);
        return resList;
    }

    @Override
    public PageInfo<HouseBill> queryEarnestPage(AccountReceiveReq qry) {
        PageHelper.startPage(qry.getPageNumber(), qry.getPageSize());
        List<HouseBill> list = reportMapper.queryEarnest(qry.getVillage());
        PageInfo bean = new PageInfo(list);
        bean.setList(list);
        return bean;
    }

    @Override
    public List<HouseBill> queryEarnestAll(AccountReceiveReq qry) {
        return reportMapper.queryEarnest(qry.getVillage());
    }

    //车位费报表计算
    private List<CarBillDTO> exchangeCarBill(List<CarBill> list,AccountReceiveReq qry) throws ParseException{
        List<CarBillDTO> resList = new ArrayList<>();
        for (CarBill carBill:list){
            CarBillDTO carBillDTO = new CarBillDTO();
            carBillDTO.setVillage(carBill.getVillage());
            carBillDTO.setBuilding(carBill.getBuilding());
            carBillDTO.setLocation(carBill.getLocation());
            carBillDTO.setRoom(carBill.getRoom());
            carBillDTO.setCostName(carBill.getCostName());
            carBillDTO.setCostType(carBill.getCostType());
            carBillDTO.setCostTypeClass(carBill.getCostTypeClass());
            carBillDTO.setCostTypeSection(carBill.getCostTypeSection());
            carBillDTO.setCarNo(carBill.getCarNo());
            carBillDTO.setLicensePlateNo(carBill.getLicensePlateNo());
            carBillDTO.setUnit(carBill.getUnit());
            if (carBill.getBillInfos().size()>0){
                String year = qry.getPayBegin().substring(0,4);
                Date nowBegin = new SimpleDateFormat("yyyy-MM").parse(qry.getPayBegin());
                Date nowEnd = new SimpleDateFormat("yyyy-MM").parse(qry.getPayEnd());
                for(BillExcel billExcel:carBill.getBillInfos()){
                    if (billExcel.getEndTime().length()>7){
                        billExcel.setEndTime(getNextDay(billExcel.getEndTime()));
                    }
                    Date billBegin = new SimpleDateFormat("yyyy-MM").parse(billExcel.getBeginTime());
                    Date billEnd = new SimpleDateFormat("yyyy-MM").parse(billExcel.getEndTime());
                    if(billBegin.compareTo(nowBegin)<=0 && billEnd.compareTo(nowEnd)<=0 && billEnd.compareTo(nowBegin)>0){
                        //订单开始时间小于查询开始时间，订单结束时间小于查询结束时间，订单结束时间大于查询开始时间
                        int nowMonth = getBetweenMonth(year+"-01",billExcel.getEndTime());
                        int allMonth = getBetweenMonth(billExcel.getBeginTime(),billExcel.getEndTime());
                        BigDecimal now = new BigDecimal(nowMonth)
                                .divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP)
                                .multiply(new BigDecimal(billExcel.getPay().toString()))
                                .setScale(6, BigDecimal.ROUND_HALF_UP);
                        carBillDTO.setPayTime(carBillDTO.getPayTime()+","+billExcel.getPayTime());
                        carBillDTO.setBeginTime(carBillDTO.getBeginTime()+","+billExcel.getBeginTime()+"~"+billExcel.getEndTime());
                        carBillDTO.setPaySum(carBillDTO.getPaySum().add(now.setScale(2,BigDecimal.ROUND_HALF_UP)));
                        continue;
                    }else if (billBegin.compareTo(nowBegin)>=0 && billEnd.compareTo(nowEnd)<=0){
                        //订单开始时间大于查询开始时间，订单结束时间小于查询结束时间
                        carBillDTO.setPayTime(carBillDTO.getPayTime()+","+billExcel.getPayTime());
                        carBillDTO.setBeginTime(carBillDTO.getBeginTime()+","+billExcel.getBeginTime()+"~"+billExcel.getEndTime());
                        carBillDTO.setPaySum(carBillDTO.getPaySum().add(new BigDecimal(billExcel.getPay().toString()).setScale(2,BigDecimal.ROUND_HALF_UP)));
                        continue;
                    }else if (billBegin.compareTo(nowBegin)>=0 && billEnd.compareTo(nowEnd)>=0 && billBegin.compareTo(nowEnd)<0){
                        //订单开始时间大于查询开始时间，订单结束时间大于查询结束时间，订单开始时间小于查询结束时间
                        int nowMonth = getBetweenMonth(billExcel.getBeginTime(),year+"-12");
                        int allMonth = getBetweenMonth(billExcel.getBeginTime(),billExcel.getEndTime());
                        BigDecimal now = new BigDecimal(nowMonth)
                                .divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP)
                                .multiply(new BigDecimal(billExcel.getPay().toString()))
                                .setScale(6, BigDecimal.ROUND_HALF_UP);
                        carBillDTO.setPayTime(carBillDTO.getPayTime()+","+billExcel.getPayTime());
                        carBillDTO.setBeginTime(carBillDTO.getBeginTime()+","+billExcel.getBeginTime()+"~"+billExcel.getEndTime());
                        carBillDTO.setPaySum(carBillDTO.getPaySum().add(now.setScale(2,BigDecimal.ROUND_HALF_UP)));
                        continue;
                    }else if (billBegin.compareTo(nowBegin)<0 && billEnd.compareTo(nowEnd)>0){
                        //订单开始时间小于查询开始时间，订单结束时间大于查询结束时间
                        int nowMonth = getBetweenMonth(year+"-01",year+"-12");
                        int allMonth = getBetweenMonth(billExcel.getBeginTime(),billExcel.getEndTime());
                        BigDecimal now = new BigDecimal(nowMonth)
                                .divide(new BigDecimal(allMonth), 6, BigDecimal.ROUND_HALF_UP)
                                .multiply(new BigDecimal(billExcel.getPay().toString()))
                                .setScale(6, BigDecimal.ROUND_HALF_UP);
                        carBillDTO.setPayTime(carBillDTO.getPayTime()+","+billExcel.getPayTime());
                        carBillDTO.setBeginTime(carBillDTO.getBeginTime()+","+billExcel.getBeginTime()+"~"+billExcel.getEndTime());
                        carBillDTO.setPaySum(carBillDTO.getPaySum().add(now.setScale(2,BigDecimal.ROUND_HALF_UP)));
                        continue;
                    }


                }
            }
            //去除前五位null和逗号
            if (null != carBillDTO.getPayTime() && carBillDTO.getPayTime().length()>0){
                String newPayTime = carBillDTO.getPayTime().substring(5);
                String newBeginTime = carBillDTO.getBeginTime().substring(5);
                carBillDTO.setPayTime(newPayTime);
                carBillDTO.setBeginTime(newBeginTime);
            }
            resList.add(carBillDTO);
        }
        return resList;
    }

    //计算月份差
    public int getBetweenMonth(String beginTime,String endTime){
        String[] beginSplit = beginTime.split("-");
        String[] endSplit = endTime.split("-");
        String beginMonth = beginSplit[1];
        String endMonth = endSplit[1];
        String beginYear = beginSplit[0];
        String endYear = endSplit[0];
        Integer betweenMonth;
        if (beginSplit.length == 2 && endSplit.length == 2) {
            betweenMonth = (Integer.valueOf(endYear) - Integer.valueOf(beginYear)) * 12 + (Integer.valueOf(endMonth) - Integer.valueOf(beginMonth))+1;
        }else{
            betweenMonth = (Integer.valueOf(endYear) - Integer.valueOf(beginYear)) * 12 + (Integer.valueOf(endMonth) - Integer.valueOf(beginMonth));
        }
        return  betweenMonth;
    }

    //计算下一个月
    public String getNextMonth(String day){
        String[] split = day.split("-");
        Integer endMonth = Integer.valueOf(split[1]);
        String year = split[0];
        Integer nextMonth = endMonth + 1;
        if (endMonth == 12) {
            nextMonth = 1;
            year = String.valueOf(Integer.valueOf(year) + 1);
        }
        if (nextMonth < 10) {
            day = year + "-0" + nextMonth;
        } else {
            day = year + "-" + nextMonth;
        }
        return day;
    }

    //计算前一个月
    public String getBeforeMonth(String day){
        String[] split = day.split("-");
        Integer endMonth = Integer.valueOf(split[1]);
        String year = split[0];
        Integer nextMonth = endMonth - 1;
        if (endMonth == 1) {
            nextMonth = 12;
            year = String.valueOf(Integer.valueOf(year) - 1);
        }
        if (nextMonth < 10) {
            day = year + "-0" + nextMonth;
        } else {
            day = year + "-" + nextMonth;
        }
        return day;
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
