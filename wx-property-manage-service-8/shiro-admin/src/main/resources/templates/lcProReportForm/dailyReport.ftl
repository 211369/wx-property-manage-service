<#include "/layout/header.ftl"/>
<div class="clearfix"></div>
<div class="row content_bg_common financeManage">
    <div class="col-md-12 col-sm-12 col-xs-12">
        <form id="searchForm" class="col-md-12 col-sm-12 col-xs-12 form-horizontal form-label-left">
            <div class="item form-group col-md-2 col-sm-2">
                <label class="col-md-4 col-sm-4 control-label" for="beginTime">查询时间:</label>
                <div class="col-md-8 col-sm-8 col-xs-12">
                    <input type="text" readonly="readonly" class="form-control col-md-12 col-xs-12" name="beginTime" id="beginTime" placeholder="请选择查询时间" autocomplete="off"/>
                </div>
            </div>
            <div class="item form-group col-md-4 col-sm-4 col-xs-2" style="margin-top: 2px;">
                <div class="col-md-12 col-sm-12 col-xs-12">
                    <button type="button" class="btn btn-sm btn-primary" onclick="getDailyReport()"  style="margin-left: 10px;"><i class="glyphicon glyphicon-search"></i>查询</button>
                    <button type="button" class="btn btn-sm btn-primary" onclick="exportDetail()"  style="margin-left: 10px;"><i class="glyphicon glyphicon-download-alt"></i>导出</button>
                </div>
            </div>
        </form>
        <table id="dailyReportTable"></table>
    </div>
