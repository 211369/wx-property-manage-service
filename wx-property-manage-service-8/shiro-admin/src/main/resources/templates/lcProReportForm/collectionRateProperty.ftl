<#include "/layout/header.ftl"/>
<div class="clearfix"></div>
<div class="row content_bg_common financeManage">
    <div class="col-md-12 col-sm-12 col-xs-12">
        <form id="searchForm" class="col-md-12 col-sm-12 col-xs-12 form-horizontal form-label-left">
            <div class="item form-group col-md-2 col-sm-2">
                <label class="col-md-3 col-sm-3 control-label" for="villageName">小区:</label>
                <div class="col-md-9 col-sm-9 col-xs-12">
                    <select id="villageName" name="villageName" class="form-control">
                        <option value="">请选择</option>
                    </select>
                </div>
            </div>
            <div class="item form-group col-md-4 col-sm-4 col-xs-12" id="timeRange">
                <label class="control-label col-md-3 col-sm-3 col-xs-12">查询时间:</label>
                <div class="col-md-4 col-sm-4 col-xs-12" style="width: 35%">
                    <input class="form-control col-md-12 col-sm-12 col-xs-12" readonly="readonly" id="beginTime" name="beginTime" placeholder="请选择开始时间">
                </div>
                <div class="col-md-1 col-sm-1 col-xs-12 other" style="width: 5%">~</div>
                <div class="col-md-4 col-sm-4 col-xs-12" style="width: 35%">
                    <input class="form-control col-md-12 col-sm-12 col-xs-12" readonly="readonly" id="endTime" name="endTime" placeholder="请选择结束时间">
                </div>
            </div>
            <div class="item form-group col-md-4 col-sm-4 col-xs-4" style="margin-top: 2px;">
                <div class="col-md-12 col-sm-12 col-xs-12">
                    <button type="button" class="btn btn-sm btn-primary" onclick="searchCollectRatePro()"  style="margin-left: 10px;"><i class="glyphicon glyphicon-search"></i>查询</button>
                    <button type="button" class="btn btn-sm btn-primary" onclick="exportDetail()"  style="margin-left: 10px;"><i class="glyphicon glyphicon-download-alt"></i>导出</button>
                </div>
            </div>
        </form>
        <table id="collectRateProTable"></table>
    </div>
</div>
<#include "/layout/footer.ftl"/>
<script src="/assets/js/xlsx.core.min.js"></script>
<script>
    $(function () {
        var exportList=new Array();
        searchVillage();
        initLayDate();
    })
    //查询小区列表
    function searchVillage() {
        var obj="";
        $.ajax({
            url: "/charge/queryVillage",
            type: "get",
            success: function(res){
                if(res&&res.length!=0){
                    res.forEach(function(item,index){
                        obj+="<option value='"+item+"'>"+item+"</option>"
                    })
                }
                $("#searchForm #villageName").html(obj);
                $("#searchForm #villageName").val(res[0]);
                getCollectRatePro();
            },
            error: function(error){
                $("#searchForm #villageName").html(obj);
                getCollectRatePro();
            }
        });
    }
    //初始化查询时间layDate组件
    function initLayDate() {
        $("#beginTime").val(new Date().getFullYear());
        $("#endTime").val(new Date().getFullYear());
        laydate.render({
            elem: '#timeRange',
            type:"year",
            range: ['#beginTime', '#endTime'],
            btns: ['confirm']
        });
    }
    //查询物业费收缴率列表
    function getCollectRatePro() {
        $("#collectRateProTable").bootstrapTable({
            url:"/report/queryCollectionRate",
            method: 'post',
            dataType: "json",
            contentType: 'application/json',
            toolbar: '#toolbar',
            toggle:"table",
            sidePagination: "server",
            pagination: false,
            pageNumber: 1,
            pageSize: 10,
            pageList: [10, 25,30],
            columns:[
                {
                    field: 'year',
                    title: '年份',
                },{
                    field: 'shouldMoney',
                    title: '应收金额(单位：元)',
                },{
                    field: 'receiveMoney',
                    title: '已收金额(单位：元)',
                },{
                    field: 'rate',
                    title: '收缴率',
                },{
                    field: 'unReceiveMoney',
                    title: '欠费金额(单位：元)',
                },{
                    field: 'remark',
                    title: '备注',
                }
            ],
            height:$(".content_bg_common").height()-$("#searchForm").height()-25,
            queryParams: function(param){
                var params={
                    payBegin:$("#beginTime").val()+"-01",
                    payEnd:$("#endTime").val()+"-12",
                };
                if($("#villageName").val())params.village=$("#villageName").val();
                return params;
            },
            formatLoadingMessage: function(){
                return "正在加载中。。。";
            },
            responseHandler:function (res) {
                var list=new Array(),shouldMoneyTotal=new BigNumber(0),receiveMoneyTotal=new BigNumber(0),unReceiveMoneyTotal=new BigNumber(0);
                if(res&&res.length!=0){
                    list=res.map(function(item,index){
                        shouldMoneyTotal=new BigNumber(shouldMoneyTotal).plus(item.shouldMoney).toNumber();
                        receiveMoneyTotal=new BigNumber(receiveMoneyTotal).plus(item.receiveMoney).toNumber();
                        unReceiveMoneyTotal=new BigNumber(unReceiveMoneyTotal).plus(item.unReceiveMoney).toNumber();
                        if(!item.remark)item.remark="";
                        item.year=item.year+"年度";
                        return item;
                    })
                    list.push({year:"合计",shouldMoney:shouldMoneyTotal,receiveMoney:receiveMoneyTotal,unReceiveMoney:unReceiveMoneyTotal,rate:"/",remark:""});
                };
                if(list.length!=0)exportList=list;
                return{
                    "total":list.length,
                    "rows":list
                }
            },
        })
    }
    //点击查询按钮
    function searchCollectRatePro () {
        $("#collectRateProTable").bootstrapTable("refresh");
    }
    /*导出明细*/
    function exportDetail(){
        if(exportList.length==0){
            layer.alert("查询数据为空，导出失败！",{title:"警告"});
        }else {
            var list = exportList.map(function (item, index) {
                var obj = {
                    "年份": item.year,
                    "应收金额(单位：元)": item.shouldMoney,
                    "已收金额(单位：元)": item.receiveMoney,
                    "收缴率": item.rate,
                    "欠费金额(单位：元)": item.unReceiveMoney,
                    "备注": item.remark ? item.remark : ""
                }
                return obj;
            })
            var data = {
                data: list,
                fileName: "物业费收缴率",
                wpx: [{wpx: 80}, {wpx: 130}, {wpx: 130}, {wpx: 80}, {wpx: 130}, {wpx: 130}]
            }
            downloadExcel(new Array(data), "物业费收缴率");
        }
    }
    //动态设置列表table的高度
    window.onresize=function () {
        $("#collectRateProTable").bootstrapTable('resetView', {
            height:$(".content_bg_common").height()-$("#searchForm").height()-25,
        });
    }
</script>
<style>
    #collectRateProTable tbody tr:last-of-type{
        font-weight: bolder;
    }
</style>