<#include "/layout/header.ftl"/>
<div class="clearfix"></div>
<div class="row content_bg_common configManage">
    <div class="col-md-12 col-sm-12 col-xs-12">
        <ul class="nav nav-tabs" id="myTab" style="display: none!important;">
            <li class="active"><a href="#config" >缴费项配置</a></li>
            <li><a href="#property">物业费导入</a></li>
            <li><a href="#park">车位费导入</a></li>
        </ul>
        <select id="selectVillage"></select>
        <div class="tab-content">
            <div class="tab-pane active" id="config">
                <table id="configTable"></table>
                <button onclick="handleVillage('add')" type="button" id="addBtn" class="btn btn-sm btn-primary" data-toggle="modal" data-target="#myModal"><span class="glyphicon glyphicon-plus"></span>新增</button>
            </div>
            <div class="tab-pane" id="property">
                <div class="exOrImport">
                    <a href="/assets/excelmodule/property.xlsx" download="物业费导入模板.xlsx">
                        <button type="button" class="btn btn-sm btn-primary"><span class="glyphicon glyphicon-save"></span>模板下载</button>
                    </a>
                    <div class="btn btn-sm" style="display: inline-block;position: relative;margin: 0;padding: 0;">
                        <button type="button" class="btn btn-sm btn-primary"><span class="glyphicon glyphicon-open"></span>批量导入</button>
                        <input type="file" id="excel-property" class="btn-sm" style="position: absolute;top: 0;left: 0;opacity: 0;width: 75px;">
                    </div>
                    <button type="button" class="btn btn-sm btn-primary" onclick="batchDelete('#propertyTable',false)"><span class="glyphicon glyphicon-trash"></span>批量删除</button>
                </div>
                <table id="propertyTable"></table>
            </div>
            <div class="tab-pane" id="park">
                <div class="exOrImport">
                    <a href="/assets/excelmodule/park.xlsx" download="车位费导入模板.xlsx">
                        <button type="button" class="btn btn-sm btn-primary"><span class="glyphicon glyphicon-save"></span>模板下载</button>
                    </a>
                    <div class="btn btn-sm" style="display: inline-block;position: relative;margin: 0;padding: 0;">
                        <button type="button" class="btn btn-sm btn-primary"><span class="glyphicon glyphicon-open"></span>批量导入</button>
                        <input type="file" id="excel-park" class="btn-sm" style="position: absolute;top: 0;left: 0;opacity: 0;width: 75px;">
                    </div>
                    <button type="button" class="btn btn-sm btn-primary" onclick="batchDelete('#parkTable',true)"><span class="glyphicon glyphicon-trash"></span>批量删除</button>
                </div>
                <table id="parkTable"></table>
            </div>
        </div>
    </div>
