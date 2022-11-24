<#include "/layout/header.ftl"/>
<div class="clearfix"></div>
<div class="row content_bg_common financeManage">
    <div class="col-md-12 col-sm-12 col-xs-12">
        <div class="x_panel">
            <form id="searchForm" class="form-horizontal form-label-left">
                <div class="item form-group col-md-2 col-sm-2 col-xs-12">
                    <label class="control-label col-md-4 col-sm-4 col-xs-12" for="village">小区名称:</label>
                    <div class="col-md-8 col-sm-8 col-xs-12 selectVillageMore">
                        <select class="form-control col-md-12 col-sm-12 col-xs-12 selectpicker" multiple="multiple" name="village" id="village" title="请选择" data-type="selectMore">
                            <option value="">请选择</option>
                        </select>
                    </div>
                </div>
                <div class="item form-group col-md-2 col-sm-2 col-xs-12 isShow">
                    <label class="control-label col-md-4 col-sm-4 col-xs-12" for="building">楼栋:</label>
                    <div class="col-md-8 col-sm-8 col-xs-12">
                        <select class="form-control col-md-12 col-sm-12 col-xs-12" name="building" id="building">
                            <option value='null'>请选择</option>
                        </select>
                    </div>
                </div>
                <div class="item form-group col-md-2 col-sm-2 col-xs-12 isShow">
                    <label class="control-label col-md-4 col-sm-4 col-xs-12" for="location">单元:</label>
                    <div class="col-md-8 col-sm-8 col-xs-12">
                        <select class="form-control col-md-12 col-sm-12 col-xs-12" name="location" id="location">
                            <option value='null'>请选择</option>
                        </select>
                    </div>
                </div>
                <div class="item form-group col-md-2 col-sm-2 col-xs-12 isShow">
                    <label class="control-label col-md-4 col-sm-4 col-xs-12" for="room">房屋:</label>
                    <div class=" col-md-8 col-sm-8 col-xs-12">
                        <select class="form-control col-md-12 col-sm-12 col-xs-12" name="room" id="room">
                            <option value=''>请选择</option>
                        </select>
                    </div>
                </div>
                <div class="item form-group col-md-2 col-sm-2 col-xs-12">
                    <label class="control-label col-md-4 col-sm-4 col-xs-12" for="costType">费用类型:</label>
                    <div class=" col-md-8 col-sm-8 col-xs-12">
                        <select class="form-control col-md-12 col-sm-12 col-xs-12" name="costType" id="costType">
                            <option>请选择</option>
                            <option>物业费</option>
                            <option>车位费</option>
                            <option>押金类</option>
                            <option>一次性</option>
                        </select>
                    </div>
                </div>
                <div class="item form-group col-md-2 col-sm-2 col-xs-12">
                    <label class="control-label col-md-4 col-sm-4 col-xs-12" for="payType">支付方式:</label>
                    <div class=" col-md-8 col-sm-8 col-xs-12">
                        <select class="form-control col-md-12 col-sm-12 col-xs-12" name="payType" id="payType">
                            <option>请选择</option>
                            <option value="0">线上支付</option>
                            <option value="1">现金支付</option>
                            <option value="2">刷卡支付</option>
                            <option value="3">混合支付</option>
                        </select>
                    </div>
                </div>
                <div class="item form-group col-md-2 col-sm-2 col-xs-12">
                    <label class="control-label col-md-4 col-sm-4 col-xs-12" for="checkFlag">是否对账:</label>
                    <div class="col-md-8 col-sm-8 col-xs-12">
                        <select class="form-control col-md-12 col-sm-12 col-xs-12" name="checkFlag" id="checkFlag">
                            <option>请选择</option>
                            <option value="1">已对账</option>
                            <option value="0">未对账</option>
                        </select>
                    </div>
                </div>
                <div class="item form-group col-md-4 col-sm-4 col-xs-12" id="payTimeRange">
                    <label class="control-label col-md-2 col-sm-2 col-xs-12">缴费日期:</label>
                    <div class="col-md-5 col-sm-5 col-xs-12" style="width: 39%">
                        <input class="form-control col-md-12 col-sm-12 col-xs-12" id="beginTime" name="beginTime" placeholder="请选择开始时间">
                    </div>
                    <div class="col-md-1 col-sm-1 col-xs-12 other" style="width: 5%">~</div>
                    <div class="col-md-5 col-sm-5 col-xs-12" style="width: 39%">
                        <input class="form-control col-md-12 col-sm-12 col-xs-12" id="endTime" name="endTime" placeholder="请选择结束时间">
                    </div>
                </div>
                <div class="item form-group col-md-4 col-sm-4 col-xs-12" id="checkTimeRange">
                    <label class="control-label col-md-2 col-sm-2 col-xs-12">对账日期:</label>
                    <div class="col-md-5 col-sm-5 col-xs-12" style="width: 39%">
                        <input class="form-control col-md-12 col-sm-12 col-xs-12" id="checkBeginTime" name="checkBeginTime" placeholder="请选择开始时间">
                    </div>
                    <div class="col-md-1 col-sm-1 col-xs-12 other" style="width: 5%">~</div>
                    <div class="col-md-5 col-sm-5 col-xs-12" style="width: 39%">
                        <input class="form-control col-md-12 col-sm-12 col-xs-12" id="checkEndTime" name="checkEndTime" placeholder="请选择结束时间">
                    </div>
                </div>
                <div class="item form-group col-md-2 col-sm-2 col-xs-2">
                    <div class="col-md-12 col-sm-12 col-xs-12" style="padding-top: 8px;margin-left: 10px;">
                        <button type="button" class="btn btn-sm btn-primary" onclick="queryFinance()">查询</button>
                        <button type="button" class="btn btn-sm btn-primary" onclick="resetFinance()">重置</button>
                        <button type="button" class="btn btn-sm btn-primary" onclick="exportBillAll()">导出</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <div class="col-md-12 col-sm-12 col-xs-12">
        <div class="costedInfo">共<span class="costedSum">0</span>笔<span class="allCount">0</span>元 已对账<span class="billCount">0</span>笔<span class="billSum">0</span>元</div>
        <table id="table"></table>
    </div>
