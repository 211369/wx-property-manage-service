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
                <label class="col-md-3 col-sm-3 control-label" for="payBegin">查询日期:</label>
                <div class="col-md-9 col-sm-9 col-xs-12">
                    <input class="col-md-12 col-sm-12 col-xs-12 form-control" id="payBegin" name="payBegin" placeholder="请选择查询日期">
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
                    <button type="button" class="btn btn-sm btn-primary" onclick="getCollectRateProList('true')"><i class="glyphicon glyphicon-search"></i>查询</button>
                </div>
                <div class="col-md-5 col-sm-5 col-xs-5">
                    <button type="button" class="btn btn-sm btn-primary" onclick="exportData()"><i class="glyphicon glyphicon-download-alt"></i>导出</button>
                </div>
            </div>
        </form>
        <table id="collectRateProTable"></table>
        <#--   receivableTableExport导出专用     -->
        <div style="width: 100%;overflow: hidden;">
            <table id="receivableTableExport" class="table table-bordered">
                <thead>
                <tr><th colspan="17" id="exportTitle">物业费收缴率统计表</th></tr>
                <tr><th colspan="17" id="exportSearchTime" style="text-align:left;"></th></tr>
                <tr>
                    <th rowspan="2">收费项目</th>
                    <th colspan="2">本月应收</th>
                    <th colspan="2">本月实收</th>
                    <th colspan="2">本月收欠</th>
                    <th rowspan="2">本月收缴率</th>
                    <th rowspan="2">本月收缴率（含欠）</th>
                    <th colspan="2">本年应收</th>
                    <th colspan="2">本年实收</th>
                    <th colspan="2">本年收欠</th>
                    <th rowspan="2">本年收缴率</th>
                    <th rowspan="2">本年收缴率（含欠）</th>
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
</div>
<#include "/layout/footer.ftl"/>
<script type="text/javascript" src="/assets/js/bootstrap-table-export.min.js"></script>
<script type="text/javascript" src="/assets/js/tableExport.min.js"></script>
<script type="text/javascript" src="/assets/js/xlsx.core.min.js"></script>
<script>
    var payBeginLayDate=null;
    $(function () {
        initLayDate();
        queryVillage();
        $(".searchForm #costName").html(costTypeToCostName("物业费"));
    })
    //初始化开始时间和结束时间的layDate日期组件
    function initLayDate() {
        var month=(new Date()).getMonth()+1>9?(new Date()).getMonth()+1:"0"+((new Date()).getMonth()+1);
        payBeginLayDate=laydate.render({
            elem: "#payBegin",
            type:"month",
            value:(new Date()).getFullYear()+"-"+month,
            done: function(value, dates){}
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

                getCollectRateProList("false");
            }
        })
    }
    /**
     * 先查询本年收缴率情况，再查询本月收缴率情况
     * @param {String} flag 值为false,代表初始化，不判断表单的值是否为空，只处理table表格；值为true,代表点击查询时的调用
     * */
    function getCollectRateProList(flag) {
        var formData=$('.receivableStatistics form').serializeObject();
        if(flag=="true"){
            var resMsgList={village:"请选择小区！",payBegin:"请选择查询日期！"};
            for(var i=0;i<Object.keys(formData).length-1;i++){
                if(!formData[Object.keys(formData)[i]]){
                    layer.alert(resMsgList[Object.keys(formData)[i]],{title:"提示"});
                    return false;
                }
            }
        }
        $("#collectRateProTable").bootstrapTable('destroy').bootstrapTable({
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
                    {title: '本月应收', colspan: 2},
                    {title: '本月实收', colspan: 2},
                    {title: '本月收欠', colspan: 2},
                    {field: 'noDebtPercent', title: '本月收缴率', rowspan: 2},
                    {field: 'receivedPercent', title: '本月收缴率（含欠）', rowspan: 2},
                    {title: '本年应收', colspan: 2},
                    {title: '本年实收', colspan: 2},
                    {title: '本年收欠', colspan: 2},
                    {field: 'noDebtPercentYear', title: '本年收缴率', rowspan: 2},
                    {field: 'receivedPercentYear', title: '本年收缴率（含欠）', rowspan: 2},
                ],
                [
                    {field: 'receiveNum', title: '业主数量'},
                    {field: 'receiveMoney', title: '金额'},
                    {field: 'receivedNum', title: '业主数量'},
                    {field: 'receivedMoney', title: '金额'},
                    {field: 'debtNum', title: '业主数量'},
                    {field: 'debtMoney', title: '金额'},
                    {field: 'receiveNumYear', title: '业主数量'},
                    {field: 'receiveMoneyYear', title: '金额'},
                    {field: 'receivedNumYear', title: '业主数量'},
                    {field: 'receivedMoneyYear', title: '金额'},
                    {field: 'debtNumYear', title: '业主数量'},
                    {field: 'debtMoneyYear', title: '金额'},
                ]
            ],
            queryParams: function(param){
                var params={
                    costName:formData.costName,
                    costType:"物业费",
                    village:formData.village,
                }
                if(flag=="false"){
                    var month=(new Date()).getMonth()+1>9?(new Date()).getMonth()+1:"0"+((new Date()).getMonth()+1);
                    params.payBegin=(new Date()).getFullYear()+"-01";
                    params.payEnd=(new Date()).getFullYear()+"-"+month;
                }else{
                    params.payBegin=$("#payBegin").val().substr(0,4)+"-01";
                    params.payEnd=$("#payBegin").val();
                }
                return params;
            },
            responseHandler:function (res) {
                var params={
                    costName:formData.costName,
                    costType:"物业费",
                    village:formData.village
                }
                if(flag=="false"){
                    var month=(new Date()).getMonth()+1>9?(new Date()).getMonth()+1:"0"+((new Date()).getMonth()+1);
                    params.payBegin=(new Date()).getFullYear()+"-"+month;
                    params.payEnd=(new Date()).getFullYear()+"-"+month;
                }else{
                    params.payBegin=$("#payBegin").val();
                    params.payEnd=$("#payBegin").val();
                }
                var list=new Array();
                $.ajax({
                    url: "/report/arQuery",
                    type: "post",
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    data:JSON.stringify(params),
                    async:false,
                    success: function(_res){
                        if(_res&&Object.keys(_res).length!=0){
                            Object.keys(_res).forEach(function(item,index){
                                var obj=_res[item];
                                obj.costName=item;
                                if(item=="总计"){
                                    obj.receiveNum="&mdash;";
                                    obj.receivedNum="&mdash;";
                                    obj.debtNum="&mdash;";
                                    obj.receiveNumYear="&mdash;";
                                    obj.receiveMoneyYear=res[item].receiveMoney;
                                    obj.receivedNumYear="&mdash;";
                                    obj.receivedMoneyYear=res[item].receivedMoney;
                                    obj.debtNumYear="&mdash;";
                                    obj.debtMoneyYear=res[item].debtMoney;
                                    obj.noDebtPercentYear=res[item].noDebtPercent;
                                    obj.receivedPercentYear=res[item].receivedPercent;
                                    list.push(obj);
                                }else{
                                    obj.receiveNumYear=res[item].receiveNum;
                                    obj.receiveMoneyYear=res[item].receiveMoney;
                                    obj.receivedNumYear=res[item].receivedNum;
                                    obj.receivedMoneyYear=res[item].receivedMoney;
                                    obj.debtNumYear=res[item].debtNum;
                                    obj.debtMoneyYear=res[item].debtMoney;
                                    obj.noDebtPercentYear=res[item].noDebtPercent;
                                    obj.receivedPercentYear=res[item].receivedPercent;
                                    list.unshift(obj);
                                }
                            })
                        }
                    }
                })
                //渲染导出专用table
                $("#receivableTableExport #exportSearchTime").html("查询时间："+$("#payBegin").val());
                var str="";
                list.forEach(function(item,index){
                    str+="<tr><td>"+item.costName+
                        "</td><td>"+item.receiveNum+
                        "</td><td>"+item.receiveMoney+
                        "</td><td>"+item.receivedNum+
                        "</td><td>"+item.receivedMoney+
                        "</td><td>"+item.debtNum+
                        "</td><td>"+item.debtMoney+
                        "</td><td>"+item.noDebtPercent+
                        "</td><td>"+item.receivedPercent+
                        "</td><td>"+item.receiveNumYear+
                        "</td><td>"+item.receiveMoneyYear+
                        "</td><td>"+item.receivedNumYear+
                        "</td><td>"+item.receivedMoneyYear+
                        "</td><td>"+item.debtNumYear+
                        "</td><td>"+item.debtMoneyYear+
                        "</td><td>"+item.noDebtPercentYear+
                        "</td><td>"+item.receivedPercentYear+
                        "</td></tr>"
                })
                $("#receivableTableExport tbody").html(str);
                return{
                    "total":list.length,
                    "rows":list
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
        $("#receivableTableExport").tableExport({
            type: 'xlsx',
            exportDataType: "all",
            fileName: "物业费收缴率统计表",
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


