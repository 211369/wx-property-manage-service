<#include "/layout/header.ftl"/>
<div class="clearfix"></div>
<div class="row content_bg_common">
    <div class="charge_manage">
        <div class="main">
            <form id="searchForm" class="form-horizontal form-label-left" style="width:50%;margin: 0 auto">
                <div class="item form-group">
                    <label class="col-md-3 col-sm-3 control-label" for="village">请选择小区:</label>
                    <div class="col-md-7 col-sm-7 col-xs-12 items">
                        <select id="village" name="village" class="form-control">
                            <option value="">请选择</option>
                        </select>
                    </div>
                </div>
                <div class="item form-group">
                    <label class="col-md-3 col-sm-3 control-label" for="building">请选择楼栋:</label>
                    <div class="col-md-7 col-sm-7 col-xs-12 items">
                        <select id="building" name="building" class="form-control">
                            <option value='null'>请选择</option>
                        </select>
                    </div>
                </div>
                <div class="item form-group">
                    <label class="col-md-3 col-sm-3 control-label" for="location">请选择单元:</label>
                    <div class="col-md-7 col-sm-7 col-xs-12 items">
                        <select id="location" name="location" class="form-control">
                            <option value='null'>请选择</option>
                        </select>
                    </div>
                </div>
                <div class="item form-group">
                    <label class="col-md-3 col-sm-3 control-label" for="room">请选择房屋:</label>
                    <div class="col-md-7 col-sm-7 col-xs-12 items">
                        <select id="room" name="room" class="form-control">
                            <option value="">请选择</option>
                        </select>
                    </div>
                </div>
            </form>
            <div class="entrance">
                <button class="btn btn-primary" type="button" onclick="openPayOrPaid('pay')" style="width: 80px;">
                    收   费
                </button>
                <button class="btn btn-primary" type="button" onclick="openPayOrPaid('paid')">
                    已缴明细
                </button>
            </div>
        </div>
        <div class="payPart">
            <div class="pay_title">
                <div class="charge_info"></div>
                <div>缴费截止时间
                    <select id="selectYear" class="form-control"></select>
                    <span class="glyphicon glyphicon-info-sign" id="payMsg" data-toggle="modal" data-target="#payMsgModal"></span>
                    <button class="btn btn-primary btn-sm return_main" onclick="returnMain()" type="button">返回</button>
                    <button class="btn btn-primary btn-sm return_main bindDepositOrDisposable" type="button" onclick="bindDepositOrDisposable()">绑定业务</button>
                    <button class="btn btn-primary btn-sm return_main discountApply" type="button" onclick="discountApply()">折扣申请</button>
                </div>
            </div>
            <div class="table">
                <table id="table"></table>
            </div>
            <div class="showBtn">
                <div class="payAllBtn">
                    <div class="showTotal">
                        <div>合计金额：</div>
                        <div class="showMoney"><span id="sumMoney">0.00</span>元</div>
                    </div>
                    <div class="payMoney">
                        <button onclick="showPayType()" class="btn btn-primary payBtn">缴费</button>
                        <button onclick="notCountSmall()" class="btn btn-primary payBtn">抹零</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="paidPart">
            <div class="paid_title">
                <span class="charge_info"></span>
                <button class="btn btn-primary btn-sm return_main" onclick="returnMain()" type="button">返回</button>
            </div>
            <div class="table">
                <table id="billTable"></table>
            </div>
        </div>
    </div>
</div>
<#--支付页面-->
<div class="charge_manage_paySelf">
    <div class="payWindow">
        <div class="payWindow_title">选择支付方式</div>
        <div class="payIcon">
            <img src="/assets/images/phone.png">
            <img src="/assets/images/card.png">
            <img src="/assets/images/cash.png">
            <img src="/assets/images/cash.png">
        </div>
        <div class="pay_type">
            <span>
                <input name="payType" value="else" type="radio"/> 线上支付
            </span>
            <span>
                <input name="payType" value="card" type="radio"/> 刷卡支付
            </span>
            <span>
                <input name="payType" value="cash" type="radio"/> 现金支付
            </span>
            <span>
                <input name="payType" value="mix" type="radio"/> 混合支付
            </span>
        </div>
        <div class="mixType">
            <form id="mixPayForm" class="form-horizontal" style="width: 60%;margin: 0 auto;">
                <div class="item form-group col-md-12 col-sm-12 col-xs-12">
                    <label class="col-md-5 col-sm-5 col-xs-12 control-label" for="qrCodeMoney">线上支付金额:</label>
                    <div class="col-md-7 col-sm-7 col-xs-12">
                        <input type="number" value="" class="col-md-12 col-sm-12 col-xs-12 form-control" oninput="mixPayTypeInput('qrCodeMoney')" onchange="mixPayTypeChange('qrCodeMoney')"name="qrCodeMoney" id="qrCodeMoney" placeholder="请输入线上支付金额">
                    </div>
                </div>
                <div class="item form-group col-md-12 col-sm-12 col-xs-12">
                    <label class="col-md-5 col-sm-5 col-xs-12 control-label" for="cardMoney">刷卡支付金额:</label>
                    <div class="col-md-7 col-sm-7 col-xs-12">
                        <input type="number" value="" class="col-md-12 col-sm-12 col-xs-12 form-control" oninput="mixPayTypeInput('cardMoney')" onchange="mixPayTypeChange('cardMoney')" name="cardMoney" id="cardMoney" placeholder="请输入刷卡支付金额">
                    </div>
                </div>
                <div class="item form-group col-md-12 col-sm-12 col-xs-12">
                    <label class="col-md-5 col-sm-5 col-xs-12 control-label" for="cashMoney">现金支付金额:</label>
                    <div class="col-md-7 col-sm-7 col-xs-12">
                        <input type="number" value="" class="col-md-12 col-sm-12 col-xs-12 form-control" oninput="mixPayTypeInput('cashMoney')" onchange="mixPayTypeChange('cashMoney')" name="cashMoney" id="cashMoney" placeholder="请输入现金支付金额">
                    </div>
                </div>
            </form>
            <div><img src="/assets/images/up.png"></div>
        </div>
        <div class="pay_button">
            <button class="btn btn-default" onclick="cancel()">取消</button>
            <button class="btn btn-primary" id="paySubmit">确定</button>
        </div>
    </div>
</div>
<#--凭证打印-->
<div class="modal fade" id="myModal" aria-labelledby="myModalLabel" aria-hidden="true">
    <div  class="financePrintWindow">
        <div id="printInfo">
            <#include "/financeManage/bill.ftl"/>
        </div>
        <div>
            <button type="button" class="btn" data-dismiss="modal">关闭</button>
            <button type="button" class="btn btn-primary" onclick="printBill()">打印</button>
        </div>
    </div>
</div>
<#--退款-->
<div class="charge_manage_refund">
    <div class="refundWindow">
        <div class="refund_info">
            <table id="tableRefund"></table>
        </div>
        <form id="approvalModalForm" class="form-horizontal form-label-left" novalidate>
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
                <label class="control-label col-md-3 col-sm-3 col-xs-12" width="30%" for="refundType">退款方式: <span class="required">*</span></label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <select id="refundType" name="refundType" class="form-control">
                        <option>请选择</option>
                        <option value="0">原路退回</option>

                    </select>
                </div>
            </div>
         </form>
        <div class="refund_button">
            <button class="btn btn-default" onclick="closeRefund()">取消</button>
            <button class="btn btn-primary" onclick="depositRefundApply()">退款审批</button>
        </div>
    </div>
</div>
<#--二维码-->
<div class="modal fade" id="myModaltwo" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content" style="width: 400px">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">请扫码缴费</h4>
            </div>
            <div class="modal-body" id="codeImg"></div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消支付</button>
                <button type="button" class="btn btn-primary">支付完成</button>
            </div>
        </div>
    </div>
</div>
<#--缴费说明-->
<div class="modal fade" id="payMsgModal" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content" style="width: 400px">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">说明</h4>
            </div>
            <div class="modal-body">
                <div class="payMsgContent">
                    <div>一、费用计算规则</div>
                    <p>1.物业费=月数*面积*单价；</p>
                    <p>2.车位费=月数*单价；</p>
                </div>
                <div class="payMsgContent">
                    <div>二、费用所属时间</div>
                    <p>1.物业费、缴费大类为购买的车位费，其默认费用结束时间算到当年12月份；</p>
                    <p>2.缴费大类为租赁的车位费,其默认费用结束时间算到次年1月份；</p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>
<#--点击绑定业务按钮展示，主要进行绑定押金和一次性收费-->
<div class="modal fade" id="depositModal" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop>
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="addroleLabel">新增绑定</h4>
            </div>
            <div class="modal-body configManageModalBody">
                <form id="depositModalForm" class="form-horizontal form-label-left" novalidate>
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
                                <option>押金类</option>
                                <option>一次性</option>
                            </select>
                        </div>
                    </div>
                    <#-- 押金类缴费项目 -->
                    <div class="item form-group costNameA">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="costName">缴费项目: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <select id="costName" name="costName" class="form-control" required="required"></select>
                        </div>
                    </div>
                    <#-- 一次性缴费项目 -->
                    <div class="item form-group costNameB" style="display: none;">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="costName">缴费项目: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <select id="costName" name="costName" class="form-control" required="required"></select>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="unit">单价(单位：元): <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="unit" id="unit" required="required" placeholder="请输入单价" autocomplete="off"/>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" onclick="sureBindDeposit()">保存</button>
            </div>
        </div>
    </div>
