<#include "/layout/header.ftl"/>
<div class="clearfix"></div>
<div class="row content_bg_common">
    <div class="col-md-12 col-sm-12 col-xs-12 user_set">
        <h1>安全设置</h1>
        <div class="user_set_flex">
            <div class="user_set_flex_msg">
                <p>安全设置</p>
                <p>设置高强度密码防止账号被他人使用</p>
            </div>
            <div class="user_set_flex_revise" data-toggle="modal" data-target="#myModal">修改密码</div>
        </div>
    </div>
</div>
<div class="modal fade" id="myModal" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="addroleLabel">修改密码</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal form-label-left" id="updatePwd" novalidate>
                    <div class="item form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="password">新密码: <span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" class="form-control col-md-7 col-xs-12" id="password" name="password" required="required" placeholder="请输入新密码"/>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" onclick="resetPwd()">保存</button>
            </div>
        </div>
    </div>
</div>
<#include "/layout/footer.ftl"/>
<script>
    function resetPwd() {
        if(validator.checkAll($("#updatePwd"))){
            $.post("/user/resetPwd",{password:$("#password").val()},function (res) {
                if(res.status==200)$.tool.alert(res.message);
                else if(res.status==500)$.tool.alertError(res.message);
                else $.tool.alertError("修改失败");
                $('#myModal').modal('hide');
            })
        }
    }
    $('#myModal').on('hide.bs.modal',function() {
        document.getElementById("updatePwd").reset();
        $(".form-group").removeClass("bad");
        $(".form-group .alert").remove();
    })

</script>