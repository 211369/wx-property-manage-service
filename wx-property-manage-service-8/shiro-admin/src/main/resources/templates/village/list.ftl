<#include "/layout/header.ftl"/>
<div class="row content_bg_common" style="padding: 0 10px;">
    <div class="hidden-xs" id="toolbar">

            <button id="btn_add" type="button" class="btn btn-sm btn-primary" title="新增小区">
                <i class="fa fa-plus"></i> 新增配置
            </button>
    </div>
    <table id="tablelist">
    </table>
<div class="modal fade" id="addOrUpdateModal" tabindex="-1" role="dialog" aria-labelledby="addroleLabel">
 <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="addroleLabel">添加配置链接</h4>
            </div>
            <div class="modal-body">
                <form id="addOrUpdateForm" class="form-horizontal form-label-left" novalidate>
                    <input type="hidden" name="id">
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="village">选择小区:<span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <select id="villageSelect" name="villageName" required="required" class="form-control col-md-7 col-xs-12">
                                <option value="">请选择</option>
                            </select>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="shopCode">门店编号: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-7 col-xs-12" name="shopCode" id="shopCode" required="required" placeholder="请输入门店编号"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="staffCode">店员编号: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-7 col-xs-12" name="staffCode" id="staffCode" required="required" placeholder="请输入店员编号"/>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                        <button type="button" class="btn btn-primary addOrUpdateBtn">保存</button>
                    </div>
                </form>
            </div>
        </div>
 </div>
</div>
</div>
<#include "/layout/footer.ftl"/>
<script>
    /**
     * 操作按钮
     * @param code
     * @param row
     * @param index
     * @returns {string}
     */
    function operateFormatter(code, row, index) {
        var trId = row.id;
        var operateBtn = [
            '<@shiro.hasPermission name="resource:edit"><a class="btn btn-xs btn-primary btn-update" data-id="' + trId + '"><i class="fa fa-edit"></i>编辑</a></@shiro.hasPermission>',
            '<@shiro.hasPermission name="resource:delete"><a class="btn btn-xs btn-danger btn-remove" data-id="' + trId + '"><i class="fa fa-trash-o"></i>删除</a></@shiro.hasPermission>'
        ];
        return operateBtn.join('');
    }
    $(function () {
        var options = {
            url: "/village/list",
            getInfoUrl: "/village/get/{id}",
            updateUrl: "/village/edit",
            removeUrl: "/village/remove",
            createUrl: "/village/add",
            saveRolesUrl: "/village/saveRoleResources",
            columns: [{
                field: 'villageName',
                title: '小区名',
                editable: true
            },{
                field: 'shopCode',
                title: '门店号',
                editable: true
            },{
                field: 'staffCode',
                title: '店员号',
                editable: true
            },{
                field: 'operate',
                title: '操作',
                formatter: operateFormatter //自定义方法，添加操作按钮
            }],
            modalName: "小区"
        }
        //1.初始化Table
        $.tableUtil.init(options);
        //2.初始化Button的点击事件
        $.buttonUtil.init(options);
        $("table").bootstrapTable('resetView', {
            height: $(".content_bg_common").height()-20
        });
    });
    /*动态设置table的高度*/
    window.onresize=function () {
        $("table").bootstrapTable('resetView', {
            height: $(".content_bg_common").height()-20
        });
    }

    $(function(){
        var url="/charge/queryVillage",obj;
        $.ajax({
                url: url,
                type: "get",
                success: function(res){
                    obj+="<option value=''>请选择</option>"
                    if(res&&res.length!=0){
                        res.forEach(function(item,index){
                            obj+="<option value='"+item+"'>"+item+"</option>"
                        })
                        $("#villageSelect").html(obj);
                        $("#villageSelect").selectpicker('refresh');
                        if(res.length==1){
                            $("#searchForm #"+type).val(res[0])
                            $("#searchForm #"+type).trigger("change");//手动改变select的值，不会触发change事件，故执行该语句
                        }else{
                        }
                    }else $("villageSelect").html(obj);
                },
                error: function(error){
                    $("villageSelect").html(obj);
                }
            });
    })

    $("#villageSelect").change(function(event){
    })
</script>