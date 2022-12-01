<#include "/layout/header.ftl"/>
<div class="clearfix"></div>
<div class="row content_bg_common depositManage">
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
                <label class="col-md-4 col-sm-4 control-label" for="refundFlag">退款状态:</label>
                <div class="col-md-8 col-sm-8 col-xs-12 items">
                    <select id="refundFlag" name="refundFlag" class="form-control">
                        <option value="9">请选择</option>
                        <option value="0">未退款</option>
                        <option value="1">已退款</option>
                    </select>
                </div>
            </div>
            <div class="item form-group col-md-2 _item">
                <label class="col-md-3 col-sm-3 control-label" for="ownerName">姓名:</label>
                <div class="col-md-9 col-sm-9 col-xs-12 items">
                    <input type="text" class="form-control col-md-12 col-xs-12" name="ownerName" id="ownerName" placeholder="请输入姓名" autocomplete="off"/>
                </div>
            </div>
        </form>
        <div class="col-md-1 col-sm-1 col-xs-1" style="padding-top: 15px;">
            <div class="col-md-12 col-sm-12 col-xs-12">
                <button type="button" class="btn btn-sm btn-primary" onclick="getDepositList()"><i class="glyphicon glyphicon-search"></i>查询</button>
            </div>
        </div>
        <table id="depositTable"></table>
    </div>
</div>
<#--退款-->
<div class="depositRefund">
    <div class="refundWindow">
        <div class="refund_info">
            <table id="tableRefund"></table>
        </div>
        <div class="refund_button">
            <button class="btn btn-default" onclick="closeRefund()">取消</button>
            <button class="btn btn-primary" onclick="handleRefund()">退款</button>
        </div>
    </div>
</div>

<#--点击退款审批按钮时展示-->
<div class="modal fade" id="approvalModal" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop>
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="addroleLabel">退款审批发起</h4>
            </div>
            <div class="modal-body configManageModalBody">
                <form id="approvalModalForm" class="form-horizontal form-label-left" novalidate>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="house">房屋: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="house" id="house" readonly="readonly" required="required" placeholder="请输入房屋" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="ownerName">业主姓名: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="ownerName" id="ownerName" readonly="readonly" required="required" placeholder="请输入业主姓名" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="ownerPhone">手机号: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="ownerPhone" id="ownerPhone" readonly="readonly" required="required" placeholder="请输入业主手机号" autocomplete="off"/>
                        </div>
                    </div>

                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="costName">缴费项目: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="costName" id="costName" readonly="readonly" required="required" placeholder="请输入房屋" autocomplete="off"/>
                        </div>
                    </div>
                    <#if 1==0>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="costType">缴费类型: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="costType" id="costType" readonly="readonly" required="required" placeholder="请输入业主姓名" autocomplete="off"/>
                        </div>
                    </div>
                    </#if>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="pay">缴费金额(单位:元): <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="pay" id="pay" readonly="readonly" required="required" placeholder="请输入业主手机号" autocomplete="off"/>
                        </div>
                    </div>

                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="applyUser">申请人: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="applyUser" id="applyUser" readonly="readonly" required="required" placeholder="请输入申请人" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="approveUser">审批人: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <select id="approveUser" name="approveUser" class="form-control">
                                <option>请选择</option>
                            </select>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="refundType">退款方式: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <select id="refundType" name="refundType" class="form-control" onchange="charge()">
                                <option>请选择</option>
                                <option value="0">原路退回</option>

                            </select>
                        </div>
                    </div>
                    <div class="item form-group" id="refundAcctHide" style="display:none">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="refundAcct">退款到账账号: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="refundAcct" id="refundAcct" required="required" placeholder="请输入退款到账账号" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group" id="acctNameHide" style="display:none">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="acctName">户名: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="acctName" id="acctName" required="required" placeholder="请输入申请人" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group" id="bankHide" style="display:none">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="bank">银行: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="bank" id="bank" required="required" placeholder="请输入银行" autocomplete="off"/>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary depositRefundApplySure">提交</button>
            </div>
        </div>
    </div>
</div>

