<#include "/layout/header.ftl"/>
<div class="clearfix"></div>
<div class="row content_bg_common" style="padding:0 10px;">
    <div class=" hidden-xs" id="toolbar">
        <@shiro.hasPermission name="role:add">
            <button id="btn_add" type="button" class="btn btn-sm btn-primary" title="新增角色">
                <i class="fa fa-plus"></i> 新增角色
            </button>
        </@shiro.hasPermission>
        <@shiro.hasPermission name="role:batchDelete">
            <button id="btn_delete_ids" type="button" class="btn btn-sm btn-primary" title="删除选中" style="margin-left: 10px;">
                <i class="fa fa-trash-o"></i> 批量删除
            </button>
        </@shiro.hasPermission>
    </div>
    <table id="tablelist"></table>
</div>
<#include "/layout/footer.ftl"/>
<!--分配资源权限弹框-->
<div class="modal fade bs-example-modal-sm" id="selectRole" tabindex="-1" role="dialog" aria-labelledby="selectRoleLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="selectRoleLabel">分配资源权限</h4>
            </div>
            <div class="modal-body">
                <form id="boxRoleForm">
                    <div class="zTreeDemoBackground left">
                        <ul id="treeDemo" class="ztree"></ul>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>
<!--分配资源权限弹框-->
<!--添加角色弹框-->
<div class="modal fade" id="addOrUpdateModal" tabindex="-1" role="dialog" aria-labelledby="addroleLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="addroleLabel">添加角色</h4>
            </div>
            <div class="modal-body">
                <form id="addOrUpdateForm" class="form-horizontal form-label-left" novalidate>
                    <input type="hidden" name="id">
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="description">角色名称: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-7 col-xs-12" name="description" id="description" required="required" placeholder="请输入角色名称"/>
                        </div>
                    </div>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="available">是否可用: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <select name="available" id="available" required="required" class="form-control col-md-7 col-xs-12">
                                <option value="">请选择</option>
                                <option value="0">不可用</option>
                                <option value="1" selected="selected">可用</option>
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary addOrUpdateBtn">保存</button>
            </div>
        </div>
    </div>
</div>
<!--/添加角色弹框-->
<!--社区绑定弹框-->
<div class="modal fade bs-example-modal-sm" id="selectVillage" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="selectRoleLabel">社区绑定</h4>
            </div>
            <div class="modal-body">
                <form id="boxVillageForm">
                    <div class="zTreeDemoBackground left">
                        <ul id="villageTreeDemo" class="ztree"></ul>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>
