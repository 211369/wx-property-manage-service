<#include "/layout/header.ftl"/>
<div class="clearfix"></div>
<div class="row content_bg_common billManage">
    <div class="col-md-12 col-sm-12 col-xs-12">
        <form id="searchForm" class="col-md-11 col-sm-11 col-xs-11 form-horizontal form-label-left">
            <div class="item form-group col-md-2 _item">
                <label class="col-md-3 col-sm-3 control-label" for="village">小区:</label>
                <div class="col-md-9 col-sm-9 col-xs-12 items">
                    <select id="village" name="village" class="form-control">
                        <option value="">请选择</option>
                    </select>
                </div>
            </div>
            <div class="item form-group col-md-2 _item">
                <label class="col-md-3 col-sm-3 control-label" for="building">楼栋:</label>
                <div class="col-md-9 col-sm-9 col-xs-12 items">
                    <select id="building" name="building" class="form-control">
                        <option value='null'>请选择</option>
                    </select>
                </div>
            </div>
            <div class="item form-group col-md-2 _item">
                <label class="col-md-3 col-sm-3 control-label" for="location">单元:</label>
                <div class="col-md-9 col-sm-9 col-xs-12 items">
                    <select id="location" name="location" class="form-control">
                        <option value='null'>请选择</option>
                    </select>
                </div>
            </div>
            <div class="item form-group col-md-2 _item">
                <label class="col-md-3 col-sm-3 control-label" for="room">房屋:</label>
                <div class="col-md-9 col-sm-9 col-xs-12 items">
                    <select id="room" name="room" class="form-control">
                        <option value="">请选择</option>
                    </select>
                </div>
            </div>
            <div class="item form-group col-md-2 _item">
                <label class="col-md-4 col-sm-4 control-label" for="isExchange">兑换状态:</label>
                <div class="col-md-8 col-sm-8 col-xs-12 items">
                    <select id="isExchange" name="isExchange" class="form-control">
                        <option value="">请选择</option>
                        <option value="0">未兑换</option>
                        <option value="1">已兑换</option>
                    </select>
                </div>
            </div>
            <div class="item form-group col-md-2 _item">
                <label class="col-md-4 col-sm-4 control-label" for="receiptType">发票类型:</label>
                <div class="col-md-8 col-sm-8 col-xs-12 items">
                    <select id="receiptType" name="receiptType" class="form-control">
                        <option value="">请选择</option>
                        <option value="0">普票</option>
                        <option value="1">专票</option>
                    </select>
                </div>
            </div>
        </form>
        <div class="col-md-1 col-sm-1 col-xs-1" style="padding-top: 15px;">
            <div class="col-md-12 col-sm-12 col-xs-12">
                <button type="button" class="btn btn-sm btn-primary" onclick="searchBill()"><i class="glyphicon glyphicon-search"></i>查询</button>
            </div>
        </div>
        <table id="billTable"></table>
    </div>
</div>
<#--收据信息弹窗-->
<div class="modal fade" id="billModal" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop>
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="addroleLabel">修改兑换信息</h4>
            </div>
            <div class="modal-body configManageModalBody">
                <form id="updateBill" class="form-horizontal form-label-left" novalidate>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="orderId">凭据号: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="orderId" id="orderId" required="required" placeholder="请输入凭据号" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="house">房屋: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="house" id="house" required="required" placeholder="请输入房屋名称" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="ownerName">姓名: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="ownerName" id="ownerName" required="required" placeholder="请输入业主姓名" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="receiptType">发票类型: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <select name="receiptType" id="receiptType" class="form-control col-md-12 col-xs-12" required="required">
                                <option value>请选择</option>
                                <option value="0">普票</option>
                                <option value="1">专票</option>
                            </select>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="receiptCode">发票号: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="receiptCode" id="receiptCode" required="required" placeholder="请输入发票号" autocomplete="off"/>
                        </div>
                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary addOrUpdateBtn" onclick="updateBill()">保存</button>
            </div>
        </div>
    </div>
