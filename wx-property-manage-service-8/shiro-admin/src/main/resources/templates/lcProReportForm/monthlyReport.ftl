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
            <div class="item form-group col-md-2 col-sm-2">
                <label class="col-md-4 col-sm-4 control-label" for="beginTime">查询时间:</label>
                <div class="col-md-8 col-sm-8 col-xs-12">
                    <input type="text" readonly="readonly" class="form-control col-md-12 col-xs-12" name="beginTime" id="beginTime" placeholder="请选择查询时间" autocomplete="off"/>
                </div>
            </div>
            <div class="item form-group col-md-4 col-sm-4 col-xs-4" style="margin-top: 2px;">
                <div class="col-md-12 col-sm-12 col-xs-12">
                    <button type="button" class="btn btn-sm btn-primary" onclick="searchProDetail()"  style="margin-left: 10px;"><i class="glyphicon glyphicon-search"></i>查询</button>
                    <button type="button" class="btn btn-sm btn-primary" onclick="exportDetail()"  style="margin-left: 10px;"><i class="glyphicon glyphicon-download-alt"></i>导出</button>
                </div>
            </div>
        </form>
        <table id="monthlyReportTable"></table>
    </div>
</div>
<#include "/layout/footer.ftl"/>
<script src="/assets/js/xlsx.core.min.js"></script>
<script>
    var exportList = new Array();//导出数据使用
    var mergeCellArr = new Array()//合并单元格使用
    var fieldArr=["costType","costTypeClass"];//需要合并列的字段名
    $(function () {
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
                getMonthlyReport();
            },
            error: function(error){
                $("#searchForm #villageName").html(obj);
                getMonthlyReport();
            }
        });
    }
    //初始化查询时间layDate组件
    function initLayDate() {
        $("#beginTime").val(new Date().getFullYear());
        laydate.render({
            elem: "#beginTime",
            type:"year",
            value:new Date().getFullYear(),
            btns:["now","confirm"]
        })
    }
    //查询收费月报表
    function getMonthlyReport() {
        $("#monthlyReportTable").bootstrapTable({
            url:"/report/queryMonthly",
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
                    field: 'costType',
                    title: '缴费类型',
                },{
                    field: 'costTypeClass',
                    title: '缴费大类',
                },{
                    field: 'costName',
                    title: '缴费项目',
                },{
                    field: 'january',
                    title: '1月',
                },{
                    field: 'february',
                    title: '2月',
                },{
                    field: 'march',
                    title: '3月',
                },{
                    field: 'april',
                    title: '4月',
                },{
                    field: 'may',
                    title: '5月',
                },{
                    field: 'june',
                    title: '6月',
                },{
                    field: 'july',
                    title: '7月',
                },{
                    field: 'august',
                    title: '8月'
                },{
                    field: 'september',
                    title: '9月'
                },{
                    field: 'october',
                    title: '10月'
                },{
                    field: 'november',
                    title: '11月'
                },{
                    field: 'december',
                    title: '12月'
                },{
                    field: 'total',
                    title: '合计'
                }
            ],
            height:$(".content_bg_common").height()-$("#searchForm").height()-25,
            queryParams: function(param){
                var params=new Object();
                if($("#villageName").val())params.village=$("#villageName").val();
                params.beginTime=$("#beginTime").val()+"-01";
                params.endTime=$("#beginTime").val()+"-12";
                return params;
            },
            formatLoadingMessage: function(){
                return "正在加载中。。。";
            },
            responseHandler:function (res) {
                mergeCellArr = new Array();
                exportList = new Array();
                if(res&&Object.keys(res).length!=0){
                    var costNames=res[Object.keys(res)[0]],list=new Array();
                    var proList=new Array(),carList=new Array(),depositList=new Array(),disposableList=new Array(),otherList=new Array(),total=new Array();
                    var proBuy=new Array(),proBease=new Array(),carBuy=new Array(),carBease=new Array();
                    var arr=new Array();//用来调整缴费项目顺序
                    Object.keys(costNames).forEach(function (item, index) {
                        var str=item.substr(0,3);
                        if(str=="物业费"){
                            var val=item.substr(3,2);
                            if(val=="购买")proBuy.push(item);
                            else if(val=="租赁")proBease.push(item);
                        }else if(str=="车位费"){
                            var val=item.substr(3,2);
                            if(val=="购买")carBuy.push(item);
                            else if(val=="租赁")carBease.push(item);
                        }else if(str=="押金类"){
                            //处理押金类顺序
                            var val=item.substr(0,item.length-2);
                            if(arr.indexOf(val)==-1){
                                arr.push(val);
                                depositList.push(val+"+)");
                                depositList.push(val+"-)");
                            }
                        }else if(str=="一次性"){
                            //处理一次性顺序
                            var val=item.substr(0,item.length-2);
                            if(arr.indexOf(val)==-1){
                                arr.push(val);
                                disposableList.push(val+"+)");
                                disposableList.push(val+"-)");
                            }
                        }else if(str=="合计")total.push(item);
                        else otherList.push(item);
                    })
                    //处理物业费数据顺序
                    proBuy.concat(proBease).forEach(function (item, index) {
                        var str=item.substr(0,item.length-2);
                        if(arr.indexOf(str)==-1){
                            arr.push(str);
                            proList.push(str+"+)");
                            proList.push(str+"-)");
                        }
                    })
                    //处理车位费数据顺序
                    carBuy.concat(carBease).forEach(function (item, index) {
                        var str=item.substr(0,item.length-2);
                        if(arr.indexOf(str)==-1){
                            arr.push(str);
                            carList.push(str+"+)");
                            carList.push(str+"-)");
                        }
                    })
                    proList.concat(carList).concat(depositList).concat(disposableList).concat(otherList).concat(total).forEach(function (item, index) {
                        var obj={
                            total:res["合计"][item],
                            january:res["1月份"][item],
                            february:res["2月份"][item],
                            march:res["3月份"][item],
                            april:res["4月份"][item],
                            may:res["5月份"][item],
                            june:res["6月份"][item],
                            july:res["7月份"][item],
                            august:res["8月份"][item],
                            september:res["9月份"][item],
                            october:res["10月份"][item],
                            november:res["11月份"][item],
                            december:res["12月份"][item]
                        }
                        if(item.substr(0,3)=="物业费"||item.substr(0,3)=="车位费"){
                            obj.costType=item.substr(0,3);
                            obj.costTypeClass=item.substr(3,2);
                            obj.costName=item.substr(5);
                        }else if(item.substr(0,3)=="押金类"||item.substr(0,3)=="一次性"){
                            obj.costType=item.substr(0,3);
                            obj.costTypeClass="/";
                            obj.costName=item.substr(3);
                        }else{
                            obj.costType="/";
                            obj.costTypeClass="/";
                            obj.costName=item;
                        }
                        list.push(obj);
                    })
                    fieldArr.forEach(function (item, index) {
                        if(item=="costType"){
                            mergeCellArr.push({index: 0, field: item, rowspan: proList.length});
                            mergeCellArr.push({index: proList.length, field: item, rowspan: carList.length});
                            mergeCellArr.push({index: proList.length+carList.length, field: item, rowspan: depositList.length});
                            mergeCellArr.push({index: proList.length+carList.length+depositList.length, field: item, rowspan: disposableList.length});
                        }else if(item=="costTypeClass"){
                            mergeCellArr.push({index: 0, field: item, rowspan: proBuy.length});
                            mergeCellArr.push({index: proBuy.length, field: item, rowspan: proBease.length});
                            mergeCellArr.push({index: proBuy.length+proBease.length, field: item, rowspan: carBuy.length});
                            mergeCellArr.push({index: proBuy.length+proBease.length+carBuy.length, field: item, rowspan: carBease.length});
                            mergeCellArr.push({index: proBuy.length+proBease.length+carBuy.length+carBease.length, field: item, rowspan: depositList.length});
                            mergeCellArr.push({index: proBuy.length+proBease.length+carBuy.length+carBease.length+depositList.length, field: item, rowspan: disposableList.length});
                        }
                    })
                }
                if(list.length!=0)exportList=list;
                return{
                    "total":list.length,
                    "rows":list
                }
            },
            onLoadSuccess:function (data) {
                mergeCellArr.forEach(function(item,index){
                    $('#monthlyReportTable').bootstrapTable('mergeCells', item);
                })
            }
        })
    }
    //点击查询按钮
    function searchProDetail () {
        $("#monthlyReportTable").bootstrapTable("refresh");
    }
    /*导出明细*/
    function exportDetail(){
        if(exportList.length==0){
            layer.alert("查询数据为空，导出失败！",{title:"警告"});
        }else{
            var list=exportList.map(function(item, index) {
                var obj={
                    "缴费类型":item.costType,
                    "缴费大类":item.costTypeClass,
                    "缴费项目":item.costName,
                    "1月":item.january,
                    "2月":item.february,
                    "3月":item.march,
                    "4月":item.may,
                    "5月":item.january,
                    "6月":item.june,
                    "7月":item.july,
                    "8月":item.august,
                    "9月":item.september,
                    "10月":item.october,
                    "11月":item.november,
                    "12月":item.december,
                    "合计":item.total
                }
                return obj;
            })
            var data={
                data:list,
                fileName:"收费月报表",
                wpx:[{wpx: 80},{wpx: 80},{wpx: 200},{wpx: 80},{wpx: 80},{wpx: 80},{wpx: 80},{wpx: 80},{wpx: 80},{wpx: 80},{wpx: 80},{wpx: 80},{wpx: 80},{wpx: 80},{wpx: 80},{wpx: 80}]
            }
            downloadExcel(new Array(data),"收费月报表");
        }
    }
    //动态设置列表table的高度
    window.onresize=function () {
        $("#monthlyReportTable").bootstrapTable('resetView', {
            height:$(".content_bg_common").height()-$("#searchForm").height()-25,
        });
    }
</script>
<style>
    #monthlyReportTable tbody tr:last-of-type{
        font-weight: bolder;
    }
</style>