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
 * 项目核心Js类，负责项目前端模板方面的初始化等操作
 *
 * @author yadong.zhang (yadong.zhang0415(a)gmail.com)
 * @website https://www.zhyd.me
 * @version 1.0
 * @date 2018-04-25
 * @since 1.0
 */
(function ($) {
    $.extend($.fn, {
        zydSelect: function (options) {
            var op = $.extend({firstText: '请选择', firstValue: ''}, options);
            function onchange(event){
                var $child = $("#" + event.data.$child);
                var $parent = event.data.$parent;
                var parentValue = $parent.val();
                if (!$child || $child.size() == 0 || !parentValue) {
                    $parent.attr('name', $child.attr('name'));
                    $child.attr('disabled', 'disabled');
                    $child.html('');
                    return false;
                }
                $.ajax({
                    type:'POST',
                    dataType:"json",
                    url:event.data.childUrl.replace("{value}", encodeURIComponent($parent.val())),
                    cache: false,
                    data:{},
                    success: function(json){
                        var childData;
                        if (json.status != 200 || !(childData = json.data) || childData.length == 0) {
                            console.error(json.message);
                            return false;
                        }
                        $child.removeAttr('disabled');
                        $parent.removeAttr('name');
                        var html = '<option value="' + op.firstValue + '">' + op.firstText + '</option>';
                        $.each(childData, function(i){
                            html += '<option value="' + childData[i]['value'] + '">' + childData[i]['text'] + '</option>';
                        });
                        $child.html(html);
                    },
                    error: $.tool.ajaxError
                });
            }
            return this.each(function (i) {
                var $this = $(this);
                var child = $this.data("child");
                var childUrl = $this.data('child-url') || '';
                var defaultText = $this.data('default-text') || '';
                if (child && childUrl) {
                    $this.unbind("change", onchange).bind("change", {$child:child, childUrl:childUrl, $parent:$this, defaultText: defaultText}, onchange);
                }
            });
        }
    });
})(jQuery);
var zhyd = window.zhyd || {
    initSidebar: function () {
        var a = function () {
            $RIGHT_COL.css("min-height", $(window).height());
            var a = $BODY.outerHeight(),
                    b = $BODY.hasClass("footer_fixed") ? -10 : $FOOTER.height(),
                    c = $LEFT_COL.eq(1).height() + $SIDEBAR_FOOTER.height(),
                    d = a < c ? c : a;
            d -= $NAV_MENU.height() + b, $RIGHT_COL.css("min-height", d)
        };
        $SIDEBAR_MENU.find("a").on("click", function (b) {
            var c = $(this).parent();
            c.is(".active") ? (c.removeClass("active active-sm"), $("ul:first", c).slideUp(function () {
                a()
            })) : (c.parent().is(".child_menu") ? $BODY.is(".nav-sm") && ($SIDEBAR_MENU.find("li").removeClass("active active-sm"), $SIDEBAR_MENU.find("li ul").slideUp()) : ($SIDEBAR_MENU.find("li").removeClass("active active-sm"), $SIDEBAR_MENU.find("li ul").slideUp()), c.addClass("active"), $("ul:first", c).slideDown(function () {
                a()
            }))
        }), $MENU_TOGGLE.on("click", function () {
            $BODY.hasClass("nav-md") ? ($SIDEBAR_MENU.find("li.active ul").hide(), $SIDEBAR_MENU.find("li.active").addClass("active-sm").removeClass("active")) : ($SIDEBAR_MENU.find("li.active-sm ul").show(), $SIDEBAR_MENU.find("li.active-sm").addClass("active").removeClass("active-sm")), $BODY.toggleClass("nav-md nav-sm"), a()
        }), $SIDEBAR_MENU.find('a[href="' + CURRENT_URL + '"]').parent("li").addClass("current-page"), $SIDEBAR_MENU.find("a").filter(function () {
            return this.href == CURRENT_URL
        }).parent("li").addClass("current-page").parents("ul").slideDown(function () {
            a()
        }).parent().addClass("active"), $(window).smartresize(function () {
            a()
        }), a(), $.fn.mCustomScrollbar && $(".menu_fixed").mCustomScrollbar({
            autoHideScrollbar: !0,
            theme: "minimal",
            mouseWheel: {
                preventDefault: !0
            }
        })
    },
    initDaterangepicker: function () {
        $('.myDatepicker').datetimepicker({
            format: 'YYYY-MM-DD HH:mm:ss',
            ignoreReadonly: true,
            allowInputToggle: true
        });
    },
    initValidator: function () {
        "undefined" != typeof validator && (console.log("zhyd.initValidator"), validator.message.date = "not a real date", $("form").on("blur", "input[required], input.optional, select.required,select[required]", validator.checkField).on("change", "select.required,select[required]", validator.checkField).on("keypress", "input[required][pattern]", validator.keypress), $(".multi.required").on("keyup blur", "input", function () {
            validator.checkField.apply($(this).siblings().last()[0])
        }), $("form").submit(function (a) {
            a.preventDefault();
            var b = !0;
            return validator.checkAll($(this)) || (b = !1), b && this.submit(), !1
        }));
    }
};