</div>
<#include "/layout/footer.ftl"/>
<script>
    $(function () {
        queryVillage("village");
        getBillList();
    })
    //获取换票记录列表
    function getBillList() {
        $("#billTable").bootstrapTable({
            url:'/bill/queryReceiptInfo',
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
                    field: 'ownerName',
                    title: '姓名',
                },{
                    field: 'ownerPhone',
                    title: '手机号',
                },{
                    field: 'receiptCode',
                    title: '发票号',
                },{
                    field: 'receiptType',
                    title: '发票类型',
                    formatter: function(code, row, index) {
                        if(code=="0") return "普票";
                        else if(code=="1") return "专票";
                        else return "";
                    }
                },{
                    field: 'isExchange',
                    title: '兑换状态',
                    formatter: function(code, row, index) {
                        if(code==0) return "未兑换";
                        else if(code==1) return "已兑换";
                        else return "";
                    }
                },{
                    field: 'receiptTime',
                    title: '兑换时间',
                },{
                    field: 'operate',
                    title: '操作',
                    formatter: function(code, row, index) {
                        return '<button class="btn btn-xs btn-primary" onclick="updateBillStatus(' + JSON.stringify(row).replace(/"/g, '&quot;') + ')"><i class="fa fa-edit"></i>编辑</button>';
                    }
                }
            ],
            height:$(".content_bg_common").height()-$("#searchForm").height()-15,
            queryParams: function(params){
                var formData=$('#searchForm').serializeArray();
                var param={
                    pageNumber:params.offset/params.limit +1,
                    pageSize:params.limit
                }
                formData.forEach(function(item,index){
                    if(item.name=="building"||item.name=="location"){
                        if(item.value!="null")param[item.name]=item.value;
                    }else{
                        if(item.value!=""){
                            if(item.name=="isExchange"||item.name=="receiptType")param[item.name]=Number(item.value);
                            else param[item.name]=item.value;
                        }
                    }
                })
                return param;
            },
            formatLoadingMessage: function(){
                return "正在加载中。。。";
            },
            responseHandler:function (res) {
                return{
                    "total":res.total,
                    "rows":res.list
                }
            },
        })
    }
    //点击查询按钮，查询收据列表
    function searchBill() {
        $("#billTable").bootstrapTable("refresh");
    }
    //点击编辑按钮，展示模态框
    function updateBillStatus(data) {
        Object.keys($("#updateBill").serializeObject()).forEach(function(item,index){
            $("#updateBill #"+item).val(data[item]);
            if(item!="receiptType"&&item!="receiptCode")$("#updateBill #"+item).attr("readonly", "readonly");
        })
        $("#billModal").modal('show');
    }
    //更新兑换信息
    function updateBill() {
        if(validator.checkAll($("#updateBill"))){
            var params={
                orderId:$("#updateBill #orderId").val(),
                receiptType:$("#updateBill #receiptType").val(),
                receiptCode:$("#updateBill #receiptCode").val()
            }
            $.ajax({
                url: "/bill/exchange",
                type: "post",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data:JSON.stringify(params),
                success: function(res){
                    if(res.code==200||res.code==500)layer.alert(res.msg,{title:res.code==200?"提示":"警告"});
                    else layer.alert("兑换失败！",{title:"警告"});
                    $("#billModal").modal('hide');
                    $("#billTable").bootstrapTable("refresh");
                },
                error: function(error){
                    $("#billModal").modal('hide');
                    layer.alert("兑换失败！",{title:"警告"});
                }
            });
        }
    }
    //关闭modal弹窗
    $('#billModal').on('hide.bs.modal',function() {
        $('#updateBill')[0].reset();
        $("#updateBill .form-group").removeClass("bad");
        $("#updateBill .form-group .alert").remove();
        $("#updateBill #orderId").removeAttr("readonly");
        $("#updateBill #house").removeAttr("readonly");
        $("#updateBill #ownerName").removeAttr("readonly");
        $("#updateBill #receiptType").removeAttr("readonly");
    })
    //动态设置业户列表table的高度
    window.onresize=function () {
        $("#billTable").bootstrapTable('resetView', {
            height:$(".content_bg_common").height()-$("#searchForm").height()-15,
        });
    }
</script>


