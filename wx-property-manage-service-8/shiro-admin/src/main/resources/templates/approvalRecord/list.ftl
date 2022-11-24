<#include "/layout/header.ftl"/>
<div class="clearfix"></div>
<div class="row content_bg_common approvalRecord">
    <div class="col-md-12 col-sm-12 col-xs-12">
        <form id="searchForm" class="col-md-12 col-sm-12 col-xs-12 form-horizontal form-label-left">
            <div class="item form-group col-md-2 col-sm-2">
                <label class="col-md-3 col-sm-3 control-label" for="village">小区:</label>
                <div class="col-md-9 col-sm-9 col-xs-12">
                    <select id="village" name="village" class="form-control">
                        <option value="">请选择</option>
                    </select>
                </div>
            </div>
            <div class="item form-group col-md-2 col-sm-2">
                <label class="col-md-3 col-sm-3 control-label" for="building">楼栋:</label>
                <div class="col-md-9 col-sm-9 col-xs-12">
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
                <label class="col-md-4 col-sm-4 control-label" for="status">审批状态:</label>
                <div class="col-md-8 col-sm-8 col-xs-12">
                    <select id="status" name="status" class="form-control">
                        <option value='null'>请选择</option>
                        <option value="0">审批中</option>
                        <option value="1">审批通过</option>
                        <option value="2">审批拒绝</option>
                    </select>
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
                    <button type="button" class="btn btn-sm btn-primary" onclick="searchApprovalRecordList()"><i class="glyphicon glyphicon-search"></i>查询</button>
                </div>
                <div class="col-md-5 col-sm-5 col-xs-5">
                    <button type="button" class="btn btn-sm btn-primary" onclick="deleteApproval('true')"><i class="glyphicon glyphicon-search"></i>批量删除</button>
                </div>
            </div>
        </form>
        <table id="approvalRecordTable"></table>
    </div>
</div>
<#--点击折扣申请审批按钮时展示，进行审批通过和拒绝的操作-->
<div class="modal fade" id="approvalModal" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop>
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="addroleLabel">审批</h4>
            </div>
            <div class="modal-body configManageModalBody">
                <form id="approvalModalForm" class="form-horizontal form-label-left" novalidate>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="house">房屋:</label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="house" id="house" readonly="readonly" placeholder="请输入房屋" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="ownerName">业主姓名:</label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="ownerName" id="ownerName" readonly="readonly" placeholder="请输入业主姓名" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="ownerPhone">手机号:</label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="ownerPhone" id="ownerPhone" readonly="readonly" placeholder="请输入业主手机号" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="applyUser">申请人:</label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="applyUser" id="applyUser" readonly="readonly" placeholder="请输入申请人" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="approveUser">审批人:</label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="approveUser" id="approveUser" readonly="readonly" placeholder="请输入审批人" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="discountRate">折率(单位:%):</label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="discountRate" id="discountRate" readonly="readonly" placeholder="请输入折率" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="discount">折扣金额(单位:元):</label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="discount" id="discount" readonly="readonly" placeholder="请输入折扣金额" autocomplete="off"/>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary approvalAgreeOrRefuse" data-type="1">同意</button>
                <button type="button" class="btn btn-danger approvalAgreeOrRefuse" data-type="2">拒绝</button>
            </div>
        </div>
    </div>
</div>
<#--点击退款审批审批按钮时展示，进行审批通过和拒绝的操作-->
<div class="modal fade" id="refundApprovalModal" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop>
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="addroleLabel">审批</h4>
            </div>
            <div class="modal-body configManageModalBody">
                <form id="refundApprovalModalForm" class="form-horizontal form-label-left" novalidate>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="house">房屋:</label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="house" id="house" readonly="readonly" placeholder="请输入房屋" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="ownerName">业主姓名:</label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="ownerName" id="ownerName" readonly="readonly" placeholder="请输入业主姓名" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="ownerPhone">手机号:</label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="ownerPhone" id="ownerPhone" readonly="readonly" placeholder="请输入业主手机号" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="costName">缴费项目: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="costName" id="costName" readonly="readonly" required="required" placeholder="请输入业主姓名" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="pay">缴费金额(单位:元): <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="pay" id="pay" readonly="readonly" required="required" placeholder="请输入业主手机号" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="applyUser">申请人:</label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="applyUser" id="applyUser" readonly="readonly" placeholder="请输入申请人" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="approveUser">审批人:</label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="approveUser" id="approveUser" readonly="readonly" placeholder="请输入审批人" autocomplete="off"/>
                        </div>
                    </div>
                    <#if (1==0)>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="discountRate">折率(单位:%):</label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="discountRate" id="discountRate" readonly="readonly" placeholder="请输入折率" autocomplete="off"/>
                        </div>
                    </div>
                    </#if>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="refundType">退款方式: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="refundType" id="refundType" readonly="readonly" required="required" placeholder="请选择退款方式" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="remark">审批意见:</label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="remark" id="remark" placeholder="请输入审批意见" autocomplete="off"/>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary approvalAgreeOrRefuse" data-type="1">同意</button>
                <button type="button" class="btn btn-danger approvalAgreeOrRefuse" data-type="2">拒绝</button>
            </div>
        </div>
    </div>