</div>
<#include "/layout/footer.ftl"/>
<script src="/assets/js/xlsx.core.min.js"></script>
<script>
    $(function () {
        initLayDate();
        queryVillage("village",true);
        queryFinance();
    })
    /*初始化layDate日期组件*/
    function initLayDate(){
        laydate.render({
            elem: '#payTimeRange',
            range: ['#beginTime', '#endTime']
        });
        laydate.render({
            elem: '#checkTimeRange',
            range: ['#checkBeginTime', '#checkEndTime']
        });
    }
    /*扫码枪*/
    /*form表单数据处理*/
    function handleFormData() {
        var obj=new Object();
        var formData=$('#searchForm').serializeObject();
        Object.keys(formData).forEach(function (item, index) {
            if(item=="building"||item=="location"){
                if(formData[item]!="null")obj[item]=formData[item];
            }else if(item=="payType"||item=="checkFlag"){
                if(formData[item]!="请选择"&&!!formData[item])obj[item]=Number(formData[item])
            }else{
                if(formData[item]!="请选择"&&!!formData[item])obj[item]=formData[item];
            }
        })
        return obj;
    }
    /*查询对账列表*/
    function queryFinance() {
        $("#table").bootstrapTable('destroy').bootstrapTable({
            url:'/bill/queryFinancial',
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
                    field: 'house',
                    title: '房屋',
                },{
                    field: 'list',
                    title: '缴费项目',
                    cellStyle: {
                        css: {'padding': '0'}
                    },
                    formatter:function (value,row,index) {
                        var dom="";
                        if(row.list.length!=0){
                            row.list.forEach(function (item,index) {
                                var costNameVal=(item.costType=="车位费"&&item.licensePlateNo?item.costName+"("+item.licensePlateNo+")":item.costName);
                                if(index==0)dom+="<p class='pStyle'>"+costNameVal+"</p>";
                                else dom+="<p class='pStyle' style='border-top:1px solid #ddd;'>"+costNameVal+"</p>";
                            })
                        }
                        return dom
                    }
                },{
                    field: 'date',
                    title: '缴费类型',
                    cellStyle: {
                        css: {'padding': '0'}
                    },
                    formatter:function (value,row,index) {
                        var dom="";
                        if(row.date.property&&row.date.property.length!=0){
                            var pHeight=(44*row.date.property.length)+"px";
                            dom+="<p class='pStyle' style='height:"+pHeight+";line-height: "+pHeight+"'>"+row.date.property[0].costType+"</p>";
                        }
                        if(row.date.park){
                            row.date.park.forEach(function (item,index) {
                                if(row.date.park.length==1)dom+="<p class='pStyle'>"+item.costType+"</p>";
                                else{
                                    if(index==0&&!row.date.property)dom+="<p class='pStyle'>"+item.costType+"</p>";
                                    else dom+="<p class='pStyle' style='border-top:1px solid #ddd;'>"+item.costType+"</p>";
                                }
                            })
                        }
                        return dom
                    },
                },{
                    field: 'date',
                    title: '缴费大类',
                    cellStyle: {
                        css: {'padding': '0'}
                    },
                    formatter:function (value,row,index) {
                        var dom="";
                        if(row.date.property&&row.date.property.length!=0){
                            var pHeight=(44*row.date.property.length)+"px";
                            dom+="<p class='pStyle' style='height:"+pHeight+";line-height: "+pHeight+"'>"+row.date.property[0].costTypeClass+"</p>";
                        }
                        if(row.date.park){
                            row.date.park.forEach(function (item,index) {
                                if(row.date.park.length==1)dom+="<p class='pStyle'>"+item.costTypeClass+"</p>";
                                else{
                                    if(index==0&&!row.date.property)dom+="<p class='pStyle'>"+item.costTypeClass+"</p>";
                                    else dom+="<p class='pStyle' style='border-top:1px solid #ddd;'>"+item.costTypeClass+"</p>";
                                }
                            })
                        }
                        return dom
                    }
                },{
                    field: 'list',
                    title: '缴费小类',
                    cellStyle: {
                        css: {'padding': '0'}
                    },
                    formatter:function (value,row,index) {
                        var dom=""
                        if(row.list.length!=0){
                            row.list.forEach(function (item,index) {
                                if(index==0)dom+="<p class='pStyle'>"+item.costTypeSection+"</p>";
                                else dom+="<p class='pStyle' style='border-top:1px solid #ddd;'>"+item.costTypeSection+"</p>";
                            })
                        }
                        return dom
                    }
                },{
                    field: 'date',
                    title: '费用所属时间',
                    cellStyle: {
                        css: {'padding': '0'}
                    },
                    formatter:function (value,row,index) {
                        var dom="";
                        if(row.date.property&&row.date.property.length!=0){
                            var pHeight=(44*row.date.property.length)+"px";
                            dom+="<p class='pStyle' style='height:"+pHeight+";line-height: "+pHeight+"'>"+row.date.property[0].beginTime+"~"+row.date.property[0].endTime+"</p>";
                        }
                        if(row.date.park){
                            row.date.park.forEach(function (item,index) {
                                if(row.date.park.length==1)dom+="<p class='pStyle'>"+(item.costType=="车位费"?item.beginTime+"~"+item.endTime:"/")+"</p>";
                                else{
                                    if(index==0&&!row.date.property)dom+="<p class='pStyle'>"+(item.costType=="车位费"?item.beginTime+"~"+item.endTime:"/")+"</p>";
                                    else dom+="<p class='pStyle' style='border-top:1px solid #ddd;'>"+(item.costType=="车位费"?item.beginTime+"~"+item.endTime:"/")+"</p>";
                                }
                            })
                        }
                        return dom
                    },
                },{
                    field: 'payTime',
                    title: '缴费日期',
                },{
                    field: 'list',
                    title: '缴费金额（单位：元）',
                    cellStyle: {
                        css: {'padding': '0'}
                    },
                    formatter:function (value,row,index) {
                        var dom=""
                        row.list.forEach(function (item,index) {
                            if(index==0)dom+="<p class='pStyle'>"+item.pay+"</p>";
                            else dom+="<p class='pStyle' style='border-top:1px solid #ddd;'>"+item.pay+"</p>";
                        })
                        return dom
                    }
                },{
                    field: 'paySum',
                    title: '总金额(单位:元)'
                },{
                    field: 'payType',
                    title: '支付方式',
                    formatter: function(code, row, index) {
                        if(row.payType==0)return "线上支付";
                        else if(row.payType==1)return "现金支付";
                        else if(row.payType==2)return "刷卡支付";
                        else if(row.payType==3)return "混合支付";
                        else return ;
                    }
                },{
                    field: 'checkFlag',
                    title: '是否对账',
                    formatter: function(code, row, index) {
                        if(row.checkFlag==0)return "未对账";
                        else if(row.checkFlag==1)return "已对账";
                        else return ;
                    }
                },{
                    field: 'checkTime',
                    title: '对账日期',
                    formatter: function(code, row, index) {
                        if(row.checkFlag==0)return "";
                        else return code;
                    }
                }
            ],
            height:$(".content_bg_common").height()-$("#searchForm").height()-$(".costedInfo").height()-25,
            queryParams: function(params){
                var param=handleFormData();
                var village=param.village;
                param.pageNumber=params.offset/params.limit +1;
                param.pageSize=params.limit;
                if(village){
                    if(typeof(village)=== 'string'){
                        param.villages=new Array(village);
                    }else{
                        param.village="";
                        param.villages=village;
                    }
                }
                return param;
            },
            formatLoadingMessage: function(){
                return "正在加载中。。。";
            },
            responseHandler:function (res) {
                var arr=new Array();
                if(res&&res.list&&Array.isArray(res.list)&&res.list.length!=0){
                    res.list.forEach(function(item,index){
                        var obj=item.billInfo;
                        var propertyMain=new Array();
                        var parkOrOther=new Array();//小类为商铺的物业费、新增的一次性和押金类的相关数据不需要合并单元格，故放入车位费一起处理
                        obj.list=new Array();
                        if(item.items["物业费"]&&item.items["物业费"].length!=0){
                            item.items["物业费"].forEach(function(item,i){
                                obj.list.push(item);
                                if(item.costTypeSection=="住宅")propertyMain.push(item);
                                else parkOrOther.push(item);
                            })
                        }
                        if(item.items["车位费"]&&item.items["车位费"].length!=0){
                            parkOrOther=parkOrOther.concat(item.items["车位费"]);
                            item.items["车位费"].forEach(function (item, i) {
                                obj.list.push(item);
                            })
                        }
                        if(item.items["押金类"]&&item.items["押金类"].length!=0) {
                            parkOrOther=parkOrOther.concat(item.items["押金类"]);
                            item.items["押金类"].forEach(function (item, i) {
                                item.costTypeClass="/";
                                item.costTypeSection="/";
                                obj.list.push(item);
                            })
                        }
                        if(item.items["一次性"]&&item.items["一次性"].length!=0) {
                            parkOrOther=parkOrOther.concat(item.items["一次性"]);
                            item.items["一次性"].forEach(function (item, i) {
                                item.costTypeClass="/";
                                item.costTypeSection="/";
                                obj.list.push(item);
                            })
                        }
                        if(!obj.checkTime)obj.checkTime="";
                        obj.date={property:propertyMain,park:parkOrOther};
                        if(obj.list.length!=0)arr.push(obj);
                    })
                }
                return{
                    "total":arr.length==0?0:res.total,
                    "rows":arr
                }
            },
            onLoadSuccess:function (data) {
                costedInfo(data.total?data.total:"0");
            }
        })
    }
    /*查询已对账笔数和金额*/
    function costedInfo(data){
        var params=handleFormData();
        var village=params.village;
        if(village){
            if(typeof(village)=== 'string'){
                params.villages=new Array(village);
            }else{
                params.village="";
                params.villages=village;
            }
        }
        $.ajax({
            url: "/bill/queryCheckedCount",
            type: "post",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            data:JSON.stringify(params),
            success: function(res){
                $(".costedInfo .costedSum").html(data?data:"0");
                $(".costedInfo .allCount").html(res.allSum?res.allSum:"0");
                $(".costedInfo .billCount").html(res.count?res.count:"0");
                $(".costedInfo .billSum").html(res.sum?res.sum:"0");
            },
            error: function(error){
                $(".costedInfo .costedSum").html("0");
                $(".costedInfo .allCount").html("0");
                $(".costedInfo .billCount").html("0");
                $(".costedInfo .billSum").html("0");
            }
        });
    }
    /*点击重置按钮，重置查询条件*/
    function resetFinance() {
        $("#village").val("");
        $("#building").val("null");
        $("#location").val("null");
        $("#room").val("");
        $("#costType").val("请选择");
        $("#payType").val("请选择");
        $("#checkFlag").val("请选择");
        $("#costType").val("请选择");
        $("#beginTime").val("");
        $("#endTime").val("");
        $("#checkBeginTime").val("");
        $("#checkEndTime").val("");
        queryFinance();
    }
    /*导出明细*/
    function exportBillAll(){
        var detailList=new Array(),gatherData=new Object();
        var params=handleFormData();
        var village=params.village;
        if(village){
            if(typeof(village)=== 'string'){
                params.villages=new Array(village);
            }else{
                params.village="";
                params.villages=village;
            }
        }
        //查询财务明细
        $.ajax({
            url: "/bill/queryFinancialAll",
            type: "post",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            data:JSON.stringify(params),
            async:false,
            success: function(res){
                if(res&&res.length!=0)detailList=res;
            },
            error: function(error){}
        });
        //查询财务汇总
        $.ajax({
            url: "/bill/queryGather",
            type: "post",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            data:JSON.stringify({village:params.village?params.village:"",villages:params.villages?params.villages:[],beginTime:$("#beginTime").val(),endTime:$("#endTime").val()}),
            async:false,
            success: function(res){
                if(res)gatherData=res;
            },
            error: function(error){}
        });
        //处理财务汇总数据，顺序需和表头一致
        detailList=detailList.map(function(item,index){
            if(item.payType==0)var payType = "线上支付";
            else if(item.payType==1)var payType = "现金支付";
            else if(item.payType==2)var payType = "刷卡支付";
            else if(item.payType==3)var payType = "混合支付";
            else var payType = "";
            var obj={
                "凭据号":item.orderId,
                "房屋":item.village+item.building+item.location+item.room,
                "缴费项目":item.costName,
                "缴费类型":item.costType,
                "缴费大类":(item.costType=="押金类"||item.costType=="一次性")?"/":item.costTypeClass,
                "缴费小类":(item.costType=="押金类"||item.costType=="一次性")?"/":item.costTypeSection,
                "费用所属时间":(item.costType=="押金类"||item.costType=="一次性")?"/":item.beginTime+"~"+item.endTime,
                "缴费日期":item.payTime,
                "缴费金额（单位：元）":item.pay,
                "支付方式":payType,
                "备注":item.remark?item.remark:""
            }
            return obj;
        })
        //处理财务汇总数据
        var gatherList=gatherData["收款"].concat(gatherData["退款"]).concat(gatherData["总计"]).map(function(item, index) {
            var obj={
                "收费项目":item.costTypeSection?item.costName+"("+item.costTypeSection+")":item.costName,
                "现金支付":item.cash,
                "刷卡支付":item.card,
                "线上支付":item.qrCode,
                "合计金额":item.perSum,
                "备注":item.remark?item.remark:""
            }
            return obj;
        })
        var data1={
            data:detailList,
            fileName:"财务明细",
            wpx:[{wpx: 150},{wpx: 150},{wpx: 100},{wpx: 80},{wpx: 80},{wpx: 80},{wpx: 150},{wpx: 150},{wpx: 120},{wpx: 80},{wpx: 100}]
        }
        var data2={
            data:gatherList,
            fileName:"财务汇总",
            wpx:[{wpx: 150},{wpx: 80},{wpx: 80},{wpx: 80},{wpx: 80},{wpx: 80}]
        }
        downloadExcel(new Array(data1,data2),"财务对账");
    }
    /*动态设置table的高度*/
    window.onresize=function () {
        $("#table").bootstrapTable('resetView', {
            height: $(".content_bg_common").height()-$("#searchForm").height()-$(".costedInfo").height()-25
        });
    }
</script>