<!--社区绑定弹框-->
<script>
    console.log('${user.username}')
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
            '<@shiro.hasPermission name="role:edit"><a class="btn btn-xs btn-primary btn-update" data-id="' + trId + '"><i class="fa fa-edit"></i>编辑</a></@shiro.hasPermission>',
            '<@shiro.hasPermission name="role:delete"><a class="btn btn-xs btn-danger btn-remove" data-id="' + trId + '"><i class="fa fa-trash-o"></i>删除</a></@shiro.hasPermission>',
            '<@shiro.hasPermission name="role:allotResource"><a class="btn btn-xs btn-info btn-allot" data-id="' + trId + '"><i class="fa fa-circle-thin"></i>分配资源</a></@shiro.hasPermission>',
            '<a class="btn btn-xs btn-info btn-build" data-id="' + trId + '"><i class="fa fa-circle-thin"></i>社区绑定</a>'
        ];
        if('${user.username}'=="root")return operateBtn.join("");
        else if('${user.username}'=="admin"){
            if(row.name!="role:admin")return operateBtn.join("");
            else return "";
        }else return "";
    }

    $(function () {
        var options = {
            url: "/roles/list",
            getInfoUrl: "/roles/get/{id}",
            updateUrl: "/roles/edit",
            removeUrl: "/roles/remove",
            createUrl: "/roles/add",
            saveRolesUrl: "/roles/saveRoleResources",
            buildVillageUrl:"/roles/buildVillage",
            columns: [{
                checkbox: true
            }, {
                field: 'description',
                title: '角色名',
                editable: false,
            }, {
                field: 'available',
                title: '是否可用',
                editable: true,
                formatter: function (code) {
                    return code ? '可用' : '不可用';
                }
            }, {
                field: 'operate',
                title: '操作',
                formatter: operateFormatter //自定义方法，添加操作按钮
            }],
            modalName: "角色",
        };
        //1.初始化Table
        $.tableUtil.init(options);
        //2.初始化Button的点击事件
        $.buttonUtil.init(options);

        $("table").bootstrapTable('resetView', {
            height: $(".content_bg_common").height()-20
        });
        /* 分配资源权限 */
        $('#tablelist').on('click', '.btn-allot', function () {
            var $this = $(this);
            var rolesId = $this.attr("data-id");
            $.ajax({
                async: false,
                type: "POST",
                data: {rid: rolesId},
                url: '/resources/resourcesWithSelected',
                dataType: 'json',
                success: function (json) {
                    var data = json.data;
                    var setting = {
                        check: {
                            enable: true,
                            chkboxType: {"Y": "ps", "N": "ps"},
                            chkStyle: "checkbox"
                        },
                        data: {
                            simpleData: {
                                enable: true
                            }
                        },
                        callback: {
                            onCheck: function (event, treeId, treeNode) {
                                console.log(treeNode.tId + ", " + treeNode.name + "," + treeNode.checked);
                                var treeObj = $.fn.zTree.getZTreeObj(treeId);
                                var nodes = treeObj.getCheckedNodes(true);
                                var ids = new Array();
                                for (var i = 0; i < nodes.length; i++) {
                                    //获取选中节点的值
                                    ids.push(nodes[i].id);
                                }
                                console.log(ids);
                                console.log(rolesId);
                                $.post(options.saveRolesUrl, {"roleId": rolesId, "resourcesId": ids.join(",")}, function (obj) { }, 'json');
                            }
                        }
                    };
                    var tree = $.fn.zTree.init($("#treeDemo"), setting, data);
                    tree.expandAll(true);//全部展开
                    $('#selectRole').modal('show');
                }
            });
        });
        /*社区绑定*/
        $('#tablelist').on('click', '.btn-build', function (){
            var $this = $(this);
            var rolesId = $this.attr("data-id");
            $.ajax({
                async: false,
                type: "GET",
                url: '/roles/queryBuildVillage?roleId='+rolesId,
                success: function (res) {
                    if(res.status==200&&res.data.length!=0){
                        var data=res.data;
                        var setting = {
                            check: {
                                enable: true,
                            },
                            data: {
                                simpleData: {
                                    enable: true
                                }
                            },
                            callback: {
                                onCheck: function (event, treeId, treeNode) {
                                    var treeObj = $.fn.zTree.getZTreeObj(treeId);
                                    var nodes = treeObj.getCheckedNodes(true);
                                    var names = new Array();
                                    for (var i = 0; i < nodes.length; i++) {
                                        names.push(nodes[i].name);
                                    }
                                    var params={"roleId": rolesId, "villages": names};
                                    $.ajax({
                                        url: options.buildVillageUrl,
                                        type: "post",
                                        dataType: "json",
                                        contentType: "application/json; charset=utf-8",
                                        data:JSON.stringify(params),
                                        success: function(res){},
                                        error: function(error){}
                                    });
                                }
                            }
                        };
                        var tree = $.fn.zTree.init($("#villageTreeDemo"), setting, data);
                        tree.expandAll(true);//全部展开
                        $('#selectVillage').modal('show');
                    }else{
                        layer.alert("社区查询结果为空！",{title:"提示"});
                    }
                },
                error:function (error) {
                    layer.alert("社区查询结果为空！",{title:"提示"});
                }
            });
        })
    });
    /*动态设置table的高度*/
    window.onresize=function () {
        $("table").bootstrapTable('resetView', {
            height: $(".content_bg_common").height()-20
        });
    }
</script>