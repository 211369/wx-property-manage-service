<#include "/layout/header.ftl"/>
<div class="clearfix"></div>
<div class="row content_bg_common ownerManage">
    <div class="col-md-12 col-sm-12 col-xs-12">
        <div class="btnGroup">
            <button type="button" class="btn btn-sm btn-primary" data-toggle="modal" data-target="#addOrUpdateOwnerModal"><i class="glyphicon glyphicon-plus"></i>新增业户</button>
            <button type="button" class="btn btn-sm btn-primary" onclick="deleteOwnerOrDetail({funcName:'owner',type:'true',domId:'#table'})"><i class="glyphicon glyphicon-trash"></i>批量删除</button>
            <a href="/assets/excelmodule/ownerExcel.xlsx" download="业户导入模板.xlsx">
                <button type="button" class="btn btn-sm btn-primary"><i class="glyphicon glyphicon-save"></i>模板下载</button>
            </a>
            <div class="btn btn-sm" style="display: inline-block;position: relative;margin: 0;padding: 0;">
                <button type="button" class="btn btn-sm btn-primary"><i class="glyphicon glyphicon-open"></i>批量导入</button>
                <input type="file" id="ownerExcel" class="btn-sm" style="position: absolute;top: 0;left: 0;opacity: 0;width: 75px;">
            </div>
        </div>
        <form id="searchForm" class="form-horizontal form-label-left">
            <div class="item form-group col-md-2">
                <label class="col-md-3 col-sm-3 control-label" for="village">小区:</label>
                <div class="col-md-9 col-sm-9 col-xs-12 items">
                    <select id="village" name="village" class="form-control">
                        <option value="">请选择</option>
                    </select>
                </div>
            </div>
            <div class="item form-group col-md-2">
                <label class="col-md-3 col-sm-3 control-label" for="building">楼栋:</label>
                <div class="col-md-9 col-sm-9 col-xs-12 items">
                    <select id="building" name="building" class="form-control">
                        <option value='null'>请选择</option>
                    </select>
                </div>
            </div>
            <div class="item form-group col-md-2">
                <label class="col-md-3 col-sm-3 control-label" for="location">单元:</label>
                <div class="col-md-9 col-sm-9 col-xs-12 items">
                    <select id="location" name="location" class="form-control">
                        <option value='null'>请选择</option>
                    </select>
                </div>
            </div>
            <div class="item form-group col-md-2">
                <label class="col-md-3 col-sm-3 control-label" for="room">房屋:</label>
                <div class="col-md-9 col-sm-9 col-xs-12 items">
                    <select id="room" name="room" class="form-control">
                        <option value="">请选择</option>
                    </select>
                </div>
            </div>
            <div class="item form-group col-md-2">
                <label class="col-md-3 col-sm-3 control-label" for="ownerName">姓名:</label>
                <div class="col-md-9 col-sm-9 col-xs-12 items">
                    <input type="text" class="form-control col-md-12 col-xs-12" name="ownerName" id="ownerName" placeholder="请输入业户姓名" autocomplete="off"/>
                </div>
            </div>
            <div class="item form-group col-md-2">
                <label class="col-md-3 col-sm-3 control-label" for="ownerPhone">手机号:</label>
                <div class="col-md-9 col-sm-9 col-xs-12 items">
                    <input type="number" class="form-control col-md-12 col-xs-12" name="ownerPhone" id="ownerPhone" placeholder="请输入业户手机号" autocomplete="off"/>
                </div>
            </div>
            <div class="item form-group col-md-1 searchBtn">
                <button type="button" class="btn btn-sm btn-primary" onclick="searchOwner()"><i class="glyphicon glyphicon-search"></i>查询</button>
            </div>
        </form>
        <table id="table"></table>
    </div>
</div>
<#--业户信息弹窗-->
<div class="modal fade" id="addOrUpdateOwnerModal" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop>
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="addroleLabel">添加业户信息</h4>
            </div>
            <div class="modal-body configManageModalBody">
                <form id="addOrUpdateForm" class="form-horizontal form-label-left" novalidate>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="village">小区名称: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="village" id="village" required="required" placeholder="请输入小区名称" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="building">楼栋名称:</label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="building" id="building" placeholder="请输入楼栋名称" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="location">单元号: </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="location" id="location" placeholder="请输入单元号" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="room">房间号: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="room" id="room" required="required" placeholder="请输入房间号" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="roomArea">房屋面积: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="roomArea" id="roomArea" required="required" placeholder="请输入房间号" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="ownerName">姓名: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="ownerName" id="ownerName" required="required" placeholder="请输入业主姓名" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="ownerPhone">手机号: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="ownerPhone" id="ownerPhone" required="required" placeholder="请输入业主手机号" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="idCardNo">身份证号: </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="idCardNo" id="idCardNo" placeholder="请输入身份证号" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="reservePhone">备用手机号: </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="reservePhone" id="reservePhone" placeholder="请输入备用手机号" autocomplete="off"/>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary addOrUpdateBtn" onclick="addOrUpdateOwner()">保存</button>
            </div>
        </div>
    </div>
