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
            <div class="item form-group col-md-2 col-sm-2">
                <label class="col-md-4 col-sm-4 control-label" for="payBegin">查询时间:</label>
                <div class="col-md-8 col-sm-8 col-xs-12">
                    <input type="text" readonly="readonly" class="form-control col-md-12 col-xs-12" name="payBegin" id="payBegin" placeholder="请选择查询时间" autocomplete="off"/>
                </div>
            </div>
            <div class="item form-group col-md-4 col-sm-4 col-xs-4" style="margin-top: 2px;">
                <div class="col-md-12 col-sm-12 col-xs-12">
                    <button type="button" class="btn btn-sm btn-primary" onclick="getParkingFee()"  style="margin-left: 10px;"><i class="glyphicon glyphicon-search"></i>查询</button>
                    <button type="button" class="btn btn-sm btn-primary" onclick="exportDetail()"  style="margin-left: 10px;"><i class="glyphicon glyphicon-download-alt"></i>导出</button>
                </div>
            </div>
        </form>
        <table id="parkingFeeTable"></table>
    </div>
</div>
<#include "/layout/footer.ftl"/>
<script src="/assets/js/xlsx.core.min.js"></script>
<script>
    $(function () {
        searchVillage();
        initLayDate();
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
                getParkingFee();
            },
            error: function(error){
                $("#searchForm #villageName").html(obj);
                getParkingFee();
            }
        });
    }
    //初始化查询时间layDate组件
    function initLayDate() {
        $("#payBegin").val(new Date().getFullYear());
        laydate.render({
            elem: '#payBegin',
            type:"year",
            btns: ['now','confirm']
        });
    }
    //查询车位费列表列表
    function getParkingFee() {
        $("#parkingFeeTable").bootstrapTable("destroy").bootstrapTable({
            url:"/report/queryCarBillPage",
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
                    field: 'carNo',
                    title: '车位号',
                },{
                    field: 'licensePlateNo',
                    title: '车牌号',
                },{
                    field: 'unit',
                    title: '单价(单位：元/月)',
                },{
                    field: 'beginTime',
                    title: '费用周期',
                },{
                    field: 'paySum',
                    title: '缴费金额(单位：元)',
                },{
                    field: 'payTime',
                    title: '缴费时间',
                }
            ],
            height:$(".content_bg_common").height()-$("#searchForm").height()-25,
            queryParams: function(param){
                var params={
                    pageNumber:param.offset/param.limit +1,
                    pageSize:param.limit,
                    village:$("#searchForm #villageName").val(),
                    payBegin:$("#payBegin").val()+"-01",
                    payEnd:$("#payBegin").val()+"-12",
                };
                return params;
            },
            formatLoadingMessage: function(){
                return "正在加载中。。。";
            },
            responseHandler:function (res) {
                var list=new Array();
                if(res&&res.list&&res.list.length!=0){
                    list=res.list.map(function (item, index) {
                        item.house=item.village+item.building+item.location+item.room;
                        if(!item.paySum)item.paySum="";
                        if(!item.payTime)item.payTime="";
                        if(!item.beginTime)item.beginTime="";
                        return item;
                    })
                }
                return{
                    "total":res.total,
                    "rows":list
                }
            },
        })
    }
    /*导出明细*/
    function exportDetail(){
        var params={
            village:$("#searchForm #villageName").val(),
            payBegin:$("#payBegin").val()+"-01",
            payEnd:$("#payBegin").val()+"-12",
        };
        $.ajax({
            url: "/report/queryCarBillAll",
            type: "post",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            data:JSON.stringify(params),
            async:false,
            success: function(res){
                if(res){
                    if(res.length==0){
                        layer.alert("查询数据为空，导出失败！",{title:"警告"});
                    }else{
                        var list=res.map(function (item, index) {
                            var obj={
                                "房屋":item.village+item.building+item.location+item.room,
                                "车位号":item.carNo,
                                "车牌号":item.licensePlateNo,
                                "单价(单位：元/月)":item.unit,
                                "费用周期":item.beginTime?item.beginTime:"",
                                "缴费金额(单位：元)":item.paySum?item.paySum:"",
                                "缴费时间":item.payTime?item.payTime:"",
                            }
                            return obj;
                        })
                        var data={
                            data:list,
                            fileName:"车位费收缴明细",
                            wpx:[{wpx: 130},{wpx: 100},{wpx: 100},{wpx: 130},{wpx: 120},{wpx: 120},{wpx: 130}]
                        }
                        downloadExcel(new Array(data),"车位费收缴明细");
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
        $("#parkingFeeTable").bootstrapTable('resetView', {
            height:$(".content_bg_common").height()-$("#searchForm").height()-25,
        });
    }
</script>