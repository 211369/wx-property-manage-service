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
                <label class="col-md-4 col-sm-4 control-label" for="costType">费用类型:</label>
                <div class="col-md-8 col-sm-8 col-xs-12">
                    <select id="costType" name="costType" class="form-control">
                        <option value="">请选择</option>
                        <option value="物业费">物业费</option>
                        <option value="车位费">车位费</option>
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
                <label class="col-md-4 col-sm-4 control-label" for="beginTime">开始时间:</label>
                <div class="col-md-8 col-sm-8 col-xs-12">
                    <input type="text" class="form-control col-md-12 col-xs-12" name="beginTime" id="beginTime" placeholder="请选择开始时间" autocomplete="off"/>
                </div>
            </div>
            <div class="item form-group col-md-2 col-sm-2">
                <label class="col-md-4 col-sm-4 control-label" for="ownerName">业户姓名:</label>
                <div class="col-md-8 col-sm-8 col-xs-12">
                    <input id="ownerName" name="ownerName" class="form-control" placeholder="请输入业户姓名">
                </div>
            </div>
            <div class="item form-group col-md-2 col-sm-2">
                <label class="col-md-3 col-sm-3 control-label" for="ownerPhone">手机号:</label>
                <div class="col-md-9 col-sm-9 col-xs-12">
                    <input id="ownerPhone" name="ownerPhone" class="form-control" placeholder="请输入手机号">
                </div>
            </div>
            <div class="item form-group col-md-2 col-sm-2 col-xs-2" style="margin-top: 2px;">
                <div class="col-md-5 col-sm-5 col-xs-5">
                    <button type="button" class="btn btn-sm btn-primary" onclick="searchArrearsAccountList()"><i class="glyphicon glyphicon-search"></i>查询</button>
                </div>
                <div class="col-md-5 col-sm-5 col-xs-5">
                    <button type="button" class="btn btn-sm btn-primary" onclick="exportData()"><i class="glyphicon glyphicon-download-alt"></i>导出</button>
                </div>
            </div>
        </form>
        <table id="arrearsAccountTable"></table>
    </div>
</div>
<div style="position: absolute;top: 0;left: 0;opacity: 0;z-index: -1">
    <table id="arrearsAccountTableAll" style="width: 100%"></table>