</div>
<#--业户详情弹窗，点击绑定业务按钮时展示-->
<div class="modal fade" id="ownerDetail" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop>
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="addroleLabel">业户业务</h4>
            </div>
            <div class="modal-body configManageModalBody">
                <div class="ownerDetailTitle"></div>
                <table id="ownerDetailTable"></table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="ownerDetailAddBtn" onclick="addDetail()">新增绑定</button>
                    <@shiro.hasPermission name="owner:delete"><button type="button" class="btn btn-primary" onclick="deleteOwnerOrDetail({funcName:'detail',type:'true',domId:'#ownerDetailTable'})">批量解绑</button></@shiro.hasPermission>
            </div>
        </div>
    </div>
</div>
<#--业户详情页新增绑定弹窗，点击新增绑定按钮时展示-->
<div class="modal fade" id="ownerDetailAdd" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop>
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="addroleLabel">新增绑定</h4>
            </div>
            <div class="modal-body configManageModalBody">
                <form id="ownerDetailAddForm" class="form-horizontal form-label-left" novalidate>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="house">房屋: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="house" id="house" readonly="readonly" required="required" placeholder="请输入房屋" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="costType">缴费类型: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <select id="costType" name="costType" class="form-control" required="required">
                                <option value="">请选择</option>
                            </select>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="costTypeClass">缴费大类: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <select id="costTypeClass" name="costTypeClass" class="form-control" required="required">
                                <option value="">请选择</option>
                            </select>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="costTypeSection">缴费小类: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <select id="costTypeSection" name="costTypeSection" class="form-control" required="required">
                                <option value="">请选择</option>
                            </select>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="costName">缴费项目: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <select id="costName" name="costName" class="form-control" required="required">
                                <option value="">请选择</option>
                            </select>
                        </div>
                    </div>
                    <div class="item form-group carNoFlag">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="carNo">车位号: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="carNo" id="carNo" required="required" placeholder="请输入车位号" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group carNoFlag">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="licensePlateNo">车牌号: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="licensePlateNo" id="licensePlateNo" required="required" placeholder="请输入车牌号" autocomplete="off"/>
                        </div>
                    </div>
                    <#--类型为车位费且大类为租赁的项目的开始时间，精确到天-->
                    <div class="beginOrEnd">
                        <div class="item form-group">
                            <label class="control-label col-md-3 col-sm-3 col-xs-12" for="beginTimeCar">开始时间: <span class="required">*</span></label>
                            <div class="col-md-6 col-sm-6 col-xs-12">
                                <input type="text" value="" class="form-control col-md-12 col-xs-12" name="beginTimeCar" id="beginTimeCar" required="required" placeholder="请选择开始时间"/>
                            </div>
                        </div>
                    </div>
                    <#--物业费或者大类为购买的车位费的开始时间，精确到月-->
                    <div class="beginOnly">
                        <div class="item form-group">
                            <label class="control-label col-md-3 col-sm-3 col-xs-12" for="beginTime">开始时间: <span class="required">*</span></label>
                            <div class="col-md-6 col-sm-6 col-xs-12">
                                <input type="text" class="form-control col-md-12 col-xs-12" value="" name="beginTime" id="beginTime" required="required" placeholder="请选择开始时间" autocomplete="off"/>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" onclick="addDetailToHouse()">保存</button>
            </div>
        </div>
    </div>
