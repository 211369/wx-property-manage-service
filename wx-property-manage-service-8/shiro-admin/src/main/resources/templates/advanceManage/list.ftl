<#include "/layout/header.ftl"/>
<div class="clearfix"></div>
<div class="row content_bg_common advanceManage">
    <div class="col-md-12 col-sm-12 col-xs-12">
        <form id="searchForm" class="col-md-12 col-sm-12 col-xs-12 form-horizontal form-label-left">
            <div class="item form-group col-md-2 col-sm-2">
                <label class="col-md-4 col-sm-4 control-label" for="village">小区:</label>
                <div class="col-md-8 col-sm-8 col-xs-12">
                    <select id="village" name="village" class="form-control">
                        <option value="">请选择</option>
                    </select>
                </div>
            </div>
            <div class="item form-group col-md-2 col-sm-2">
                <label class="col-md-4 col-sm-4 control-label" for="building">楼栋:</label>
                <div class="col-md-8 col-sm-8 col-xs-12">
                    <select id="building" name="building" class="form-control">
                        <option value='null'>请选择</option>
                    </select>
                </div>
            </div>
            <div class="item form-group col-md-2 col-sm-2">
                <label class="col-md-3 col-sm-3 control-label" for="location">单元:</label>
                <div class="col-md-9 col-sm-9 col-xs-12">
                    <select id="location" name="location" class="form-control">
                        <option value='null'>请选择</option>
                    </select>
                </div>
            </div>
            <div class="item form-group col-md-2 col-sm-2">
                <label class="col-md-3 col-sm-3 control-label" for="room">房屋:</label>
                <div class="col-md-9 col-sm-9 col-xs-12">
                    <select id="room" name="room" class="form-control">
                        <option value="">请选择</option>
                    </select>
                </div>
            </div>
            <div class="item form-group col-md-2 col-sm-2">
                <label class="col-md-3 col-sm-3 control-label" for="beginTime">开始时间:</label>
                <div class="col-md-9 col-sm-9 col-xs-12">
                    <input type="text" class="form-control col-md-12 col-xs-12" name="beginTime" id="beginTime" placeholder="请选择开始时间" autocomplete="off"/>
                </div>
            </div>
            <div class="item form-group col-md-2 col-sm-2">
                <label class="col-md-3 col-sm-3 control-label" for="endTime">结束时间:</label>
                <div class="col-md-9 col-sm-9 col-xs-12">
                    <input type="text" class="form-control col-md-12 col-xs-12" name="endTime" id="endTime" placeholder="请选择结束时间" autocomplete="off"/>
                </div>
            </div>
            <div class="item form-group col-md-2 col-sm-2">
                <label class="col-md-4 col-sm-4 control-label" for="costType">费用类型:</label>
                <div class="col-md-8 col-sm-8 col-xs-12">
                    <select id="costType" name="costType" class="form-control">
                        <option value="">请选择</option>
                        <option value="物业费">物业费</option>
                        <option value="车位费">车位费</option>
                    </select>
                </div>
            </div>
            <#--物业费和车位费全量使用-->
            <div class="item form-group col-md-2 col-sm-2">
                <label class="col-md-4 col-sm-4 control-label" for="costName">缴费项目:</label>
                <div class="col-md-8 col-sm-8 col-xs-12">
                    <select id="costName" name="costName" class="form-control"></select>
                </div>
            </div>