</div>
<#--缴费项弹窗-->
<div class="modal fade" id="myModal" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="addroleLabel">添加缴费项</h4>
            </div>
            <div class="modal-body configManageModalBody">
                <form id="addOrUpdateForm" class="form-horizontal form-label-left" novalidate>

                    <input type="hidden" class="form-control col-md-7 col-xs-12" id="village" name="village" required="required" disabled></input>

                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="costName">缴费项目: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-7 col-xs-12" id="costName" name="costName" required="required" placeholder="请输入缴费项目"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="costType">费用类型:<span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <!--<input type="text" class="form-control col-md-7 col-xs-12" name="costType" id="costType" required="required" placeholder="请输入费用类型"/>-->
                            <select name="costType" id="costType" required="required" class="form-control col-md-7 col-xs-12">
                                <option value=''>请选择</option>
                                <option value='物业费'>物业费</option>
                                <option value='车位费'>车位费</option>
                                <option value='押金类'>押金类</option>
                                <option value='一次性'>一次性</option>
                            </select>
                        </div>
                    </div>
                    <div class="item form-group costTypeClassOrSection">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="costTypeClass">缴费大类:<span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-7 col-xs-12" name="costTypeClass" id="costTypeClass" required="required" placeholder="请输入缴费大类"/>
                        </div>
                    </div>
                    <div class="item form-group costTypeClassOrSection">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="costTypeSection">缴费小类:<span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-7 col-xs-12" name="costTypeSection" id="costTypeSection" required="required" placeholder="请输入缴费小类"/>
                        </div>
                    </div>
                    <div class="item form-group addOrUpdateFormUnit">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="unit">单价（单位:元）:<span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="number" min="0" class="form-control col-md-7 col-xs-12" name="unit" id="unit" required="required" placeholder="请输入单价（单位：元）"/>
                        </div>
                    </div>
                    <div class="item form-group addOrUpdateFormMark">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="unit">备注:</label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-7 col-xs-12" name="mark" id="mark" placeholder="请输入备注"/>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary addOrUpdateBtn" onclick="addOrUpdateVillage()">保存</button>
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
        var costId;
        queryVillage("config");
    })
    /**
     * 操作按钮
     * @param code
     * @param row
     * @param index
     * @returns {string}
     */
    function operateFormatter(code, row, index) {
        var trId = row.costId;
        var rowItem=JSON.stringify(row);
        var operateBtn = [
            '<button class="btn btn-xs btn-primary btn-update" data-id="' + trId + '" data-toggle="modal" data-target="#myModal" onclick="handleVillage(' + JSON.stringify(row).replace(/"/g, '&quot;') + ');"><i class="fa fa-edit"></i>编辑</button>',
            '<button class="btn btn-xs btn-danger btn-remove" data-id="' + trId + '" onclick="deleteItem(\''+trId+'\')"><i class="fa fa-trash-o"></i>删除</button>',
        ];
        return operateBtn.join('');
    }
    //查询小区列表
    function queryVillage(type){
        $.ajax({
            url: '/config/queryVillage',
            type: "get",
            success: function(res){
                if(res&&res.length!=0){
                    var optionVillage="";
                    $.each(res,function(index,item){
                        optionVillage+='<option value='+item+'>'+item+'</option>';
                    })
                    $("#selectVillage").html(optionVillage);
                    $("#village").html('<option value="">请选择</option>'+optionVillage);
                    if(type=="config")queryByVillage($("#selectVillage").val());
                    else if(type=="property")queryProperty("#propertyTable",false);
                    else if(type=="park")queryProperty("#parkTable",true);
                }else{
                    $("#selectVillage").html('<option value="请选择">请选择</option>');
                    $("#village").html('<option value="">请选择</option>');
                    queryByVillage("");
                }
            },
            error: function(error){
                $("#selectVillage").html('<option value="请选择">请选择</option>');
                $("#village").html('<option value="">请选择</option>');
                queryByVillage("");
            }
        });
    }
    //查询缴费项配置列表
    function queryByVillage (data){
        $("#configTable").bootstrapTable('destroy').bootstrapTable({
            url:'/config/queryByVillage',
            method: 'GET',
            toolbar: '#toolbar',
            pagination: false,
            columns:[{
                field: 'costName',
                title: '缴费项目',
            },{
                field: 'costType',
                title: '费用类型',
            },{
                field: 'costTypeClass',
                title: '缴费大类',
                formatter:function (code, row, index) {
                    if(row.costType=="押金类"||row.costType=="一次性"){
                        return "/";
                    }else return code;
                }
            },{
                field: 'costTypeSection',
                title: '缴费小类',
                formatter:function (code, row, index) {
                    if(row.costType=="押金类"||row.costType=="一次性"){
                        return "/";
                    }else return code;
                }
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
                field: 'mark',
                title: '备注',
            },
            {
                field: 'Name',
                title: '操作',
                formatter: operateFormatter
            }],
            queryParams: function(params){
                return {village:data};
            },
            formatLoadingMessage: function(){
                return "正在加载中。。。";
            },
            responseHandler:function (res) {
               var list=new Array();
               if(res&&res.length!=0){
                   res.forEach(function(item,index){
                       if(item.costType=="押金类"||item.costType=="一次性"){
                           var obj=list.find(function(value, i){
                               return (item.costType == value.costType&&item.costName == value.costName);
                           });
                           if(!obj)list.push(item);
                       }else{
                           list.push(item);
                       }
                   })
               }
               return list;
            },
        })
    };
    //缴费项模态框开启
    function handleVillage(data){
        if(data&&data!="add"){
            $("#addroleLabel").html("修改缴费项");
            $("#village").attr("disabled", "disabled");
            $("#village").val(data.village);
            $("#costName").val(data.costName);
            $("#costType").val(data.costType);
            $("#unit").val(data.unit);
            if(data.costType=="押金类"||data.costType=="一次性"){
                $("#addOrUpdateForm .costTypeClassOrSection").css("display","none");
                $("#addOrUpdateForm .addOrUpdateFormUnit").css("display","none");

            }else{
                $("#costTypeClass").val(data.costTypeClass);
                $("#costTypeSection").val(data.costTypeSection);

            }
            costId=data.costId;
        }else{
            $("#addroleLabel").html("添加缴费项");
            $("#village").removeAttr("disabled");
        }
    }
    //缴费项模态框关闭
    $('#myModal').on('hide.bs.modal',function() {
        $('#addOrUpdateForm')[0].reset();
        $("#addOrUpdateForm .form-group").removeClass("bad");
        $("#addOrUpdateForm .form-group .alert").remove();
        $("#addOrUpdateForm .costTypeClassOrSection").css("display","block");
        $("#addOrUpdateForm .addOrUpdateFormUnit").css("display","block");
    })
    //缴费项模态框对押金类和一次性的费用类型做相关处理
    $("#addOrUpdateForm #costType").bind("input propertychange",function () {
        if($("#addOrUpdateForm #costType").val()=="押金类"||$("#addOrUpdateForm #costType").val()=="一次性"){
            $("#addOrUpdateForm .costTypeClassOrSection").css("display","none");

        }else {
            $("#addOrUpdateForm .costTypeClassOrSection").css("display","block");

        }
    })

    //点击提交，新增、更新缴费项
    function addOrUpdateVillage(){
        var valid = validator.checkAll($("#addOrUpdateForm"))
        if( valid || $("#addOrUpdateForm #costType").val()=="押金类"||$("#addOrUpdateForm #costType").val()=="一次性"){
            var url,type;
            var params={
                village:$("#selectVillage").val(),
                costName:$("#costName").val(),
                costType:$("#costType").val(),
                costTypeClass:$("#costTypeClass").val(),
                costTypeSection:$("#costTypeSection").val(),
                unit:$("#unit").val(),
                mark:$("#mark").val()
            };
            if($("#addroleLabel").html()=="添加缴费项"){
                url="/config/add";
                type="post";
            }else if($("#addroleLabel").html()=="修改缴费项"){
                url="/config/update";
                type="put";
                params.costId=costId;
            }
            $.ajax({
                url: url,
                type: type,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data:JSON.stringify(params),
                success: function(res){
                    $('#myModal').modal('hide');
                    if(res.code==200||res.code==500)layer.alert(res.msg,{title:res.code==200?"提示":"警告"});
                    else layer.alert($("#addroleLabel").html()=="添加缴费项"?"添加失败！":"修改失败！",{title:"警告"});
                    queryByVillage($("#selectVillage").val());
                },
                error: function(error){
                    $('#myModal').modal('hide');
                    layer.alert($("#addroleLabel").html()=="添加缴费项"?"添加失败！":"修改失败！",{title:"警告"});
                }
            });
        }
    }
    //删除缴费项
    function deleteItem(data){
        layer.confirm('确定删除该条配置项？', {
            btn: ['确定','取消'],
            title:"提示"
        }, function(){
            $.ajax({
                url: "/config/delete?costId="+data,
                type: "delete",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function(res){
                    if(res.code==200||res.code==500)layer.alert(res.msg,{title:res.code==200?"提示":"警告"});
                    else layer.alert("删除失败！",{title:"警告"});
                    queryByVillage($("#selectVillage").val());
                },
                error: function(error){
                    layer.alert("删除失败！",{title:"警告"});
                }
            });
        }, function(){});
    }
    //tab切换
    $('#myTab a').click(function (e) {
        if(e.target.hash=="#config"){
            queryByVillage($("#selectVillage").val());
        }else if(e.target.hash=="#property"){
            queryProperty("#propertyTable",false);
        }else if(e.target.hash=="#park"){
            queryProperty("#parkTable",true);
        }
        e.preventDefault();
        $(this).tab('show');
    })
    //选择小区
    $("#selectVillage").change(function(){
        var type=$(".nav-tabs li.active").find("a").attr("href");
        if(type=="#config")queryByVillage($("#selectVillage").val());
        else if(type=="#property")queryProperty("#propertyTable",false);
        else if(type=="#park")queryProperty("#parkTable",true);
    })
    //查询物业费、车位费列表
    function queryProperty(domName,flag) {
        var columns=new Array();
        columns=[
            {
                checkbox: true
            },{
                field: 'house',
                title: '房屋',
            },{
                field: 'costName',
                title: '缴费项目',
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
                field: 'roomArea',
                title: '房屋面积（单位：米）',
                visible:flag==false?true:false
            },{
                field: '',
                title: '操作',
                formatter:function(code, row, index){
                    var obj={
                        dom:flag==false?"#propertyTable":"#parkTable",
                        type:flag==false?false:true,
                        params:{
                            houseId:row.houseId,
                            costId:row.costId,
                            carId:row.carId,
                        }
                    }
                    return '<button class="btn btn-xs btn-danger btn-remove" onclick="batchDelete(' + JSON.stringify(obj).replace(/"/g, '&quot;') + ');"><i class="fa fa-trash-o"></i>删除</button>'
                }
            }
        ];
        $(domName).bootstrapTable('destroy').bootstrapTable({
            url:'/config/queryProperty',
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
            columns:columns,
            height: $(".content_bg_common").height()-98,
            queryParams: function(params){
                var param={
                    pageNumber:params.offset/params.limit +1,
                    pageSize:params.limit,
                    village:$("#selectVillage").val(),
                    flag:flag
                }
                return param;
            },
            formatLoadingMessage: function(){
                return "正在加载中。。。";
            },
            responseHandler:function (res) {
               var list=res.list.map(function(item,index){
                    var obj={
                        house:item.village+item.building+item.location+item.room,
                        time:item.beginTime+"~"+item.endTime,
                        roomArea:item.roomArea,
                        houseId:item.houseId,
                        carId:item.carId,
                        costId:item.costId,
                        costTypeClass:item.costTypeClass,
                        costTypeSection:item.costTypeSection,
                    }
                    if(item.costType=="车位费")obj.costName=item.costName+item.carNo;
                    else obj.costName=item.costName;
                    return obj;
                })
                return{
                    "total":res.total,
                    "rows":list
                }
            }
        })
    }
    //物业费文件发生变化
    $("#excel-property").change(function(e){
        importExcel(e,"property","#excel-property");
    })
    //车位费文件发生变化
    $('#excel-park').change(function(e) {
        importExcel(e,"park","#excel-park");
    });
    //导入excel，并读取excel数据
    function importExcel(data,type,domName){
        var files = data.target.files;
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
                    break; // 如果只取第一张表，就取消注释这行
                }
            }
            sendExcelData(results,type,domName);
        };
        fileReader.readAsArrayBuffer(files[0]);
    }
    //处理读取的excel数据
    function sendExcelData(data,type,domName){
        $(domName).val('');
        if(data.length==0){
            layer.alert("不能导入空数据表格！",{title:"警告"});
        }else{
            var list=new Array();
            var flag;
            for(var index in data){
                var item=data[index];
                if(!item["小区名称(必填)"]||!item["房间号(必填)"]||!item["房屋面积(必填)"]||!item["姓名(必填)"]||!item["手机号(必填)"]||!item["缴费项目(必填)"]||!item["缴费类型(必填)"]||!item["缴费大类(必填)"]||!item["缴费小类(必填)"]||!item["单价(必填)"]||!item["费用开始时间(必填)"]||!item["费用结束时间(必填)"]){
                    var compKeys=["小区名称(必填)","房间号(必填)","房屋面积(必填)","姓名(必填)","手机号(必填)","缴费项目(必填)","缴费类型(必填)","缴费大类(必填)","缴费小类(必填)","单价(必填)","费用开始时间(必填)","费用结束时间(必填)"];
                    for(var i in compKeys){
                        if(item[compKeys[i]]==undefined){
                            layer.alert("第 <span style='font-weight: bolder;'>"+(Number(index)+2)+"</span> 行 <span style='font-weight: bolder;'>"+compKeys[i]+"</span> 的值不能为空！",{title:"警告"});
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
                        roomArea:Number(item["房屋面积(必填)"]),
                        ownerName:item["姓名(必填)"],
                        ownerPhone:String(item["手机号(必填)"]),
                        idCardNo:item["身份证号"]?String(item["身份证号"]):"",
                        reservePhone:item["备用手机号"]?String(item["备用手机号"]):"",
                        costName:item["缴费项目(必填)"],
                        costType:item["缴费类型(必填)"],
                        costTypeClass:item["缴费大类(必填)"],
                        costTypeSection:item["缴费小类(必填)"],
                        unit:Number(item["单价(必填)"]),
                        beginTime:String(item["费用开始时间(必填)"]),
                        endTime:String(item["费用结束时间(必填)"]),
                    };
                    if(type=="park"){
                        if(item["车位号(必填)"]==undefined){
                            layer.alert("第 <span style='font-weight: bolder;'>"+(Number(index)+2)+"</span> 行 <span>车位号(必填)</span> 的值不能为空！",{title:"警告"});
                            flag=false;
                            break;
                        }else obj.carNo=String(item["车位号(必填)"]);
                    }else obj.carNo="";
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
                    if(res.code==200||res.code==500)layer.alert(res.msg,{title:res.code==200?"提示":"警告"});
                    else layer.alert("导入失败！",{title:"警告"});
                    queryVillage(type);
                },
                error: function(error){
                    layer.alert("导入失败！",{title:"警告"});
                }
            });
        }
    }
    /*动态设置table的高度*/
    window.onresize=function () {
        var domTable=$(".nav-tabs li.active").find("a").attr("href")+"Table";
        if(domTable!="#configTable"){
            $(domTable).bootstrapTable('resetView', {
                height: $(".content_bg_common").height()-110
            });
        }
    }
    /*
    * 单个或批量删除物业费、车位费
    * @type 若type值为undefined,则为单个删除；若type为false,则为批量删除物业费,若type为true,则为批量删除车位费
    * @data 单个删除时，data为删除的该条数据相关参数；批量删除时,data为table的id名
    * */
    function batchDelete(data,type) {
        var selectList=new Array();
        if(type==undefined)selectList.push(data.params);//这是单个删除
        else selectList=$(data).bootstrapTable('getSelections');//这是批量删除
        if(selectList.length==0){
            layer.alert("请至少选择一条记录！",{title:"警告"});
        }else{
            layer.confirm(type==undefined?"确定删除该条数据":"确定批量删除当前所选数据？", {
                btn: ['确定','取消'],
                title:"提示"
            }, function () {
                var params=selectList.map(function(item,index){
                    return {houseId:item.houseId,carId:item.carId,costId:item.costId};
                })
                $.ajax({
                    url: "/config/deleteImport",
                    type: "post",
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    data:JSON.stringify(params),
                    success: function(res){
                        if(res.code==200||res.code==500)layer.alert(res.msg,{title:res.code==200?"提示":"警告"});
                        else layer.alert("删除失败！",{title:"警告"});
                        queryProperty(type==undefined?data.dom:data,type==undefined?data.type:type);
                    },
                    error: function(error){
                        layer.alert("删除失败！",{title:"警告"});
                    }
                });
            },function () {});
        }
    }
</script>


