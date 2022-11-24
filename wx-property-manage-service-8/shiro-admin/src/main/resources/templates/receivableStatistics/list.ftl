<#include "/layout/header.ftl"/>
<div class="clearfix"></div>
<div class="row content_bg_common receivableStatistics">
    <div class="col-md-12 col-sm-12 col-xs-12">
        <form class="col-md-12 col-sm-12 col-xs-12 form-horizontal form-label-left searchForm">
            <div class="item form-group col-md-2 col-sm-2">
                <label class="col-md-2 col-sm-2 control-label" for="village">小区:</label>
                <div class="col-md-10 col-sm-10 col-xs-10">
                    <select id="village" name="village" class="form-control"></select>
                </div>
            </div>
            <div class="item form-group col-md-2 col-sm-2">
                <label class="col-md-3 col-sm-3 control-label" for="payBegin">开始时间:</label>
                <div class="col-md-9 col-sm-9 col-xs-12">
                    <input class="col-md-12 col-sm-12 col-xs-12 form-control" id="payBegin" name="payBegin" placeholder="请选择开始时间">
                </div>
            </div>
            <div class="item form-group col-md-2 col-sm-2">
                <label class="col-md-3 col-sm-3 control-label" for="payEnd">结束时间:</label>
                <div class="col-md-9 col-sm-9 col-xs-12">
                    <input class="col-md-12 col-sm-12 col-xs-12 form-control" id="payEnd" name="payEnd" placeholder="请选择结束时间">
                </div>
            </div>
            <div class="item form-group col-md-2 col-sm-2">
                <label class="col-md-3 col-sm-3 control-label" for="costType">费用类型:</label>
                <div class="col-md-9 col-sm-9 col-xs-12">
                    <select id="costType" name="costType" class="form-control">
                        <option>物业费</option>
                        <option>车位费</option>
                    </select>
                </div>
            </div>
            <div class="item form-group col-md-2 col-sm-2">
                <label class="col-md-4 col-sm-4 control-label" for="costName">缴费项目:</label>
                <div class="col-md-8 col-sm-8 col-xs-12">
                    <select id="costName" name="costName" class="form-control"></select>
                </div>
            </div>
            <div class="item form-group col-md-2 col-sm-2">
                <div class="col-md-5 col-sm-5 col-xs-5">
                    <button type="button" class="btn btn-sm btn-primary" onclick="getProOrCarReceiveList('true')"><i class="glyphicon glyphicon-search"></i>查询</button>
                </div>
                <div class="col-md-5 col-sm-5 col-xs-5">
                    <button type="button" class="btn btn-sm btn-primary" onclick="exportData()"><i class="glyphicon glyphicon-download-alt"></i>导出</button>
                </div>
            </div>
        </form>
        <div id="proTableMain"><table id="receivableProTable"></table></div>
        <div id="carTableMain" style="display: none;"><table id="receivableCarTable"></table></div>
        <#--   receivableTableExport导出专用     -->
        <table id="receivableTableExport" class="table table-bordered">
            <thead>
                <tr><th colspan="15" id="exportTitle"></th></tr>
                <tr><th colspan="15" id="exportSearchTime" style="text-align:left;"></th></tr>
                <tr>
                    <th rowspan="2">收费项目</th>
                    <th colspan="2">本期收入</th>
                    <th colspan="2">本期应收</th>
                    <th colspan="2">本期实收</th>
                    <th colspan="2">本期收欠</th>
                    <th colspan="2">本期预收</th>
                    <th colspan="2">本期退费</th>
                    <th rowspan="2">本期收缴率（含欠）</th>
                    <th rowspan="2">本期收缴率（不含欠）</th>
                </tr>
                <tr>
                    <th>业主数量</th>
                    <th>金额</th>
                    <th>业主数量</th>
                    <th>金额</th>
                    <th>业主数量</th>
                    <th>金额</th>
                    <th>业主数量</th>
                    <th>金额</th>
                    <th>业主数量</th>
                    <th>金额</th>
                    <th>业主数量</th>
                    <th>金额</th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>