<#--            &lt;#&ndash;物业费使用&ndash;&gt;-->
<#--            <div class="item form-group col-md-2 col-sm-2 propertyType" style="display: none;">-->
<#--                <label class="col-md-4 col-sm-4 control-label" for="costName">缴费项目:</label>-->
<#--                <div class="col-md-8 col-sm-8 col-xs-12">-->
<#--                    <select id="costName" name="costName" class="form-control"></select>-->
<#--                </div>-->
<#--            </div>-->
<#--            &lt;#&ndash;车位费使用&ndash;&gt;-->
<#--            <div class="item form-group col-md-2 col-sm-2 carType" style="display: none;">-->
<#--                <label class="col-md-4 col-sm-4 control-label" for="costName">缴费项目:</label>-->
<#--                <div class="col-md-8 col-sm-8 col-xs-12">-->
<#--                    <select id="costName" name="costName" class="form-control"></select>-->
<#--                </div>-->
<#--            </div>-->
            <div class="item form-group col-md-2 col-sm-2 col-xs-2" style="margin-top: 2px;">
                <div class="col-md-5 col-sm-5 col-xs-5">
                    <button type="button" class="btn btn-sm btn-primary" onclick="searchAdvanceList()"><i class="glyphicon glyphicon-search"></i>查询</button>
                </div>
                <div class="col-md-5 col-sm-5 col-xs-5">
                    <button type="button" class="btn btn-sm btn-primary" onclick="exportData()"><i class="glyphicon glyphicon-download-alt"></i>导出</button>
                </div>
            </div>
        </form>
        <table id="advanceManageTable"></table>
    </div>
</div>
<div style="width:90%;position: absolute;top: 0;left: 0;opacity: 0;z-index: -1">
    <table id="advanceManageTableAll" style="width: 100%"></table>