function countChecked() {
    "all" === checkState && $(".bulk_action input[name='table_records']").iCheck("check"), "none" === checkState && $(".bulk_action input[name='table_records']").iCheck("uncheck");
    var a = $(".bulk_action input[name='table_records']:checked").length;
    a ? ($(".column-title").hide(), $(".bulk-actions").show(), $(".action-cnt").html(a + " Records Selected")) : ($(".column-title").show(), $(".bulk-actions").hide())
}

function gd(a, b, c) {
    return new Date(a, b - 1, c).getTime()
}

!function (a, b) {
    var c = function (a, b, c) {
        var d;
        return function () {
            function h() {
                c || a.apply(f, g), d = null
            }

            var f = this,
                    g = arguments;
            d ? clearTimeout(d) : c && a.apply(f, g), d = setTimeout(h, b || 100)
        }
    };
    jQuery.fn[b] = function (a) {
        return a ? this.bind("resize", c(a)) : this.trigger(b)
    }
}(jQuery, "smartresize");

var CURRENT_URL = window.location.href.split("#")[0].split("?")[0],
        $BODY = $("body"),
        $MENU_TOGGLE = $("#menu_toggle"),
        $SIDEBAR_MENU = $("#sidebar-menu"),
        $SIDEBAR_FOOTER = $(".sidebar-footer"),
        $LEFT_COL = $(".left_col"),
        $RIGHT_COL = $(".right_col"),
        $NAV_MENU = $(".nav_menu"),
        $FOOTER = $("footer"),
        randNum = function () {
            return Math.floor(21 * Math.random()) + 20
        };
