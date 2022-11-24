package com.zyd.shiro.controller;


import java.util.HashMap;
import java.util.Map;
import com.alibaba.fastjson.JSON;
import com.zyd.shiro.util.HttpUtil;
import com.zyd.shiro.util.SDKConfig;
import com.zyd.shiro.util.SignUtil;
import net.sf.json.JSONObject;
import org.apache.commons.lang3.StringUtils;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class APIController {

    private static final Logger logger = LoggerFactory.getLogger(APIController.class);

    private static final String priKeyStr = SDKConfig.getConfig().getIpayPrivateKey();
    private static final String url = SDKConfig.getConfig().getIpayUrl();
    private static final String mchntCd = SDKConfig.getConfig().getIpayMchntCd();
    private static final String notifyUrl = SDKConfig.getConfig().getIpayNotifyUrl();
    // 终端流水号 需由商户自行提供，每次调起接口都不可相同，长度不可超过32位
    private static final String traceNo = "2021" + System.currentTimeMillis();


    /**
     *  此demo 仅供参考
     */
    public static void main(String[] args) {
//        APIController itest = new APIController();
//        itest.doApplyQrcode();
        double a = 1264.64;
        double b = 2000;
        double c = 0;
        System.out.println(a+b+c);

    }

    /**
     * @Method:doApplyQrcode
     * @Description 主扫申码测试示例
     * @Author zhix.huang
     * @Date 2019/5/20 13:36
     * @Param  []
     * @return void
     * @throw
     **/
    @Test
    public void doApplyQrcode() {
        System.out.println("主扫申码");
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
        //终端流水号
        data.put("trace_no", traceNo);
        //超时时间  非必填
        data.put("time_out", "120");
        //交易金额  以分为单位
        data.put("total_fee", "234");
        //交易类型
        data.put("trans_type", "1003");
        //店员号
        data.put("staff_id", "0000");
        //交易码
        data.put("tran_code", "applyQrCode");
        //异步通知地址
        data.put("notify_url",notifyUrl);
        System.out.println(data);
        try {
            /**
             * 签名
             */
            data.put("sign", SignUtil.generateSignature(data, priKeyStr));
            /**
             * map转json
             */
            JSONObject js  = JSONObject.fromObject(data);
            System.out.println("请求报文："+js.toString());
            String result = HttpUtil.postData(url,js.toString(),"application/json");
            System.out.println("返回报文："+result);
            // 网络问题
            if (StringUtils.isBlank(result)){
                System.out.println("网络异常");
            }
            //返回报文：{"sign":"jGfW/blfWsyA/aSIJShMtJMj6sDYQZhSN1ScKDncxSDRiLFOS55tHWnh5Or1RjNlSAWRp5RcPSOkI124qsXd4E8BYcXauevatXgVByzKUuclin4eJTwlfaWZvbFrzr1It/ZxUAnFHgDAU9ZTRE6uQhdDl8iTryPbUHj0vbAdPvxK5EgeIifKWPl2lZa+CbkUvWNaSzsUt8cFg3svdJ3LKCQFj6eH3YNykVxz6lva+vAo26gOpIKDGwG2Ohq7xI9GMpdhRF0y4APanqXtge4fbm9B1C+v/D11ns9jCb17nELn47QBqtvMeQkxCoNiCx4adpi3qoeuUzxaVgvzQrd++g==","
            // trace_no":"20211613975821187","out_trade_id":"20210222143733216183025407920589","total_fee":"1","return_msg":"申码成功","return_code":"00","url":"https://weixinsupport.nbcb.com.cn/qrcode1/qrCodeRedirect.do?qrCode=/20210222143733046668519521515670"}

            /**
             * 转化成map
             */
            Map<String, String> respMap = (Map<String, String>) JSON.parse(result);
            //验签
            if(SignUtil.checkSign(respMap)){
                System.out.println("验签成功");
                if ("00".equals(respMap.get("return_code"))){
                    System.out.println("交易成功！");
                    System.out.println("二维码为url："+respMap.get("url"));
                    //二维码为url：https://weixinsupport.nbcb.com.cn/qrcode1/qrCodeRedirect.do?qrCode=/20210222143733046668519521515670

                }else{
                    System.out.println("交易失败！");
                }
            }else {
                System.out.println("验签失败");
            }


        } catch (Exception e) {
            logger.error(e.getMessage());
        }
    }

    @Test
    public void tuiKuan() {
        System.out.println("退款");
        HashMap<String, String> data = new HashMap<String, String>();
        /**
         * 组装请求报文
         */
        data.put("mchnt_cd", mchntCd);
        data.put("tran_code", "refund");
        data.put("staff_id", "0000");
        //门店
        //data.put("shop_id", "333021253110759001");
        data.put("refund_fee", "1");
        data.put("trace_no", "27791772ef7a48688023a8d663a1ddf4");
        data.put("orig_trace_no", "27791772ef7a48688023a8d663a1ddf5");
        data.put("orig_out_trade_id", "20210923095347552140359490668577");
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
            JSONObject js  = JSONObject.fromObject(data);
            System.out.println("请求报文："+js.toString());
            String result = HttpUtil.postData(url,js.toString(),"application/json");
            System.out.println("返回报文："+result);
            /**
             * 转化成map
             */
            Map<String, String> respMap = (Map<String, String>) JSON.parse(result);
            //验签
            if(SignUtil.checkSign(respMap)){
                System.out.println("验签成功");
                if ("00".equals(respMap.get("return_code"))){
                    System.out.println("交易成功！");
                    //TODO

                }else{
                    System.out.println("交易失败！");
                    //TODO
                }
            }else {
                System.out.println("验签失败");
                //TODO
            }


        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     *@Method:doIsScan
     *@Description 被扫测试示例
     *@Author wangchao
     * @Date 2021/02/22 13:36
     *@return void
     */
    @Test
    public void doIsScan(){

        HashMap<String, String> data = new HashMap<String, String>();
        /**
         * 组装请求报文
         */
         //交易码
        data.put("tran_code", "isScan");
        //商户号
        data.put("mchnt_cd", mchntCd);
        //店员号
        data.put("staff_id", "0000");
        //终端流水号
        data.put("trace_no", traceNo);
        //超时时间  非必填
        data.put("time_out", "120");
        //交易金额  以分为单位
        data.put("total_fee", "1");
        // 用户付款码
        data.put("auth_code","281915449146993600");

        try {
            // 进行加签
            data.put("sign", SignUtil.generateSignature(data, priKeyStr));
            /**
             * map转json
             */
            JSONObject js  = JSONObject.fromObject(data);
            System.out.println("请求报文："+js.toString());
            String result = HttpUtil.postData(url,js.toString(),"application/json");
            System.out.println("返回报文："+result);
            // 返回报文：{"trans_status_desc":"支付成功","fund_type":"0","trans_status":"02","trace_no":"20211613975639099",
            // "fund_type_name":"账户余额","t0Flag":"1","out_trade_id":"20210222143431586632856422761971","return_msg":"提交成功","trans_datetime":"20210222143505","channel_type":"2","
            // sign":"FdjCDo9S+tyL7PVkUObCKuvVQr6YM2LbEbIguUVLe/XtpPxD1bRg/oCXIapxXTrt0rp1TdZsbu1zfXjQ7CESTcuPimIWBVRvafRS36qkIs6XE4V+2pRJWVPj5hsei5TKtXHpoeuvHgMPZZ5GDwE0J8CchrQazcqy51ZW4WRFl2ABTOUqO1kamIaI8iTDg58ufS9C34Io91r8bjhAql55vL2qgWO8H7dP3O9YdV133KaAXaNe1nYUhfNMq4KxE0qnoVZAK8PWShUk+/7ze5XkUYvxxm5ztnCX05WOGcccHH13qL5KKbtYND0BMmcc/uLiLUc/AbjXk29Sxuie802KXg==",
            // "trade_id":"112021022222001458491435578435","total_fee":"1","channel_type_name":"支付宝","hanglingCharge":"0","return_code":"00","platformFee":"0"}
            /**
             * 转化成map
             */
            Map<String, String> respMap = (Map<String, String>) JSON.parse(result);
            //验签
            if(SignUtil.checkSign(respMap)){
                System.out.println("验签成功");
                if ("00".equals(respMap.get("return_code"))){
                    System.out.println("支付成功！");
                    System.out.println(respMap.get("return_msg"));
                }else{
                    System.out.println("支付失败！");
                }
            }else {
                System.out.println("验签失败");
            }
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
    }

    /**
     *@Method:doQueryOrderStatus
     *@Description 订单查询测试示例
     *@Author wangchao
     * @Date 2021/02/22 13:50
     *@return void
     */
    @Test
    public void doQueryOrderStatus(){

        HashMap<String, String> data = new HashMap<String, String>();
        //交易码
        data.put("tran_code", "queryOrderStatus");
        // 此处为防止网络问题出现接收不到 易收宝返回的订单号，由原订单的流水号去查询
        data.put("trace_no","20211613975639099");
        // 订单流水号，此流水号为易收宝返回的订单号 交易返回报文中 out_trade_id 字段
        data.put("out_trade_id","20210222143431586632856422761971");
        //商户号
        data.put("mchnt_cd", mchntCd);

        try {
            // 进行加签
            data.put("sign", SignUtil.generateSignature(data, priKeyStr));
            /**
             * map转json
             */
            JSONObject js  = JSONObject.fromObject(data);
            System.out.println("请求报文："+js.toString());
            String result = HttpUtil.postData(url,js.toString(),"application/json");
            System.out.println("返回报文："+result);
            //返回报文：{"trans_status_desc":"支付成功","fund_type":"0","trans_status":"02","trace_no":"20211613975639099","fund_type_name":"账户余额","t0Flag":"1","out_trade_id":"20210222143431586632856422761971","return_msg":"查询成功","trans_datetime":"20210222143431","channel_type":"2","bussinessLine":"3",
            // "sign":"Nqt3+HrDvGEkzmE3xIiJTFSrEe8vwWhUepd0FqXYNrlOAFvn1AQ8WhjZi5MHp/lEjVyCrFQiD6Qzqww3vYpoNCpu7r8VjQmy2pLBqFJvahLQwnokF/xaV7DlfyjujQ3jQrD+QGGZYhtOmCa+IwxniPyotlNhOa/kgkHzdRxT2coebIOkRsuCsm7nbehoEXxma0dHzftosWBnfbOWH0B3+s7TaLMvO6brU8BeiIQtAsXINVxi3om1tdgX6db8hXypYutacebdyv2yrU+sLUQcAhLrzi6dBuMyVYIDc5b41x99M/yar44NTVbWBqUWFB1KMfTNdb6JisVL8Z9jBBKQ2Q==",
            // "refundAmount":"0","total_fee":"1","channel_type_name":"支付宝","hanglingCharge":"0","return_code":"00","platformFee":"0"}
            /**
             * 转化成map
             */
            Map<String, String> respMap = (Map<String, String>) JSON.parse(result);
            //验签
            if(SignUtil.checkSign(respMap)){
                System.out.println("验签成功");
                if ("00".equals(respMap.get("return_code"))){
                    System.out.println("查询成功！");
                    System.out.println(respMap.get("return_msg"));
                }else{
                    System.out.println("查询失败！");
                    System.out.println(respMap.get("return_msg"));
                }
            }else {
                System.out.println("验签失败");
            }
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
    }
    /**
     *@Method:doRefund
     *@Description 退款测试示例
     *@Author wangchao
     * @Date 2021/02/22 14:00
     *@return void
     */
    @Test
    public void doRefund(){

        HashMap<String, String> data = new HashMap<String, String>();
        //交易码
        data.put("tran_code", "refund");
        //商户号
        data.put("mchnt_cd", mchntCd);
        // 员工号
        data.put("staff_id","0000");
        // 退款金额 以分为单位，
        data.put("refund_fee","1");
        //终端流水号
        data.put("trace_no", traceNo);
        // 原终端流水号  此流水号为交易成功 那笔流水号。
        data.put("orig_trace_no","20211613975639099");
        // 原商户订单流水号，此流水号为易收宝返回的订单号 交易返回报文中 out_trade_id 字段
        data.put("orig_out_trade_id","20210222143431586632856422761971");

        try {
            // 进行加签
            data.put("sign", SignUtil.generateSignature(data, priKeyStr));
            /**
             * map转json
             */
            JSONObject js  = JSONObject.fromObject(data);
            System.out.println("请求报文："+js.toString());
            String result = HttpUtil.postData(url,js.toString(),"application/json");
            System.out.println("返回报文："+result);
            //返回报文：{"sign":"MN7q1OvoZhbCLghU7cJQFLU8GBV+OPqzTIcBZxD3/P3qausAiQTL/XdYiIT4c7J4TrSGIcGTwgKdtGQ5RsDXdu6j4uksENFpnmPHcOEeCpEp1/Lj09xxi+dBYr/IdNznsDjkKgwAfq0H/4zLfARehBsM4sWkv9TZTGwHzcK1kB1iiQX1vUPvRLdipDIWV50C2YLERT2jwxo8cBa5U7J4f+7C74B2hckQSAA7zn6kVMa9Orqb94G9q/VBNRTlL7dsftL7wgDPzFTDHbkRPSEsWUnXM9ksmBz16GKoukDZ0RfZ8sA84cVsx5R4IbOABjFP4VgMazrccetUalGieWjS5g==",
            // "refundFlag":"0","refund_fee":"1","fund_type":"0","total_fee":"1","out_trade_id":"20210222145409559683642054366268","return_msg":"申请退款成功","refund_datetime":"20210222145409","trans_datetime":"20210222143431","hanglingCharge":"0","return_code":"00"}
            /**
             * 转化成map
             */
            Map<String, String> respMap = (Map<String, String>) JSON.parse(result);
            //验签
            if(SignUtil.checkSign(respMap)){
                System.out.println("验签成功");
                if ("00".equals(respMap.get("return_code"))){
                    System.out.println("申请退款成功！");
                    System.out.println(respMap.get("return_msg"));
                }else{
                    System.out.println("退款失败！");
                    System.out.println(respMap.get("return_msg"));
                }
            }else {
                System.out.println("验签失败");
            }
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
    }

    /**
     *@Method:doQueryRefund
     *@Description 退款查询测试示例
     *@Author wangchao
     * @Date 2021/02/22 14:10
     *@return void
     */
    @Test
    public void doQueryRefund(){

        HashMap<String, String> data = new HashMap<String, String>();
        //交易码
        data.put("tran_code", "queryRefund");
        //商户号
        data.put("mchnt_cd", mchntCd);
        // 此处为防止网络问题出现接收不到易收宝返回的订单号，由原订单的流水号去查询
        data.put("trace_no","20211613976816126");
        // 订单流水号，此流水号为易收宝返回的订单号 交易返回报文中 out_trade_id 字段
        // 退款查询时，要取退款那笔返回的订单号，不要取交易成功的订单号
        data.put("out_trade_id","20210222145409559683642054366268");

        try {
            // 进行加签
            data.put("sign", SignUtil.generateSignature(data, priKeyStr));
            /**
             * map转json
             */
            JSONObject js  = JSONObject.fromObject(data);
            System.out.println("请求报文："+js.toString());
            String result = HttpUtil.postData(url,js.toString(),"application/json");
            System.out.println("返回报文："+result);
            //返回报文：{"trans_status_desc":"退款交易成功","refund_no":"20210222145409559683642054366268","refund_fee":"1","trans_status":"02","out_trade_id":"20210222143431586632856422761971","return_msg":"退款查询成功","refund_datetime":"20210222145409","trans_datetime":"20210222145409","trade_type":"1006","refund_status_desc":"已退款",
            // "sign":"Q3ijETO2NjGDg+lPVLO1Ygsv40W/8FOhaZSn2VI34qm1yhI7Nb+jOuz2VxutmGKCi/wzOo10JR26XOEsAV6tadU+CzGRjMWCNlKSiVH3MIMwCsXHJUlqequn8gOqGK8MuMWn9xYn30XuwnOoSKPLITPN4ISqeePfcsMZcwMwgbxA7zQ+S9f8HW8OsWv6+TvjoG+qfklCJUG4sI505Xsig3Tp42GUbX67YKxBapCF67vJiih7FkYmBGN37MEVUAIh/rLw5I5cpCxHZxX5hBwNNRuPquRM5IbzBkAEaI6uHUAbeggEbr9ad48biQ82wu7f/RkT5/QzgWZ7Qqd81bXrTA==",
            // "refundAmount":"1","orig_trans_datetime":"20210222143431","orig_out_trade_id":"20210222143431586632856422761971","total_fee":"1","trade_id":"112021022222001458491435578435","time_end":"20210222145409","hanglingCharge":"0","refund_status":"02","return_code":"00"}
            /**
             * 转化成map
             */
            Map<String, String> respMap = (Map<String, String>) JSON.parse(result);
            //验签
            if(SignUtil.checkSign(respMap)){
                System.out.println("验签成功");
                if ("00".equals(respMap.get("return_code"))){
                    System.out.println("退款查询成功！");
                    System.out.println(respMap.get("return_msg"));
                }else{
                    System.out.println("退款查询失败！");
                    System.out.println(respMap.get("return_msg"));
                }
            }else {
                System.out.println("验签失败");
            }
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
    }


    /**
     *@Method:doTransFlwQuery
     *@Description 交易明细测试示例
     *@Description 此处是批量查询，查询时间跨度不能超过三个月
     *@Author wangchao
     * @Date 2021/02/22 14:20
     *@return void
     */
    @Test
    public void doTransFlwQuery(){

        HashMap<String, String> data = new HashMap<String, String>();
        //交易码
        data.put("tran_code", "transFlwQuery");
        //商户号
        data.put("mchnt_cd", mchntCd);
        // 员工号
        data.put("staff_id","0000");
        // 交易查询起始时间  格式为 YYYYMMDDHHMMSS
        data.put("start_time","20200901000000");
        // 交易查询结束时间  格式为 YYYYMMDDHHMMSS
        data.put("end_time","20201201000000");
        // 交易状态
        data.put("trans_status","02,10");
        // 页数
        data.put("page_no","1");
        // 行数
        data.put("rows","10");

        try {
            // 进行加签
            data.put("sign", SignUtil.generateSignature(data, priKeyStr));
            /**
             * map转json
             */
            JSONObject js  = JSONObject.fromObject(data);
            System.out.println("请求报文："+js.toString());
            String result = HttpUtil.postData(url,js.toString(),"application/json");
            System.out.println("返回报文："+result);
            //返回报文：{"sign":"i5nRSvA5GSxgaVgIGNH7v9AaEIEHJXEOrr68lbxj4hZjbBGugmDaYcSAVZ5jdWxQuAS26x3CrImyuVq2toftcs3gS/fCEk/BZeXyIw2cDw8i1Nj4KI/HRJM1AGM9RM/R14/e8iyjqUYrS0MXTAS1o30ygJTvKxeR+2iHg0RqESDB8IyiiMmOd9PJ6hBCBHZkOuzSONbdoHuSfpDcvsGkWrbmdimocOgX/1It2PotsCw5e+hRntccbU2c7T7ZykMJJZMLSlp+KmxXSTT6PUHjeABy318/K3bMGttSTrliR/5UwDsM9UiCto/7FdCBtDr7IG6+P0ILysPpxQCbXyf83Q==",
            // "trans_data":"[{\"fund_type\":\"1\",\"remark\":\"\",\"platFormFee\":\"0\",\"refundAmount\":1,\"total_fee\":1,\"mchnt_cd\":\"333021253110488\",\"rebates\":\"1\",\"hanglingCharge\":\"0\",\"refund_amount\":\"1\",\"trans_status_desc\":\"已退款\",\"trans_status\":\"10\",\"out_trade_id\":\"20210222143431586632856422761971\",\"trans_datetime\":\"20210222143431\",\"channel_type\":2,\"businessLine\":\"3\",\"trans_type\":\"1001\"}]",
            // "return_msg":"查询成功","total_rows":"1","allFee":"0","allNum":"0","return_code":"00"}

            /**
             * 转化成map
             */
            Map<String, String> respMap = (Map<String, String>) JSON.parse(result);
            //验签
            if(SignUtil.checkSign(respMap)){
                System.out.println("验签成功");
                if ("00".equals(respMap.get("return_code"))){
                    System.out.println("查询成功！");
                    System.out.println(respMap.get("return_msg"));
                }else{
                    System.out.println("查询失败！");
                    System.out.println(respMap.get("return_msg"));
                }
            }else {
                System.out.println("验签失败");
            }
        } catch (Exception e) {
            logger.error(e.getMessage());
        }

    }

    /**
     *@Method:doRrCheckFile
     *@Description 查询对账测试示例
     *@Author wangchao
     *@Date 2021/02/22 14:10
     *@return void
     */
    @Test
    public void doRrCheckFile(){

        HashMap<String, String> data = new HashMap<String, String>();

        //交易码
        data.put("tran_code", "qrCheckFile");
        //商户号
        data.put("mchnt_cd", mchntCd);
        // 交易日期 当日不可查
        data.put("trans_date","20200916");
        // 查询页数
        data.put("qr_page","1");

        try {
            // 进行加签
            data.put("sign", SignUtil.generateSignature(data, priKeyStr));
            /**
             * map转json
             */
            JSONObject js  = JSONObject.fromObject(data);
            System.out.println("请求报文："+js.toString());
            String result = HttpUtil.postData(url,js.toString(),"application/json");
            System.out.println("返回报文："+result);
            //返回报文：{"sign":"AdM9thcsC8joh/vpZN0+rGN2mrk8o6Pm4vW3CJ6bMAaJCwclcaPDMfNJgh8Zqv/9uxDpIUpamYMAwDBKvKDP8mTCk3rLmtdl7aM5w9WAkA7Uj1NkObMnThY/BLlnw+U/F1NCoXURZiW+fDG2hCn+21XHL9v6e3HWyDB8K7Q5tS5qhpdW+wqeINagC6R2bIymsUGodf0wd4XsTo8VfAcI8xsE7mF5+H7Ytl/KcbHYRbA0SJSUoL5nAYREV1HK0FfXxLG2oG8SYMesI381sLHyMLg8wCLotySX4ZPpSVQ/37tGxuFynrDzyvPxKtLi23A5lRW/y5JSytxPu9F+7jDzBA==",
            // "trans_data":"[]","return_msg":"查询成功","total_rows":"0","return_code":"00"}

            /**
             * 转化成map
             */
            Map<String, String> respMap = (Map<String, String>) JSON.parse(result);
            //验签
            if(SignUtil.checkSign(respMap)){
                System.out.println("验签成功");
                if ("00".equals(respMap.get("return_code"))){
                    System.out.println("查询成功！");
                    System.out.println(respMap.get("return_msg"));
                }else{
                    System.out.println("查询失败！");
                    System.out.println(respMap.get("return_msg"));
                }
            }else {
                System.out.println("验签失败");
            }
        } catch (Exception e) {
            logger.error(e.getMessage());
        }

    }

    /**
     *@Method:doJsPay
     *@Description 微信公众号 微信小程序测试示例
     *@Author wangchao
     *@Date 2021/02/22 14:10
     *@return void
     */
    @Test
    public void doJsPay(){

        HashMap<String, String> data = new HashMap<String, String>();
        //交易码
        data.put("tran_code", "jsPay");
        //商户号
        data.put("mchnt_cd", mchntCd);
        // 微信开放平台审核通过的应用 appid
        data.put("sub_appid","wx09f64c32c5ca725a");
        // 用户在商户 appid 下的唯一标识
        data.put("sub_openid","oUpF8uEQTik1HB6l_ctI0DHEcYeg");
        // 异步地址
        data.put("notify_url","https://www.baidu.com");
        // 终端流水号
        data.put("trace_no",traceNo);
        // 交易金额
        data.put("total_fee","1");

        try {
            // 进行加签
            data.put("sign", SignUtil.generateSignature(data, priKeyStr));
            /**
             * map转json
             */
            JSONObject js  = JSONObject.fromObject(data);
            System.out.println("请求报文："+js.toString());
            String result = HttpUtil.postData(url,js.toString(),"application/json");
            System.out.println("返回报文："+result);

            /**
             * 转化成map
             */
            Map<String, String> respMap = (Map<String, String>) JSON.parse(result);
            //验签
            if(SignUtil.checkSign(respMap)){
                System.out.println("验签成功");
                if ("00".equals(respMap.get("return_code"))){
                    System.out.println(respMap.get("return_msg"));
                }else{
                    System.out.println(respMap.get("return_msg"));
                }
            }else {
                System.out.println("验签失败");
            }
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
    }
}
