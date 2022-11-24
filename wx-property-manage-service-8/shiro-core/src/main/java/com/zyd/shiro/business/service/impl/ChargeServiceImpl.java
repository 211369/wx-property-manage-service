package com.zyd.shiro.business.service.impl;

import com.alibaba.fastjson.JSON;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zyd.shiro.business.entity.*;
import com.zyd.shiro.business.service.ChargeService;
import com.zyd.shiro.persistence.beans.SysVillage;
import com.zyd.shiro.persistence.mapper.ChargeMapper;
import com.zyd.shiro.util.*;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.zyd.shiro.util.SecretUtil.decrypt2;

@Service
@Transactional
@Slf4j
public class ChargeServiceImpl implements ChargeService {

    private static final String priKeyStr = SDKConfig.getConfig().getIpayPrivateKey();
    private static final String url = SDKConfig.getConfig().getIpayUrl();
    private static final String mchntCd = SDKConfig.getConfig().getIpayMchntCd();
    private static final String notifyUrl = SDKConfig.getConfig().getIpayNotifyUrl();

    @Autowired
    private ChargeMapper chargeMapper;
    @Autowired
    private WebsocketImpl websocket;

    public static int differentDays(String beginTime, String endTime) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date date1 = sdf.parse(beginTime);
            Date date2 = sdf.parse(endTime);
            Calendar cal1 = Calendar.getInstance();
            cal1.setTime(date1);

            Calendar cal2 = Calendar.getInstance();
            cal2.setTime(date2);
            int day1 = cal1.get(Calendar.DAY_OF_YEAR);
            int day2 = cal2.get(Calendar.DAY_OF_YEAR);