<#include "/layout/footer.ftl"/>
<script>
    $(function () {
        queryVillage("village");
        getDepositList();
        //approveUserList();
    })
    //获取押金台账
    function getDepositList() {
        $("#depositTable").bootstrapTable('destroy').bootstrapTable({
            url:'/charge/queryRefundList',
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
                    field: 'costName',
                    title: '缴费项目',
                },{
                    field: 'costType',
                    title: '缴费类型',
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
                    field: 'refundPay',
                    title: '退款金额(单位:元)',
                    visible: $("#refundFlag").val()==1?true:false,
                },{
                    field: 'payType',
                    title: '支付方式',
                },{
                    field: 'refundFlag',
                    title: '退款状态',
                    formatter: function(code, row, index) {
                        if(code==0 | code==null) return "未退款";
                        else if(code==1) return "已退款";
                        else return "";
                    }
                },{
                    field: 'payTime',
                    title: $("#refundFlag").val()==1?"退款时间":"缴费时间",
                },{
                    field: 'refundType',
                    title: '退款方式',
                    visible: $("#refundFlag").val()==1?true:false,
                },{
                    field: 'status',
                    title: '审批状态',
                    cellStyle : function cellStyle(value, row, index) {
                        if(value=="审批通过")var color="green";
                        else if(value=="审批拒绝")var color="red";
                        else if(value=="审批中")var color="orange";
                        else var color="black";
                        return {
                            css : {
                                "color" : color
                            }
                        };
                    }
                },{
                    field: 'operate',
                    title: '操作',
                    //visible: $("#billType").val()==0?true:false,
                    formatter: function(code, row, index) {
                        //if(row.payType=="线上支付" && row.billType==0)return '<@shiro.hasPermission name="charge:refund"><button class="btn btn-xs btn-danger" onclick="depositRefundApply(' + JSON.stringify(row).replace(/"/g, '&quot;') + ')"><i class="fa fa-edit"></i>退款审批</button></@shiro.hasPermission>';
                        //else if(row.payType=="线上支付" && row.billType==3 && row.refundType=="原路退回")return '<@shiro.hasPermission name="charge:refund"><button class="btn btn-xs btn-danger" onclick="handleDepositRefund(' + JSON.stringify(row).replace(/"/g, '&quot;') + ')"><i class="fa fa-edit"></i>退款</button></@shiro.hasPermission>';
                        //else return '';
                        if(row.payType=="线上支付" && row.billType==0 && (row.status=='' | row.status=='审批拒绝'))return '<@shiro.hasPermission name="charge:refund"><button class="btn btn-xs btn-danger" onclick="depositRefundApply(' + JSON.stringify(row).replace(/"/g, '&quot;') + ')"><i class="fa fa-edit"></i>退款审批</button></@shiro.hasPermission>';
                        else return '';                    }
                }
            ],
            height:$(".content_bg_common").height()-$("#searchForm").height()-10,
            queryParams: function(params){
                var formData=$('#searchForm').serializeArray();
                var param={
                    orderId:params.orderId,
                    pageNumber:params.offset/params.limit +1,
                    pageSize:params.limit
                }
                formData.forEach(function(item,index){
                    if(item.name=="building"||item.name=="location"){
                        if(item.value!="null")param[item.name]=item.value;
                    }else{
                        if(item.value!=""){
                            if(item.name=="billType")param[item.name]=Number(item.value);
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
                var list=res.list.map(function (item, index) {
                    item.house=item.village+item.building+item.location+item.room;
                    item.refundPay=item.pay;
                    //处理支付方式
                    if(item.payType==0)item.payType="线上支付";
                    if(item.payType==1)item.payType="现金支付";
                    if(item.payType==2)item.payType="刷卡支付";
                    if(item.payType==3)item.payType="混合支付";
                    //处理审批状态
                    if(item.status==0)item.status="审批中";
                    else if(item.status==1)item.status="审批通过";
                    else if(item.status==2)item.status="审批拒绝";
                    else item.status="";
                    return item;
                })
                return{
                    "total":res.total,
                    "rows":list
                }
            },
        })
    }
    //点击退款按钮，进入退款页面
    function handleDepositRefund(data) {
        var list=new Array(data);
        console.log(data.payType,11)
        $("#tableRefund").bootstrapTable("destroy").bootstrapTable({
            data:list,
            columns:[
                {
                    field: 'costName',
                    title: '缴费项目',
                },{
                    field: 'costType',
                    title: '缴费类型',
                },{
                    field: 'payTime',
                    title: '缴费时间',
                },{
                    field: 'unit',
                    title: '单价(单位:元)',
                },{
                    field: 'pay',
                    title: '退款金额(单位:元)',
                }
            ],
            pagination: false,
        })
        $('.depositRefund').css('display', 'block');
    }

    //点击退款按钮，提交退款
    function handleRefund() {
        layer.confirm("确定将该项押金进行退款?",{
            btn: ['确定','取消'],
            title:"提示"
        }, function () {
            var reFundList=$('#tableRefund').bootstrapTable('getData');
            var obj={
                costId:reFundList[0].costId,
                costName:reFundList[0].costName,
                costType:reFundList[0].costType,
                costTypeClass:"",
                costTypeSection:"",
                beginTime:"",
                endTime:"",
                unit:reFundList[0].unit,
                pay:Number(reFundList[0].pay),
            }
            var params={
                orderId:reFundList[0].orderId,
                houseId:reFundList[0].houseId,
                paySum:reFundList[0].pay,
                billItemList:new Array(obj)
            }
            $.ajax({
                url: "/charge/refund",
                type: "post",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data:JSON.stringify(params),
                success: function(res){
                    if(res.code==200||res.code==500){
                        layer.alert(res.msg,{title:res.code==200?"提示":"警告"});
                    }else layer.alert("退款失败！",{title:"警告"});
                    $('.depositRefund').css('display', 'none');
                    getDepositList();
                },
                error: function(error){
                    layer.alert("退款失败！",{title:"警告"});
                    $('.depositRefund').css('display', 'none');
                    getDepositList();
                }
            });
        },function () {});
    }

    function charge() {
        var refund = $("#approvalModalForm #refundType").val();
        if(refund!=="1"){
            refundAcctHide.style.display='none';
            acctNameHide.style.display='none';
            bankHide.style.display='none';
        }else{
            refundAcctHide.style.display='block';
            acctNameHide.style.display='block';
            bankHide.style.display='block';
        }
    }

    //点击退款审批按钮，发起退款审批
    function depositRefundApply(data) {
        console.log(12)
        approveUserList(data);
        $("#approvalModalForm #house").val(data.house);
        $("#approvalModalForm #ownerName").val(data.ownerName);
        $("#approvalModalForm #ownerPhone").val(data.ownerPhone);
        $("#approvalModalForm #costName").val(data.costName);
        $("#approvalModalForm #costType").val(data.costType);
        $("#approvalModalForm #pay").val(data.pay);
        $("#approvalModalForm #applyUser").val("${user.username}");
        $("#approvalModalForm #refundAcct").val(data.refundAcct);
        $("#approvalModalForm #acctName").val(data.acctName);
        $("#approvalModalForm #bank").val(data.bank);
        $('#approvalModal').modal('show');
        $("#approvalModal .depositRefundApplySure").unbind("click").bind("click",function () {
            var params={
                id:data.costId,
                orderId:data.orderId,
                costId:data.costId,
                houseId:data.houseId,
                applyUser:"${user.username}",
                refundType:$("#approvalModalForm #refundType").val(),
                refundAcct:$("#approvalModalForm #refundAcct").val(),
                acctName:$("#approvalModalForm #acctName").val(),
                bank:$("#approvalModalForm #bank").val(),
                approveUser:$("#approvalModalForm #approveUser").val(),
                costName:$("#approvalModalForm #costName").val(),
                costType:$("#approvalModalForm #costType").val(),
                pay:$("#approvalModalForm #pay").val(),
            };
            if(params.approveUser=="请选择"||!params.approveUser){
                layer.alert("请选择审批人",{title:"警告"});
                return;
            }
            if(params.refundType=="请选择"||!params.refundType){
                layer.alert("请选择退款方式",{title:"警告"});
                return;
            }
            $.ajax({
                url: "/approval/addRefundApply",
                type: "post",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data:JSON.stringify(params),
                success: function(res){
                    if(res.code==200||res.code==500){
                        layer.alert(res.msg,{title:res.code==200?"提示":"警告"});
                    }else layer.alert("！",{title:"警告"});
                    $('#approvalModal').modal('hide');
                    getDepositList();
                },
                error: function(error){
                    layer.alert("申请失败！",{title:"警告"});
                    $('#approvalModal').modal('hide');
                }
            });
        })
    }

    //查询用户列表，退款审批发起中的审批人使用
    function approveUserList(data) {
        var param={
            village:data.village
        };
        $.ajax({
            url: "/approval/listUsers",
            type: "post",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            data:JSON.stringify(param),
            success: function(res){
                if(res&&res.length!=0){
                    var str="";
                    res.forEach(function (item,index) {
                        str+="<option value='"+item.username+"'>"+item.nickname+"</option>";
                    })

                    $("#approvalModalForm #approveUser").html("<option value='请选择'>请选择</option>");
                    $("#approvalModalForm #approveUser").val("请选择");
                    $("#approvalModalForm #approveUser").append(str);
                    console.log($("#approvalModalForm #approveUser").val("请选择"));
                }
            },
            error: function(error){}
        });
    }

    //退款审批发起弹窗关闭
    $('#approvalModal').on('hide.bs.modal', function () {
        $("#approvalModalForm #approveUser").val("请选择");
        $("#approvalModalForm #refundType").val("请选择");
        $("#approvalModalForm #discount").val("");
        $("#approvalModalForm #discountRate").val("");
        refundAcctHide.style.display='none';
        acctNameHide.style.display='none';
        bankHide.style.display='none';
    })

    //关闭退款页面
    function closeRefund() {
        $('.depositRefund').css('display', 'none')
    }
    //动态设置业户列表table的高度
    window.onresize=function () {
        $("#depositTable").bootstrapTable('resetView', {
            height:$(".content_bg_common").height()-$("#searchForm").height()-10,
        });
    }
</script>