</div>
<#include "/layout/footer.ftl"/>
<script>
    var mergeCellArr = new Array();//合并单元格使用
    $(function () {
        queryVillage("village");
        approvalRecordList();
    })
    /*获取折扣审批记录*/
    function approvalRecordList() {
        $("#approvalRecordTable").bootstrapTable({
            url:"/approval/queryApproval",
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
                    checkbox: true,
                    formatter: function(value, row, index) {
                        if(row.status ==="审批中"){
                            return { disabled : false}
                        }else{
                            return { disabled : true}
                        }
                    }
                },{
                    field: 'approvalType',
                    title: '审批类型',
                },{
                    field: 'house',
                    title: '房屋',
                },{
                    field: 'ownerName',
                    title: '业户姓名',
                },{
                    field: 'ownerPhone',
                    title: '手机号',
                },{
                    field: 'applyUser',
                    title: '申请人',
                },{
                    field: 'approveUser',
                    title: '审批人',
                },{
                    field: 'status',
                    title: '审批状态',
                    cellStyle : function cellStyle(value, row, index) {
                        if(value=="审批通过")var color="green";
                        else if(value=="审批拒绝")var color="red";
                        else var color="orange";
                        return {
                            css : {
                                "color" : color
                            }
                        };
                    }
                },{
                    field: 'remark',
                    title: '审批意见',
                },{
                    field: 'operate',
                    title: '操作',
                    formatter:function (code, row, index) {
                        console.log(row,1)
                        if(row.status=="审批中" && row.approvalType=="折扣申请")return '<button type="button" class="btn btn-sm btn-primary" onclick="showApprovalWindow(' + JSON.stringify(row).replace(/"/g, '&quot;') + ')">审批</button><button type="button" class="btn btn-sm btn-danger" onclick="deleteApproval(' + JSON.stringify(row).replace(/"/g, '&quot;') + ')">删除</button>';
                        else if(row.status=="审批中" && row.approvalType=="退款审批")return '<button type="button" class="btn btn-sm btn-primary" onclick="showRefundApprovalWindow(' + JSON.stringify(row).replace(/"/g, '&quot;') + ')">审批</button><button type="button" class="btn btn-sm btn-danger" onclick="deleteApproval(' + JSON.stringify(row).replace(/"/g, '&quot;') + ')">删除</button>';
                        else return '<button type="button" class="btn btn-sm btn-primary" disabled>审批</button><button type="button" class="btn btn-sm btn-danger" disabled>删除</button>';

                    }
                }
            ],
            height:$(".content_bg_common").height()-$("#searchForm").height()-25,
            queryParams: function(param){
                var formData=$('#searchForm').serializeArray();
                var params={
                    pageNumber:param.offset/param.limit +1,
                    pageSize:param.limit,
                    approveUser:"${user.username}"
                };
                formData.forEach(function (item,index) {
                    if(item.name=="building"||item.name=="location"){
                        if(item.value==""||(item.value&&item.value!="null"))params[item.name]=item.value;
                    }else{
                        if(item.value)params[item.name]=(item.name=="status"?Number(item.value):item.value);
                    }
                })
                return params;
            },
            formatLoadingMessage: function(){
                return "正在加载中。。。";
            },
            responseHandler:function (res) {
                var list=new Array();
                if(res&&res.list&&res.list.length!=0){
                    list=res.list.map(function (item,index) {
                        //处理房屋
                        item.house=item.village+item.building+item.location+item.room;
                        //处理审批状态
                        if(item.status==0)item.status="审批中";
                        else if(item.status==1)item.status="审批通过";
                        else if(item.status==2)item.status="审批拒绝";
                        else item.status="";
                        return item;
                    })
                }
                return{
                    "total":res.total,
                    "rows":res.list
                }
            }
        })
    }
    //点击查询按钮
    function searchApprovalRecordList() {
        $("#approvalRecordTable").bootstrapTable("refresh");
    }
    //展示审批弹窗
    function showApprovalWindow(data){
        var formData=$("#approvalModalForm").serializeObject();
        Object.keys(formData).forEach(function (item, index) {
            $("#approvalModalForm #"+item).val(data[item]);
        })
        $("#approvalModal .approvalAgreeOrRefuse").unbind("click").bind("click",function () {
            var params={
                id:data.id,
                houseId:data.houseId,
                orderId:data.orderId,
                applyUser:data.applyUser,
                discount:data.discount,
                discountRate:data.discountRate,
                approveUser:data.approveUser,
                approvalType:data.approvalType,
                status:Number($(this).attr("data-type"))
            }
            $.ajax({
                url: "/approval/update",
                type: "post",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data:JSON.stringify(params),
                success: function(res){
                    if(res.code==200)layer.alert(res.msg,{title:"提示"});
                    else if(res.code==500)layer.alert(res.msg,{title:"警告"});
                    else layer.alert("操作失败",{title:"警告"});
                    $("#approvalRecordTable").bootstrapTable("refresh");
                    $("#approvalModal").modal("hide");
                },
                error: function(error){
                    layer.alert("操作失败",{title:"警告"});
                    $("#approvalRecordTable").bootstrapTable("refresh");
                    $("#approvalModal").modal("hide");
                }
            });
        })
        $("#approvalModal").modal("show");
    }

    //展示审批弹窗
    function showRefundApprovalWindow(data){
        var formData=$("#refundApprovalModalForm").serializeObject();
        Object.keys(formData).forEach(function (item, index) {
            $("#refundApprovalModalForm #"+item).val(data[item]);
        })
        $("#refundApprovalModal .approvalAgreeOrRefuse").unbind("click").bind("click",function () {
            var params={
                id:data.id,
                refundId:data.refundId,
                houseId:data.houseId,
                orderId:data.orderId,
                costId:data.costId,
                applyUser:data.applyUser,
                refundType:data.refundType,
                approvalType:data.approvalType,
                approveUser:data.approveUser,
                remark:$("#refundApprovalModalForm #remark").val(),
                status:Number($(this).attr("data-type"))
            }
            $.ajax({
                url: "/approval/update",
                type: "post",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data:JSON.stringify(params),
                success: function(res){
                    if(res.code==200)layer.alert(res.msg,{title:"提示"});
                    else if(res.code==500)layer.alert(res.msg,{title:"警告"});
                    else layer.alert("操作失败",{title:"警告"});
                    $("#approvalRecordTable").bootstrapTable("refresh");
                    $("#refundApprovalModal").modal("hide");
                },
                error: function(error){
                    layer.alert("操作失败",{title:"警告"});
                    $("#approvalRecordTable").bootstrapTable("refresh");
                    $("#refundApprovalModal").modal("hide");
                }
            });
        })
        $("#refundApprovalModal").modal("show");
    }

    /**
     * 单个或批量删除
     * @param {String、Object} data data值为"true"则批量删除，否则单个删除
     * */
    function deleteApproval(data){
        var arr=new Array();
        if(data=="true"){
            var checkList=$("#approvalRecordTable").bootstrapTable('getSelections');
            if(checkList.length==0){
                layer.alert("请至少选择一条记录！",{title:"警告"});
                return;
            }else{
                checkList.forEach(function (item,index) {
                    arr.push(item.id);
                })
            }
        }else arr.push(data.id);
        layer.confirm(data=="true"?"确定批量删除当前所选数据？":"确定删除该条数据?", {
            btn: ['确定','取消'],
            title:"提示"
        }, function () {
            $.ajax({
                url: "/approval/delete",
                type: "post",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data:JSON.stringify(arr),
                success: function(res){
                    if(res.code==200||res.code==500)layer.alert(res.msg,{title:res.code==200?"提示":"警告"});
                    else layer.alert("删除失败！",{title:"警告"});
                    $("#approvalRecordTable").bootstrapTable("refresh");
                },
                error: function(error){
                    layer.alert("删除失败！",{title:"警告"});
                    $("#approvalRecordTable").bootstrapTable("refresh");
                }
            });
        },function () {});
    }
    //动态设置业户列表table的高度
    window.onresize=function () {
        $("#approvalRecordTable").bootstrapTable('resetView', {
            height:$(".content_bg_common").height()-$("#searchForm").height()-25,
        });
    }
</script>