            int year1 = cal1.get(Calendar.YEAR);
            int year2 = cal2.get(Calendar.YEAR);
            if (year1 != year2) //同一年
            {
                int timeDistance = 0;
                for (int i = year1; i < year2; i++) {
                    if (i % 4 == 0 && i % 100 != 0 || i % 400 == 0) //闰年
                    {
                        timeDistance += 366;
                    } else //不是闰年
                    {
                        timeDistance += 365;
                    }
                }

                return timeDistance + (day2 - day1);
            } else //不同年
            {
                System.out.println("判断day2 - day1 : " + (day2 - day1));
                return day2 - day1;
            }
        } catch (ParseException e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public List<String> queryBuildingByVillage(String village) {
        return chargeMapper.queryBuildingByVillage(village);
    }

    @Override
    public List<String> queryLocationByVillageBuilding(String village, String building) {
        return chargeMapper.queryLocationByVillageBuilding(village, building);
    }

    @Override
    public List<String> queryHouse(String village, String building, String location) {
        return chargeMapper.queryHouse(village, building, location);
    }

    @Override
    public HouseInfo queryHouseInfo(String village, String building, String location, String room) {
        return chargeMapper.queryHouseInfo(village, building, location, room);
    }

    @Override
    public ChargeDTO queryCharge(String village, String building, String location, String room, int year) {
        int nextYear = year + 1;
        String endMonth = nextYear + "-01";
        HouseInfo houseInfo = chargeMapper.queryHouseInfo(village, building, location, room);
        BigDecimal roomArea = new BigDecimal(houseInfo.getRoomArea().toString());
        ChargeDTO chargeDTO = new ChargeDTO();
        chargeDTO.setHouseInfo(houseInfo);
        String houseId = houseInfo.getHouseId();
        List<Charge> chargeList = chargeMapper.queryCharge(houseId);
        List<Charge> newChages = new ArrayList<>();
        for (Charge charge : chargeList) {
            String costType = charge.getCostType();
//            String costName = charge.getCostName();
            String beginTime = charge.getBeginTime();
//            String endTime = charge.getEndTime();
            BigDecimal unit = charge.getUnit();

            BigDecimal total;
//            if(!"车位租赁费".equals(costName)){
            Integer betweenMonth;
            if ("物业费".equals(costType)) {
                betweenMonth = getBetweenMonth(beginTime, endMonth);
                if (betweenMonth <= 0) {
                    continue;
                }
                total = roomArea.multiply(new BigDecimal(betweenMonth.toString())).multiply(unit).setScale(2, BigDecimal.ROUND_UP);
            } else if ("车位费".equals(costType)) {
                betweenMonth = getBetweenMonth(beginTime, endMonth);
                if (betweenMonth <= 0) {
                    continue;
                }
                total = new BigDecimal(betweenMonth.toString()).multiply(unit).setScale(2, BigDecimal.ROUND_UP);
            } else {
                total = unit;
            }

//            }else{
//                Integer days = differentDays(beginTime,endTime);
//                if(days<=0){
//                    continue;
//                }
//                total = unit.divide(new BigDecimal("30"),2,BigDecimal.ROUND_UP).multiply(new BigDecimal(days.toString())).setScale(2,BigDecimal.ROUND_UP).doubleValue();
//
//            }
            charge.setTotalMoney(total.doubleValue());
            newChages.add(charge);
        }
        chargeDTO.setChargeList(newChages);
        return chargeDTO;
    }

    @Override
    public Map<String, Object> pay(PayDTO payDTO) {
        Map<String, Object> map = new HashMap<>();
        Long userId = (Long) SecurityUtils.getSubject().getPrincipal();
        String receiveName = chargeMapper.queryNameById(userId);
        String type = payDTO.getType();
        String traceNo = new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date());
        payDTO.setOrderId(traceNo);
        Integer payType = 0;
        String url = null;
        BillInfo billInfo = new BillInfo();
        billInfo.setReceiveName(receiveName);

        SysVillage sysVillage = chargeMapper.queryShopIdByHouseId(payDTO.getHouseId());

        if (null == sysVillage || StringUtils.isBlank(sysVillage.getStaffCode())) {
            throw new RuntimeException("当前小区未配置门店号或店员号，请联系管理员");
        }

        if ("wx".equals(type)) {
            payType = 4;
            wechatPay(payDTO);
        } else if ("mix".equals(type)) {
            payType = 3;
            if (payDTO.getQrCodeMoney() > 0) {
                url = doApplyQrcode(payDTO.getQrCodeMoney(), traceNo, sysVillage.getShopCode(), sysVillage.getStaffCode());
            } else {
                billInfo.setStatus(0);
            }
            billInfo.setRemark("线上支付" + payDTO.getQrCodeMoney() + "元" +
                    "，现金支付" + payDTO.getCashMoney() + "元" +
                    "，刷卡支付" + payDTO.getCardMoney() + "元");
        } else if ("card".equals(type)) {
            payType = 2;
            billInfo.setStatus(0);
        } else if ("cash".equals(type)) {
            payType = 1;
            billInfo.setStatus(0);
        } else {
            payType = 0;
            url = doApplyQrcode(payDTO.getTotalMoney(), traceNo, sysVillage.getShopCode(), sysVillage.getStaffCode());
        }
        map.put("url", url);
        billInfo.setOrderId(traceNo);
        String houseId = payDTO.getHouseId();
        billInfo.setHouseId(houseId);
        billInfo.setPaySum(new BigDecimal(payDTO.getTotalMoney()));
        billInfo.setPayTime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        billInfo.setCheckFlag(0);
        billInfo.setPayType(payType);
        billInfo.setBillType(0);
        chargeMapper.insertBillInfo(billInfo);
        List<BillItem> itemList = payDTO.getItemList();
        for (BillItem billItem : itemList) {
            billItem.setOrderId(traceNo);
//                Integer isTimeChange = billItem.getIsTimeChange();
            String costId = billItem.getCostId();
            String carNo = billItem.getCarId();
            String carId = chargeMapper.queryCarId(carNo, houseId, costId);
            if ("cash".equals(type) || "card".equals(type) || ("mix".equals(type) && payDTO.getQrCodeMoney() == 0)) {
//                    if(isTimeChange == 1){
                String day = "";
                if (!"车位费".equals(billItem.getCostType()) && !"物业费".equals(billItem.getCostType())) {
//                            day = getNextDay(billItem.getEndTime());
                    chargeMapper.deleteConfig(houseId, costId, carId);
                } else {
                    day = billItem.getEndTime();

                    String[] split = day.split("-");
                    //租赁日期到月的，时间与购买一并处理
                    if (split.length != 3 || "购买".equals(billItem.getCostTypeClass())) {
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
                    } else {
                        day = getNextDay(day);
                    }
                    chargeMapper.updateConfig(houseId, costId, carId, day, new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
                }
//                    chargeMapper.updateConfig(houseId,costId,carId,day,new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
//                    }else{
//                        chargeMapper.deleteConfig(houseId,costId,carId);
//                    }
            }
            chargeMapper.insertBillItem(billItem);
        }
        map.put("code", 200);
        map.put("msg", "缴费成功");
        return map;
    }

    public void wechatPay(PayDTO payDTO) {
        //付款
        HashMap<String, String> data = new HashMap<String, String>();
        /**
         * 组装请求报文
         */
        data.put("tran_code", "jsPay");
        //商户号
        data.put("mchnt_cd", mchntCd);
        data.put("sub_appid", "wx3ce78b731b599332");
        //终端流水号
        data.put("trace_no", payDTO.getOrderId());
        //交易金额  以分为单位
        data.put("total_fee", new BigDecimal(payDTO.getTotalMoney().toString()).multiply(new BigDecimal("100")).stripTrailingZeros().toPlainString());
        //用户标识
        data.put("sub_openid", payDTO.getOpenId());
        //门店号
        data.put("shop_id", payDTO.getShopId());
        //异步通知地址
        data.put("notify_url", notifyUrl);
        log.info("请求报文:{}", data);
        try {
            /**
             * 签名
             */
            data.put("sign", SignUtil.generateSignature(data, priKeyStr));
            /**
             * map转json
             */
            JSONObject js = JSONObject.fromObject(data);
            log.info("请求报文:{}", js.toString());
            String result = HttpUtil.postData(url, js.toString(), "application/json");
            log.info("返回报文:{}", result);
            // 网络问题
            if (StringUtils.isBlank(result)) {
                log.error("网络异常");
            }
            /**
             * 转化成map
             */
            Map<String, String> respMap = (Map<String, String>) JSON.parse(result);
            //验签
            if (SignUtil.checkSign(respMap)) {
                log.info("验签成功");
                if ("00".equals(respMap.get("return_code"))) {
                    log.info("交易成功！");
                } else {
                    log.info("交易失败！");
                }
            } else {
                log.info("验签失败");
            }
        } catch (Exception e) {
            log.error(e.getMessage());
        }
    }

    /**
     * 易收宝退款接口
     *
     * @return
     */
    public Boolean refund(String orderId, String orignOrderId, String tradeId, BigDecimal refundFee) {
        //退款
        HashMap<String, String> data = new HashMap<String, String>();
        data.put("mchnt_cd", mchntCd);
        data.put("tran_code", "refund");
        data.put("staff_id", "0000");
        //门店
        //data.put("shop_id", "333021253110759001");
        data.put("refund_fee", new BigDecimal(refundFee.toString()).multiply(new BigDecimal("100")).stripTrailingZeros().toPlainString());
        data.put("trace_no", orderId);
        data.put("orig_trace_no", orignOrderId);
        data.put("orig_out_trade_id", tradeId);
        //data.put("device_id", "100000098");
        data.put("remark", "");
        try {
            /**
             * 签名
             */
            data.put("sign", SignUtil.generateSignature(data, priKeyStr));
            /**
             * map转json
             */
            JSONObject js = JSONObject.fromObject(data);
            System.out.println("请求报文：" + js.toString());
            String result = HttpUtil.postData(url, js.toString(), "application/json");
            System.out.println("返回报文：" + result);
            /**
             * 转化成map
             */
            Map<String, String> respMap = (Map<String, String>) JSON.parse(result);
            //验签
            if (SignUtil.checkSign(respMap)) {
                System.out.println("验签成功");
                if ("00".equals(respMap.get("return_code"))) {
                    System.out.println("交易成功！");
                    //TODO
                    return true;
                } else {
                    System.out.println("交易失败！");
                    //TODO
                    return false;
                }
            } else {
                System.out.println("验签失败");
                //TODO
                return false;
            }


        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 易收宝退款接口
     *
     * @return
     */
    public Boolean depositRefund(String orderId, String orignOrderId, String tradeId, Double refundFee) {
        //退款
        HashMap<String, String> data = new HashMap<String, String>();
        data.put("mchnt_cd", mchntCd);
        data.put("tran_code", "refund");
        data.put("staff_id", "0000");
        //门店
        //data.put("shop_id", "333021253110759001");
        data.put("refund_fee", new BigDecimal(refundFee.toString()).multiply(new BigDecimal("100")).stripTrailingZeros().toPlainString());
        data.put("trace_no", orderId);
        data.put("orig_trace_no", orignOrderId);
        data.put("orig_out_trade_id", tradeId);
        //data.put("device_id", "100000098");
        data.put("remark", "");
        try {
            /**
             * 签名
             */
            data.put("sign", SignUtil.generateSignature(data, priKeyStr));
            /**
             * map转json
             */
            JSONObject js = JSONObject.fromObject(data);
            System.out.println("请求报文：" + js.toString());
            String result = HttpUtil.postData(url, js.toString(), "application/json");
            System.out.println("返回报文：" + result);
            /**
             * 转化成map
             */
            Map<String, String> respMap = (Map<String, String>) JSON.parse(result);
            //验签
            if (SignUtil.checkSign(respMap)) {
                System.out.println("验签成功");
                if ("00".equals(respMap.get("return_code"))) {
                    System.out.println("交易成功！");
                    //TODO
                    return true;
                } else {
                    System.out.println("交易失败！");
                    //TODO
                    return false;
                }
            } else {
                System.out.println("验签失败");
                //TODO
                return false;
            }


        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public String doApplyQrcode(Double totalMoney, String traceNo, String shopId, String staffId) {
        HashMap<String, String> data = new HashMap<String, String>();
        /**
         * 组装请求报文
         */
        //商户号
        data.put("mchnt_cd", mchntCd);
        //终端类型  非必填
        data.put("device_type", "2");
        //终端号    非必填
        data.put("device_id", "2222222222");
        //超时时间  非必填
        data.put("time_out", "120");
        //终端流水号
        data.put("trace_no", traceNo);
        //交易金额  以分为单位
        data.put("total_fee", new BigDecimal(totalMoney.toString()).multiply(new BigDecimal("100")).stripTrailingZeros().toString());
//        data.put("total_fee","1");
        //交易类型
        data.put("trans_type", "1003");
        //门店号
        data.put("shop_id", shopId);
        //店员号
        data.put("staff_id", staffId);
        //交易码
        data.put("tran_code", "applyQrCode");
        //异步通知地址
        data.put("notify_url", notifyUrl);
        log.error("请求报文:{}", data);
        log.info("请求报文:{}", data);
        String resultUrl = null;
        try {
            /**
             * 签名
             */
            data.put("sign", SignUtil.generateSignature(data, priKeyStr));
            /**
             * map转json
             */
            JSONObject js = JSONObject.fromObject(data);
            log.info("请求报文:{}", js.toString());
            String result = HttpUtil.postData(url, js.toString(), "application/json");
            log.info("返回报文:{}", result);
            // 网络问题
            if (StringUtils.isBlank(result)) {
                log.error("网络异常");
            }
            /**
             * 转化成map
             */
            Map<String, String> respMap = (Map<String, String>) JSON.parse(result);
            //验签
            if (SignUtil.checkSign(respMap)) {
                log.info("验签成功");
                if ("00".equals(respMap.get("return_code"))) {
                    resultUrl = respMap.get("url");
                    log.info("交易成功！");
                    log.info("二维码为url：{}", resultUrl);
                } else {
                    log.info("交易失败！");
                }
            } else {
                log.info("验签失败");
            }
        } catch (Exception e) {
            log.error(e.getMessage());
        }
        return resultUrl;
    }

    @Override
    public void notifyOrder(OrderResult orderResult) {
        try {
            String orderId = orderResult.getTraceNo();
            String transStatus = orderResult.getTransStatus();
            //保存易收宝订单号
            String outTradeId = orderResult.getOutTradeId();
            BillInfo billInfo = chargeMapper.queryBillInfoById(orderId);
            String houseId = billInfo.getHouseId();
            log.info("回调查询房屋号：{}", houseId);
            List<BillItem> list = chargeMapper.queryItemById(orderId);
            Integer status = null;
            if ("02".equals(transStatus)) {
                status = 0;
            } else if ("03".equals(transStatus)) {
                status = 1;
            }
            chargeMapper.updateBillInfo(orderId, status, outTradeId);
            for (BillItem billItem : list) {
//                String beginTime = billItem.getBeginTime();
                String endTime = billItem.getEndTime();
                String costId = billItem.getCostId();
                String carNo = billItem.getCarId();
                String carId = null;
                if (carNo != null) {
                    carId = chargeMapper.queryCarId(carNo, houseId, costId);
                }
                Charge charge = chargeMapper.queryEffectiveTime(houseId, carId, costId);
//                String originBegin = charge.getBeginTime();
                String originEnd = charge.getEndTime();
                log.info("回调endTime:{}", endTime);
                log.info("回调originEnd:{}", originEnd);
//                if(!endTime.equals(originEnd)){
                String day = "";
                if (!"车位费".equals(billItem.getCostType()) && !"物业费".equals(billItem.getCostType())) {
//                        day = getNextDay(billItem.getEndTime());
                    chargeMapper.deleteConfig(houseId, costId, carId);
                } else {
                    day = billItem.getEndTime();
                    if ("购买".equals(billItem.getCostTypeClass())) {
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
                    } else {
                        day = getNextDay(day);
                    }
                    chargeMapper.updateConfig(houseId, costId, carId, day, new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
                    log.info("回调修改后的时间:{}", day);
                }
//                    chargeMapper.updateConfig(houseId,costId,carId,day,new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
//                }else{
//                    chargeMapper.deleteConfig(houseId,costId,carId);
//                }
            }
            websocket.groupMessage("支付回调成功");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public Double countRefundMoney(BillItem billItem) {
        String orginTime = billItem.getOrginTime();
        String beginTime = billItem.getBeginTime();
        String endTime = billItem.getEndTime();
        Double pay = billItem.getPay();
        Integer orginBetween = 0;
        Integer nowBetween = 0;
        Double refund;
        if ("购买".equals(billItem.getCostTypeClass())) {
            orginBetween = getBetweenMonth(orginTime, endTime) + 1;
            nowBetween = getBetweenMonth(beginTime, endTime) + 1;
            refund = new BigDecimal(nowBetween.toString()).divide(new BigDecimal(orginBetween.toString()), 2, BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal(pay.toString())).setScale(2, BigDecimal.ROUND_DOWN).doubleValue();
        } else if ("租赁".equals(billItem.getCostTypeClass())) {
            orginBetween = differentDays(orginTime, endTime) + 1;
            nowBetween = differentDays(beginTime, endTime) + 1;
            refund = new BigDecimal(nowBetween.toString()).divide(new BigDecimal(orginBetween.toString()), 6, BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal(pay.toString())).setScale(2, BigDecimal.ROUND_DOWN).doubleValue();
        } else {
            refund = pay;
        }
        return refund;
    }

    @Override
    public Map<String, Object> refund(BillInfo billInfo) {
        Map<String, Object> map = new HashMap<>();
        List<BillItem> billItems = billInfo.getBillItemList();
        for (BillItem billItem : billItems) {
            if (billItem.getPay() > 0) {
                int exist = chargeMapper.existBill(billInfo.getHouseId(), billInfo.getOrderId(), billItem);
                if (exist > 0) {
                    map.put("code", 500);
                    map.put("msg", "退款失败，存在重复退款");
                    log.info(billItem.getCostType() + billItem.getCostTypeClass()
                            + billItem.getCostTypeSection() + billItem.getCostName() + "存在重复退款");
                    return map;
                }
            }
        }
//        String traceNo = new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date());
        String orignOrderId = billInfo.getOrderId();
        String traceNo = billInfo.getOrderId() + "-1";
        billInfo.setStatus(0);
        billInfo.setBillType(1);
//        billInfo.setPayType(1);
//        billInfo.setBillType();
        String nowTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        billInfo.setPayTime(nowTime);
        //退款给原订单打标签
        chargeMapper.updateBillRefund(billInfo.getOrderId(), 1);
        billInfo.setOrderId(traceNo);
        String houseId = billInfo.getHouseId();
        chargeMapper.insertBillInfo(billInfo);
        List<BillItem> billItemList = billInfo.getBillItemList();
        for (BillItem billItem : billItemList) {
            billItem.setOrderId(traceNo);
            Double pay = billItem.getPay();
            if (pay > 0.00) {
                String costId = billItem.getCostId();
//                    String costName = billItem.getCostName();
                String beginTime = billItem.getBeginTime();
//                    String endTime = billItem.getEndTime();
                chargeMapper.insertBillItem(billItem);
                String carNo = billItem.getCarId();
                String carId = "";
                if (carNo != null) {
                    carId = chargeMapper.queryCarId(carNo, houseId, costId);
                }
//                Date beginDate = null;
//                Date endDate = null;
//                if(costName.equals("车位租赁费")){
//                    beginDate = new SimpleDateFormat("yyyy-MM-dd").parse(beginTime);
//                    endDate = new SimpleDateFormat("yyyy-MM-dd").parse(endTime);
//                }else{
//                    beginDate = new SimpleDateFormat("yyyy-MM").parse(beginTime);
//                    endDate = new SimpleDateFormat("yyyy-MM").parse(endTime);
//                }
                if ("车位费".equals(billItem.getCostType()) || "物业费".equals(billItem.getCostType())) {
                    Charge charge = chargeMapper.queryEffectiveTime(houseId, carId, costId);
                    if (charge != null) {
                        chargeMapper.updateConfig(houseId, costId, carId, beginTime, nowTime);
                    }
                }
//                    else{
//                        chargeMapper.insertConfig(houseId,costId,carId,beginTime,endTime,nowTime);
//                    }
            }
        }
        if (billInfo.getBillType() == 1) {
            String outTradeId = chargeMapper.getOutTradeId(orignOrderId);
            boolean flag = refund(traceNo, orignOrderId, outTradeId, billInfo.getPaySum());
            if (flag) {
                map.put("code", 200);
                map.put("msg", "退款成功");
            } else {
                //数据库还原
                chargeMapper.updateBillRefund(orignOrderId, 0);
                chargeMapper.deleteBillRefund(traceNo);
                map.put("code", 201);
                map.put("msg", "退款失败");
            }
        } else {
            map.put("code", 200);
            map.put("msg", "退款成功");
        }
        return map;
    }


    @Transactional(rollbackFor = Exception.class)
    @Override
    public Map<String, Object> depositRefund(BillInfo billInfo,BillItem billItem) {
        Map<String, Object> map = new HashMap<>();
        if (billItem.getPay() > 0) {
            int exist = chargeMapper.existBill(billInfo.getHouseId(), billInfo.getOrderId(), billItem);
            if (exist > 0) {
                map.put("code", 500);
                map.put("msg", "退款失败，存在重复退款");
                log.info(billItem.getCostType() + billItem.getCostTypeClass()
                        + billItem.getCostTypeSection() + billItem.getCostName() + "存在重复退款");
                return map;
            }
        }
//        String traceNo = new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date());
        String orignOrderId = billInfo.getOrderId();
        String traceNo = billInfo.getOrderId() + "-1";
        billInfo.setStatus(0);
        billInfo.setBillType(1);
//        billInfo.setPayType(1);
//        billInfo.setBillType();
        String nowTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        billInfo.setPayTime(nowTime);
        //退款给原订单打标签
        chargeMapper.updateBillRefund(billInfo.getOrderId(), 1);
        billInfo.setOrderId(traceNo);
        chargeMapper.insertBillInfo(billInfo);

        billItem.setOrderId(traceNo);
        Double pay = billItem.getPay();
        if (pay > 0.00) {
            chargeMapper.insertBillItem(billItem);
        }

        if (billInfo.getBillType() == 1) {
            String outTradeId = chargeMapper.getOutTradeId(orignOrderId);
            boolean flag = refund(traceNo, orignOrderId, outTradeId, BigDecimal.valueOf(billItem.getPay()));
            if (flag) {
                map.put("code", 200);
                map.put("msg", "退款成功");
            } else {
                //数据库还原
                chargeMapper.updateBillRefund(orignOrderId, 0);
                chargeMapper.deleteBillRefund(traceNo);
                map.put("code", 201);
                map.put("msg", "退款失败");
            }
        } else {
            map.put("code", 200);
            map.put("msg", "退款成功");
        }
        return map;
    }

    @Override
    public BillInfoDTO queryBill(String village, String building, String location, String room, Integer page, Integer pageSize) {
        BillInfoDTO billInfoDTO = new BillInfoDTO();
        PageHelper.startPage(page, pageSize);
        List<BillInfo> list = chargeMapper.queryBill(village, building, location, room);
        HouseInfo houseInfo = chargeMapper.queryHouseInfo(village, building, location, room);
        billInfoDTO.setPageInfo(new PageInfo<>(list, 10));
        billInfoDTO.setHouseInfo(houseInfo);
        return billInfoDTO;
    }

    @Override
    public Double countPay(BillItem billItem) {
        Double total = 0.0;
        String costType = billItem.getCostType();
        String beginTime = billItem.getBeginTime();
        String endTime = billItem.getEndTime();
//        String costName = billItem.getCostName();
        Double unit = billItem.getUnit();
        Double area = billItem.getArea();
//        if(!costName.equals("车位租赁费")){
        Integer betweenMonth;
        if ("物业费".equals(costType)) {
            betweenMonth = getBetweenMonth(beginTime, endTime) + 1;
            total = new BigDecimal(area.toString()).multiply(new BigDecimal(betweenMonth.toString())).multiply(new BigDecimal(unit.toString())).setScale(2, BigDecimal.ROUND_UP).doubleValue();
        } else if ("车位费".equals(costType) && "购买".equals(billItem.getCostTypeClass())) {
            betweenMonth = getBetweenMonth(beginTime, endTime) + 1;
            total = new BigDecimal(betweenMonth.toString()).multiply(new BigDecimal(unit.toString())).setScale(2, BigDecimal.ROUND_UP).doubleValue();
        } else if ("车位费".equals(costType) && "租赁".equals(billItem.getCostTypeClass())) {
            betweenMonth = getBetweenMonth(beginTime, getNextDay(endTime));
            total = new BigDecimal(betweenMonth.toString()).multiply(new BigDecimal(unit.toString())).setScale(2, BigDecimal.ROUND_UP).doubleValue();
        } else {
            total = unit;
        }

//        }else{
////            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//            Integer days = 0;
//            days = differentDays(beginTime,endTime);
//            total = new BigDecimal(unit.toString()).divide(new BigDecimal("30"),2,BigDecimal.ROUND_UP).multiply(new BigDecimal(days.toString())).setScale(2,BigDecimal.ROUND_UP).doubleValue();
//
//        }
        Double discount = billItem.getDiscount();
        if (discount != null) {
            total = Double.valueOf(new BigDecimal(total.toString()).subtract(new BigDecimal(discount.toString())).toString());

        }
        return total;
    }

    @Override
    public PageInfo<Deposit> queryDeposit(Deposit deposit) {
        List<Deposit> list = new ArrayList<>();
        PageInfo bean = new PageInfo(list);
        if (1 == deposit.getBillType()) {
            PageHelper.startPage(deposit.getPageNumber(), deposit.getPageSize());
            list = chargeMapper.queryDeposit(deposit);
            bean.setList(list);
            bean = new PageInfo(list);
        } else {
            List<Deposit> refund = chargeMapper.queryDeposit(deposit);
            deposit.setBillType(1);
            List<Deposit> refunded = chargeMapper.queryDeposit(deposit);
            refund.removeAll(refunded);
            bean.setList(refund);
            bean = new PageInfo(refund);
        }
        return bean;
    }

    @Override
    public PageInfo<Deposit> queryRefundList(Deposit deposit) {
        List<String> villageList = chargeMapper.getVillage(SessionUtil.getUser().getUsername());
        deposit.setVillageList(villageList);
        List<Deposit> list = new ArrayList<>();
        PageInfo bean = new PageInfo(list);
        if (1 == deposit.getBillType()) {
            PageHelper.startPage(deposit.getPageNumber(), deposit.getPageSize());
            list = chargeMapper.queryRefundList(deposit);
            bean.setList(list);
            bean = new PageInfo(list);
        } else {
            List<Deposit> refund = chargeMapper.queryRefundList(deposit);
            deposit.setBillType(1);
            List<Deposit> refunded = chargeMapper.queryRefundList(deposit);
            refund.removeAll(refunded);
            bean.setList(refund);
            bean = new PageInfo(refund);
        }
        return bean;
    }

    @Override
    public List<ChargeDTO> queryBind(String phone) {
        List<ChargeDTO> resList = new ArrayList<>();
        List<HouseInfo> houseInfos = chargeMapper.queryBind(phone);
        for (HouseInfo houseInfo : houseInfos) {
            ChargeDTO chargeDTO = this.queryCharge(houseInfo.getVillage(),
                    houseInfo.getBuilding(), houseInfo.getLocation(), houseInfo.getRoom(),
                    Calendar.getInstance().get(Calendar.YEAR));
            BigDecimal chargeSum = new BigDecimal(0);
            for (Charge charge : chargeDTO.getChargeList()) {
                chargeSum = chargeSum.add(new BigDecimal(charge.getTotalMoney().toString()));
            }
            chargeDTO.getHouseInfo().setCharge(chargeSum);
            resList.add(chargeDTO);
        }
        return resList;
    }

    @Override
    public void addBind(String phone, String houseId) {
        boolean flag = true;
        List<HouseInfo> houseInfos = chargeMapper.queryBind(phone);
        for (HouseInfo houseInfo : houseInfos) {
            if (houseInfo.getHouseId().equals(houseId)) {
                flag = false;
            }
        }
        if (flag) {
            chargeMapper.addBind(phone, houseId);
        }
    }

    @Override
    public void deleteBind(String phone, String houseId) {
        chargeMapper.deleteBind(phone, houseId);
    }

    @Override
    public Map<String, String> getAuth(String code) {
        Map<String, String> map = new HashMap<>();
//        String url = "https://api.weixin.qq.com/sns/jscode2session?appid=wx3ce78b731b599332&secret=acd42b72aff660e356ceb893bc5142a0&js_code="+code+"&grant_type=authorization_code";
//        String url = "https://api.weixin.qq.com/sns/jscode2session?appid=wxf3ed88d6bcea924a&secret=9e4417ff9a26b8ee3989f70c0d7b6a9d&js_code="+code+"&grant_type=authorization_code";
        String url = "https://api.weixin.qq.com/sns/jscode2session?appid=wx6217202581132c72&secret=27ee8d0123fb592bde197b3d917f120d&js_code=" + code + "&grant_type=authorization_code";
        String json = HttpUtil.doGet(url);
        if (json != null) {
            map = (Map<String, String>) JSON.parse(json);
            String openid = map.get("openid");
            String phone = chargeMapper.queryPhone(openid);
            map.put("phone", phone);
        }
        return map;
    }


    public String getAuthSessionKey(String code) {
        Map<String, String> map = new HashMap<>();
        //        String url = "https://api.weixin.qq.com/sns/jscode2session?appid=wx3ce78b731b599332&secret=acd42b72aff660e356ceb893bc5142a0&js_code="+code+"&grant_type=authorization_code";
//        String url = "https://api.weixin.qq.com/sns/jscode2session?appid=wxf3ed88d6bcea924a&secret=9e4417ff9a26b8ee3989f70c0d7b6a9d&js_code="+code+"&grant_type=authorization_code";
        String url = "https://api.weixin.qq.com/sns/jscode2session?appid=wx6217202581132c72&secret=27ee8d0123fb592bde197b3d917f120d&js_code=" + code + "&grant_type=authorization_code";
        String json = HttpUtil.doGet(url);
        String openid = "";
        if (json != null) {
            map = (Map<String, String>) JSON.parse(json);
            openid = map.get("session_key");
        }
        return openid;
    }

    @Override
    public String saveAuth(Auth auth) {
        String sessionKey = getAuthSessionKey(auth.getCode());
        String phone = decrypt2(auth.getEncryptedData(), sessionKey, auth.getIv(), "UTF-8");
        if (StringUtils.isNoneBlank(phone)) {
            chargeMapper.saveAuth(phone, auth.getOpenId());
        }
        return phone;
    }

    public String getNextDay(String day) {
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

    public int getBetweenMonth(String beginTime, String endTime) {
        String[] beginSplit = beginTime.split("-");
        String[] endSplit = endTime.split("-");
        String beginMonth = beginSplit[1];
        String endMonth = endSplit[1];
        String beginYear = beginSplit[0];
        String endYear = endSplit[0];
        Integer betweenMonth = (Integer.valueOf(endYear) - Integer.valueOf(beginYear)) * 12 + (Integer.valueOf(endMonth) - Integer.valueOf(beginMonth));
        return betweenMonth;
    }

}