</div>
<#include "/layout/footer.ftl"/>
<script src="/assets/js/xlsx.core.min.js"></script>
<script>
    var mergeCellArr = new Array();//合并单元格使用
    var fieldArr=["orderId","house","receiptCode","house","ownerName","payType","payTime"];//需要合并列的字段名
    $(function () {
        initLayDate();
        getDailyReport();
    })
    //初始化查询时间layDate组件
    function initLayDate() {
        var month=new Date().getMonth()+1>9?new Date().getMonth()+1:"0"+String(new Date().getMonth()+1);
        var day=new Date().getDate()>9?new Date().getDate():"0"+String(new Date().getDate());
        laydate.render({
            elem: "#beginTime",
            value:new Date().getFullYear()+"-"+month+"-"+day,
            btns:["now","confirm"]
        })
    }
    //查询收支日报表
    function getDailyReport() {
        var currentYear = $("#beginTime").val()?$("#beginTime").val().substr(0,4):new Date().getFullYear();
        $("#dailyReportTable").bootstrapTable("destroy").bootstrapTable({
            url:"/report/queryDailyPage",
            method: 'post',
            dataType: "json",
            contentType: 'application/json',
            toolbar: '#toolbar',
            toggle:"table",
            sidePagination: "server",
            pagination: true,
            pageNumber: 1,
            pageSize: 10,
            pageList: [10, 25,30],
            columns:[
                {
                    field: 'orderId',
                    title: '凭据号',
                },{
                    field: 'receiptCode',
                    title: '发票号',
                },{
                    field: 'house',
                    title: '房屋',
                },{
                    field: 'ownerName',
                    title: '业主姓名',
                },{
                    field: 'costType',
                    title: '缴费类型',
                },{
                    field: 'costName',
                    title: '缴费项目',
                },{
                    field: 'income',
                    title: '收入(单位:元)',
                },{
                    field: 'expend',
                    title: '支出(单位:元)',
                },{
                    field: 'payTimeRange',
                    title: '费用所属时间',
                },{
                    field: 'before',
                    title: currentYear+'年前',
                },{
                    field: 'now',
                    title: currentYear+'年',
                },{
                    field: 'after',
                    title: currentYear+'年后',
                },{
                    field: 'payType',
                    title: '结账方式',
                },{
                    field: 'payTime',
                    title: '入账时间',
                }
            ],
            height:$(".content_bg_common").height()-$("#searchForm").height()-25,
            queryParams: function(param){
                var params={
                    pageNumber:param.offset/param.limit +1,
                    pageSize:param.limit,
                    beginTime:$("#beginTime").val(),
                    endTime:$("#beginTime").val(),
                }
                return params;
            },
            formatLoadingMessage: function(){
                return "正在加载中。。。";
            },
            responseHandler:function (res) {
                var list=new Array(),num=0,_num=0;//需要先执行mergeCellArr.push后再对num做运算，_num作为中转使用
                mergeCellArr = new Array();
                if(res&&res.list&&Array.isArray(res.list)&&res.list.length!=0){
                    res.list.forEach(function (item, index) {
                        if(Object.keys(item.items).length!=0){
                            var rowspanLength=0;
                            Object.keys(item.items).forEach(function (_item,_index) {
                                item.items[_item].forEach(function (value,i) {
                                    var obj={
                                        house:item.billInfo.house,
                                        orderId:item.billInfo.orderId,
                                        ownerName:item.billInfo.ownerName,
                                        receiptCode:item.billInfo.receiptCode?item.billInfo.receiptCode:"",
                                        payTimeRange:value.costType=="物业费"||value.costType=="车位费"?value.beginTime+"~"+value.endTime:"/",
                                        before:value.before,
                                        after:value.after,
                                        costName:value.costName,
                                        costType:value.costType,
                                        payTime:item.billInfo.payTime
                                    }
                                    //处理结账方式
                                    if(item.billInfo.payType==0)obj.payType="线上支付";
                                    else if(item.billInfo.payType==1)obj.payType="现金支付";
                                    else if(item.billInfo.payType==2)obj.payType="刷卡支付";
                                    else if(item.billInfo.payType==3)obj.payType="混合支付";
                                    else obj.payType="";
                                    //处理收入和支出
                                    if(item.billInfo.billType==0){
                                        obj.income=value.pay;
                                        obj.expend="";
                                    }else if(item.billInfo.billType==1){
                                        obj.income="";
                                        obj.expend=value.pay;
                                    }else{
                                        obj.income="";
                                        obj.expend="";
                                    }
                                    //处理非车位费非物业费项目的当年收支情况
                                    if(value.costType=="物业费"||value.costType=="车位费")obj.now=value.now;
                                    else obj.now=value.pay;
                                    list.push(obj);
                                })
                                _num+=item.items[_item].length;
                                rowspanLength+=item.items[_item].length;
                            })
                            fieldArr.forEach(function (_value, _i) {
                                mergeCellArr.push({index: num, field: _value, rowspan: rowspanLength});
                            })
                            num=_num;//若先执行num+运算，会导致合并单元格错乱
                        }
                    })
                }
                return{
                    "total":res.total,
                    "rows":list
                }
            },
            onLoadSuccess:function (data) {
                mergeCellArr.forEach(function(item,index){
                    $('#dailyReportTable').bootstrapTable('mergeCells', item);
                })
            },
        })
    }
    //导出明细
    function exportDetail(){
        var currentYear = $("#beginTime").val()?$("#beginTime").val().substr(0,4):new Date().getFullYear();
        $.ajax({
            url: "/report/queryDailyAll",
            type: "post",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            data:JSON.stringify({beginTime:$("#beginTime").val(),endTime:$("#beginTime").val()}),
            async:false,
            success: function(res){
                if(res&&res.list){
                    if(res.list.length==0){
                        layer.alert("查询数据为空，导出失败！",{title:"警告"});
                    }else{
                        var list=new Array();
                        res.list.forEach(function (item, index) {
                            if(Object.keys(item.items).length!=0){
                                Object.keys(item.items).forEach(function (_item,_index) {
                                    item.items[_item].forEach(function (value,i) {
                                        //处理结账方式
                                        if(item.billInfo.payType==0)var payType="线上支付";
                                        else if(item.billInfo.payType==1)var payType="现金支付";
                                        else if(item.billInfo.payType==2)var payType="刷卡支付";
                                        else if(item.billInfo.payType==3)var payType="混合支付";
                                        else var payType="";
                                        //处理收入和支出
                                        if(item.billInfo.billType==0){
                                            var income=value.pay;
                                            var expend="";
                                        }else if(item.billInfo.billType==1){
                                            var income="";
                                            var expend=value.pay;
                                        }else{
                                            var income="";
                                            var expend="";
                                        }
                                        //处理非车位费非物业费项目的当年收支情况
                                        if(value.costType=="物业费"||value.costType=="车位费")var now=value.now;
                                        else var now=value.pay;
                                        var obj={
                                            "凭据号":item.billInfo.orderId,
                                            "发票号":item.billInfo.receiptCode?item.billInfo.receiptCode:"",
                                            "房屋":item.billInfo.house,
                                            "业主姓名":item.billInfo.ownerName,
                                            "缴费类型":value.costType,
                                            "缴费项目":value.costName,
                                            "收入(单位:元)":income,
                                            "支出(单位:元)":expend,
                                            "费用所属时间":value.costType=="物业费"||value.costType=="车位费"?value.beginTime+"~"+value.endTime:"/",
                                            [currentYear+"年前"]:value.before,
                                            [currentYear+"年"]:now,
                                            [currentYear+"年后"]:value.after,
                                            '结账方式':payType,
                                            "入账时间":item.billInfo.payTime
                                        }
                                        list.push(obj);
                                    })
                                })
                            }
                        })
                        var data={
                            data:list,
                            fileName:"收支日报表",
                            wpx:[{wpx: 120},{wpx: 120},{wpx: 160},{wpx: 120},{wpx: 80},{wpx: 120},{wpx: 100},{wpx: 100},{wpx: 130},{wpx: 100},{wpx: 100},{wpx: 100},{wpx: 100},{wpx: 130}]
                        }
                        downloadExcel(new Array(data),"收支日报表");
                    }
                }else layer.alert("数据查询异常，导出失败！",{title:"警告"});
            },
            error: function(error){
                layer.alert("数据查询异常，导出失败！",{title:"警告"});
            }
        });
    }
    //动态设置列表table的高度
    window.onresize=function () {
        $("#dailyReportTable").bootstrapTable('resetView', {
            height:$(".content_bg_common").height()-$("#searchForm").height()-25,
        });
    }
</script>