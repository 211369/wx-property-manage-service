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
            <div class="item form-group col-md-4 col-sm-4 col-xs-4" style="margin-top: 2px;">
                <div class="col-md-12 col-sm-12 col-xs-12">
                    <button type="button" class="btn btn-sm btn-primary" onclick="getMarginAccount()"  style="margin-left: 10px;"><i class="glyphicon glyphicon-search"></i>查询</button>
                    <button type="button" class="btn btn-sm btn-primary" onclick="exportDetail()"  style="margin-left: 10px;"><i class="glyphicon glyphicon-download-alt"></i>导出</button>
                </div>
            </div>
        </form>
        <table id="marginAccountTable"></table>
    </div>
</div>
<#include "/layout/footer.ftl"/>
<script src="/assets/js/xlsx.core.min.js"></script>
<script>
    var mergeCellArr = new Array();//合并单元格使用
    var fieldArr=["house","ownerName","roomArea"];//需要合并列的字段名
    $(function () {
        searchVillage();
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
                getMarginAccount();
            },
            error: function(error){
                $("#searchForm #villageName").html(obj);
                getMarginAccount();
            }
        });
    }
    //查询保证金台账
    function getMarginAccount() {
        $("#marginAccountTable").bootstrapTable("destroy").bootstrapTable({
            url:"/report/queryEarnestPage",
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
                    field: 'house',
                    title: '房屋',
                },{
                    field: 'ownerName',
                    title: '业主姓名',
                },{
                    field: 'roomArea',
                    title: '房屋面积(单位：㎡)',
                },{
                    field: 'costType',
                    title: '缴费类型',
                },{
                    field: 'costName',
                    title: '缴费项目',
                },{
                    field: 'pay',
                    title: '缴费金额(单位:元)',
                },{
                    field: 'payTime',
                    title: '缴费时间',
                },{
                    field: 'payRefund',
                    title: '退款金额(单位:元)',
                },{
                    field: 'payTimeRefund',
                    title: '退款时间',
                },{
                    field: 'refundType',
                    title: '是否退款',
                }
            ],
            height:$(".content_bg_common").height()-$("#searchForm").height()-25,
            queryParams: function(param){
                console.log(param)
                var params={
                    pageNumber:param.offset/param.limit +1,
                    pageSize:param.limit,
                    village:$("#searchForm #villageName").val()
                };
                return params;
            },
            formatLoadingMessage: function(){
                return "正在加载中。。。";
            },
            responseHandler:function (res) {
                var list=new Array(),num=0;
                mergeCellArr = new Array();
                if(res&&res.list&&res.list.length!=0){
                    res.list.map(function (item, index) {
                        if(item.billInfos&&item.billInfos.length==0){
                            var obj={
                                house:item.village+item.building+item.location+item.room,
                                ownerName:item.ownerName,
                                roomArea:item.roomArea,
                                costType:"",
                                costName:"",
                                pay:"",
                                payTime:"",
                                payRefund:"",
                                payTimeRefund:"",
                                refundType:""
                            }
                            list.push(obj);
                            num+=1;
                        }else{
                            item.billInfos.forEach(function (_item,_index) {
                                var obj={
                                    house:item.village+item.building+item.location+item.room,
                                    ownerName:item.ownerName,
                                    roomArea:item.roomArea,
                                    costType:_item.costType,
                                    costName:_item.costName,
                                }
                                //处理缴费信息、退款信息
                                if(_item.billType==1){
                                    obj.pay="";
                                    obj.payTime="";
                                    obj.payRefund=_item.pay;
                                    obj.payTimeRefund=_item.payTime;
                                    obj.refundType="已退款";
                                }else{
                                    obj.pay=_item.pay;
                                    obj.payTime=_item.payTime;
                                    obj.payRefund="";
                                    obj.payTimeRefund="";
                                    if(_item.billType==0)obj.refundType="未退款";
                                    else obj.refundType="";
                                }
                                list.push(obj);
                            })
                            fieldArr.forEach(function (_value, _i) {
                                mergeCellArr.push({index: num, field: _value, rowspan: item.billInfos.length});
                            })
                            num+=item.billInfos.length;
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
                    $('#marginAccountTable').bootstrapTable('mergeCells', item);
                })
            },
        })
    }
    /*导出明细*/
    function exportDetail(){
        $.ajax({
            url: "/report/queryEarnestAll",
            type: "post",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            data:JSON.stringify({village:$("#searchForm #villageName").val()}),
            async:false,
            success: function(res){
                if(res){
                    if(res.length==0){
                        layer.alert("查询数据为空，导出失败！",{title:"警告"});
                    }else{
                        var list=new Array();
                        res.map(function (item, index) {
                            if(item.billInfos&&item.billInfos.length==0){
                                var obj={
                                    "房屋":item.village+item.building+item.location+item.room,
                                    "业主姓名":item.ownerName,
                                    "面积(单位:㎡)":item.roomArea,
                                    "缴费类型":"",
                                    "缴费项目":"",
                                    "缴费金额(单位:元)":"",
                                    "缴费时间":"",
                                    "退款金额(单位:元)":"",
                                    "退款时间":"",
                                    "是否退款":""
                                }
                                list.push(obj);
                            }else{
                                item.billInfos.forEach(function (_item,_index) {
                                    var obj={
                                        "房屋":item.village+item.building+item.location+item.room,
                                        "业主姓名":item.ownerName,
                                        "面积(单位:㎡)":item.roomArea,
                                        "缴费类型":_item.costType,
                                        "缴费项目":_item.costName,
                                    }
                                    //处理缴费信息、退款信息
                                    if(_item.billType==1){
                                        obj["缴费金额(单位:元)"]="";
                                        obj["缴费时间"]="";
                                        obj["退款金额(单位:元)"]=_item.pay;
                                        obj["退款时间"]=_item.payTime;
                                        obj["是否退款"]="已退款";
                                    }else{
                                        obj["缴费金额(单位:元)"]=_item.pay;
                                        obj["缴费时间"]=_item.payTime;
                                        obj["退款金额(单位:元)"]="";
                                        obj["退款时间"]="";
                                        if(_item.billType==0)obj["是否退款"]="未退款";
                                        else obj["是否退款"]="";
                                    }
                                    list.push(obj);
                                })
                            }
                        })
                        var data={
                            data:list,
                            fileName:"保证金台账",
                            wpx:[{wpx: 130},{wpx: 100},{wpx: 120},{wpx: 100},{wpx: 100},{wpx: 120},{wpx: 130},{wpx: 120},{wpx: 130},{wpx: 100}]
                        }
                        downloadExcel(new Array(data),"保证金台账");
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
        $("#marginAccountTable").bootstrapTable('resetView', {
            height:$(".content_bg_common").height()-$("#searchForm").height()-25,
        });
    }
</script>