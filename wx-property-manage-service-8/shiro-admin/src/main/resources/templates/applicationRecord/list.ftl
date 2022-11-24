<#include "/layout/header.ftl"/>
<div class="clearfix"></div>
<div class="row content_bg_common applicationRecord">
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
                <label class="col-md-4 col-sm-4 control-label" for=" ">审批状态:</label>
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
                    <button type="button" class="btn btn-sm btn-primary" onclick="searchApplicationRecordList()"><i class="glyphicon glyphicon-search"></i>查询</button>
                </div>
                <div class="col-md-5 col-sm-5 col-xs-5">
                    <button type="button" class="btn btn-sm btn-primary" onclick="deleteApplication('true')"><i class="glyphicon glyphicon-search"></i>批量删除</button>
                </div>
            </div>
        </form>
        <table id="applicationRecordTable"></table>
    </div>
</div>
<#--点击编辑按钮时展示折扣申请-->
<div class="modal fade" id="applicationModal" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop>
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="addroleLabel">修改信息</h4>
            </div>
            <div class="modal-body">
                <form id="applicationModalForm" class="form-horizontal form-label-left" novalidate>
                    <div class="item form-group">
                        <label class="control-label col-md-4 col-sm-4 col-xs-12" for="house">房屋: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="house" id="house" readonly="readonly" required="required" placeholder="请输入房屋" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-4 col-sm-4 col-xs-12" for="ownerName">业主姓名: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="ownerName" id="ownerName" readonly="readonly" required="required" placeholder="请输入业主姓名" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-4 col-sm-4 col-xs-12" for="ownerPhone">手机号: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="ownerPhone" id="ownerPhone" readonly="readonly" required="required" placeholder="请输入业主手机号" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-4 col-sm-4 col-xs-12" for="applyUser">申请人: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="applyUser" id="applyUser" readonly="readonly" required="required" placeholder="请输入申请人" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-4 col-sm-4 col-xs-12" for="approveUser">审批人: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="approveUser" id="approveUser" readonly="readonly" required="required" placeholder="请输入审批人" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-4 col-sm-4 col-xs-12" for="discountRate">折率(单位:%):</label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="discountRate" id="discountRate" oninput="discountOrDiscountRateInput('#discountRate')" placeholder="请输入折率" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-4 col-sm-4 col-xs-12" for="discount">折扣金额(单位:元):</label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="discount" id="discount" oninput="discountOrDiscountRateInput('#discount')" placeholder="请输入折扣金额" autocomplete="off"/>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary agree">提交</button>
            </div>
        </div>
    </div>
</div>
<#--点击编辑按钮时展示退款审批-->
<div class="modal fade" id="refundApplicationModal" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop>
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="addroleLabel">修改信息</h4>
            </div>
            <div class="modal-body">
                <form id="refundApplicationModalForm" class="form-horizontal form-label-left" novalidate>
                    <div class="item form-group">
                        <label class="control-label col-md-4 col-sm-4 col-xs-12" for="house">房屋: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="house" id="house" readonly="readonly" required="required" placeholder="请输入房屋" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-4 col-sm-4 col-xs-12" for="ownerName">业主姓名: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="ownerName" id="ownerName" readonly="readonly" required="required" placeholder="请输入业主姓名" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-4 col-sm-4 col-xs-12" for="ownerPhone">手机号: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="ownerPhone" id="ownerPhone" readonly="readonly" required="required" placeholder="请输入业主手机号" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-4 col-sm-4 col-xs-12" for="costName">缴费项目: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="costName" id="costName" readonly="readonly" required="required" placeholder="请输入房屋" autocomplete="off"/>
                        </div>
                    </div>
                    <#if 1==0>
                    <div class="item form-group">
                        <label class="control-label col-md-4 col-sm-4 col-xs-12" for="costType">缴费类型: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="costType" id="costType" readonly="readonly" required="required" placeholder="请输入业主姓名" autocomplete="off"/>
                        </div>
                    </div>
                    </#if>
                    <div class="item form-group">
                        <label class="control-label col-md-4 col-sm-4 col-xs-12" for="pay">缴费金额(单位:元): <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="pay" id="pay" readonly="readonly" required="required" placeholder="请输入业主手机号" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-4 col-sm-4 col-xs-12" for="applyUser">申请人: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="applyUser" id="applyUser" readonly="readonly" required="required" placeholder="请输入申请人" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-4 col-sm-4 col-xs-12" for="approveUser">审批人: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="approveUser" id="approveUser" readonly="readonly" required="required" placeholder="请输入审批人" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-4 col-sm-4 col-xs-12" for="refundType">退款方式: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <select id="refundType" name="refundType" class="form-control">
                                <option>请选择</option>
                                <option value="原路退回">原路退回</option>
                             </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary agree">提交</button>
            </div>
        </div>
    </div>