</div>
<#include "/layout/footer.ftl"/>
<script type="text/javascript" src="/assets/js/bootstrap-table-export.min.js"></script>
<script type="text/javascript" src="/assets/js/tableExport.min.js"></script>
<script type="text/javascript" src="/assets/js/xlsx.core.min.js"></script>
<script>
    $(function () {
        var configList=new Array();
        queryVillage("village");
        getOwnerList();
        laydate.render({
            elem: '#beginTimeCar',
        });
        laydate.render({
            elem: '#beginTime',
            type:"month",
        });
    })
    //获取业户列表
    function getOwnerList(){
        $("#table").bootstrapTable({
            url:'/proprietor/queryHouse',
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
                    checkbox: true
                },{
                    field: 'house',
                    title: '房屋',
                },{
                    field: 'ownerName',
                    title: '姓名',
                },{
                    field: 'ownerPhone',
                    title: '手机号',
                },{
                    field: 'roomArea',
                    title: '房屋面积',
                },{
                    field: 'idCardNo',
                    title: '身份证号',
                },{
                    field: 'reservePhone',
                    title: '备用手机号',
                },{
                    field: 'operate',
                    title: '操作',
                    formatter: function(code, row, index) {
                        var obj={
                            funcName:"owner",
                            type:"false",
                            domId:"#table",
                            houseId:row.houseId
                        }
                        var operateBtn = [
                            '<button class="btn btn-xs btn-primary btn-update" onclick="updateOwner(' + JSON.stringify(row).replace(/"/g, '&quot;') + ')"><i class="fa fa-edit"></i>编辑</button>',
                           <!-- '<button class="btn btn-xs btn-danger btn-remove" disabled onclick="deleteOwnerOrDetail(' + JSON.stringify(obj).replace(/"/g, '&quot;') + ')"><i class="fa fa-trash-o"></i>删除</button>', -->
                            '<button class="btn btn-xs btn-info " onclick="searchOwnerDetail(' + JSON.stringify(row).replace(/"/g, '&quot;') + ')"><i class="fa fa-circle-thin"></i>绑定业务</button>'
                        ];
                        return operateBtn.join('');
                    }
                }
            ],
            height:$(".content_bg_common").height()-$("#searchForm").height()-75,
            queryParams: function(params){
                var param=$('#searchForm').serializeObject();
                if(param.building=="null")param.building=null;
                if(param.location=="null")param.location=null;
                param.pageNumber=params.offset/params.limit +1;
                param.pageSize=params.limit;
                return param;
            },
            formatLoadingMessage: function(){
                return "正在加载中。。。";
            },
            responseHandler:function (res) {
                var list=new Array();
                if(res&&res.list&&res.list.length!=0){
                    list=res.list.map(function (item, index) {
                        item.house=item.village+item.building+item.location+item.room;
                        return item;
                    })
                }
                return{
                    "total":list.length==0?0:res.total,
                    "rows":list
                }
            },
        })
    }
    //业户excel文件发生变化
    $('#ownerExcel').change(function(e) {
        var files = e.target.files;
        var fileReader = new FileReader();
        fileReader.onload = function(ev) {
            try {
                var data = ev.target.result,results = [];
                var workbook = XLSX.read(data, {
                    type: 'array'
                });
            } catch (data) {
                layer.alert("文件读取异常！",{title:"警告"});
                return;
            }
            for (var sheet in workbook.Sheets) {
                if (workbook.Sheets.hasOwnProperty(sheet)) {
                    results = results.concat(XLSX.utils.sheet_to_json(workbook.Sheets[sheet]));
                    break; // 只取第一张表
                }
            }
            sendExcelData(results);
        };
        fileReader.readAsArrayBuffer(files[0]);
    });
    //处理读取的excel数据
    function sendExcelData(data){
        var load=layer.load(0, {
            shade: [0.2,'#000']
        });
        $("#ownerExcel").val('');
        if(data.length==0){
            layer.alert("不能导入空数据表格！",{title:"警告"});
        }else{
            var list=new Array();
            var flag;//必填项为空时，做中断语句执行使用
            for(var index in data){
                var item=data[index];
                if((item["小区名称(必填)"]&&String(item["小区名称(必填)"]).indexOf("示例")!=-1)||(item["楼栋名称"]&&String(item["楼栋名称"]).indexOf("示例")!=-1)||(item["单元号"]&&String(item["单元号"]).indexOf("示例")!=-1)||(item["房间号(必填)"]&&String(item["房间号(必填)"]).indexOf("示例")!=-1)||(item["房屋面积(必填)"]&&String(item["房屋面积(必填)"]).indexOf("示例")!=-1)||(item["姓名(必填)"]&&String(item["姓名(必填)"]).indexOf("示例")!=-1)||(item["手机号(必填)"]&&String(item["手机号(必填)"]).indexOf("示例")!=-1)||(item["身份证号"]&&String(item["身份证号"]).indexOf("示例")!=-1)||(item["备用手机号"]&&String(item["备用手机号"]).indexOf("示例")!=-1)||(item["车位号"]&&String(item["车位号"]).indexOf("示例")!=-1)||(item["缴费项目(必填)"]&&String(item["缴费项目(必填)"]).indexOf("示例")!=-1)||(item["缴费类型(必填)"]&&String(item["缴费类型(必填)"]).indexOf("示例")!=-1)||(item["缴费大类"]&&String(item["缴费大类"]).indexOf("示例")!=-1)||(item["缴费小类"]&&String(item["缴费小类"]).indexOf("示例")!=-1)||(item["单价(必填)"]&&String(item["单价(必填)"]).indexOf("示例")!=-1)||(item["费用开始时间"]&&String(item["费用开始时间"]).indexOf("示例")!=-1)){
                    if(data.length==1)layer.alert("不能导入空数据表格！",{title:"警告"});
                    continue;
                }
                if(!item["小区名称(必填)"]||!item["房间号(必填)"]||!item["房屋面积(必填)"]||!item["缴费项目(必填)"]||!item["缴费类型(必填)"]||!item["单价(必填)"]){
                    var compKeys=["小区名称(必填)","房间号(必填)","房屋面积(必填)","缴费项目(必填)","缴费类型(必填)","单价(必填)"];
                    for(var i in compKeys){
                        if(!item[compKeys[i]]){
                            layer.alert("第<span style='font-weight: bolder;'>"+(Number(index)+2)+"</span>行<span style='font-weight: bolder;'>"+compKeys[i]+"</span>的值不能为空！",{title:"警告"});
                            break;
                        }
                    }
                    flag=false;
                    break;
                }else{
                    var obj={
                        village:item["小区名称(必填)"],
                        building:item["楼栋名称"]?item["楼栋名称"]:"",
                        location:item["单元号"]?item["单元号"]:"",
                        room:String(item["房间号(必填)"]),
                        roomArea:String(item["房屋面积(必填)"]),
                        ownerName:item["姓名(必填)"],
                        ownerPhone:String(item["手机号(必填)"]),
                        idCardNo:item["身份证号"]?String(item["身份证号"]):"",
                        reservePhone:item["备用手机号"]?String(item["备用手机号"]):"",
                        costName:item["缴费项目(必填)"],
                        costType:item["缴费类型(必填)"],
                        unit:Number(item["单价(必填)"]),
                    };
                    //单独处理缴费大类、缴费小类、费用开始时间：若为车位费和物业费，则缴费大类、缴费小类和费用开始时间必填
                    if(obj.costType=="物业费"||obj.costType=="车位费"){
                        if(!item["缴费大类"]){
                            layer.alert("第<span style='font-weight: bolder;'>"+(Number(index)+2)+"</span>行<span style='font-weight: bolder;'>缴费大类</span>的值不能为空！",{title:"警告"});
                            flag=false;
                            break;
                        }else obj.costTypeClass=item["缴费大类"];
                        if(!item["缴费小类"]){
                            layer.alert("第<span style='font-weight: bolder;'>"+(Number(index)+2)+"</span>行<span style='font-weight: bolder;'>缴费小类</span>的值不能为空！",{title:"警告"});
                            flag=false;
                            break;
                        }else obj.costTypeSection=item["缴费小类"];
                        if(!item["费用开始时间"]){
                            layer.alert("第<span style='font-weight: bolder;'>"+(Number(index)+2)+"</span>行<span style='font-weight: bolder;'>费用开始时间</span>的值不能为空！",{title:"警告"});
                            flag=false;
                            break;
                        }else obj.beginTime=String(item["费用开始时间"]);
                    }else{
                        obj.costTypeClass="";
                        obj.costTypeSection="";
                        obj.beginTime="";
                    }
                    //单独处理车位号和车牌号：若为车位费，则车位号和车牌号必填
                    if(obj.costType=="车位费"){
                        if(!item["车位号"]){
                            layer.alert("第<span style='font-weight: bolder;'>"+(Number(index)+2)+"</span>行<span style='font-weight: bolder;'>车位号</span>的值不能为空！",{title:"警告"});
                            flag=false;
                            break;
                        }else obj.carNo=String(item["车位号"]);
                        if(!item["车牌号"]){
                            layer.alert("第<span style='font-weight: bolder;'>"+(Number(index)+2)+"</span>行<span style='font-weight: bolder;'>车牌号</span>的值不能为空！",{title:"警告"});
                            flag=false;
                            break;
                        }else obj.licensePlateNo=String(item["车牌号"]);
                    }else{
                        obj.carNo="";
                        obj.licensePlateNo="";
                    }
                    list.push(obj);
                }
            }
            if(flag==false)return;
            $.ajax({
                url: "/config/propertyImport",
                type: "post",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data:JSON.stringify(list),
                success: function(res){
                    layer.close(load);
                    if(res.code==200||res.code==500)layer.alert(res.msg,{title:res.code==200?"提示":"警告"});
                    else layer.alert("导入失败！",{title:"警告"});
                    queryVillage("village");
                    $("#table").bootstrapTable("refresh");
                },
                error: function(error){
                    layer.close(load);
                    layer.alert("导入失败！",{title:"警告"});
                }
            });
        }
    }
    //点击查询按钮
    function searchOwner(){
        $("#table").bootstrapTable("refresh");
    }
    //点击编辑按钮,修改业户信息
    function updateOwner(data) {
        Object.keys($("#addOrUpdateForm").serializeObject()).forEach(function (item, index) {
            $("#addOrUpdateForm #"+item).val(data[item]);
        })
        $("#addOrUpdateForm #village").attr("readonly", "readonly");
        $("#addOrUpdateForm #building").attr("readonly", "readonly");
        $("#addOrUpdateForm #location").attr("readonly", "readonly");
        $("#addOrUpdateForm #room").attr("readonly", "readonly");
        $("#addOrUpdateOwnerModal .modal-title").html("修改业户信息");
        $("#addOrUpdateOwnerModal .addOrUpdateBtn").attr("data-id", data.houseId);
        $("#addOrUpdateOwnerModal").modal('show');
    }
    //点击保存按钮，新增或者更新业户信息
    function addOrUpdateOwner(){
        if(validator.checkAll($("#addOrUpdateForm"))){
            var list=new Array(),obj=$("#addOrUpdateForm").serializeObject(),type="添加";
            if($("#addOrUpdateOwnerModal .modal-title").html()=="修改业户信息"){
                obj.houseId=$("#addOrUpdateOwnerModal .addOrUpdateBtn").attr("data-id");
                type="修改";
            }
            list.push(obj);
            $.ajax({
                url: "/proprietor/addOrUpdate",
                type: "post",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data:JSON.stringify(list),
                success: function(res){
                    if(res.code==200||res.code==500)layer.alert(res.msg,{title:res.code==200?"提示":"警告"});
                    else layer.alert(type=="添加"?"添加失败！":"修改失败！",{title:"警告"});
                    $("#addOrUpdateOwnerModal").modal('hide');
                    queryVillage("village");
                    $("#table").bootstrapTable("refresh");
                },
                error: function(error){
                    $("#addOrUpdateOwnerModal").modal('hide');
                    layer.alert(type=="添加"?"添加失败！":"修改失败！",{title:"警告"});
                }
            });
        }
    }
    //关闭新增或更新业户模态框
    $('#addOrUpdateOwnerModal').on('hide.bs.modal',function() {
        $('#addOrUpdateForm')[0].reset();
        $("#addOrUpdateForm .form-group").removeClass("bad");
        $("#addOrUpdateForm .form-group .alert").remove();
        $("#addOrUpdateOwnerModal .modal-title").html("添加业户信息");
        $("#addOrUpdateOwnerModal .addOrUpdateBtn").removeAttr("data-id");
        $("#addOrUpdateForm #village").removeAttr("readonly");
        $("#addOrUpdateForm #building").removeAttr("readonly");
        $("#addOrUpdateForm #location").removeAttr("readonly");
        $("#addOrUpdateForm #room").removeAttr("readonly");
    })
    //关闭业户详情模态框
    $('#ownerDetail').on('hide.bs.modal',function() {
        $("#ownerDetail #ownerDetailAddBtn").removeAttr("data-house");
    })
    //关闭新增绑定模态框
    $('#ownerDetailAdd').on('hide.bs.modal',function() {
        $('#ownerDetailAddForm')[0].reset();
        $("#ownerDetailAddForm .form-group").removeClass("bad");
        $("#ownerDetailAddForm .form-group .alert").remove();

        $("#ownerDetailAddForm .carNoFlag").css("display","none");
        $("#ownerDetailAddForm .beginOrEnd").css("display","none");
        $("#ownerDetailAddForm .beginOnly").css("display","none");

        $("#ownerDetailAddForm .carNoFlag #carNo").val("");
        $("#ownerDetailAddForm .carNoFlag #licensePlateNo").val("");
        $("#ownerDetailAddForm #beginTime").val("");
        $("#ownerDetailAddForm #beginTimeCar").val("");
    })
    /**
    * 单个或批量删除业户以及删除业户详情
    * @param {object} data  data.funcName("owner":删除业户、"detail":删除业户详情；)
    * */
    function deleteOwnerOrDetail(data) {
        var selectList=new Array(),url,tableName;
        if(data.type=='false'){
            //这是单个删除
            if(data.funcName=="owner")selectList.push(data.houseId);
            else if(data.funcName=="detail")selectList.push({"houseId":data.houseId,"carId":data.carId,costId:data.costId});
        }
        else{
            //这是批量删除
            var arr=$(data.domId).bootstrapTable('getSelections');
            arr.forEach(function(item,index){
                if(data.funcName=="owner")selectList.push(item.houseId);
                else if(data.funcName=="detail")selectList.push({"houseId":item.houseId,"carId":item.carId,costId:item.costId});
            })
        }
        if(data.funcName=="owner"){
            url="/proprietor/deleteBatch";
        }
        else if(data.funcName=="detail"){
            url="/proprietor/deleteDetail";
        }
        if(selectList.length==0){
            layer.alert("请至少选择一条记录！",{title:"警告"});
        }else{
            layer.confirm(data.type=='false'?"确定删除该条数据?":"确定批量删除当前所选数据？", {
                btn: ['确定','取消'],
                title:"提示"
            }, function () {
                $.ajax({
                    url: url,
                    type: "post",
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    data:JSON.stringify(selectList),
                    success: function(res){
                        if(res.code==200||res.code==500)layer.alert(res.msg,{title:res.code==200?"提示":"警告"});
                        else layer.alert("删除失败！",{title:"警告"});
                        $(data.domId).bootstrapTable("refresh");
                    },
                    error: function(error){
                        layer.alert("删除失败！",{title:"警告"});
                    }
                });
            },function () {});
        }
    }
    //点击绑定业务按钮，查询该条房屋对应业务详情
    function searchOwnerDetail(data) {
        var str=data.house+"，业主："+data.ownerName;
        $("#ownerDetail .ownerDetailTitle").html(str);
        $("#ownerDetail #ownerDetailAddBtn").attr("data-house",JSON.stringify(data));//按钮关联小区数据，以便查询小区对应的缴费配置项以及其他相关信息
        $("#ownerDetailTable").bootstrapTable('destroy').bootstrapTable({
            url:'/proprietor/queryDetail',
            method: 'get',
            dataType: "json",
            contentType: 'application/json',
            toolbar: '#toolbar',
            toggle:"table",
            sidePagination: "server",
            columns:[
                {
                    checkbox: true,
                },{
                    field: 'costName',
                    title: '缴费项目',
                },{
                    field: 'costType',
                    title: '费用类型',
                },{
                    field: 'costTypeClass',
                    title: '缴费大类',
                },{
                    field: 'costTypeSection',
                    title: '缴费小类',
                },{
                    field: 'carNo',
                    title: '车位号',
                },{
                    field: 'licensePlateNo',
                    title: '车牌号',
                },{
                    field: 'unit',
                    title: '单价',
                    formatter:function (code, row, index) {
                        if(row.costType=="物业费"){
                            return code+"元／(㎡<span style='font-weight: bolder;'>·</span>月)";
                        }else if(row.costType=="车位费"){
                            return code+"元／月";
                        }else return code+"元";
                    }
                },{
                    field: 'beginTime',
                    title: '开始时间',
                },{
                    field: 'operate',
                    title: '操作',
                    formatter: function(code, row, index) {
                        var obj={
                            funcName:'detail',
                            type:"false",
                            domId:"#ownerDetailTable",
                            houseId:row.houseId,
                            carId:row.carId,
                            costId:row.costId
                        }
                        // return '<button class="btn btn-xs btn-primary" id="'+row.houseId+'" onclick="deleteOwnerOrDetail(' + JSON.stringify(obj).replace(/"/g, '&quot;') + ')"><i class="glyphicon glyphicon-minus"></i>解除绑定</button>';
                        return '<@shiro.hasPermission name="owner:delete"><button class="btn btn-xs btn-primary" id="'+row.houseId+'" onclick="deleteOwnerOrDetail(' + JSON.stringify(obj).replace(/"/g, '&quot;') + ')"><i class="glyphicon glyphicon-minus"></i>解除绑定</button></@shiro.hasPermission>';
                    }
                }
            ],
            queryParams: function(params){
                return {houseId:data.houseId,village:data.village};
            },
            formatLoadingMessage: function(){
                return "正在加载中。。。";
            },
            responseHandler:function (res) {
                $("#ownerDetail").modal('show');
                var arr=res.bind,list=new Array();
                var propertyList=new Array(),carList=new Array(),depositList=new Array(),disposableList=new Array();
                arr.forEach(function (item, index) {
                    if(item.costType=="物业费"){
                        item.carNo="/";
                        item.licensePlateNo="/";
                        propertyList.push(item);
                    }
                    if(item.costType=="车位费"){
                        carList.push(item);
                    }
                    if(item.costType=="押金类"){
                        item.costTypeClass="/";
                        item.costTypeSection="/";
                        item.beginTime="/";
                        item.carNo="/";
                        item.licensePlateNo="/";
                        depositList.push(item);
                    }
                    if(item.costType=="一次性"){
                        item.costTypeClass="/";
                        item.costTypeSection="/";
                        item.beginTime="/";
                        item.carNo="/";
                        item.licensePlateNo="/";
                        disposableList.push(item);
                    }
                })
                list=propertyList.concat(carList).concat(depositList).concat(disposableList);
                return{
                    "total":list.length,
                    "rows":list
                }
            },
            onLoadSuccess: function (data) {
                if($(".content_bg_common").height()-$("#ownerDetailTable").height()<200){
                    $("#ownerDetailTable").bootstrapTable('resetView', {
                        height: $(".content_bg_common").height()-240
                    });
                }
            },
        })
    }
    //点击新增绑定按钮，查询对应配置项
    function addDetail(){
        var houseInfo=JSON.parse($("#ownerDetail #ownerDetailAddBtn").attr("data-house"));
        $.ajax({
            url: "/config/queryByVillage",
            type: "get",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            data:{village:houseInfo.village},
            success: function(res){
                if(res.length==0){
                    layer.alert(houseInfo.village+"无缴费项，请先在配置管理中新增缴费项！",{title:"警告"});
                }else{
                    configList=res;
                    $("#ownerDetailAddForm #house").val(houseInfo.house);
                    handleConfigList();
                    $("#ownerDetailAdd").modal('show');
                }
            },
            error: function(error){
                layer.alert("数据查询异常",{title:"警告"});
            }
        });
    }
    //点击新增绑定中的保存按钮
    function addDetailToHouse(){
        var houseInfo=JSON.parse($("#ownerDetail #ownerDetailAddBtn").attr("data-house"));
        var formInfo=$("#ownerDetailAddForm").serializeObject();
        if(validator.checkAll($("#ownerDetailAddForm"))){
            var params={
                houseId:houseInfo.houseId,
                carId:"",
                costId:formInfo.costName,
            }
            //处理是否为车位费
            if(formInfo.costType=="车位费")params.carNo=formInfo.carNo;
            //处理是否为车位租赁费
            if(formInfo.costType=="车位费"&&formInfo.costTypeClass=="租赁"){
                params.beginTime=formInfo.beginTimeCar;
                params.endTime=formInfo.endTime;
            }else{
                params.beginTime=formInfo.beginTime;
                params.endTime="";
            }
            $.ajax({
                url: "/proprietor/addDetail",
                type: "post",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data:JSON.stringify(params),
                success: function(res){
                    if(res.code==200||res.code==500)layer.alert(res.msg,{title:res.code==200?"提示":"警告"});
                    else layer.alert("绑定失败！",{title:"警告"});
                    $('#ownerDetailAdd').modal('hide');
                    $("#ownerDetailTable").bootstrapTable("refresh")
                },
                error: function(error){
                    layer.alert("绑定失败！",{title:"警告"});
                }
            });
        }
    }
    //新增绑定功能，处理缴费项配置数据，一层层向下查找
    function handleConfigList(data){
        $("#ownerDetailAddForm #costTypeClass").removeAttr("disabled");
        $("#ownerDetailAddForm #costTypeSection").removeAttr("disabled");
        var arr=[];
        if(!data){
            $("#ownerDetailAddForm #costType").html("<option value=''>请选择</option>");
            configList.forEach(function(item,index){
                if(arr.indexOf(item.costType)==-1){
                    arr.push(item.costType);
                    $("#ownerDetailAddForm #costType").append("<option value='"+item.costType+"'>"+item.costType+"</option>");
                }
            })
        }else if(data.type=="costType"){
            if(data.costType!="押金类"&&data.costType!="一次性"){
                $("#ownerDetailAddForm #costTypeClass").html("<option value=''>请选择</option>");
                configList.forEach(function(item,index){
                    if(data.costType==item.costType&&arr.indexOf(item.costTypeClass)==-1){
                        arr.push(item.costTypeClass);
                        $("#ownerDetailAddForm #costTypeClass").append("<option value='"+item.costTypeClass+"'>"+item.costTypeClass+"</option>");
                    }
                })
            }else{
                $("#ownerDetailAddForm #costTypeClass").html("<option value=''>请选择</option>");
                $("#ownerDetailAddForm #costTypeSection").html("<option value=''>请选择</option>");
                $("#ownerDetailAddForm #costTypeClass").attr("disabled", "disabled");
                $("#ownerDetailAddForm #costTypeSection").attr("disabled", "disabled");
                configList.forEach(function(item,index){
                    if(data.costType==item.costType){
                        arr.push(item.costName);
                        $("#ownerDetailAddForm #costName").append("<option value='"+item.costId+"'>"+item.costName+"("+item.unit+"元)"+"</option>");
                    }
                })
            }
        }else if(data.type=="costTypeClass"){
            $("#ownerDetailAddForm #costTypeSection").html("<option value=''>请选择</option>");
            configList.forEach(function(item,index){
                if(data.costType==item.costType&&data.costTypeClass==item.costTypeClass&&arr.indexOf(item.costTypeSection)==-1){
                    arr.push(item.costTypeSection);
                    $("#ownerDetailAddForm #costTypeSection").append("<option value='"+item.costTypeSection+"'>"+item.costTypeSection+"</option>");
                }
            })
        }else if(data.type=="costTypeSection"){
            $("#ownerDetailAddForm #costName").html("<option value=''>请选择</option>");
            configList.forEach(function(item,index){
                if(data.costType==item.costType&&data.costTypeClass==item.costTypeClass&&data.costTypeSection==item.costTypeSection&&arr.indexOf(item.costTypeSection)==-1){
                    arr.push(item.costName);
                    $("#ownerDetailAddForm #costName").append("<option value='"+item.costId+"'>"+item.costName+"</option>");
                }
            })
        }else if(data.type=="costName"){
            if($("#ownerDetailAddForm #costType").val()=="押金类"||$("#ownerDetailAddForm #costType").val()=="一次性"){
                $("#ownerDetailAddForm #costTypeClass").attr("disabled", "disabled");
                $("#ownerDetailAddForm #costTypeSection").attr("disabled", "disabled");
            }
        }
    }
    //新增绑定：缴费类型select发生变化
    $("#ownerDetailAddForm #costType").change(function(){
        var costTypeVal=$("#ownerDetailAddForm #costType option:selected").val();
        var obj={
            type:"costType",
            costType:costTypeVal
        }
        //缴费类型为车位费时，需展示车位号和车牌号
        if(costTypeVal=="车位费"){
            $("#ownerDetailAddForm .carNoFlag").css("display","block");
            $("#ownerDetailAddForm .carNoFlag #carNo").val("");
            $("#ownerDetailAddForm .carNoFlag #licensePlateNo").val("");
        }else $("#ownerDetailAddForm .carNoFlag").css("display","none");
        //重置时间组件
        $("#ownerDetailAddForm #beginTime").val("");
        $("#ownerDetailAddForm #beginTimeCar").val("");
        $("#ownerDetailAddForm .beginOrEnd").css("display","none");
        $("#ownerDetailAddForm .beginOnly").css("display","none");
        $("#addOrUpdateForm .beginOrEnd .form-group").removeClass("bad");
        $("#addOrUpdateForm .beginOrEnd .form-group .alert").remove();
        $("#addOrUpdateForm .beginOnly .form-group").removeClass("bad");
        $("#addOrUpdateForm .beginOnly .form-group .alert").remove();

        $("#ownerDetailAddForm #costTypeClass").html("<option value=''>请选择</option>");
        $("#ownerDetailAddForm #costTypeSection").html("<option value=''>请选择</option>");
        $("#ownerDetailAddForm #costName").html("<option value=''>请选择</option>");
        handleConfigList(obj);
    })
    //新增绑定：缴费大类select发生变化
    $("#ownerDetailAddForm #costTypeClass").change(function(){
        var costTypeVal=$("#ownerDetailAddForm #costType option:selected").val();
        var costTypeClassVal=$("#ownerDetailAddForm #costTypeClass option:selected").val();
        var obj={
            type:"costTypeClass",
            costType:costTypeVal,
            costTypeClass:costTypeClassVal
        }
        //处理开始时间
        //1.物业费、车位费且大类为购买的  精确到月；2.车位费且大类为租赁的   精确到天；3.押金类、一次性无日期组件
        $("#ownerDetailAddForm #beginTime").val("");
        $("#ownerDetailAddForm #beginTimeCar").val("");
        if(costTypeVal=="物业费"||(costTypeVal=="车位费"&&costTypeClassVal=="购买")){
            $("#ownerDetailAddForm .beginOrEnd").css("display","none");
            $("#ownerDetailAddForm .beginOnly").css("display","block");
        }else if(costTypeVal=="车位费"&&costTypeClassVal=="租赁"){
            $("#ownerDetailAddForm .beginOrEnd").css("display","block");
            $("#ownerDetailAddForm .beginOnly").css("display","none");
        }else{
            $("#ownerDetailAddForm .beginOrEnd").css("display","none");
            $("#ownerDetailAddForm .beginOnly").css("display","none");
        }
        $("#ownerDetailAddForm #costTypeSection").html("<option value=''>请选择</option>");
        $("#ownerDetailAddForm #costName").html("<option value=''>请选择</option>");
        handleConfigList(obj);
    })
    //新增绑定：缴费小类select发生变化
    $("#ownerDetailAddForm #costTypeSection").change(function(){
        var obj={
            type:"costTypeSection",
            costType:$("#ownerDetailAddForm #costType option:selected").val(),
            costTypeClass:$("#ownerDetailAddForm #costTypeClass option:selected").val(),
            costTypeSection:$("#ownerDetailAddForm #costTypeSection option:selected").val(),
        }
        $("#ownerDetailAddForm #costName").html("<option value=''>请选择</option>");
        handleConfigList(obj);
    })
    //新增绑定：缴费项目select发生变化
    $("#ownerDetailAddForm #costName").change(function(){
        var obj={
            type:"costName",
            costName:$("#ownerDetailAddForm #costName option:selected").html()
        }
        handleConfigList(obj);
    })
    //动态设置业户列表table的高度
    window.onresize=function () {
        $("#table").bootstrapTable('resetView', {
            height:$(".content_bg_common").height()-$("#searchForm").height()-75
        });
    }
</script>