</div>
<#include "/layout/footer.ftl"/>
<script type="text/javascript" src="/assets/js/bootstrap-table-export.min.js"></script>
<script type="text/javascript" src="/assets/js/tableExport.min.js"></script>
<script type="text/javascript" src="/assets/js/xlsx.core.min.js"></script>
<script>
    var flag=true;//初始化状态,主要区别开始时间是否手动给值
    var mergeCellArr = new Array();//合并单元格使用
    var propertyOrCarType=costTypeToCostName("");
    var propertyType=costTypeToCostName("物业费");
    var carType=costTypeToCostName("车位费");
    $(function () {
        initLayDate();
        queryVillage("village");
        getArrearsAccountList("true");
        getArrearsAccountList("false");
        $("#searchForm #costName").html(propertyOrCarType);
    })
    //初始化开始时间layDate日期组件
    function initLayDate() {
        laydate.render({
            elem: "#beginTime",
            type:"month",
            value:(new Date()).getFullYear()+"-01",
            done: function(value, dates){
            }
        })
    }
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
    /**
     * 获取欠费台账
     * @param {String} isPage "true代表分页","false"代表全量
     * */
    function getArrearsAccountList(isPage) {
        if(isPage=="true")var domId="#arrearsAccountTable",url="/report/debtQueryPage";
        else var domId="#arrearsAccountTableAll",url="/report/debtQuery";
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
                    title: '欠费金额(单位:元)',
                }
            ],
            height:$(".content_bg_common").height()-$("#searchForm").height()-30,
            queryParams: function(param){
                var formData=$('#searchForm').serializeArray();
                var params={beginTime:flag==true?(new Date()).getFullYear()+"-01":formData.beginTime};
                formData.forEach(function (item,index) {
                    if(item.name=="building"||item.name=="location"){
                        if(item.value==""||(item.value&&item.value!="null"))params[item.name]=item.value;
                    }else{
                        if(item.value)params[item.name]=item.value;
                    }
                })
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
                mergeCellArr=new Array();
                if(isPage=="true"&&res&&res.list&&res.list.length!=0)arr=res.list;
                else if(isPage=="false"&&res&&res.length!=0)arr=res;
                if(arr.length!=0){
                    arr.forEach(function (item, index) {
                        if(item.deposits.length!=0){
                            mergeCellArr.push({index: list.length, field: "house", rowspan: item.deposits.length});
                            mergeCellArr.push({index: list.length, field: "ownerName", rowspan: item.deposits.length});
                            mergeCellArr.push({index: list.length, field: "ownerPhone", rowspan: item.deposits.length});
                            item.deposits.forEach(function (_item,_index) {
                                // 处理房屋名称
                                _item.house=_item.village+_item.building+_item.location+_item.room;
                                //处理车位费的缴费项目，包含车位号、车牌号
                                if(_item.costType=="车位费"){
                                    _item.costName=_item.costName+(_item.carId?_item.carId:"")+(_item.licensePlateNo?"("+_item.licensePlateNo+")":"")
                                }
                                //处理费用所属时间
                                var beginTimeArr=_item.beginTime.split("-");
                                var endTimeArr=(flag==true?[(new Date()).getFullYear(),"01"]:$("#beginTime").val().split("-"));
                                if(_item.costType=="车位费"&&_item.costTypeClass=="租赁"){
                                    if(flag==true){
                                        _item.time=_item.beginTime+"~"+(Number(endTimeArr[0])-1)+"-12-"+beginTimeArr[2];
                                    }else{
                                        if(Number(endTimeArr[1])==1)var endTimeOther=Number(endTimeArr[0])-1+"-12-"+beginTimeArr[2];
                                        else var endTimeOther=endTimeArr[0]+(Number(endTimeArr[1])-1>9?"-"+(Number(endTimeArr[1])-1):"-0"+(Number(endTimeArr[1])-1))+"-"+beginTimeArr[2];
                                        _item.time=_item.beginTime+"~"+endTimeOther;
                                    }
                                }else if(_item.costType=="物业费"||(_item.costType=="车位费"&&_item.costTypeClass=="购买")){
                                    if(flag==true){
                                        _item.time=_item.beginTime+"~"+(Number(endTimeArr[0])-1)+"-12";
                                    }else{
                                        if(Number(endTimeArr[1])==1)var endTimeOther=(Number(endTimeArr[0])-1)+"-12";
                                        else var endTimeOther=endTimeArr[0]+(Number(endTimeArr[1])-1>9?"-"+(Number(endTimeArr[1])-1):"-0"+(Number(endTimeArr[1])-1));
                                        _item.time=_item.beginTime+"~"+endTimeOther;
                                    }
                                }else{
                                    _item.time="/";
                                }
                                list.push(_item);
                            })
                        }
                    })
                }
                return{
                    "total":isPage=="true"?res.total:res.length,
                    "rows":list
                }
            },
            onLoadSuccess:function (data) {
                if(mergeCellArr.length!=0){
                    mergeCellArr.forEach(function(item,index){
                        $(domId).bootstrapTable('mergeCells', item);
                    })
                }
            },
        })
    }
    //点击查询按钮
    function searchArrearsAccountList() {
        flag=false;
        if(!$("#beginTime").val()){
            layer.alert("请选择开始时间！",{title:"警告"});
            return;
        }
        $("#arrearsAccountTable").bootstrapTable("refresh");
        $("#arrearsAccountTableAll").bootstrapTable("refresh");
    }
    //导出
    function exportData() {
        if($('#arrearsAccountTableAll').bootstrapTable("getData").length==0){
            layer.alert("不能导出空数据表格！",{title:"警告"});
            return false;
        }
        $("#arrearsAccountTableAll").tableExport({
            type: 'excel',
            exportDataType: "all",
            fileName: "欠费台账",
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
        $("#arrearsAccountTable").bootstrapTable('resetView', {
            height:$(".content_bg_common").height()-$("#searchForm").height()-30,
        });
    }
</script>