</div>
<#include "/layout/footer.ftl"/>
<script>
    var mergeCellArr = new Array();//合并单元格使用
    $(function () {
        queryVillage("village");
        applicationRecordList();
    })
    /*获取折扣申请、退款审批记录*/
    function applicationRecordList() {
        $("#applicationRecordTable").bootstrapTable({
            url:"/approval/queryByPage",
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
                    field: 'orderId',
                    title: '订单号',
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
                        if(row.status=="审批中" && row.approvalType=="折扣申请") {
                            return '<button type="button" class="btn btn-sm btn-primary" onclick="showApplicationDetail(' + JSON.stringify(row).replace(/"/g, '&quot;') + ')">详情</button><button type="button" class="btn btn-sm btn-primary" onclick="showApplicationWindow(' + JSON.stringify(row).replace(/"/g, '&quot;') + ')">编辑</button><button type="button" class="btn btn-sm btn-danger" onclick="deleteApplication(' + JSON.stringify(row).replace(/"/g, '&quot;') + ')">删除</button>';
                        }else if(row.status=="审批中" && row.approvalType=="退款审批") {
                            return '<button type="button" class="btn btn-sm btn-primary" onclick="showRefundApplicationDetail(' + JSON.stringify(row).replace(/"/g, '&quot;') + ')">详情</button><button type="button" class="btn btn-sm btn-primary" onclick="showRefundApplicationWindow(' + JSON.stringify(row).replace(/"/g, '&quot;') + ')">编辑</button><button type="button" class="btn btn-sm btn-danger" onclick="deleteApplication(' + JSON.stringify(row).replace(/"/g, '&quot;') + ')">删除</button>';
                        }else return '<button type="button" class="btn btn-sm btn-primary" disabled>详情</button><button type="button" class="btn btn-sm btn-primary" disabled>编辑</button><button type="button" class="btn btn-sm btn-danger" disabled>删除</button>';
                    }
                }
            ],
            height:$(".content_bg_common").height()-$("#searchForm").height()-25,
            queryParams: function(param){
                var formData=$('#searchForm').serializeArray();
                var params={
                    pageNumber:param.offset/param.limit +1,
                    pageSize:param.limit,
                    applyUser:"${user.username}"
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
    function searchApplicationRecordList() {
        $("#applicationRecordTable").bootstrapTable("refresh");
    }
    //跳转押金台账
    function showApplicationDetail(data) {
        window.location.href="/depositManage?orderId="+data.orderId;
        var param={
            orderId:data.orderId,
        }
        getDepositList(param);
    }
    //跳转押金台账
    function showRefundApplicationDetail(data) {
    console.log(002);
    console.log(data,002);
        window.location.href="/chargeManage?village="+data.village+'&building='+data.building+'&location='+data.location+'&room='+data.room;
        setTimeout(() => {
            console.log(11111)
        },50000)
        console.log(222);
        var formData=$("#searchForm").serializeObject();
        formData.village=data.village;
        formData.building=data.building;
        formData.location=data.location;
        formData.room=data.room;
        console.log(1111);
        console.log(formData,005)
        // openPayOrPaid("paid")
        console.log(formData,006)
    }
    //展示折扣申请编辑弹窗
    function showApplicationWindow(data){
        console.log(data,4321)
        var formData=$("#applicationModalForm").serializeObject();
        Object.keys(formData).forEach(function (item, index) {
            $("#applicationModalForm #"+item).val(data[item]);
        })
        $("#applicationModal .agree").unbind("click").bind("click",function () {
            var params={
                id:data.id,
                houseId:data.houseId,
                orderId:data.orderId,
                discount:$("#applicationModalForm #discount").val(),
                discountRate:$("#applicationModalForm #discountRate").val()
            }
            if(Number(params.discount)==0&&Number(params.discountRate)==0){
                layer.alert("折扣金额和折率不能同时为空或为0！",{title:"警告"});
                return;
            }
            $.ajax({
                url: "/approval/updateDiscount",
                type: "post",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data:JSON.stringify(params),
                success: function(res){
                    if(res.code==200)layer.alert(res.msg,{title:"提示"});
                    else if(res.code==500)layer.alert(res.msg,{title:"警告"});
                    else layer.alert("操作失败",{title:"警告"});
                    $("#applicationRecordTable").bootstrapTable("refresh");
                    $("#applicationModal").modal("hide");
                },
                error: function(error){
                    layer.alert("操作失败",{title:"警告"});
                    $("#applicationRecordTable").bootstrapTable("refresh");
                    $("#applicationModal").modal("hide");
                }
            });
        })
        $("#applicationModal").modal("show");
    }
    //展示退款审批编辑弹窗
    function showRefundApplicationWindow(data){
        console.log(data,999)
        var formData=$("#refundApplicationModalForm").serializeObject();
        Object.keys(formData).forEach(function (item, index) {
            $("#refundApplicationModalForm #"+item).val(data[item]);
            $("#refundApplicationModalForm #refundType").val(data.refundType);
        })
        $("#refundApplicationModal .agree").unbind("click").bind("click",function () {
            var params={
                id:data.id,
                houseId:data.houseId,
                orderId:data.orderId,
                refundType :$("#refundApplicationModalForm #refundType").val(),
            }
            $.ajax({
                url: "/approval/updateRefundType",
                type: "post",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data:JSON.stringify(params),
                success: function(res){
                    if(res.code==200)layer.alert(res.msg,{title:"提示"});
                    else if(res.code==500)layer.alert(res.msg,{title:"警告"});
                    else layer.alert("操作失败",{title:"警告"});
                    $("#applicationRecordTable").bootstrapTable("refresh");
                    $("#refundApplicationModal").modal("hide");
                },
                error: function(error){
                    layer.alert("操作失败",{title:"警告"});
                    $("#applicationRecordTable").bootstrapTable("refresh");
                    $("#refundApplicationModal").modal("hide");
                }
            });
        })
        $("#refundApplicationModal").modal("show");
    }
    //变价弹窗中的折扣金额和折率改变
    function discountOrDiscountRateInput(domId) {
        var val=$("#applicationModalForm "+domId).val();
        if(isNaN(val)==true){
            $("#applicationModalForm "+domId).val("");
        }else if(Number(val)==0&&val!=""&&val.indexOf(".")==-1){
            $("#applicationModalForm "+domId).val(0);
        }else{
            if(domId=="#discountRate"){
                if(Number(val)>100){
                    $("#applicationModalForm "+domId).val(100);
                }
            }
            var indexStr=val.indexOf(".");
            if(indexStr!=-1&&(val.length-1-indexStr>2)){
                $("#applicationModalForm "+domId).val(val.slice(0,indexStr+3));
            }
        }
    }
    /**
     * 单个或批量删除
     * @param {String、Object} data data值为"true"则批量删除，否则单个删除
     * */
    function deleteApplication(data){
        var arr=new Array();
        if(data=="true"){
            var checkList=$("#applicationRecordTable").bootstrapTable('getSelections');
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
                url: "approval/delete",
                type: "post",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data:JSON.stringify(arr),
                success: function(res){
                    if(res.code==200||res.code==500)layer.alert(res.msg,{title:res.code==200?"提示":"警告"});
                    else layer.alert("删除失败！",{title:"警告"});
                    $("#applicationRecordTable").bootstrapTable("refresh");
                },
                error: function(error){
                    layer.alert("删除失败！",{title:"警告"});
                    $("#applicationRecordTable").bootstrapTable("refresh");
                }
            });
        },function () {});
    }
    //动态设置业户列表table的高度
    window.onresize=function () {
        $("#applicationRecordTable").bootstrapTable('resetView', {
            height:$(".content_bg_common").height()-$("#searchForm").height()-25,
        });
    }
</script>


