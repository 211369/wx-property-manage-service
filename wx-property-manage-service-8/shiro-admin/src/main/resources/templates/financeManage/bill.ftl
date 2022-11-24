<div class="bill">
    <div id="qrCode"></div>
    <div class="title">
        <div>金华市婺城区城乡物业管理有限公司</div>
<#--        <div>无锡市金佳物业管理有限公司</div>-->
        <div>收款凭据</div>
    </div>
    <ul class="custInfo">
        <li>
            <span class="infoTitle">客户名称：</span>
            <span class="infoContent ownerName"></span>
        </li>
        <li>
            <span class="infoTitle">凭据号：</span>
            <span class="infoContent orderId"></span>
        </li>
        <li>
            <span class="infoTitle">房屋：</span>
            <span class="infoContent house"></span>
        </li>
        <li>
            <span class="infoTitle">收款时间：</span>
            <span class="infoContent payTime"></span>
        </li>
    </ul>
    <table border="1" cellspacing="0" cellpadding="0">
        <thead>
            <td><div style="width: 160px;margin:0 auto;">收费项目</div></td>
            <td><div style="width: 65px;margin:0 auto;">缴费小类</div></td>
            <td>收款方式</td>
            <td><div style="width: 160px;margin:0 auto;">费用所属时间</div></td>
            <td>面积</td>
            <td></td>
            <td>单价</td>
            <td>金额(单位:元)</td>
         </thead>
        <tbody></tbody>
    </table>
    <div class="otherInfo">
        <div>收款人：<span class="receiveName"></span></div>
        <div>
            <span>打印时间：<i style="font-style: normal;" class="time"></i></span>
            <span class="comp">收款单位：盖章有效</span>
        </div>
        <div>此收据仅作为收款凭证，请在30天内凭此收据更换增值税发票，押金类除外。</div>
        <img src="assets/images/seal.png">
    </div>
</div>
<script src="assets/js/print.min.js"></script>
<script>
    function billData(data,type) {
        $("#qrCode").html("");
        var tableStr="";
        var arr=new Array(),list=new Array();//人防留存与人防物业留存在时合并为人防停车费
        //处理支付方式
        if(data.payType==0)var payType="线上支付";
        else if(data.payType==1)var payType="现金支付";
        else if(data.payType==2)var payType="刷卡支付";
        else if(data.payType==3)var payType="混合支付";
        data.data.forEach(function (item,index) {
            if(item.costType=="押金类"||item.costType=="一次性"){
                item.costTypeClass="/";
                item.costTypeSection="/";
                item.orderTime="/";
                item.area="/";
            }
            if(item.costType=="车位费")item.area="/";
            if(!item.discount||Number(item.discount)==0)item.discount="/";

            if(item.costType=="车位费"&&(item.costTypeSection=="人防留存"||item.costTypeSection=="人防物业留存")){
                item.costTypeSection="人防停车费";
                arr.push(item);
            }else list.push(item);
        })
        var billList=list.concat(arr);
        billList.forEach(function(item,index){
            if(arr.length>1){
                if(index<list.length)tableStr+="<tr><td>"+item.costName+"</td><td>"+item.costTypeSection+"</td><td>"+payType+"</td><td>"+item.orderTime+"</td><td>"+item.area+"</td><td>"+item.discount+"</td><td>"+item.unit+"</td><td>"+item.pay+"</td></tr>";
                else if(index==list.length)tableStr+="<tr><td>"+item.costName+"</td><td rowspan='"+arr.length+"'>"+item.costTypeSection+"</td><td>"+payType+"</td><td>"+item.orderTime+"</td><td>"+item.area+"</td><td>"+item.discount+"</td><td>"+item.unit+"</td><td>"+item.pay+"</td></tr>";
                else if(index>list.length)tableStr+="<tr><td>"+item.costName+"</td><td>"+payType+"</td><td>"+item.orderTime+"</td><td>"+item.area+"</td><td>"+item.discount+"</td><td>"+item.unit+"</td><td>"+item.pay+"</td></tr>";
            }else tableStr+="<tr><td>"+item.costName+"</td><td>"+item.costType+"</td><td>"+payType+"</td><td>"+item.orderTime+"</td><td>"+item.area+"</td><td>"+item.discount+"</td><td>"+item.unit+"</td><td>"+item.pay+"</td></tr>"
        })
        if(data.payType==3)tableStr+="<tr><td colspan='8' style='text-align: left'>备注："+data.remark+"</td></tr>";
        tableStr+="<tr><td colspan='8'><div style='text-align: left'>合计金额(大写)：<span style='letter-spacing: 10px;font-size: 15px;font-weight: bolder;'>"+data.paySumCn+"</span><span style='margin-left: 20px'>￥"+data.paySum+"</span></div></td></tr>";
        $(".bill .ownerName").html(data.ownerName);
        $(".bill .orderId").html(data.orderId);
        $(".bill .house").html(data.house);
        $(".bill .payTime").html(data.payTime);
        $(".bill .receiveName").html(data.receiveName);
        $(".bill .time").html(data.time);
        $(".bill tbody").html(tableStr);
        if(type){
            var qrcode = new QRCode(document.getElementById("qrCode"), {width: 70,height: 70});
            qrcode.makeCode(data.orderId);
            $(".bill #qrCode").css("display","inline-block");
        }
    }
</script>
<style>
    @import "assets/css/bill.css";
</style>