</div>
<#--点击折扣申请按钮时展示-->
<div class="modal fade" id="discountApplyModal" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop>
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="addroleLabel">折扣申请</h4>
            </div>
            <div class="modal-body configManageModalBody">
                <form id="discountApplyModalForm" class="form-horizontal form-label-left" novalidate>
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
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="discountRate">折率(单位:%): </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="discountRate" id="discountRate" oninput="discountOrDiscountRateInput('#discountRate')" placeholder="请输入折率" autocomplete="off"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="discount">折扣金额(单位:元):</label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-12 col-xs-12" name="discount" id="discount" oninput="discountOrDiscountRateInput('#discount')" placeholder="请输入折扣金额" autocomplete="off"/>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary discountApplySure">提交</button>
            </div>
        </div>
    </div>
</div>
<#include "/layout/footer.ftl"/>
<script>
    var mergeCellArr = new Array();//欠费缴费页面  合并单元格使用
    var endTimeInputArr = new Array();//需要声明laydate实例的结束时间input的id名集合(欠费缴费)
    var refundBeginTimeInputArr = new Array();//需要声明laydate实例的开始时间input的id名集合（退款）
    var mergeCellPropArr = new Array();//合并的n条物业数据的下标集合(欠费缴费)
    var mergeCellRefundPropArr = new Array();//合并的n条物业数据的下标集合(退款)
    var refundListLength=0;//退款的总数据条数，合并总金额字段使用
    var beginTimeLayDate;
    var proServiceRowIndex=-1;//欠费缴费列表中，物业费服务费行下标，用来处理抹零时对应的金额变化
    var proServiceFlag=false;//欠费缴费列表中，勾选的行数据中是否包含物业费服务费

    $(function () {
        initYear();
        queryVillage("village");
        //approveUserList();
        //监听支付方式的变化
        $('.pay_type input[type=radio]').on("ifChecked",function() {
            if(this.value=="mix"){
                $(".payWindow .mixType").css("display","block");
                $(".payWindow .pay_button #paySubmit").before('<button class="btn btn-primary resetMixPay" onclick="resetMixPayVal()">重置</button>')
            }else{
                $(".payWindow .mixType").css("display","none");
                $(".payWindow .mixType input").val('');
                $(".payWindow .pay_button .resetMixPay").remove();
            }
        });
    })

    //初始化欠费缴费中的年份选择select
    function initYear(){
        var currentYear=(new Date()).getFullYear();
        for(var i=(currentYear-3);i<(currentYear+4);i++){
            $("#selectYear").append("<option value='"+i+"'>"+i+"年</option>")
        }
        $("#selectYear").val(currentYear);
    }
    //监测年份变化
    $("#selectYear").change(function(){
        $("#sumMoney").html("0.00");
        $("#table").bootstrapTable("refresh");
    })
    //点击欠费缴费、已缴明细按钮
    function openPayOrPaid(type) {
        var formData=$("#searchForm").serializeObject();
        if(formData.village=="")layer.alert('请选择小区！',{title:"警告"});
        else if(formData.building=="null")layer.alert('请选择楼栋！',{title:"警告"});
        else if(formData.location=="null")layer.alert('请选择单元！',{title:"警告"});
        else if(formData.room=="")layer.alert('请选择房屋！',{title:"警告"});
        else{
            if(type=="pay"){
                proServiceRowIndex=-1;
                proServiceFlag=false;
                $("#selectYear").val((new Date()).getFullYear());
                queryCharge();
                $('.main').css("display", "none");
                $('.payPart').css("display", "block");
                getDepositConfig();//查询配置项押金类和一次性，绑定业务使用
            }else if(type=="paid"){
                getBillTable();
                $('.main').css("display", "none");
                $('.payPart').css("display", "none");
                $('.paidPart').css("display", "block");
            }
        }
    }
    //查询欠费缴费列表
    function queryCharge() {
        $("#table").bootstrapTable("destroy").bootstrapTable({
            url:'/charge/queryCharge',
            method: 'get',
            dataType: "json",
            contentType: 'application/json',
            toolbar: '#toolbar',
            toggle:"table",
            sidePagination: "server",
            pagination: false,
            uniqueId:"id",
            columns:[
                {
                    checkbox: true,
                    field: 'checkbox',
                    formatter: function(code, row, index) {
                        return {checked:code};
                    }
                },{
                    field: 'costName',
                    title: '缴费项目',
                    formatter: function(code, row, index) {
                        if(row.costType=="车位费")return code+row.carNo+(row.licensePlateNo?"("+row.licensePlateNo+")":"");
                        else return code;
                    }
                },{
                    field: 'costType',
                    title: '缴费类型',
                },{
                    field: 'costTypeClass',
                    title: '缴费大类',
                    formatter: function(code, row, index) {
                        if(row.costType=="押金类"||row.costType=="一次性")return "/";
                        else return code;
                    }
                },{
                    field: 'costTypeSection',
                    title: '缴费小类',
                    formatter: function(code, row, index) {
                        if(row.costType=="押金类"||row.costType=="一次性")return "/";
                        else return code;
                    }
                },{
                    field: 'beginTime',
                    title: '费用所属时间',
                    formatter: function(code, row, index) {
                        if(row.costType=="押金类"||row.costType=="一次性")return "/";
                        else return row.beginTime+' ~ <input style="min-width: 120px;" readonly="readonly" type="text" value="'+row.endTime+'" id="costId'+index+row.costId+'" class="form-control timeInput"/>';
                    }
                },{
                    field: 'area',
                    title: '房屋面积(单位:㎡)',
                    formatter: function(code, row, index) {
                        if(row.costType=="押金类"||row.costType=="一次性"||row.costType=="车位费")return "/";
                        else return code;
                    }
                },{
                    field: 'unit',
                    title: '单价',
                    formatter:function (code, row, index) {
                        if(row.costType=="物业费"){
                            return code+"元／(㎡<span style='font-weight: bolder;'>·</span>月)";
                        }else if(row.costType=="车位费"){
                            return code+"元／月";
                        }else if(row.costType=="押金类"||row.costType=="一次性"){
                            return code+"元";
                        }else return code+"元";
                    }
                },
                {
                    field: 'discountRate',
                    title: '折率(%)',
                    width:120,

                    formatter: function(code, row, index) {
                        return '<input disabled type="text" value="'+code+'" id="discountRate'+index+'" class="form-control discountRateInput" data-totalMoneyCount="'+row.totalMoneyCount+'" placeholder="请输入折率" oninput="discountRateInput(\''+index+'\')"/>'
                    }
                },{
                    field: 'discount',
                    title: '折扣(单位:元)',
                    width:150,

                    formatter: function(code, row, index) {
                        return '<input disabled type="text" value="'+code+'" class="form-control discountInput" id="discount'+index+'" placeholder="请输入折扣金额" oninput="discountInput(\''+index+'\')" autocomplete="off"/>'
                    }
                },
                {
                    field: 'totalMoney',
                    title: '欠费金额(单位:元)',
                }
            ],
            queryParams: function(params){
                var formData=$("#searchForm").serializeObject();
                var param={
                    village:formData.village,
                    room:formData.room,
                    year:$("#selectYear").val()
                }
                if(formData.building!="null")param.building=formData.building;
                if(formData.location!="null")param.location=formData.location;
                return param;
            },
            formatLoadingMessage: function(){
                return "正在加载中。。。";
            },
            responseHandler:function (res) {
                //展示业主信息
                var chargeInfo = res.houseInfo.village + res.houseInfo.building + res.houseInfo.location + res.houseInfo.room + '，业主：' + res.houseInfo.ownerName + '，联系电话：' + res.houseInfo.ownerPhone
                $('.charge_info').html(chargeInfo);
                //将业户信息绑定到"绑定业务"按钮中，方便后续对押金和一次性进行绑定操作
                $(".payPart .bindDepositOrDisposable").attr("data-houseInfo",JSON.stringify(res.houseInfo));
                //将业户信息绑定到"折扣申请"按钮中，方便后续进行折扣申请操作
                $(".payPart .discountApply").attr("data-houseInfo",JSON.stringify(res.houseInfo));

                // var mergeCellArrOther=new Array();//方便计算合并的格数
                var fieldArr=["checkbox","costType","costTypeClass","beginTime","area"];//需要合并列的字段名
                // var rowIndex=0,flag=false,num=0;//行的下标
                mergeCellArr=new Array();
                endTimeInputArr=new Array();
                mergeCellPropArr=new Array();

                //先处理数据，保证住宅物业费合并单元格；其他费用先分类再拼接，保证数据不穿插错乱
                var propertyMainArr=new Array();//小类为住宅的物业费
                var propertyOtherArr=new Array();//小类为非住宅的物业费
                var carArr=new Array();//车位费
                var depositArr=new Array();//押金类
                var disposableArr=new Array();//一次性
                var otherArr=new Array();//其他的一些费用，防止存在时无法归类
                res.chargeList.forEach(function (item,index) {
                    // //新增id属性，获取某条行数据使用
                    // item.id=index;
                    item.checkbox=false;
                    //新增初始的欠费总金额，防止计算过程中数据不对
                    item.totalMoneyCount=item.totalMoney;
                    //新增houseId属性，支付时使用
                    item.houseId=res.houseInfo.houseId;
                    //处理缴费大类、缴费小类
                    if(item.costType=="押金类"||item.costType=="一次性"){
                        item.costTypeClass="";
                        item.costTypeSection="";
                    }
                    //处理房屋面积
                    if(item.costType=="物业费")item.area=res.houseInfo.roomArea;
                    else item.area="";
                    //处理开始时间
                    if(item.costType=="物业费")item.beginTime=item.beginTime.substring(0,7);
                    //处理结束时间
                    if(item.costType=="物业费"||(item.costType=="车位费"&&item.costTypeClass=="购买"))item.endTime=$("#selectYear").val()+"-12";
                    else if(item.costType=="车位费"&&item.costTypeClass=="租赁"){
                        var day=moment(item.beginTime).date()<10?"0"+moment(item.beginTime).date():moment(item.beginTime).date()
                        item.endTime=moment(Number($("#selectYear").val())+1+"-01-"+day).subtract(1, "days").format("YYYY-MM-DD");
                    }else item.endTime="";
                    //处理折率
                    item.discountRate='';
                    //处理折扣
                    item.discount='';
                    //费用进行分组
                    if(item.costType=="物业费"&&item.costTypeSection=="住宅")propertyMainArr.push(item);
                    else if(item.costType=="物业费"&&item.costTypeSection!="住宅")propertyOtherArr.push(item);
                    else if(item.costType=="车位费")carArr.push(item);
                    else if(item.costType=="押金类")depositArr.push(item);
                    else if(item.costType=="一次性")disposableArr.push(item);
                    else otherArr.push(item);
                })
                var list=(propertyMainArr.concat(propertyOtherArr).concat(carArr).concat(depositArr).concat(disposableArr)).map(function(item,index){
                    //处理车位费和物业费结束时间layDate的数据
                    if(item.costType=="物业费"||item.costType=="车位费"){
                        var obj=item;
                        obj.domId="#costId"+index+item.costId;
                        obj.rowIndex=index;
                        endTimeInputArr.push(obj);
                    }
                    if(item.costType=="物业费"&&item.costTypeSection=="住宅")mergeCellPropArr.push(index);
                    //新增id属性，获取某条行数据使用
                    item.id=index;
                    //记录物业费服务费的行标，当总额抹零时，需对物业费服务费的欠费金额做相应处理
                    if(item.costName=="物业费服务费")proServiceRowIndex=index;
                    return item;
                });
                if(propertyMainArr.length!=0){
                    fieldArr.forEach(function (item, index) {
                        mergeCellArr.push({index: 0, field: item, rowspan: propertyMainArr.length});
                    })
                }
                return{
                    "total":list.length,
                    "rows":list
                }
            },
            onLoadSuccess:function (data) {
                resetPayTable();
            },
            onCheck:function(row, $element){
                countTotalMoney(true,row);
            },
            onUncheck:function(row, $element){
                countTotalMoney(false,row);
            },
            onCheckAll: function (rowsAfter,rowsBefore) {
                countTotalMoney();
            },
            onUncheckAll: function (rowsAfter,rowsBefore) {
                countTotalMoney();
            }
        })
    }
    //车位费类型且租赁大类，结束时间额外处理
    function handleCarEndTime(date) {
        var beginTimeArr=date.split("-");
        var nextMonth=moment([beginTimeArr[0], beginTimeArr[1]-1, beginTimeArr[2]]).add(1, 'months').format("YYYY-MM-DD");
        var nextMonthDate=moment(nextMonth).date();
        if(Number(beginTimeArr[2])==Number(nextMonthDate)){
            nextMonth=moment(nextMonth).subtract(1, "days").format("YYYY-MM-DD");
        }
        return nextMonth;
    }
    //初始化欠费缴费中结束时间的layDate组件
    function initBeginTimeInput(data){
        laydate.render({
            elem: data.domId,
            type: (data.costType=="车位费"&&data.costTypeClass=="租赁")?'date':'month',
            min:(data.costType=="车位费"&&data.costTypeClass=="租赁")?handleCarEndTime(data.beginTime):data.beginTime+"-01",
            btns: ['confirm'],
            ready:function(date){
                var mainDay=Number(data.beginTime.split("-")[2]);//获取开始时间的日
                if(mainDay<2)mainDay=31;
                else mainDay=mainDay-1;
                if(data.costType=="车位费"&&data.costTypeClass=="租赁"){
                    var laydateAll=$('.layui-laydate-content td');
                    var laydatePrev=$('.layui-laydate-content td.laydate-day-prev');
                    var laydateNext=$('.layui-laydate-content td.laydate-day-next');
                    var laydateThisLength=laydateAll.length-laydatePrev.length-laydateNext.length;
                    $('.layui-laydate-content td').each(function(index,item){
                        if($(this).attr('class')=="laydate-day-prev"||$(this).attr('class')=="laydate-day-next")$(this).addClass("laydate-disabled");
                        else{
                            if(laydateThisLength>mainDay-1) {
                                if ($(this).text() != mainDay) $(this).addClass("laydate-disabled");
                                else $(this).addClass("layui-this");
                            }else{
                                if(Number($(this).text())!=laydateThisLength)$(this).addClass("laydate-disabled");
                                else $(this).addClass("layui-this");
                            }
                        }
                    })
                }
            },
            change: function(value, date, endDate){
                var mainDay=Number(data.beginTime.split("-")[2]);//获取开始时间的日
                if(mainDay<2)mainDay=31;
                else mainDay=mainDay-1;
                if(data.costType=="车位费"&&data.costTypeClass=="租赁"){
                    var laydateAll=$('.layui-laydate-content td');
                    var laydatePrev=$('.layui-laydate-content td.laydate-day-prev');
                    var laydateNext=$('.layui-laydate-content td.laydate-day-next');
                    var laydateThisLength=laydateAll.length-laydatePrev.length-laydateNext.length;
                    $('.layui-laydate-content td').each(function(index,item){
                        if($(this).attr('class')=="laydate-day-prev"||$(this).attr('class')=="laydate-day-next")$(this).addClass("laydate-disabled");
                        else{
                            if(laydateThisLength>mainDay-1) {
                                if ($(this).text() != mainDay) $(this).addClass("laydate-disabled");
                                else $(this).addClass("layui-this");
                            }else{
                                if(Number($(this).text())!=laydateThisLength)$(this).addClass("laydate-disabled");
                                else $(this).addClass("layui-this");
                            }
                        }
                    })
                }
            },
            done: function(value, date, endDate){
                if(data.costType=="车位费"||(data.costType=="物业费"&&data.costTypeSection!="住宅")){
                    updateCellData(data.rowIndex,'endTime',value);
                    //日期改变时，查询对应的金额
                    var currentRow=$('#table').bootstrapTable('getRowByUniqueId',data.rowIndex);
                    searchTotalMoney(currentRow,data.rowIndex);
                }else if(data.costType=="物业费"&&data.costTypeSection=="住宅"){
                    //物业费对应的日期改变时，需查询所有物业费类型的数据
                    mergeCellPropArr.forEach(function (item, index) {
                        updateCellData(item,'endTime',value);
                        //日期改变时，查询对应的金额
                        var currentRow=$('#table').bootstrapTable('getRowByUniqueId',item);
                        searchTotalMoney(currentRow,item);
                    })
                }
                // //再次执行合并单元格，否则合并效果会丢失
                mergeCellArr.forEach(function(item,index){
                    $('#table').bootstrapTable('mergeCells', item);
                })
            }
        })
    }
    /**
     * 日期改变时，查询单条数据对应的欠费总金额
     * */
    function searchTotalMoney(data,rowIndex){
        var params={
            beginTime: data.beginTime,
            endTime:data.endTime,
            unit:data.unit,
            discount:"",
            costType:data.costType,
            costName:data.costName,
            costTypeClass:data.costTypeClass,
            costTypeSection:data.costTypeSection,
        }
        if(data.costType=="物业费")params.area=data.area;
        $.ajax({
            url: '/charge/countPay',
            type: "post",
            dataType: "json",
            contentType:'application/json;charset=UTF-8',
            data: JSON.stringify(params),
            success: function (res) {
                updateCellData(rowIndex,'totalMoneyCount',res);
                discountRateInput(rowIndex);
                resetPayTable();
            },
            error: function (error) {

            }
        });
    }
    //折率改变
    function discountRateInput(rowIndex) {
        //处理输入的折率为非数字的情况
        if(isNaN($("#discountRate"+rowIndex).val())==true){
            $("#discountRate"+rowIndex).val("");
        }else if(Number($("#discountRate"+rowIndex).val())>100){
            $("#discountRate"+rowIndex).val(100);
        }else if(Number($("#discountRate"+rowIndex).val())==0&&$("#discountRate"+rowIndex).val()!=""&&$("#discountRate"+rowIndex).val().indexOf(".")==-1){
            $("#discountRate"+rowIndex).val(0);
        }else{
            var val= $("#discountRate"+rowIndex).val();
            var indexStr=val.indexOf(".");
            if(indexStr!=-1&&(val.length-1-indexStr>2)){
                $("#discountRate"+rowIndex).val(val.slice(0,indexStr+3));
            }
        }
        var initialTotalMoney=$("#discountRate"+rowIndex).attr("data-totalMoneyCount");//初始的欠费金额
        var discountMoney=(10*(initialTotalMoney*Number($("#discountRate"+rowIndex).val()))/1000).toFixed(2);//折扣的金额
        updateCellData(rowIndex,'discountRate',$("#discountRate"+rowIndex).val());//更新折率
        updateCellData(rowIndex,'discount',(discountMoney==0||!discountMoney)?"":discountMoney);//更新折扣金额
        updateCellData(rowIndex,'totalMoney',(initialTotalMoney-discountMoney).toFixed(2));//更新总价
        resetPayTable();
        countTotalMoney();
        //光标自动聚焦，且至于文字最右
        $("#discountRate"+rowIndex).focus();
        var strLength=$("#discountRate"+rowIndex).val().length;
        document.getElementById("discountRate"+rowIndex).setSelectionRange(strLength, strLength);
    }
    //监测手动输入时的折扣金额的变化
    function discountInput(rowIndex){
        //处理输入的折率为非数字的情况
        if(isNaN($("#discount"+rowIndex).val())==true){
            $("#discount"+rowIndex).val("");
        }else if(Number($("#discount"+rowIndex).val())==0&&$("#discount"+rowIndex).val()!=""&&$("#discount"+rowIndex).val().indexOf(".")==-1){
            $("#discount"+rowIndex).val(0);
        }else{
            var val= $("#discount"+rowIndex).val();
            var indexStr=val.indexOf(".");
            if(indexStr!=-1&&(val.length-1-indexStr>2)){
                $("#discount"+rowIndex).val(val.slice(0,indexStr+3));
            }
        }
        var initialTotalMoney=$("#discountRate"+rowIndex).attr("data-totalMoneyCount");//初始的欠费金额
        if(Number($("#discount"+rowIndex).val())>initialTotalMoney)$("#discount"+rowIndex).val(initialTotalMoney);

        var discountMoney=$("#discount"+rowIndex).val();//折扣的金额
        //更新折扣金额
        updateCellData(rowIndex,'discount',discountMoney);
        //更新总价
        updateCellData(rowIndex,'totalMoney',(initialTotalMoney-discountMoney).toFixed(2));
        resetPayTable();
        countTotalMoney();
        //光标自动聚焦，且至于文字最右
        $("#discount"+rowIndex).focus();
        var strLength=$("#discount"+rowIndex).val().length;
        document.getElementById("discount"+rowIndex).setSelectionRange(strLength, strLength);
    }
    //操作抹零按钮
    function notCountSmall(){
        var totalMoney=Number($("#sumMoney").html());
        $("#sumMoney").html((Math.floor(totalMoney)).toFixed(2))
        //总额抹零后，对物业服务费金额做相应处理
        if(proServiceRowIndex!=-1&&proServiceFlag==true){
            var currentProTotalMoney=Number($('#table').bootstrapTable('getRowByUniqueId',proServiceRowIndex).totalMoney);
            updateCellData(proServiceRowIndex,'totalMoney',(1000*currentProTotalMoney-(1000*Number(totalMoney)-1000*Number($("#sumMoney").html())))/1000);
            resetPayTable();
        }
    }
    //欠费缴费table优化
    function resetPayTable(){
        //重新实例化date组件
        endTimeInputArr.forEach(function(item,index){
            initBeginTimeInput(item);
        })
        //再次执行合并单元格，否则合并效果会丢失
        mergeCellArr.forEach(function(item,index){
            $('#table').bootstrapTable('mergeCells', item);
        })
    }
    /**
     * 更新单元格数据
     * @params {number} index  更新单元格的行下标
     * @params {string} field  更新单元格的字段名
     * @params {string} value  更新单元格的值
     * */
    function updateCellData(index,field,value){
        $('#table').bootstrapTable('updateCell', {
            index: index,
            field: field,
            value: value
        })
    }
    /**
     * 计算合计金额
     * @params {boolean} type  true代表单选选中，false代表取消单选
     * @params {object} row  单选或取消单选的行数据
     * 全选或取消全选时，type和row均不传
     * */
    function countTotalMoney(type,row){
        proServiceFlag=false;
        if(row&&row.costType=="物业费"&&row.costTypeSection=="住宅"){
            if(type==true||type==false){
                mergeCellPropArr.forEach(function(item,index){
                    updateCellData(item,'checkbox',type);
                })
                resetPayTable();
            }
        }
        var totalMoney=0;
        var selectArr=$("#table").bootstrapTable('getSelections');
        selectArr.forEach(function(item,index){
            totalMoney+=(1000*Number(item.totalMoney));
            //处理勾选的行数据中是否有物业费服务费
            if(item.costName=="物业费服务费")proServiceFlag=true;
        })
        $("#sumMoney").html(totalMoney/1000);
    }
    /*绑定业务：查询小区已配置的押金类和一次性*/
    function getDepositConfig() {
        $.ajax({
            url: "/config/queryByVillage?village="+$("#searchForm #village").val(),
            type: "get",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function(res){
                if(res&&res.length!=0){
                    var depositStrA="",depositStrB="";
                    res.forEach(function (item,index) {
                        if(item.costType=="押金类"&&depositStrA.indexOf(item.costName)==-1) {
                            depositStrA+="<option value='"+item.costName+"'>"+item.costName+"</option>";
                        }
                        else if(item.costType=="一次性"&&depositStrB.indexOf(item.costName)==-1) {
                            depositStrB+="<option value='"+item.costName+"'>"+item.costName+"</option>";
                        }
                    })
                    console.log(depositStrB)
                    console.log(depositStrA)
                    if(depositStrA=="")$("#depositModalForm .costNameA #costName").html("<option value=''>请选择</option>");
                    else $("#depositModalForm .costNameA #costName").html(depositStrA);
                    if(depositStrB=="")$("#depositModalForm .costNameB #costName").html("<option value=''>请选择</option>");
                    else $("#depositModalForm .costNameB #costName").html(depositStrB);
                }else{
                    $("#depositModalForm .costNameA #costName").html("<option value=''>请选择</option>");
                    $("#depositModalForm .costNameB #costName").html("<option value=''>请选择</option>");
                }
            },
            error: function(error){
                $("#depositModalForm .costNameA #costName").html("<option value=''>请选择</option>");
                $("#depositModalForm .costNameB #costName").html("<option value=''>请选择</option>");
            }
        });
    }
    /*绑定业务中  缴费类型发生改变*/
    $("#depositModalForm #costType").change(function(){
        if($("#depositModalForm #costType").val()=="押金类"){
            $("#depositModalForm .costNameA").css("display","block");
            $("#depositModalForm .costNameB").css("display","none");
        }else{
            $("#depositModalForm .costNameA").css("display","none");
            $("#depositModalForm .costNameB").css("display","block");
        }
    })
    /*点击绑定业务按钮，绑定押金或一次性收费项目*/
    function bindDepositOrDisposable() {
        var houseInfo=JSON.parse($(".payPart .bindDepositOrDisposable").attr("data-houseInfo"));
        $("#depositModalForm #house").val(houseInfo.village+houseInfo.building+houseInfo.location+houseInfo.room);
        $('#depositModal').modal('show');
    }
    /*点击绑定业务功能中的保存按钮，确定绑定押金或一次性收费项目*/
    function sureBindDeposit() {
        var houseInfo=JSON.parse($(".payPart .bindDepositOrDisposable").attr("data-houseInfo"));
        if(validator.checkAll($("#depositModalForm"))){
            var load=layer.load(0, {
                shade: [0.2,'#000']
            });
            var obj={
                village:houseInfo.village,
                building:houseInfo.building,
                location:houseInfo.location,
                room:houseInfo.room,
                costTypeClass:"",
                costTypeSection:"",
                beginTime:"",
                roomArea:String(houseInfo.roomArea),
                ownerName:houseInfo.ownerName,
                ownerPhone:houseInfo.ownerPhone,
                idCardNo:houseInfo.idCardNo,
                reservePhone:houseInfo.reservePhone,
                carNo:"",
                licensePlateNo:"",
                costName:$("#depositModalForm #costType").val()=="押金类"?$("#depositModalForm .costNameA #costName").val():$("#depositModalForm .costNameB #costName").val(),
                costType:$("#depositModalForm #costType").val(),
                unit:$("#depositModalForm #unit").val(),
            };
            $.ajax({
                url: "/config/propertyImport",
                type: "post",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data:JSON.stringify(new Array(obj)),
                success: function(res){
                    layer.close(load);
                    if(res.code==200)layer.alert("绑定成功",{title:"提示"});
                    else layer.alert("绑定失败",{title:"警告"});
                    $("#table").bootstrapTable("refresh");
                    $('#depositModal').modal('hide');
                },
                error: function(error){
                    layer.close(load);
                    layer.alert("绑定失败",{title:"警告"});
                    $("#table").bootstrapTable("refresh");
                    $('#depositModal').modal('hide');
                }
            });
        }
    }
    /*关闭绑定押金或一次性收费项目弹窗*/
    $('#depositModal').on('hide.bs.modal', function () {
        $('#depositModalForm')[0].reset();
        $("#depositModalForm .costNameA").css("display",'block');
        $("#depositModalForm .costNameB").css("display",'none');
        $("#depositModalForm .form-group").removeClass("bad");
        $("#depositModalForm .form-group .alert").remove();
    })
    /* 点击返回按钮，返回主页面 */
    function returnMain() {
        $('#sumMoney').html("0.00")
        $("#table").bootstrapTable('destroy');
        $("#billTable").bootstrapTable('destroy');
        $('.main').css("display", "block");
        $('.payPart').css("display", "none");
        $('.paidPart').css("display", "none");
    }
    /**
     * 混合支付中 输入线上支付金额、刷卡支付金额、现金支付金额
     * @params {string} type  "qrCodeMoney":线上支付、"cardMoney":刷卡支付、"cashMoney":现金支付；
     * */
    function mixPayTypeInput(type){
        var cardMoney=new BigNumber($("#cardMoney").val()?$("#cardMoney").val():0);
        var cashMoney=new BigNumber($("#cashMoney").val()?$("#cashMoney").val():0);
        var qrCodeMoney=new BigNumber($("#qrCodeMoney").val()?$("#qrCodeMoney").val():0);
        var totalMoney=new BigNumber($("#sumMoney").html());
        if(type=="qrCodeMoney"){
            var value=totalMoney.minus(cardMoney).minus(cashMoney).toNumber();
            if(qrCodeMoney>value){
                $("#qrCodeMoney").val(value);
            }
        }else if(type=="cashMoney"){
            var value=totalMoney.minus(cardMoney).minus(qrCodeMoney).toNumber();
            if(cashMoney>value){
                $("#cashMoney").val(value);
            }
        }else if(type=="cardMoney"){
            var value=totalMoney.minus(cashMoney).minus(qrCodeMoney).toNumber();
            if(cardMoney>value){
                $("#cardMoney").val(value);
            }
        }
    }
    /**
     * 混合支付中线上支付金额、刷卡支付金额、现金支付金额改变
     * @params {string} type  "qrCodeMoney":线上支付、"cardMoney":刷卡支付、"cashMoney":现金支付；
     * */
    function mixPayTypeChange(type){
        var cardMoney=$("#cardMoney").val()==""?"":new BigNumber($("#cardMoney").val());
        var cashMoney=$("#cashMoney").val()==""?"":new BigNumber($("#cashMoney").val());
        var qrCodeMoney=$("#qrCodeMoney").val()==""?"":new BigNumber($("#qrCodeMoney").val());
        var totalMoney=new BigNumber($("#sumMoney").html());
        if(type=="qrCodeMoney"){
            if(qrCodeMoney!=""){
                if(cardMoney==""&&cashMoney!=""){
                    $("#cardMoney").val(totalMoney.minus(qrCodeMoney).minus(cashMoney).toNumber());
                }else if(cardMoney!=""&&cashMoney==""){
                    $("#cashMoney").val(totalMoney.minus(qrCodeMoney).minus(cardMoney).toNumber());
                }
            }else{
                if(cardMoney!=""&&cashMoney!=""){
                    $("#qrCodeMoney").val(totalMoney.minus(cardMoney).minus(cashMoney).toNumber());
                }
            }
        }else if(type=="cashMoney"){
            if(cashMoney!=""){
                if(cardMoney==""&&qrCodeMoney!=""){
                    $("#cardMoney").val(totalMoney.minus(qrCodeMoney).minus(cashMoney).toNumber());

                }else if(cardMoney!=""&&qrCodeMoney==""){
                    $("#qrCodeMoney").val(totalMoney.minus(cardMoney).minus(cashMoney).toNumber());
                }
            }else{
                if(cardMoney!=""&&qrCodeMoney!=""){
                    $("#cashMoney").val(totalMoney.minus(cardMoney).minus(qrCodeMoney).toNumber());
                }
            }
        }else if(type=="cardMoney"){
            if(cardMoney!=""){
                if(cashMoney==""&&qrCodeMoney!=""){
                    $("#cashMoney").val(totalMoney.minus(qrCodeMoney).minus(cardMoney).toNumber());
                }else if(cashMoney!=""&&qrCodeMoney==""){
                    $("#qrCodeMoney").val(totalMoney.minus(cardMoney).minus(cashMoney).toNumber());
                }
            }else{
                if(cashMoney!=""&&qrCodeMoney!=""){
                    $("#cardMoney").val(totalMoney.minus(cashMoney).minus(qrCodeMoney).toNumber());
                }
            }
        }
    }
    //重置混合支付中各项金额
    function resetMixPayVal() {
        $(".payWindow .mixType input").val('');
    }
    //展示支付类型弹窗
    function showPayType() {
        var selectArr=$("#table").bootstrapTable('getSelections');
        if(selectArr.length==0)layer.alert("请至少选择一条记录！",{title:"警告"});
        else{
            $('.charge_manage_paySelf').css('display', 'block');
            //进入支付功能
            $("#paySubmit").unbind('click').bind("click",function(){
                $("#paySubmit").attr("disabled","disabled");
                if($('input[name=payType]:checked').val()==undefined){
                    layer.alert('请选择支付方式！',{title:"警告"});
                    $("#paySubmit").removeAttr("disabled");
                }else if($('input[name=payType]:checked').val()=="mix"){
                    var formDate=$("#mixPayForm").serializeObject();
                    var qrCodeMoney=new BigNumber(formDate.qrCodeMoney);
                    var cardMoney=new BigNumber(formDate.cardMoney);
                    var cashMoney=new BigNumber(formDate.cashMoney);
                    var totalMoney=(new BigNumber($("#sumMoney").html())).toNumber();

                    if(totalMoney!=qrCodeMoney.plus(cardMoney).plus(cashMoney).toNumber()){
                        layer.alert('混合支付金额不匹配！',{title:"警告"});
                        $("#paySubmit").removeAttr("disabled");
                    }else if((qrCodeMoney==0&&cardMoney==0)||(qrCodeMoney==0&&cashMoney==0)||(cashMoney==0&&cardMoney==0)){
                        layer.alert('混合支付至少包含两种支付方式！',{title:"警告"});
                        $("#paySubmit").removeAttr("disabled");
                    }else{
                        paySubmit(selectArr);
                    }
                }else{
                    paySubmit(selectArr);
                }
            });
        }
    }
    //点击确定按钮，提交支付
    function paySubmit(data){
        var load=layer.load(0, {
            shade: [0.2,'#000']
        });
        var arr=new Array();
        data.forEach(function(item,index){
            var obj={
                costId:item.costId,
                costType:item.costType,
                costTypeClass:item.costTypeClass,
                costTypeSection:item.costTypeSection,
                costName:item.costName,
                beginTime:item.beginTime,
                endTime:item.endTime,
                unit:item.unit,
                discount:item.discount?Number(item.discount):0,
                discountRate:item.discountRate,
                pay:item.totalMoney,
            }
            if(item.costType=="物业费")obj.area=Number(item.area);
            else if(item.costType=="车位费"){
                obj.carId=item.carNo;
                obj.licensePlateNo=item.licensePlateNo;
            }
            arr.push(obj);
        })
        var params={
            houseId:data[0].houseId,
            type:$('input[name=payType]:checked').val(),
            totalMoney:$("#sumMoney").html(),
            itemList:arr
        };
        if($('input[name=payType]:checked').val()=="mix"){
            params.qrCodeMoney=Number($("#mixPayForm #qrCodeMoney").val());
            params.cardMoney=Number($("#mixPayForm #cardMoney").val());
            params.cashMoney=Number($("#mixPayForm #cashMoney").val());
        }
        $.ajax({
            url: '/charge/pay',
            type: "post",
            dataType: "json",
            contentType:'application/json;charset=UTF-8',
            data: JSON.stringify(params),
            success: function (res) {
                layer.close(load);
                if($('input[name=payType]:checked').val()=="else"||($('input[name=payType]:checked').val()=="mix"&&params.qrCodeMoney!=0))var isOnLine=true;
                else var isOnLine=false;
                if(res.code==200){
                    if(isOnLine==true){
                        if(res.url){
                        console.log(res.url)
                            $('#myModaltwo').modal('show');
                            $('#myModaltwo #codeImg').html("");
                            var qrcode = new QRCode(
                                document.getElementById("codeImg"), {
                                    width: 280,
                                    height: 280
                                }
                            );
                            qrcode.makeCode(res.url);
                            openWebsocket();
                            $("#paySubmit").removeAttr("disabled");
                            return;
                        }else layer.alert('支付异常！',{title:"警告"});
                    }else layer.alert(res.msg,{title:"提示"});
                }else if(res.code==500) layer.alert(res.msg,{title:"警告"});
                else layer.alert('支付异常！',{title:"警告"});
                paySuccessReset();
            },
            error: function (error) {
                layer.close(index);
                layer.alert('缴费异常！',{title:"警告"});
                paySuccessReset();
            }
        });
    }
    //缴费成功或失败时，重置相关参数
    function paySuccessReset(){
        getBillTable();
        $(".charge_manage .payPart").css('display', 'none');
        $(".charge_manage .paidPart").css('display', 'block');

        $('.charge_manage_paySelf').css('display', 'none');
        $(".pay_type div").removeClass("checked");
        $(".pay_type input").removeAttr("checked");
        $(".payWindow .mixType").css('display', 'none');
        $(".payWindow .pay_button .resetMixPay").remove();
        $("#sumMoney").html("0.00")
        $("#paySubmit").removeAttr("disabled");
    }
    //支付类型弹窗取消
    function cancel() {
        $('.charge_manage_paySelf').css('display', 'none');
        $(".pay_type div").removeClass("checked");
        $(".pay_type input").removeAttr("checked");
        $(".payWindow .mixType").css('display', 'none');
        $(".payWindow .mixType input").val('');
        $(".payWindow .pay_button .resetMixPay").remove();
    }
    //线上支付二维码弹框关闭时清除旧二维码
    $('#myModaltwo').on('hide.bs.modal', function () {
        $('#myModaltwo #codeImg').html('')
    })
    //查询用户列表，折扣申请中的审批人使用
    function approveUserList(houseInfo) {
        var param={
            village:houseInfo.village
        };
        $.ajax({
            url: "/approval/listUsers",
            type: "post",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            data:JSON.stringify(param),
            success: function(res){
            console.log(res,55)
                if(res&&res.length!=0){
                    var str="";
                    res.forEach(function (item,index) {
                        str+="<option value='"+item.username+"'>"+item.nickname+"</option>";
                    })
                    $("#discountApplyModalForm #approveUser").append(str);
                }
            },
            error: function(error){}
        });
    }

    //查询用户列表，退款审批发起中的审批人使用
    function approveUserList(row) {
        var param={
            village:row.village
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

    //点击折扣申请按钮，进行折扣申请
    function discountApply() {
        var houseInfo=JSON.parse($(".payPart .discountApply").attr("data-houseInfo"));
        approveUserList(houseInfo);
        $("#discountApplyModalForm #house").val(houseInfo.village+houseInfo.building+houseInfo.location+houseInfo.room);
        $("#discountApplyModalForm #ownerName").val(houseInfo.ownerName);
        $("#discountApplyModalForm #ownerPhone").val(houseInfo.ownerPhone);
        $("#discountApplyModalForm #applyUser").val("${user.username}");
        $('#discountApplyModal').modal('show');
        $("#discountApplyModal .discountApplySure").unbind("click").bind("click",function () {
            var params={
                houseId:houseInfo.houseId,
                applyUser:"${user.username}",
                approveUser:$("#discountApplyModalForm #approveUser").val(),
                discount:$("#discountApplyModalForm #discount").val(),
                discountRate:$("#discountApplyModalForm #discountRate").val(),
            };
            if(params.approveUser=="请选择"||!params.approveUser){
                layer.alert("请选择审批人",{title:"警告"});
                return;
            }
            if(Number(params.discount)==0&&Number(params.discountRate)==0){
                layer.alert("折扣金额和折率不能同时为空或为0！",{title:"警告"});
                return;
            }
            $.ajax({
                url: "/approval/add",
                type: "post",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data:JSON.stringify(params),
                success: function(res){
                    if(res.code==200||res.code==500){
                        layer.alert(res.msg,{title:res.code==200?"提示":"警告"});
                    }else layer.alert("申请失败！",{title:"警告"});
                    $('#discountApplyModal').modal('hide');
                },
                error: function(error){
                    layer.alert("申请失败！",{title:"警告"});
                    $('#discountApplyModal').modal('hide');
                }
            });
        })
    }
    //折扣申请中的折扣金额和折率改变
    function discountOrDiscountRateInput(domId) {
        var val=$("#discountApplyModalForm "+domId).val();
        if(isNaN(val)==true){
            $("#discountApplyModalForm "+domId).val("");
        }else if(Number(val)==0&&val!=""&&val.indexOf(".")==-1){
            $("#discountApplyModalForm "+domId).val(0);
        }else{
            if(domId=="#discountRate"){
                if(Number(val)>100){
                    $("#discountApplyModalForm "+domId).val(100);
                }
            }
            var indexStr=val.indexOf(".");
            if(indexStr!=-1&&(val.length-1-indexStr>2)){
                $("#discountApplyModalForm "+domId).val(val.slice(0,indexStr+3));
            }
        }
    }
    //折扣申请弹窗关闭
    $('#discountApplyModal').on('hide.bs.modal', function () {
        $("#discountApplyModalForm #approveUser").val("请选择");
        $("#discountApplyModalForm #discount").val("");
        $("#discountApplyModalForm #discountRate").val("");
    })
    //获取已缴明细列表
    function getBillTable(){
        $('#billTable').bootstrapTable("destroy").bootstrapTable({
            url:'/charge/queryBill',
            method: 'get',
            dataType: "json",
            contentType: 'application/json',
            toolbar: '#toolbar',
            toggle:"table",
            sidePagination: "server",
            height:$(".content_bg_common").height()-70,
            pagination: true,
            pageNumber: 1,
            pageSize: 10,
            pageList: [10, 25,30],
            columns: [
                {
                    field: 'orderId',
                    title: '凭据号'
                },
                {
                    field: 'village',
                    title: '小区'
                },{
                    field: 'costNameStr',
                    title: '缴费项目',
                    cellStyle: {
                        css: {'padding': '0'}
                    }
                },{
                    field: 'costTypeStr',
                    title: '缴费类型',
                    cellStyle: {
                        css: {'padding': '0'}
                    }
                },{
                    field: 'costTypeClassStr',
                    title: '缴费大类',
                    cellStyle: {
                        css: {'padding': '0'}
                    }
                },{
                    field: 'costTypeSectionStr',
                    title: '缴费小类',
                    cellStyle: {
                        css: {'padding': '0'}
                    }
                },{
                    field: 'timeStr',
                    title: '费用所属时间',
                    cellStyle: {
                        css: {'padding': '0'}
                    },
                },{
                    field: 'payTime',
                    title: '缴费日期',
                },{
                    field: 'discountRateStr',
                    title: '折率(%)',
                    cellStyle: {
                        css: {'padding': '0'}
                    },
                },{
                    field: 'discountStr',
                    title: '折扣金额(单位:元)',
                    cellStyle: {
                        css: {'padding': '0'}
                    },
                },{
                    field: 'payStr',
                    title: '缴费金额(单位:元)',
                    cellStyle: {
                        css: {'padding': '0'}
                    },
                },{
                    field: 'paySum',
                    title: '总金额(单位:元)'
                },{
                    field: 'payType',
                    title: '支付方式'
                },{
                    field: 'remark',
                    title: '备注',
                    formatter:function (value,row,index){
                        if(row.payType=="混合支付")return value;
                        else return "";
                    }
                },{
                    field:'operate',
                    title: '操作',
                    formatter:function (value,row,index){
                    console.log(row,99)
                        var trId = row.orderId;
                        if(row.billType==0){
                            //if(row.refundFlag==0)var refundBtnStr='<@shiro.hasPermission name="charge:refund"><button onclick="refund(' + JSON.stringify(row).replace(/"/g, '&quot;') + ')" class="btn btn-xs btn-danger">退款审批</button></@shiro.hasPermission>';
                            //else if(row.refundFlag==1)var refundBtnStr='<@shiro.hasPermission name="charge:refund"><button class="btn btn-xs btn-danger" disabled>退款审批</button></@shiro.hasPermission>';
                            var refundBtnStr='';

                            var operateBtn = [
                                '<div>',
                                '<button class="btn btn-xs btn-primary" data-id="' + row.orderId + '" data-toggle="modal" data-target="#myModal" onclick="buildPdfData(\''+row.orderId+'\')">凭证打印</button>',
                                refundBtnStr,
                                '</div>'
                            ];
                        }else{
                            var operateBtn = [
                                '<div>',
                                '</div>'
                            ];
                        }
                        return operateBtn.join('');
                    }
                }
            ],
            rowStyle:function(row,index){
                if (row.billType!=0) {
                    return {
                        classes: "success"
                    };
                }
                return {};
            },
            queryParams:function (params){
                var formData=$("#searchForm").serializeObject();
                var param={
                    village:formData.village,
                    room:formData.room,
                    page:params.offset/params.limit +1,
                    pageSize:params.limit,
                }
                if(formData.building!="null")param.building=formData.building;
                if(formData.location!="null")param.location=formData.location;
                return param;
            },
            responseHandler:function (res){
            console.log(res,88)
                //渲染业户基本信息
                var chargeInfo = res.houseInfo.village + res.houseInfo.building + res.houseInfo.location + res.houseInfo.room + '，业主：' + res.houseInfo.ownerName + '，联系电话：' + res.houseInfo.ownerPhone;
                $('.charge_info').html(chargeInfo);
                var arr = res.pageInfo.list,tableList=new Array();
                arr.forEach(function (item,index){
                    var list = new Array(),propertyList = new Array(),carList = new Array();
                    var costNameStr="",costTypeStr="",costTypeClassStr="",costTypeSectionStr="",discountRateStr="",discountStr="",payStr="",timeStr="";
                    //分开处理物业费和车位费数据，方便后续单元格合并等渲染操作
                    item.billItemList.forEach(function (_item){
                        if(_item.costType=="物业费"&&_item.costTypeSection=="住宅"){
                            _item.houseId=res.houseInfo.houseId;
                            propertyList.push(_item);
                        }else{
                            //因小类为商铺的物业费、新增的押金类和一次性均不需合并相关单元格，故将数据放进车位费中一起处理
                            _item.houseId=res.houseInfo.houseId;
                            if(_item.costType=="物业费")carList.unshift(_item);
                            else carList.push(_item);
                        }
                    })
                    if(propertyList.length!=0){
                        list.push({property:propertyList});
                        //处理物业费的缴费项目、缴费大类、缴费小类、缴费金额、折率、折扣金额
                        propertyList.forEach(function (_item,_index){
                            if(_index==0)var styleP='pStyle';
                            else var styleP='pStyle pBorder';
                            costNameStr+="<p class='"+styleP+"'>"+_item.costName+"</p>";
                            payStr+="<p class='"+styleP+"'>"+_item.pay+"</p>";
                            discountRateStr+="<p class='"+styleP+"'>"+(_item.discountRate&&Number(_item.discountRate)!=0?_item.discountRate:"/")+"</p>";
                            discountStr+="<p class='"+styleP+"'>"+(_item.discount&&Number(_item.discount)!=0?_item.discount:"/")+"</p>";
                        })
                        //处理物业费的费用所属时间、缴费类型、大类、小类的合并
                        var timeHeight=propertyList.length*45-propertyList.length+"px";
                        timeStr+="<p style='margin:0;padding:0;height:"+timeHeight+";line-height:"+timeHeight+";'>"+propertyList[0].beginTime+"~"+propertyList[0].endTime+"</p>";
                        costTypeStr+="<p style='margin:0;padding:0;height:"+timeHeight+";line-height:"+timeHeight+";'>"+propertyList[0].costType+"</p>";
                        costTypeClassStr+="<p style='margin:0;padding:0;height:"+timeHeight+";line-height:"+timeHeight+";'>"+propertyList[0].costTypeClass+"</p>";
                        costTypeSectionStr+="<p style='margin:0;padding:0;height:"+timeHeight+";line-height:"+timeHeight+";'>"+propertyList[0].costTypeSection+"</p>";
                    }
                    if(carList.length!=0){
                        list.push({car:carList});
                        //处理车位费的缴费项目、缴费大类、缴费小类、缴费金额、费用所属时间、折率、折扣金额
                        carList.forEach(function (_item,_index){
                            if(propertyList.length==0&&_index==0)var styleP='pStyle';
                            else var styleP='pStyle pBorder';
                            if(_item.costType=="车位费"||_item.costType=="物业费"){
                                if(_item.costType=="车位费")costNameStr+="<p class='"+styleP+"'>"+_item.costName+_item.carId+(_item.licensePlateNo?"("+_item.licensePlateNo+")":"")+"</p>";
                                else costNameStr+="<p class='"+styleP+"'>"+_item.costName+"</p>";
                                costTypeClassStr+="<p class='"+styleP+"'>"+_item.costTypeClass+"</p>";
                                costTypeSectionStr+="<p class='"+styleP+"'>"+_item.costTypeSection+"</p>";
                                timeStr+="<p class='"+styleP+"'>"+_item.beginTime+"~"+_item.endTime+"</p>";
                            }else{
                                costNameStr+="<p class='"+styleP+"'>"+_item.costName+"</p>";
                                costTypeClassStr+="<p class='"+styleP+"'>/</p>";
                                costTypeSectionStr+="<p class='"+styleP+"'>/</p>";
                                timeStr+="<p class='"+styleP+"'>/</p>";
                            }
                            costTypeStr+="<p class='"+styleP+"'>"+_item.costType+"</p>";
                            payStr+="<p class='"+styleP+"'>"+_item.pay+"</p>";
                            discountRateStr+="<p class='"+styleP+"'>"+(_item.discountRate&&Number(_item.discountRate)!=0?_item.discountRate:"/")+"</p>";
                            discountStr+="<p class='"+styleP+"'>"+(_item.discount&&Number(_item.discount)!=0?_item.discount:"/")+"</p>";
                        })
                    }
                    //处理支付方式
                    if(item.payType==0)item.payType="线上支付";
                    if(item.payType==1)item.payType="现金支付";
                    if(item.payType==2)item.payType="刷卡支付";
                    if(item.payType==3)item.payType="混合支付";

                    item.village=res.houseInfo.village;
                    item.costNameStr=costNameStr;
                    item.costTypeStr=costTypeStr;
                    item.costTypeClassStr=costTypeClassStr;
                    item.costTypeSectionStr=costTypeSectionStr;
                    item.payStr=payStr;
                    item.timeStr=timeStr;
                    item.discountRateStr=discountRateStr;
                    item.discountStr=discountStr;
                    item.list=list;
                    tableList.push(item);
                })
                return{
                    "total":res.pageInfo.total,
                    "rows":tableList
                }
            }
        })
    }
    /*查询凭证*/
    function buildPdfData(data){
        $.ajax({
            url: "/pdf/buildPdfData",
            type: "get",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            data:{orderId:data},
            success: function(res){
                billData(res,true);
            },
            error: function(error){

            }
        });
    }
    /*打印凭证*/
    function printBill(){
        printJS({
            printable: 'printInfo',
            type: 'html',
            scanStyles:false,
            css:'assets/css/bill.css'
        })
    }
    //点击退款审批按钮，进入退款审批页面
    function refund(row) {
        approveUserList(row);
        $("#approvalModalForm #applyUser").val("${user.username}");
        refundBeginTimeInputArr=new Array();
        mergeCellRefundPropArr=new Array();
        var list=new Array();
        row.list.forEach(function(item,index){
            var itemKey=Object.keys(item)[0];
            if(itemKey=="property"){
                item[itemKey].forEach(function(_item,_index){
                    _item.checkbox=false;
                    _item.domId="reFundCostId"+_index+_item.costId;//开始日期input的id名
                    _item.orginTime=_item.beginTime;//缴费总时间段的开始日期
                    _item.initPay=_item.pay;//记录该缴费项目 缴费总时间段的总金额
                    _item.maxPay=_item.pay;//记录该缴费项目最大的退款金额
                    _item.inputPay="";//input中的退款金额
                    _item.isShowPay=false;//是否显示欠费金额，初始化时不显示、改变日期时不显示
                    if(_index==0)_item.pushFlag=true;//pushFlag用来判断是否将该条数据push进refundBeginTimeInputArr中，实例化物业费的layDate使用
                    else _item.pushFlag=false;
                    list.push(_item);
                })
            }else if(itemKey=="car"){
                item[itemKey].forEach(function(_item,_index){
                    _item.checkbox=false;
                    _item.domId="reFundCostId"+_index+_item.costId;
                    _item.orginTime=_item.beginTime;
                    _item.initPay=_item.pay;
                    _item.maxPay=_item.pay;
                    _item.isShowPay=false;
                    _item.pushFlag=true;
                    if(_item.costType=="押金类"||item.costType=="一次性")_item.inputPay=_item.pay;
                    else _item.inputPay="";
                    list.push(_item);
                })
            }
        })
        list=list.map(function(item,index){
            item.rowIndex=index;
            item.paySum=row.paySum;
            if(item.pushFlag==true)refundBeginTimeInputArr.push(item);
            if(item.costType=="物业费")mergeCellRefundPropArr.push(item.rowIndex);
            return item;
        })
        refundListLength=list.length;
        $("#tableRefund").bootstrapTable("destroy").bootstrapTable({
            data:list,
            uniqueId:"rowIndex",
            columns:[
                {
                    checkbox: true,
                    field: 'checkbox',
                    formatter: function(code, row, index) {
                        return {checked:code};
                    }
                },{
                    field: 'costName',
                    title: '缴费项目',
                    formatter: function(code, row, index) {
                        if(row.costType=="车位费")return code+(row.carId?row.carId:"")+(row.licensePlateNo?"("+row.licensePlateNo+")":"");
                        else return code;
                    }
                },{
                    field: 'costType',
                    title: '缴费类型',
                },{
                    field: 'costTypeClass',
                    title: '缴费大类',
                    formatter: function(code, row, index) {
                        if(row.costType=="押金类"||row.costType=="一次性")return "/";
                        else return code;
                    }
                },{
                    field: 'costTypeSection',
                    title: '缴费小类',
                    formatter: function(code, row, index) {
                        if(row.costType=="押金类"||row.costType=="一次性")return "/";
                        else return code;
                    }
                },{
                    field: 'beginTime',
                    title: '选择退款日期',
                    formatter: function(code, row, index) {
                        if(row.costType=="押金类"||row.costType=="一次性")return "/";
                        else return '<input readonly="readonly" type="text" value="'+row.beginTime+'" id="'+row.domId+'" class="form-control" style="width: 100px"/>'+" ~ "+row.endTime;
                    }
                },{
                    field: 'unit',
                    title: '单价',
                    formatter:function (code, row, index) {
                        if(row.costType=="物业费"){
                            return code+"元／(㎡<span style='font-weight: bolder;'>·</span>月)"
                        }else if(row.costType=="车位费"){
                            return code+"元／月"
                        }else return code+"元"
                    }
                },{
                    field: 'paySum',
                    title: '总金额(单位:元)',
                },{
                    field: 'inputPay',
                    title: '退款金额(单位:元)',
                    formatter: function(code, row, index) {
                        if(row.costType=="押金类"||row.costType=="一次性")return row.pay;
                        else return '<input type="text" class="form-control" id="refundPay'+row.rowIndex+'" value="'+code+'" placeholder="最大金额不超过'+row.maxPay+'" style="width: 200px" oninput="refundPayInput(' + JSON.stringify(row).replace(/"/g, '&quot;') + ')"autocomplete="off"/>';
                    }
                }
            ],
            pagination: false,
            onCheck:function(row, $element){
                if(row.costType=="物业费"){
                    mergeCellRefundPropArr.forEach(function(item,index){
                        $('#tableRefund').bootstrapTable('updateCell', {
                            index: item,
                            field: "checkbox",
                            value: true
                        })
                    })
                }
                refundBeginTimeInputArr.forEach(function(item,index){
                    initRefundBeginTime($('#tableRefund').bootstrapTable('getRowByUniqueId',item.rowIndex));
                })
                $('#tableRefund').bootstrapTable('mergeCells', {index: 0, field: "beginTime", rowspan: mergeCellRefundPropArr.length});
                $('#tableRefund').bootstrapTable('mergeCells', {index: 0, field: "checkbox", rowspan: mergeCellRefundPropArr.length});
                $('#tableRefund').bootstrapTable('mergeCells', {index: 0, field: "paySum", rowspan: refundListLength});
            },
            onUncheck:function(row, $element){
                if(row.costType=="物业费"){
                    mergeCellRefundPropArr.forEach(function(item,index){
                        $('#tableRefund').bootstrapTable('updateCell', {
                            index: item,
                            field: "checkbox",
                            value: false
                        })
                    })
                }
                refundBeginTimeInputArr.forEach(function(item,index){
                    initRefundBeginTime($('#tableRefund').bootstrapTable('getRowByUniqueId',item.rowIndex));
                })
                $('#tableRefund').bootstrapTable('mergeCells', {index: 0, field: "beginTime", rowspan: mergeCellRefundPropArr.length});
                $('#tableRefund').bootstrapTable('mergeCells', {index: 0, field: "checkbox", rowspan: mergeCellRefundPropArr.length});
                $('#tableRefund').bootstrapTable('mergeCells', {index: 0, field: "paySum", rowspan: refundListLength});
            },
            onCheckAll: function (rowsAfter,rowsBefore) {},
            onUncheckAll: function (rowsAfter,rowsBefore) {},
        })
        refundBeginTimeInputArr.forEach(function(item,index){
            initRefundBeginTime(item);
        })
        $('#tableRefund').bootstrapTable('mergeCells', {index: 0, field: "beginTime", rowspan: mergeCellRefundPropArr.length});
        $('#tableRefund').bootstrapTable('mergeCells', {index: 0, field: "checkbox", rowspan: mergeCellRefundPropArr.length});
        $('#tableRefund').bootstrapTable('mergeCells', {index: 0, field: "paySum", rowspan: refundListLength});
        $('.charge_manage_refund').css('display', 'block');
    }
    //初始化退款中的layDate组件
    function initRefundBeginTime(data){
        laydate.render({
            elem: "#"+data.domId,
            min:(data.costType=="车位费"&&data.costTypeClass=="租赁")?data.orginTime:data.orginTime+"-01",
            max:(data.costType=="车位费"&&data.costTypeClass=="租赁")?data.endTime:data.endTime+"-28",
            type:(data.costType=="车位费"&&data.costTypeClass=="租赁")?"date":"month",
            done: function(value, date, endDate){
                if(data.costType=="物业费"){
                    mergeCellRefundPropArr.forEach(function(item,index){
                        $('#tableRefund').bootstrapTable('updateCell', {index: item,field: "beginTime",value: value});
                        reFundBeginTimeMoney($('#tableRefund').bootstrapTable('getRowByUniqueId',item));
                    })
                }else{
                    $('#tableRefund').bootstrapTable('updateCell', {index: data.rowIndex,field: "beginTime",value: value});
                    reFundBeginTimeMoney($('#tableRefund').bootstrapTable('getRowByUniqueId',data.rowIndex));
                }
                //注意：更新单元格后，需重新执行合并单元格，否则合并效果会丢失
                $('#tableRefund').bootstrapTable('mergeCells', {index: 0, field: "beginTime", rowspan: mergeCellRefundPropArr.length});
                $('#tableRefund').bootstrapTable('mergeCells', {index: 0, field: "checkbox", rowspan: mergeCellRefundPropArr.length});
                $('#tableRefund').bootstrapTable('mergeCells', {index: 0, field: "paySum", rowspan: refundListLength});
            }
        })
    }
    //退款页面，切换退款开始时间,查询金额
    function reFundBeginTimeMoney(data){
        var params={
            orginTime: data.orginTime,
            beginTime:data.beginTime,
            endTime:data.endTime,
            pay:data.initPay,
            costName:data.costName,
            costTypeClass:data.costTypeClass,
            costTypeSection:data.costTypeSection
        }
        $.ajax({
            url: '/charge/countRefundMoney',
            type: "post",
            dataType: "json",
            contentType:'application/json;charset=UTF-8',
            data: JSON.stringify(params),
            success: function (res) {
                $('#tableRefund').bootstrapTable('updateCell', {index: data.rowIndex,field: "pay",value: res});
                $('#tableRefund').bootstrapTable('updateCell', {index: data.rowIndex,field: "maxPay",value: res});
                $('#tableRefund').bootstrapTable('updateCell', {index: data.rowIndex,field: "inputPay",value: ""});
                $('#tableRefund').bootstrapTable('updateCell', {index: data.rowIndex,field: "isShowPay",value: false});
                refundBeginTimeInputArr.forEach(function(item,index){
                    initRefundBeginTime($('#tableRefund').bootstrapTable('getRowByUniqueId',item.rowIndex));
                })
                $('#tableRefund').bootstrapTable('mergeCells', {index: 0, field: "beginTime", rowspan: mergeCellRefundPropArr.length});
                $('#tableRefund').bootstrapTable('mergeCells', {index: 0, field: "checkbox", rowspan: mergeCellRefundPropArr.length});
                $('#tableRefund').bootstrapTable('mergeCells', {index: 0, field: "paySum", rowspan: refundListLength});
            },
            error: function (error) {}
        });
    }
    //输入退款金额
    function refundPayInput(data) {
        //处理输入的退款金额为非数字的情况
        if(isNaN($("#refundPay"+data.rowIndex).val())==true){
            $("#refundPay"+data.rowIndex).val("");
        }else if(Number($("#refundPay"+data.rowIndex).val())>Number(data.maxPay)){
            $("#refundPay"+data.rowIndex).val(data.maxPay);
        }else if(Number($("#refundPay"+data.rowIndex).val())<0){
            $("#refundPay"+data.rowIndex).val("");
        }else{
            var val= $("#refundPay"+data.rowIndex).val();
            var indexStr=val.indexOf(".");
            if(indexStr!=-1&&(val.length-1-indexStr>2)){
                $("#refundPay"+data.rowIndex).val(val.slice(0,indexStr+3));
            }
        }
        //更新退款金额单元格的数据
        $('#tableRefund').bootstrapTable('updateCell', {index: data.rowIndex,field: "inputPay",value: $("#refundPay"+data.rowIndex).val()});
        $('#tableRefund').bootstrapTable('updateCell', {index: data.rowIndex,field: "isShowPay",value: true});
        refundBeginTimeInputArr.forEach(function(item,index){
            initRefundBeginTime(item);
        })
        $('#tableRefund').bootstrapTable('mergeCells', {index: 0, field: "beginTime", rowspan: mergeCellRefundPropArr.length});
        $('#tableRefund').bootstrapTable('mergeCells', {index: 0, field: "checkbox", rowspan: mergeCellRefundPropArr.length});
        $('#tableRefund').bootstrapTable('mergeCells', {index: 0, field: "paySum", rowspan: refundListLength});
        //光标自动聚焦，且至于文字最右
        $("#refundPay"+data.rowIndex).focus();
        var strLength=$("#refundPay"+data.rowIndex).val().length;
        document.getElementById("refundPay"+data.rowIndex).setSelectionRange(strLength, strLength);
    }
    //提交退款审批
    function depositRefundApply() {
        var reFundList=$("#tableRefund").bootstrapTable('getSelections'),list=new Array();
        if(reFundList.length==0){
            layer.alert("请选择退款项！",{title:"警告"});
            return;
        }else{
            for(var i=0;i<reFundList.length;i++){
                if(reFundList[i].costType!="押金类"&&reFundList[i].costType!="一次性"&&reFundList[i].inputPay==""){
                    layer.alert("请输入退款金额！",{title:"警告"});
                    return;
                }
            }
        }
        var paySum=reFundList.reduce(function(prev, cur){
            if(cur.costType!="押金类"&&cur.costType!="一次性")return Number(cur.inputPay)+prev;
            else return Number(cur.unit)+prev;
        }, 0);
        reFundList.forEach(function(item,index){
            var obj={
                costId:item.costId,
                costName:item.costName,
                costTypeClass:item.costTypeClass,
                costTypeSection:item.costTypeSection,
                costType:item.costType,
                beginTime:item.beginTime,
                endTime:item.endTime,
                unit:item.unit,
                pay:(item.costType!="押金类"&&item!="一次性")?Number(item.inputPay):Number(item.unit),
            }
            if(item.costType=="物业费")obj.area=item.area;
            else if(item.costType=="车位费"){
                obj.carId=item.carId;
                obj.licensePlateNo=item.licensePlateNo;
            }
            list.push(obj);
        })
        var params={
            orderId:reFundList[0].orderId,
            houseId:reFundList[0].houseId,
            costId:reFundList[0].costId,
            applyUser:"${user.username}",
            refundType:$("#approvalModalForm #refundType").val(),
            approveUser:$("#approvalModalForm #approveUser").val(),
            paySum:paySum,
            billItemList:list
        }
        console.log(params,12)
        $.ajax({
            url: '/approval/addRefundApply',
            type: "post",
            dataType: "json",
            contentType:'application/json;charset=UTF-8',
            data: JSON.stringify(params),
            success: function (res) {
                if(res.code==200||res.code==500){
                    layer.alert(res.msg,{title:res.code==200?"提示":"警告"});
                }else layer.alert("申请失败！",{title:"警告"});
                $('.charge_manage_refund').css('display', 'none');
                $("#billTable").bootstrapTable('refresh');
                $('#billTable').bootstrapTable('resetView');
            },
            error: function (error) {
                layer.alert("申请失败！",{title:"警告"});
                $('.charge_manage_refund').css('display', 'none');
                $("#billTable").bootstrapTable('refresh');
                $('#billTable').bootstrapTable('resetView');
            }
        });
    }
    //关闭退款页面
    function closeRefund() {
        refundListLength=0;
        $("#approvalModalForm #approveUser").val("请选择");
        $("#approvalModalForm #refundType").val("请选择");
        $('.charge_manage_refund').css('display', 'none')
    }
    /*动态设置table的高度*/
    window.onresize=function () {
        $("#billTable").bootstrapTable('resetView', {
            height: $(".content_bg_common").height()-70
        });
    }
    /*websocket*/
    function openWebsocket() {
        var websocket = null;
        // var wsUrl="//18.35.240.8:8099/websocket";//测试环境
        //var wsUrl="//180.101.149.61:8099/websocket";//生产ip金佳
        var wsUrl="//101.34.133.117:9000/websocket";//金华测试环境
        //var wsUrl="43.143.61.171:9000/websocket";//生产婺城城投
        if('WebSocket' in window) {
            websocket = new WebSocket("ws:"+wsUrl);
        } else if('MozWebSocket' in window) {
            websocket = new MozWebSocket("ws:"+wsUrl);
        } else {
            websocket = new SockJS(wsUrl);
        }

        //连接发生错误的回调方法
        websocket.onerror = function () {
            console.log("WebSocket连接发生错误");
        };

        //连接成功建立的回调方法
        websocket.onopen = function () {
            console.log("WebSocket连接成功");
        }

        //接收到消息的回调方法
        websocket.onmessage = function (event) {
            layer.alert("缴费成功！",{title:"提示"});
            $('#myModaltwo').modal('hide')
            $('#myModaltwo #codeImg').html('')
            paySuccessReset();
        }

        //连接关闭的回调方法
        websocket.onclose = function () {
            // setMessageInnerHTML("WebSocket连接关闭");
        }
        //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
        window.onbeforeunload = function () {
            closeWebSocket();
        }
        //关闭WebSocket连接
        function closeWebSocket() {
            websocket.close();
        }
    }

</script>
<style>
    #codeImg{
        width: 300px;
        height: 300px;
        text-align: center;
        margin: 10px auto;
    }
</style>