/**
 * MIT License
 *
 * Copyright (c) 2018 yadong.zhang
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 * bootstrap-table工具类
 *
 * @author yadong.zhang (yadong.zhang0415(a)gmail.com)
 * @website https://www.zhyd.me
 * @version 1.0
 * @date 2018-04-22
 * @since 1.0
 */
(function ($) {
    $.extend({
        tableUtil: {
            _option: {},
            init: function (options) {
                $.tableUtil._option = options;
                // console.log(options.url);
                $('#tablelist').bootstrapTable({
                    url: options.url,
                    method: 'post',                      //请求方式（*）
                    toolbar: '#toolbar',                //工具按钮用哪个容器
                    striped: false,                      //是否显示行间隔色
                    cache: true,                       //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
                    contentType: "application/x-www-form-urlencoded", // 发送到服务器的数据编码类型, application/x-www-form-urlencoded为了实现post方式提交
                    sortable: false,                     //是否启用排序
                    sortOrder: "asc",                   //排序方式
                    sortStable: true,                   // 设置为 true 将获得稳定的排序
                    queryParams: $.tableUtil.queryParams,//传递参数（*）
                    queryParamsType: '',
                    pagination: true,                   //是否显示分页（*）
                    sidePagination: "server",           //分页方式：client客户端分页，server服务端分页（*）
                    pageNumber: 1,                       //初始化加载第一页，默认第一页
                    pageSize: 10,                       //每页的记录行数（*）
                    pageList: [10, 20, 30, 50, 100],        //可供选择的每页的行数（*）
                    search: false,                       //是否启用搜索框 根据sidePagination选择从前后台搜索
                    strictSearch: true,                 //设置为 true启用 全匹配搜索，否则为模糊搜索
                    searchOnEnterKey: true,            // 设置为 true时，按回车触发搜索方法，否则自动触发搜索方法
                    minimumCountColumns: 1,             //最少允许的列数
                    // showColumns: true,                  //是否显示 内容列下拉框
                    showRefresh: false,                  //是否显示刷新按钮
                    // showToggle: true,                   //是否显示详细视图和列表视图的切换按钮
                    // detailView: true,                   //是否显示父子表
                    // showExport: true,                   //是否显示导出
                    // exportDataType: "basic",              //basic', 'all', 'selected'.
                    // clickToSelect: true,                //是否启用点击选中行
                    // singleSelect: true,
                    height: $(".content_bg_common").height()-90,   //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
                    onEditableSave: function (field, row, oldValue, $el) {
                        if (options.updateUrl) {
                            $.ajax({
                                type: "post",
                                url: options.updateUrl,
                                data: {strJson: JSON.stringify(row)},
                                success: function (json) {
                                    layer.alert(json.message,{title:json.status == 200?"提示":"警告"});
                                },
                                error: function () {
                                    layer.alert("网络超时！",{title:"警告"});
                                }
                            });
                        } else {
                            layer.alert("无效的请求地址！",{title:"警告"});
                            return;
                        }
                    },
                    rowStyle: options.rowStyle || function (row, index){return {};},
                    columns: options.columns
                });
            },
            queryParams: function (params) {
                params = $.extend({}, params);
                return params;
            },
            refresh: function () {
                $("#tablelist").bootstrapTable('refresh', {url: $.tableUtil._option.url});
            },
            reload: function () {
                $("#table").bootstrapTable('refresh', {url: $.tableUtil._option.url});
            }
        },
        buttonUtil: {
            init: function (options) {
                /* 添加 */
                $("#btn_add").click(function () {
                    resetForm();
                    $("#addOrUpdateModal").modal('show');
                    $("#addOrUpdateModal").find(".modal-dialog .modal-content .modal-header h4.modal-title").html("添加" + options.modalName);

                    if ($("#password") && $("#password")[0]) {
                        $("#password").attr("required", "required");
                    }
                    if ($("#username") && $("#username")[0]) {
                        $("#username").removeAttr("readonly");
                    }
                    bindSaveInfoEvent(options.createUrl);
                });

                /* 修改 */
                $('#tablelist').on('click', '.btn-update', function () {
                    resetForm();
                    var $this = $(this);
                    var userId = $this.attr("data-id");
                    $.ajax({
                        type: "post",
                        url: options.getInfoUrl.replace("{id}", userId),
                        success: function (json) {
                            var info = json.data;
                            if(options.getInfoUrl.indexOf('/roles/get')!=-1){
                                if(info.available==true)info.available="1";
                                else if(info.available==false)info.available="0";
                            }
                            resetForm(info);
                            $("#addOrUpdateModal").modal('show');
                            $("#addOrUpdateModal").find(".modal-dialog .modal-content .modal-header h4.modal-title").html("修改" + options.modalName);
                            if ($("#password") && $("#password")[0]) {
                                $("#password").removeAttr("required");
                            }
                            if ($("#username") && $("#username")[0]) {
                                $("#username").attr("readonly", "readonly");
                            }
                            bindSaveInfoEvent(options.updateUrl);
                        },
                        error: function () {
                            layer.alert("网络超时！",{title:"警告"})
                        }
                    });
                });
                /* 员工列表修改 */
                $('#table').on('click', '.btn-update', function () {
                    var $this = $(this);
                    var Id = $(this).closest("tr").find("td").eq(0).text();
                    var Name = $(this).closest("tr").find("td").eq(1).text();
                    var Phone = $(this).closest("tr").find("td").eq(2).text();
                    var Url = $(this).closest("tr").find("td").eq(3).text();
                    var info = {
                        staffId: Id,
                        staffName: Name,
                        phone: Phone,
                        url: Url
                    };
                    resetForm(info);
                    $("#addOrUpdateModal").modal('show');
                    $("#addOrUpdateModal").find(".modal-dialog .modal-content .modal-header h4.modal-title").html("修改" + options.modalName);
                    if ($("#password") && $("#password")[0]) {
                        $("#password").removeAttr("required");
                    }
                    if ($("#username") && $("#username")[0]) {
                        $("#username").attr("readonly", "readonly");
                    }
                    bindSaveInfoEvent(options.updateUrl,"put");
                });


                /* 删除 */
                function remove(ids) {
                    layer.confirm("确定删除该" + options.modalName + "信息？", {
                        btn: ['确定','取消'],
                        title:"提示"
                    }, function () {
                        $.ajax({
                            type: "post",
                            url: options.removeUrl,
                            traditional: true,
                            data: {'ids': ids},
                            success: function (json) {
                                if(json.status==200||json.code==200){
                                    if(json.message){
                                        layer.alert(json.message,{title:"提示"})
                                    }else if(json.msg){
                                        layer.alert(json.msg,{title:"提示"})
                                    }
                                }else{
                                    if(json.message){
                                        layer.alert(json.message,{title:"警告"})
                                    }
                                }
                                $("#table").bootstrapTable('refresh', {url: $.tableUtil._option.url});
                                $.tableUtil.refresh();
                            },
                            error:  function () {
                                layer.alert("网络超时！",{title:"警告"})
                            }
                        });
                    }, function () {});
                }

                /* 批量删除用户 */
                $("#btn_delete_ids").click(function () {
                    var selectedId = getSelectedId();
                    if (!selectedId || selectedId == '[]' || selectedId.length == 0) {
                        layer.alert("请至少选择一条记录！",{title:"警告"});
                        return;
                    }
                    remove(selectedId);
                });

                /* 删除 */
                $('#tablelist').on('click', '.btn-remove', function () {
                    var $this = $(this);
                    var userId = $this.attr("data-id");
                    remove(userId);
                });
            }
        }
    });
})(jQuery);

