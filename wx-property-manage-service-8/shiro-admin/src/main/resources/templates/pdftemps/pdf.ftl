<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="Content-Style-Type" content="text/css"/>
    <title></title>
    <style type="text/css">
        body {
            font-family: pingfang sc light;
        }
        .center{
            text-align: center;
            width: 100%;
        }
    </style>
</head>
<body>
    <p style="text-align: center;">
    <strong>金华市婺城区城乡物业管理有限公司</strong><br/>
    <strong>收款凭据</strong>
</p>

<table width="100%">
    <tbody>
        <tr>
            <td width="150" valign="top" >
                客户名称：
            </td>
            <td width="450" valign="top" >
                ${ownerName}
            </td>
             <td width="150" valign="top" >
                凭据号：
            </td>
            <td width="450" valign="top" >
                ${orderId}
            </td>
         </tr>
         <tr>
            <td width="150" valign="top" >
                房屋：
            </td>
            <td width="450" valign="top" >
                ${house}
            </td>
             <td width="150" valign="top" >
                收款时间：
            </td>
            <td width="450" valign="top" >
                ${payTime}
            </td>
         </tr>
    </tbody>
</table>
<br/>
<table width="100%" border="1" style="border-collapse:collapse">
    <tbody>
        <tr>
            <td width="99" valign="top" >
                收费项目
            </td>
            <td width="99" valign="top" >
                收款方式
            </td>
            <td width="198" valign="top" >
                费用所属时间
            </td>
            <td width="99" valign="top" >
                面积
            </td>
            <td width="99" valign="top" >
                折扣
            </td>
            <td width="99" valign="top" >
                单价
            </td>
            <td width="99" valign="top" >
                金额
            </td>
        </tr>
        <#list data as item>
	        <tr>
	            <td width="99" valign="top" >
	                ${item.costName}
	            </td>
	            <td width="99" valign="top" >
	                ${payType}
	            </td>
	            <td width="198" valign="top" >
	                ${item.orderTime}
	            </td>
	            <td width="99" valign="top" >
	                ${item.area}
	            </td>
	            <td width="99" valign="top" >
	                ${item.unit}
	            </td>
	            <td width="99" valign="top" >
	                ${item.discount}
	            </td>
	            <td width="99" valign="top" >
	                ${item.pay}
	            </td>
	        </tr>
        </#list>
     
        <tr>
            <td width="99" valign="top">应收金额</td>
            <td width="99" valign="top">${amount}</td>
            <td width="198" valign="top">折扣金额</td>
            <td width="99" valign="top" >
                ————
            </td>
            <td width="99" valign="top">${discountSum}</td>        
            <td width="99" valign="top" >实收金额</td>
            <td width="99" valign="top" >${paySum}</td>
        </tr>
    </tbody>
</table>
<p>
    <br/>
</p>

<p style="text-align: left;position: relative">
    <span>收款人：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="Apple-tab-span" style="white-space: pre;">${payee}</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;交款人:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${payer}</span>
	<br/>
	<span>打印时间：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="Apple-tab-span" style="white-space: pre;">${time}</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;收款单位:（盖章有效）&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
	<br/>
	<span>此收据仅作为收款凭证，请在30天内凭此收据更换增值税发票，押金类除外</span><img src="${path}/1.jpg" height="100" width="100" style="position: absolute;bottom:0;right: 0;"></img>
</p>

</body>
</html>