</div>
<#include "/layout/footer.ftl"/>
<script type="text/javascript" src="/assets/js/bootstrap-table-export.min.js"></script>
<script type="text/javascript" src="/assets/js/tableExport.min.js"></script>
<script type="text/javascript" src="/assets/js/xlsx.core.min.js"></script>
<script>
    var payBeginLayDate=null,payEndLayDate=null;
    var propertyType=costTypeToCostName("物业费");
    var carType=costTypeToCostName("车位费");
    $(function () {
        initLayDate();
        queryVillage();
        $(".searchForm #costName").html(propertyType);
    })
    //费用类型发生改变
    $(".searchForm #costType").change(function(){
        var val=$(".searchForm #costType").val();
        if(val==""){
            $(".searchForm #costName").html(propertyOrCarType);
        }else if(val=="物业费"){
            $(".searchForm #costName").html(propertyType);
        }else if(val=="车位费"){
            $(".searchForm #costName").html(carType);
        }
    });
    //初始化开始时间和结束时间的layDate日期组件
    function initLayDate() {
        payBeginLayDate=laydate.render({
            elem: "#payBegin",
            type:"month",
            max:"2099-12-31",
            value:(new Date()).getFullYear()+"-01",
            done: function(value, dates){
                payEndLayDate.config.min ={
                    year:dates.year,
                    month:dates.month-1,
                    date: dates.date,
                    hours: 0,
                    minutes: 0,
                    seconds : 0
                };
            }
        })
        payEndLayDate=laydate.render({
            elem: "#payEnd",
            type:"month",
            min:"1970-1-1",
            value:(new Date()).getFullYear()+"-12",
            done: function(value, dates){
                payBeginLayDate.config.max={
                    year:dates.year,
                    month:dates.month-1,
                    date: dates.date,
                    hours: 0,
                    minutes: 0,
                    seconds : 0
                }
            }
        })
    }
    //查询小区
    function queryVillage(){
        $.ajax({
            url: "/charge/queryVillage",
            type: "get",
            success: function(res){
                if(res&&res.length!=0){
                    var obj=new Object();
                    res.forEach(function(item,index){
                        if(index==0)obj+="<option selected='selected'>"+item+"</option>";
                        else obj+="<option value="+item+">"+item+"</option>";
                    })
                    $("form #village").html(obj);
                }else $("form #village").html("<option value=''>请选择</option>");

                getProOrCarReceiveList("false");
            }
        })
    }
    /**
     * 获取物业费或车位费应收统计
     * @param {String} flag 值为false,代表初始化，不判断表单的值是否为空，只处理table表格；值为true,代表点击查询时的调用
     * */
    function getProOrCarReceiveList(flag) {
        var formData=$('.receivableStatistics form').serializeObject(),domId="";
        console.log(formData)
        var resMsgList={village:"请选择小区！",payBegin:"请选择开始时间！",payEnd:"请选择结束时间！",costType:"请选择费用类型！"};
        if(flag=="true"){
            for(var i=0;i<Object.keys(formData).length-1;i++){
                if(!formData[Object.keys(formData)[i]]){
                    layer.alert(resMsgList[Object.keys(formData)[i]],{title:"提示"});
                    return false;
                }
            }
        }
        if(formData.costType=="物业费"){
            domId="#receivableProTable";
            $("#receivableTableExport #exportTitle").html("物业费收缴率统计表");
            $("#receivableTableExport #exportSearchTime").html("查询时间："+$("#payBegin").val()+"到"+$("#payEnd").val());
        }
        else if(formData.costType=="车位费"){
            domId="#receivableCarTable";
            $("#receivableTableExport #exportTitle").html("车位费收缴率统计表");
            $("#receivableTableExport #exportSearchTime").html("查询时间："+$("#payBegin").val()+"到"+$("#payEnd").val());
        }
        else return;
        $(domId).bootstrapTable('destroy').bootstrapTable({
            url:"/report/arQuery",
            method: 'post',
            dataType: "json",
            contentType: 'application/json',
            toolbar: '#toolbar',
            toggle:"table",
            sidePagination: "server",
            pagination: false,
            columns:[
                [
                    {field: 'costName', title: '收费项目', rowspan: 2},
                    {title: '本期收入', colspan: 2},
                    {title: '本期应收', colspan: 2},
                    {title: '本期实收', colspan: 2},
                    {title: '本期收欠', colspan: 2},
                    {title: '本期预收', colspan: 2},
                    {title: '本期退费', colspan: 2},
                    {field: 'receivedPercent', title: '本期收缴率（含欠）', rowspan: 2},
                    {field: 'noDebtPercent', title: '本期收缴率（不含欠）', rowspan: 2},
                ],
                [
                    {field: 'realNum', title: '业主数量'},
                    {field: 'realMoney', title: '金额'},
                    {field: 'receiveNum', title: '业主数量'},
                    {field: 'receiveMoney', title: '金额'},
                    {field: 'receivedNum', title: '业主数量'},
                    {field: 'receivedMoney', title: '金额'},
                    {field: 'debtNum', title: '业主数量'},
                    {field: 'debtMoney', title: '金额'},
                    {field: 'advanceNum', title: '业主数量'},
                    {field: 'advanceMoney', title: '金额'},
                    {field: 'refundNum', title: '业主数量'},
                    {field: 'refundMoney', title: '金额'}
                ]
            ],
            queryParams: function(params){
                console.log(formData)
                if(flag=="false"){
                    formData.payBegin=(new Date()).getFullYear()+"-01";
                    formData.payEnd=(new Date()).getFullYear()+"-12";
                }
                return formData;
            },
            formatLoadingMessage: function(){
                return "正在加载中。。。";
            },
            responseHandler:function (res) {
                var list=new Array();
                if(res&&Object.keys(res).length!=0){
                    Object.keys(res).forEach(function(item,index){
                        var obj=res[item];
                        obj.costName=item;
                        if(item=="总计"){
                            obj.realNum="&mdash;";
                            obj.receiveNum="&mdash;";
                            obj.receivedNum="&mdash;";
                            obj.debtNum="&mdash;";
                            obj.advanceNum="&mdash;";
                            obj.refundNum="&mdash;";
                            list.push(obj);
                        }
                        else list.unshift(obj);
                    })
                }
                //渲染导出专用table
                var str="";
                list.forEach(function(item,index){
                    str+="<tr><td>"+item.costName+
                        "</td><td>"+item.realNum+
                        "</td><td>"+item.realMoney+
                        "</td><td>"+item.receiveNum+
                        "</td><td>"+item.receiveMoney+
                        "</td><td>"+item.receivedNum+
                        "</td><td>"+item.receivedMoney+
                        "</td><td>"+item.debtNum+
                        "</td><td>"+item.debtMoney+
                        "</td><td>"+item.advanceNum+
                        "</td><td>"+item.advanceMoney+
                        "</td><td>"+item.refundNum+
                        "</td><td>"+item.refundMoney+
                        "</td><td>"+item.receivedPercent+
                        "</td><td>"+item.noDebtPercent+
                        "</td></tr>"
                })
                $("#receivableTableExport tbody").html(str);
                return{
                    "total":list.length,
                    "rows":list
                }
            },
            onLoadSuccess:function () {
                if(formData.costType=="物业费"){
                    $("#proTableMain").show();
                    $("#carTableMain").hide();
                }else if(formData.costType=="车位费"){
                    $("#proTableMain").hide();
                    $("#carTableMain").show();
                }
            }
        })
    }
    /**
     *导出excel
     * */
    function exportData() {
        if($('#receivableTableExport').bootstrapTable("getData").length==0){
            layer.alert("不能导出空数据表格！",{title:"警告"});
            return false;
        }
        if($("#costType").val()=="物业费")var fileName="物业费报表";
        else if($("#costType").val()=="车位费")var fileName=" 车位费报表";
        $("#receivableTableExport").tableExport({
            type: 'excel',
            exportDataType: "all",
            fileName: fileName,
            mso:{
                //修复导出数字不显示为科学计数法
                onMsoNumberFormat: function (cell, row, col) {
                    return !isNaN($(cell).text())?'\\@':'';
                }
            },
            onCellHtmlData: function (cell, row, col, data){
                return data;
            },
        });
    }
</script>