function bindSaveInfoEvent(url,request) {
    if(url.indexOf("staff")!=-1){
        $(".addOrUpdateBtn").unbind('click');
        $(".addOrUpdateBtn").click(function () {
            var DataDeal = {
                //将从form中通过$('#form').serialize()获取的值转成json
                formToJson: function (data) {
                    data=data.replace(/&/g,"\",\"");
                    data=data.replace(/=/g,"\":\"");
                    data="{\""+data+"\"}";
                    return data;
                },
            };
            var data11=$("#addOrUpdateForm").serialize();//获取值
            data11= decodeURIComponent(data11,true);//防止中文乱码
            var jsonData=DataDeal.formToJson(data11);//转化为json
            if (validator.checkAll($("#addOrUpdateForm"))) {
                if(request=="put"){//员工列表更新
                    $.ajax({
                        type: "put",
                        url: url,
                        dataType: "json",
                        data: jsonData,
                        contentType: "application/json; charset=utf-8",
                        success: function (json) {
                            if(json.status==200||json.code==200){
                                if(json.message){
                                    layer.alert(json.message,{title:"提示"})
                                }else if(json.msg){
                                    layer.alert(json.msg,{title:"提示"})
                                }
                            }else{
                                if(json.message){
                                    layer.alert(json.message,{title:"警告"})
                                }
                            }
                            $("#addOrUpdateModal").modal('hide');
                            $.tableUtil.reload();
                        },
                        error:  function () {
                            layer.alert("网络超时！",{title:"警告"})
                        }
                    });
                }else{
                    //系统默认新增、更新方式
                    $.ajax({
                        type: "post",
                        url: url,
                        dataType: "json",
                        data: jsonData,
                        contentType: "application/json; charset=utf-8",
                        success: function (json) {
                            if(json.status==200||json.code==200){
                                if(json.message){
                                    layer.alert(json.message,{title:"提示"})
                                }else if(json.msg){
                                    layer.alert(json.msg,{title:"提示"})
                                }
                            }else{
                                if(json.message){
                                    layer.alert(json.message,{title:"警告"})
                                }
                            }
                            $("#addOrUpdateModal").modal('hide');
                            $.tableUtil.reload();
                        },
                        error:  function () {
                            layer.alert("网络超时！",{title:"警告"})
                        }
                    });
                }
            }
        })

    }else{
        $(".addOrUpdateBtn").unbind('click');
        $(".addOrUpdateBtn").click(function () {
            if (validator.checkAll($("#addOrUpdateForm"))) {
                $.ajax({
                    type: "post",
                    url: url,
                    data: $("#addOrUpdateForm").serialize(),
                    success: function (json) {
                        if(json.status==200||json.code==200){
                            if(json.message){
                                layer.alert(json.message,{title:"提示"})
                            }else if(json.msg){
                                layer.alert(json.msg,{title:"提示"})
                            }
                        }else{
                            if(json.message){
                                layer.alert(json.message,{title:"警告"})
                            }
                        }
                        $("#addOrUpdateModal").modal('hide');
                        $.tableUtil.refresh();
                    },
                    error: function () {
                        layer.alert("网络超时！",{title:"警告"})
                    }
                });
            }
        })
    }
}