</div>
<#include "/layout/footer.ftl"/>
<script type="text/javascript" src="/assets/js/tableExport.min.js"></script>
<script type="text/javascript" src="/assets/js/bootstrap-table-export.min.js"></script>
<script type="text/javascript" src="/assets/js/xlsx.core.min.js"></script>
<script>
    var beginTimeLayDate=null,endTimeLayDate=null;
    var flag=true;//初始化状态
    var propertyOrCarType=costTypeToCostName("");
    var propertyType=costTypeToCostName("物业费");
    var carType=costTypeToCostName("车位费");
    $(function () {
        initLayDate();
        queryVillage("village");
        getAdvanceList("true");
        getAdvanceList("false");
        $("#searchForm #costName").html(propertyOrCarType);
    })
    //费用类型发生改变
    $("#searchForm #costType").change(function(){
        var val=$("#searchForm #costType").val();
        if(val==""){
            $("#searchForm #costName").html(propertyOrCarType);
        }else if(val=="物业费"){
            $("#searchForm #costName").html(propertyType);
        }else if(val=="车位费"){
            $("#searchForm #costName").html(carType);
        }
    });
    //初始化开始时间和结束时间的layDate日期组件
    function initLayDate() {
        beginTimeLayDate=laydate.render({
            elem: "#beginTime",
            type:"month",
            max:(new Date()).getFullYear()+"-12-01",
            value:(new Date()).getFullYear()+"-01",
            done: function(value, dates){
                endTimeLayDate.config.min ={
                    year:dates.year,
                    month:dates.month-1,
                    date: dates.date,
                    hours: 0,
                    minutes: 0,
                    seconds : 0
                };
            }
        })
        endTimeLayDate=laydate.render({
            elem: "#endTime",
            type:"month",
            min:(new Date()).getFullYear()+"-01-01",
            value:(new Date()).getFullYear()+"-12",
            done: function(value, dates){
                beginTimeLayDate.config.max={
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
    /**
     * 获取预收台账
     * @param {String} isPage "true代表分页","false"代表全量
     * */
    function getAdvanceList(isPage) {
        if(isPage=="true")var domId="#advanceManageTable",url="/report/advanceQueryPage";
        else var domId="#advanceManageTableAll",url="/report/advanceQuery";
        $(domId).bootstrapTable({
            url:url,
            method: 'post',
            dataType: "json",
            contentType: 'application/json',
            toolbar: '#toolbar',
            toggle:"table",
            sidePagination: "server",
            pagination: isPage=="true"?true:false,
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
                    field: 'costName',
                    title: '缴费项目',
                },{
                    field: 'costType',
                    title: '缴费类型',
                },{
                    field: 'costTypeClass',
                    title: '缴费大类',
                },{
                    field: 'costTypeSection',
                    title: '缴费小类',
                },{
                    field: 'time',
                    title: '费用所属时间',
                },{
                    field: 'ownerName',
                    title: '姓名',
                },{
                    field: 'ownerPhone',
                    title: '手机号',
                },{
                    field: 'unit',
                    title: '单价(单位:元)',
                },{
                    field: 'pay',
                    title: '缴费金额(单位:元)',
                },{
                    field: 'payType',
                    title: '支付方式',
                },{
                    field: 'payTime',
                    title: '缴费时间',
                }
            ],
            height:$(".content_bg_common").height()-$("#searchForm").height()-25,
            queryParams: function(param){
                var formData=$('#searchForm').serializeObject();
                var params={
                    costType:formData.costType,
                    costName:formData.costName,
                    beginTime:flag==true?(new Date()).getFullYear()+"-01":formData.beginTime,
                    endTime:flag==true?(new Date()).getFullYear()+"-12":formData.endTime
                }
                if(formData.village)params.village=formData.village;
                if(formData.room)params.room=formData.room;
                if(formData.building==""||(formData.building&&formData.building!="null"))params.building=formData.building;
                if(formData.location==""||(formData.location&&formData.location!="null"))params.location=formData.location;
                if(isPage=="true"){
                    params.pageNumber=param.offset/param.limit +1;
                    params.pageSize=param.limit;
                }
                return params;
            },
            formatLoadingMessage: function(){
                return "正在加载中。。。";
            },
            responseHandler:function (res) {
                var list=new Array(),arr=new Array();
                if(isPage=="true"&&res&&res.list&&res.list.length!=0)arr=res.list;
                else if(isPage=="false"&&res&&res.length!=0)arr=res;
                if(arr.length!=0){
                    list=arr.map(function (item, index) {
                        item.house=item.village+item.building+item.location+item.room;
                        //处理车位费的缴费项目，包好车位号、车牌号
                        if(item.costType=="车位费"){
                            item.costName=item.costName+(item.carId?item.carId:"")+(item.licensePlateNo?"("+item.licensePlateNo+")":"")
                        }
                        //处理支付方式
                        if(item.payType==0)item.payType="线上支付";
                        if(item.payType==1)item.payType="现金支付";
                        if(item.payType==2)item.payType="刷卡支付";
                        if(item.payType==3)item.payType="混合支付";
                        //处理费用所属时间
                        if(flag==true){
                            item.beginTime=(new Date()).getFullYear()+1+"-01";
                        }else{
                            var endTime=$("#endTime").val();
                            var year=endTime.slice(0,4);
                            var month=endTime.slice(5,7);
                            if(Number(month)==12)var beginTimeOther=Number(year)+1+"-01";
                            else var beginTimeOther=year+(Number(month)+1>9?"-"+(Number(month)+1):"-0"+(Number(month)+1))
                            item.beginTime=beginTimeOther;
                        }
                        item.time=item.beginTime+"~"+item.endTime;
                        return item;
                    })
                }
                return{
                    "total":isPage=="true"?res.total:list.length,
                    "rows":list
                }
            },
        })
    }
    //点击查询按钮
    function searchAdvanceList() {
        flag=false;
        var formData=$('#searchForm').serializeObject();
        if(!formData.beginTime){
            layer.alert("请选择开始时间！",{title:"警告"});
            return;
        }
        if(!formData.endTime){
            layer.alert("请选择结束时间！",{title:"警告"});
            return;
        }
        $("#advanceManageTable").bootstrapTable("refresh");
        $("#advanceManageTableAll").bootstrapTable("refresh");
    }
    //导出
    function exportData() {
        if($('#advanceManageTableAll').bootstrapTable("getData").length==0){
            layer.alert("不能导出空数据表格！",{title:"警告"});
            return false;
        }
        $("#advanceManageTableAll").tableExport({
            type: 'excel',
            exportDataType: "all",
            fileName: "预收报表",
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
    //动态设置业户列表table的高度
    window.onresize=function () {
        $("#advanceManageTable").bootstrapTable('resetView', {
            height:$(".content_bg_common").height()-$("#searchForm").height()-25,
        });
    }
</script>