$(document).ready(function () {
    $(".collapse-link").on("click", function () {
        var a = $(this).closest(".x_panel"),
                b = $(this).find("i"),
                c = a.find(".x_content");
        a.attr("style") ? c.slideToggle(200, function () {
            a.removeAttr("style")
        }) : (c.slideToggle(200), a.css("height", "auto")), b.toggleClass("fa-chevron-up fa-chevron-down")
    }), $(".close-link").click(function () {
        var a = $(this).closest(".x_panel");
        a.remove()
    });
}), $(document).ready(function () {
    $('[data-toggle="tooltip"]').tooltip({
        container: "body"
    })
}), $(".progress .progress-bar")[0] && $(".progress .progress-bar").progressbar(), $(document).ready(function () {
    if ($(".js-switch")[0]) {
        var a = Array.prototype.slice.call(document.querySelectorAll(".js-switch"));
        a.forEach(function (a) {
            new Switchery(a, {
                color: "#26B99A"
            })
        })
    }
}), $(document).ready(function () {
    $("input[type=checkbox], input[type=radio]").iCheck({
        checkboxClass: 'icheckbox_square-green',
        radioClass: 'iradio_square-green',
        increaseArea: '20%' // optional
    });
}), $("table input").on("ifChecked", function () {
    checkState = "", $(this).parent().parent().parent().addClass("selected"), countChecked()
}), $("table input").on("ifUnchecked", function () {
    checkState = "", $(this).parent().parent().parent().removeClass("selected"), countChecked()
});
var checkState = "";
$(".bulk_action input").on("ifChecked", function () {
    checkState = "", $(this).parent().parent().parent().addClass("selected"), countChecked()
}), $(".bulk_action input").on("ifUnchecked", function () {
    checkState = "", $(this).parent().parent().parent().removeClass("selected"), countChecked()
}), $(".bulk_action input#check-all").on("ifChecked", function () {
    checkState = "all", countChecked()
}), $(".bulk_action input#check-all").on("ifUnchecked", function () {
    checkState = "none", countChecked()
}), $(document).ready(function () {
    $(".expand").on("click", function () {
        $(this).next().slideToggle(200), $expand = $(this).find(">:first-child"), "+" == $expand.text() ? $expand.text("-") : $expand.text("+")
    })
}), "undefined" != typeof NProgress && ($(document).ready(function () {
    NProgress.start()
}), $(window).on('load',function () {
    NProgress.done()
}));
var originalLeave = $.fn.popover.Constructor.prototype.leave;
$.fn.popover.Constructor.prototype.leave = function (a) {
    var c, d,
            b = a instanceof this.constructor ? a : $(a.currentTarget)[this.type](this.getDelegateOptions()).data("bs." + this.type);
    originalLeave.call(this, a), a.currentTarget && (c = $(a.currentTarget).siblings(".popover"), d = b.timeout, c.one("mouseenter", function () {
        clearTimeout(d), c.one("mouseleave", function () {
            $.fn.popover.Constructor.prototype.leave.call(b, b)
        })
    }))
}, $("body").popover({
    selector: "[data-popover]",
    trigger: "click hover",
    delay: {
        show: 50,
        hide: 400
    }
}), $(document).ready(function () {
    // 图片预览
    $(".showImage").fancybox();
    zhyd.initDaterangepicker();
    zhyd.initValidator();
    zhyd.initSidebar();
    $("select.zydSelect").zydSelect();
});
/*数组序列化转为对象*/
$.fn.serializeObject = function()
{
    var o = {};
    var a = this.serializeArray();
    $.each(a, function() {
        if (o[this.name]) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
};

/*小区、楼栋、单元、房间select的多级联动*/
/**
 * 查询小区、楼栋、单元、房屋
 * @param type {String} select的id名(小区:village、楼栋:building、单元:location、房间:room)
 * @param flag {Boolean} 对账模块中小区多选使用，其他模块无需传此参数
 * 注：导入excel中，楼栋和单元为非必填项，故存在楼栋和单元值为空字符串的情况，查询的楼栋和单元列表会有空字符串的数据；
 *    查询业户列表时，若查楼栋和单元的全量数据，则楼栋和单元的字段不传或者传值null,传值空字符串查询出的结果不是全量，是楼栋和单元值为空字符串的数据；
 *    故楼栋和单元中请选择的option，value给值"null",查询业户列表时，其值处理为null。
 * */
function queryVillage(type,flag) {
    var url="",params=new Object(),obj;
    if(type=="village"){
        url="/charge/queryVillage";
        if(flag)obj="";
        else obj="<option value=''>请选择</option>";
    }else if(type=="building"){
        url="/charge/queryBuildingByVillage";
        obj="<option value='null'>请选择</option>";
        params={
            village:$('#searchForm #village  option:selected').val()
        }
    }else if(type=="location"){
        url="/charge/queryLocationByVillageBuilding";
        obj="<option value='null'>请选择</option>";
        params={
            village:$('#searchForm #village  option:selected').val(),
            building:$('#searchForm #building  option:selected').val()
        }
    }else if(type=="room"){
        url="/charge/queryHouse";
        obj="<option value=''>请选择</option>";
        params={
            village:$('#searchForm #village  option:selected').val(),
            building:$('#searchForm #building  option:selected').val(),
            location:$('#searchForm #location  option:selected').val()
        }
    }
    $.ajax({
        url: url,
        type: "get",
        data:params,
        success: function(res){
            if(res&&res.length!=0){
                res.forEach(function(item,index){
                    obj+="<option value='"+item+"'>"+item+"</option>"
                })
                $("#searchForm #"+type).html(obj);
                if(type=="village"&&flag)$("#village").selectpicker('refresh');
                if(res.length==1){
                    $("#searchForm #"+type).val(res[0])
                    $("#searchForm #"+type).trigger("change");//手动改变select的值，不会触发change事件，故执行该语句
                }else{
                    if(type=="village"){
                        $("#searchForm #building").html("<option value='null'>请选择</option>");
                        $("#searchForm #location").html("<option value='null'>请选择</option>");
                        $("#searchForm #room").html("<option value=''>请选择</option>");
                    }else if(type=="building"){
                        $("#searchForm #location").html("<option value='null'>请选择</option>");
                        $("#searchForm #room").html("<option value=''>请选择</option>");
                    }else if(type=="location"){
                        $("#searchForm #room").html("<option value=''>请选择</option>");
                    }
                }
            }else $("#searchForm #"+type).html(obj);
        },
        error: function(error){
            $("#searchForm #"+type).html(obj);
        }
    });
}
//小区select值发生变化
$("#searchForm #village").change(function(event){
    var type=event.target.dataset.type;
    var villageVal=$('#searchForm #village').val();
    if(type=="selectMore"&&villageVal&&villageVal.length>1){
        $("#searchForm .isShow").css("display","none");
        $("#searchForm #building").html("<option value='null'>请选择</option>");
        $("#searchForm #location").html("<option value='null'>请选择</option>");
        $("#searchForm #room").html("<option value=''>请选择</option>");
    }else{
        $("#searchForm .isShow").css("display","block");
        if($('#searchForm #village  option:selected').val()){
            queryVillage("building");
        }else{
            $("#searchForm #building").html("<option value='null'>请选择</option>");
            $("#searchForm #location").html("<option value='null'>请选择</option>");
            $("#searchForm #room").html("<option value=''>请选择</option>");
        }
    }
})
//楼栋select值发生变化
$("#searchForm #building").change(function(){
    var buildingVal=$('#searchForm #building  option:selected').val();
    if((buildingVal&&buildingVal!="null")||buildingVal==""){
        queryVillage("location");
    }else{
        $("#searchForm #location").html("<option value='null'>请选择</option>");
        $("#searchForm #room").html("<option value=''>请选择</option>");
    }
})
//单元select值发生变化
$("#searchForm #location").change(function(){
    var locationVal=$('#searchForm #location  option:selected').val();
    if((locationVal&&locationVal!="null")||locationVal==""){
        queryVillage("room");
    }else{
        $("#searchForm #room").html("<option value=''>请选择</option>");
    }
})
/**
 * 根据费用类型查询对应的缴费项目
 * @param {String} type type传空字符串代表查询的全量，type传值则只能传"物业费"和"车位费"
 */
function costTypeToCostName(type){
    var str="<option value=''>请选择</option>";
    $.ajax({
        url: "/config/queryCostName?costType="+type,
        type: "get",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        async:false,
        success: function(res){
            if(res&&Array.isArray(res)&&res.length!=0){
                res.forEach(function (item,index) {
                    str+="<option value='"+item+"'>"+item+"</option>";
                })
            }
        },
        error: function(error){}
    });
    return str;
}

/**
 * 导出多sheet页excel
 * 注意：该方法下载的excel使用office打不开，提示文件已损坏
 * */
var rcExcel = function() {
    return {
        ExportToExcel: function(options) {
            var loopSheet = undefined;
            var fileName = options.fileName ? options.fileName : "MyRevenueReport";

            var loopSheetTitles = "";
            var loopSheetData = "";

            var sheetName = "";

            var tmplWorkbookXML = '<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?><Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">' +
                '<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office"><Author>Axel Richter</Author><Created>{created}</Created></DocumentProperties>' +
                '<Styles>' +
                '<Style ss:ID="def_titles"><Alignment ss:Horizontal="Center"ss:Vertical="Center"/><Font ss:FontName="Arial Unicode MS"x:CharSet="134"ss:Size="10"ss:Color="#000000"ss:Bold="1"/></Style>' +
                '<Style ss:ID="def_data"><Alignment ss:Horizontal="Center"ss:Vertical="Center"/><Font ss:FontName="Arial Unicode MS"x:CharSet="134"ss:Size="10"ss:Color="#000000"/></Style>' +
                '</Styles>' +
                '{worksheets}</Workbook>',
                tmplWorksheetXML = '<Worksheet ss:Name="{nameWS}"><Table ss:DefaultColumnWidth="120">{rows}</Table></Worksheet>',
                tmplCellXML = '<Cell{attributeStyleID}{attributeFormula}><Data ss:Type="{nameType}">{data}</Data></Cell>';

            var ctx = "";
            var workbookXML = "";
            var worksheetsXML = "";
            var rowsXML = "";

            if (typeof(fileName) != "string") { return };
            var dataValue = "";
            var dataType = "";
            var dataStyle = "";
            var dataFormula = "";
            for (var i = 0; i < options.sheets.length; i++) { //loop Sheet
                loopSheet = options.sheets[i];
                loopSheetTitles = loopSheet.titles;
                loopSheetData = loopSheet.data;

                sheetName = loopSheet.name ? loopSheet.name : this.defaultOptions.sheetName;

                if (loopSheetTitles && typeof(loopSheetTitles) != "object") { continue; };
                if (loopSheetData && typeof(loopSheetData) != "object") { continue; };

                //每一列的标题 开始
                rowsXML += '<Row>';
                for (var k = 0; k < loopSheetTitles.length; k++) {

                    dataValue = loopSheetTitles[k];
                    dataType = typeof dataValue;
                    dataStyle = "def_titles";
                    dataFormula = undefined;

                    ctx = {
                        attributeStyleID: ' ss:StyleID="' + dataStyle + '"',
                        nameType: (dataType == 'Number' || dataType == 'DateTime' || dataType == 'Boolean' || dataType == 'Error') ? dataType : 'String',
                        data: (dataFormula) ? '' : dataValue,
                        attributeFormula: (dataFormula) ? ' ss:Formula="' + dataFormula + '"' : ''
                    };
                    rowsXML += this.format(tmplCellXML, ctx);
                }
                rowsXML += '</Row>';
                //每一列的标题 结束

                //数据
                for (var j = 0; j < loopSheet.data.length; j++) {
                    rowsXML += '<Row>';
                    for (var index in loopSheet.data[j]) {
                        dataValue = loopSheet.data[j][index] === "." ? "" : loopSheet.data[j][index];
                        dataType = typeof dataValue;
                        dataStyle = "def_data";
                        dataFormula = undefined;

                        ctx = {
                            attributeStyleID: ' ss:StyleID="' + dataStyle + '"',
                            nameType: (dataType == 'Number' || dataType == 'DateTime' || dataType == 'Boolean' || dataType == 'Error') ? dataType : 'String',
                            data: (dataFormula) ? '' : dataValue,
                            attributeFormula: (dataFormula) ? ' ss:Formula="' + dataFormula + '"' : ''
                        };
                        rowsXML += this.format(tmplCellXML, ctx);
                    }

                    rowsXML += '</Row>';
                }
                ctx = { rows: rowsXML, nameWS: sheetName || 'Sheet' + i };
                worksheetsXML += this.format(tmplWorksheetXML, ctx);
                rowsXML = "";
            }

            ctx = { created: (new Date()).getTime(), worksheets: worksheetsXML };
            workbookXML = this.format(tmplWorkbookXML, ctx);

            this.saveAs(new Blob([workbookXML], { type: 'application/octet-stream' }), fileName);
        },
        saveAs: function(blob, fileName) {
            var tmpa = document.createElement("a");
            tmpa.download = fileName ? fileName + '.xlsx' : new Date().getTime() + '.xlsx';
            tmpa.href = URL.createObjectURL(blob); //绑定a标签
            tmpa.click(); //模拟点击实现下载
            setTimeout(function() { //延时释放
                URL.revokeObjectURL(blob); //用URL.revokeObjectURL()来释放这个object URL
            }, 100);
        },
        format: function(s, c) {
            return s.replace(/{(\w+)}/g, function(m, p) {
                return c[p];
            })
        },
        info: function() {
            return this.defaultOptions.plugin;
        },
        defaultOptions: {
            sheetName: "",
            plugin: {
                author: "Charles Ran",
                version: "1.0"
            }
        }
    }
}();
/**
 * 导出多sheet页excel
 * 注意：该方法下载的excel使用office和wps打开均正常
 * */
function downloadExcel(data,excelName) {
    var wopts = { bookType: 'xlsx', bookSST: true, type: 'binary', cellStyles: true };//这里的数据是用来定义导出的格式类型
    var wb = {
        SheetNames: [],
        Sheets: {},
        Props: {}
    };
    data.forEach(function(item,index){
        var list=XLSX.utils.json_to_sheet(item.data);
        if(item.wpx)list['!cols'] = (item.wpx);
        wb.Sheets[item.fileName] = list;
        wb.SheetNames[index]=item.fileName;

        //设置样式
        for (cell in item.data) {
            if (cell != '!merges' && cell != '!ref') {
                item.data[cell].s = {
                    font: {
                        name: '宋体',
                        sz: 14,
                        color: { rgb: "#00000000" },
                        bold: false,
                        italic: false,
                        underline: false
                    },
                    alignment: {
                        horizontal: "center",
                        vertical: "center"
                    },
                    fill: { bgColor: { indexed: 64 } }
                };
            }
        }
    })
    saveAs(
        new Blob([s2ab(XLSX.write(wb, wopts))], { type: "application/octet-stream" }),
        excelName + '.' + (wopts.bookType == "biff2" ? "xls" : wopts.bookType)
    );
}
function s2ab(s) {
    if (typeof ArrayBuffer !== 'undefined') {
        var buf = new ArrayBuffer(s.length);
        var view = new Uint8Array(buf);
        for (var i = 0; i != s.length; ++i) view[i] = s.charCodeAt(i) & 0xFF;
        return buf;
    } else {
        var buf = new Array(s.length);
        for (var i = 0; i != s.length; ++i) buf[i] = s.charCodeAt(i) & 0xFF;
        return buf;
    }
}
//如果使用 FileSaver.js 就不要同时使用以下函数
function saveAs(obj, fileName) {//当然可以自定义简单的下载文件实现方式
    var tmpa = document.createElement("a");
    tmpa.download = fileName || "下载";
    tmpa.href = URL.createObjectURL(obj); //绑定a标签
    tmpa.click(); //模拟点击实现下载
    setTimeout(function () { //延时释放
        URL.revokeObjectURL(obj); //用URL.revokeObjectURL()来释放这个object URL
    }, 100);
}