<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>登录 | 物业收费管理系统</title>
    <link href="/assets/images/property.ico" rel="icon">
    <link href="/assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="/assets/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <link href="/assets/css/jquery-confirm.min.css" rel="stylesheet">
    <link href="/assets/css/nprogress.min.css" rel="stylesheet">
    <link href="/assets/css/zhyd.core.css" rel="stylesheet">
    <style>
        .modal.fade .modal-dialog{
            transition: none;
            position: absolute;
            top: 0;
            left: 50%;
        }
        .modal-content{
            background-color:transparent;
            border:none;
            box-shadow:none;
            padding: 10px;
            background-color: #fff;
        }
        .modal-backdrop{
            background: url("/assets/images/login_bg.jpg");
            background-size: 100% 100%;
        }
        .modal-backdrop.in{
            opacity: 1;
        }
        .form-control{
            font-size: 13px;
            height: 40px;
            border:none;
            box-shadow:none;
            -webkit-box-shadow:none;
        }
        .login_content{
            text-shadow: none;
        }
        .login_content h1{
            font-size: 38px;
        }
        .login_content form input[type=text], .login_content form input[type=email], .login_content form input[type=password] {
            width: 70%;
            -ms-box-shadow: none;
            -o-box-shadow: none;
            box-shadow: none;
            border: none;
        }
        .login_content form input[type=text]:focus, .login_content form input[type=email]:focus, .login_content form input[type=password]:focus {
            -ms-box-shadow: none;
            -o-box-shadow: none;
            box-shadow: none;
            border: none;
            outline: none;
        }
        .login_content form input[type=text]:-webkit-autofill, .login_content form input[type=email]:-webkit-autofill, .login_content form input[type=password]:-webkit-autofill{
            -webkit-text-fill-color: #777;
            background-color: #fff;
            background-image: none;
            transition: background-color 50000s ease 0s;
        }
        .btn-login{
            width: 70%;
            height: 40px;
            border: none;
            margin: 10px 0 0;
            font-weight: 600;
            font-size: 15px;
            background-color: #1DCD9E;
            letter-spacing: .5em;
        }
        .btn:hover,.btn:visited,.btn-success,.btn-success:hover{
            border: none;
            background: #1DCD9E!important;
        }
        .btn:active, .btn.active{
            box-shadow:none;
        }
        .modal.fade .modal-dialog .modal-content{
            width:420px!important;
            border-radius: 12px;
        }
    </style>
</head>

<body class="login">
<div class="modal fade" id="modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static"
     data-keyboard="false">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-body">
                <div class="login_wrapper">
                    <div class="animate form login_form" style="position: relative;">
                        <section class="login_content">
                            <form action="/passport/signin" method="POST" id="login-form">
                                <h1>物业收费管理系统</h1>
                                <div>
                                    <input type="text" class="form-control" placeholder="请输入用户名" name="username" required="" style="border:0px;outline:none;background-color:#f8f7f7;color:#ccc"/>
                                </div>
                                <div>
                                    <input type="password" class="form-control" placeholder="请输入密码" name="password" required="" style="border:0px;outline:none;background-color:#f8f7f7;color:#ccc"/>
                                </div>
<#--                                <div class="form-group" style="text-align : left">
                                    <label><input type="checkbox" id="rememberMe" name="rememberMe" style="width: 12px; height: 12px;margin-right: 5px;">记住我</label>
                                </div>-->
                                <div>
                                    <button type="button" class="btn btn-success btn-login">登录</button>
                                </div>
                                <div class="clearfix"></div>
                            </form>
                        </section>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
<script src="/assets/js/jquery.min.js" type="text/javascript"></script>
<script src="/assets/js/jquery-migrate.min.js" type="text/javascript"></script>
<script src="/assets/js/bootstrap.min.js" type="text/javascript"></script>
<script src="/assets/js/jquery-confirm.min.js" type="text/javascript"></script>
<script src="/assets/js/zyd.tool.js"></script>
<script>
    $("#modal").modal('show');
    $(".btn-login").click(function () {
        $.ajax({
            type: "POST",
            url: "/passport/signin",
            data: $("#login-form").serialize(),
            dataType: "json",
            success: function (json) {
                if (json.status === 200) {
                    window.location.href = "/index";
                }else{
                    $.tool.ajaxSuccess(json);
                    $("#img-kaptcha").attr("src", '/getKaptcha?time=' + new Date().getTime());
                }
            }
        });
    });
    $("#img-kaptcha").click(function () {
        $(this).attr("src", '/getKaptcha?time=' + new Date().getTime());
    });
    document.onkeydown = function (event) {
        var e = event || window.event || arguments.callee.caller.arguments[0];
        if (e && e.keyCode === 13) {
            $(".btn-login").click();
        }
    };
</script>
</html>