function resetForm(info) {
    $("#addOrUpdateModal form input,#addOrUpdateModal form select,#addOrUpdateModal form textarea").each(function () {
        var $this = $(this);
        clearText($this, this.type, info);
    });
}

function clearText($this, type, info){
    var $div = $this.parents(".item");
    if ($div.hasClass("bad")) {
        $div.removeClass("bad");
        $div.find("div.alert").remove();
    }
    if (info) {
        var thisName = $this.attr("name");
        var thisValue = info[thisName];
        if (type == 'radio') {
            $this.iCheck(((thisValue && 1 == $this.val()) || (!thisValue && 0 == $this.val())) ? 'check' : 'uncheck')
        } else if (type == 'checkbox') {
            $this.iCheck((thisValue || thisValue == 1) ? 'check' : 'uncheck');
        } else {
            if (thisValue && thisName != 'password') {
                $this.val(thisValue);
            }
        }
    } else {
        if (type === 'radio' || type === 'checkbox') {
            $this.iCheck('uncheck');
        }else{
            $this.val('');
        }
    }
}

/**
 * 获取选中的记录ID
 * @returns {Array}
 */
function getSelectedId() {
    var selectedJson = $("#tablelist").bootstrapTable('getAllSelections');
    var ids = [];
    $.each(selectedJson, function (i) {
        ids.push(selectedJson[i].id);
    });
    return ids;
}

/**
 * 获取选中的记录
 * @returns {*|jQuery}
 */
function getSelectedObj() {
    var selectedJson = $("#tablelist").bootstrapTable('getAllSelections');
    return selectedJson;
}
