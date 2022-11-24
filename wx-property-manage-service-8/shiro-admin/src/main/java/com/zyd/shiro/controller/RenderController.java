/**
 * MIT License
 * Copyright (c) 2018 yadong.zhang
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
package com.zyd.shiro.controller;

/**
 * 页面渲染相关 -- 页面跳转
 *
 * @author yadong.zhang (yadong.zhang0415(a)gmail.com)
 * @version 1.0
 * @website https://www.zhyd.me
 * @date 2018/4/24 14:37
 * @since 1.0
 */

import com.zyd.shiro.util.ResultUtil;
import org.apache.shiro.authz.annotation.RequiresAuthentication;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * 页面跳转类
 *
 * @author yadong.zhang (yadong.zhang0415(a)gmail.com)
 * @version 1.0
 * @website https://www.zhyd.me
 * @date 2018/4/24 14:37
 * @since 1.0
 */
@Controller
public class RenderController {

    @RequiresAuthentication
    @GetMapping(value = {"", "/index"})
    public ModelAndView home() {
        return ResultUtil.view("index");
    }

    @GetMapping("/userSet")
    public ModelAndView userSet() {
        return ResultUtil.view("userSet/list");
    }

    @GetMapping("/chargeManage")
    public ModelAndView chargeManage() {
        return ResultUtil.view("chargeManage/list");
    }

    @RequiresPermissions("financeManage")
    @GetMapping("/financeManage")
    public ModelAndView financeManage() {
        return ResultUtil.view("financeManage/list");
    }

    @RequiresPermissions("financeManageSearch")
    @GetMapping("/financeManageSearch")
    public ModelAndView financeManageSearch() {
        return ResultUtil.view("financeManageSearch/list");
    }

    @GetMapping("/configManage")
    public ModelAndView configManage() {
        return ResultUtil.view("configManage/list");
    }

    @GetMapping("/ownerManage")
    public ModelAndView ownerManage() {
        return ResultUtil.view("ownerManage/list");
    }

    @GetMapping("/billManage")
    public ModelAndView billManage() {
        return ResultUtil.view("billManage/list");
    }

    @RequiresPermissions("receivableStatisticsPro")
    @GetMapping("/receivableStatisticsPro")
    public ModelAndView receivableStatisticsPro() {
        return ResultUtil.view("receivableStatisticsPro/list");
    }

    @RequiresPermissions("receivableStatisticsCar")
    @GetMapping("/receivableStatisticsCar")
    public ModelAndView receivableStatisticsCar() {
        return ResultUtil.view("receivableStatisticsCar/list");
    }

    @RequiresPermissions("collectionRatePro")
    @GetMapping("/collectionRatePro")
    public ModelAndView collectionRatePro() {
        return ResultUtil.view("collectionRatePro/list");
    }

    @RequiresPermissions("advanceManage")
    @GetMapping("/advanceManage")
    public ModelAndView advanceManage() {
        return ResultUtil.view("advanceManage/list");
    }

    @RequiresPermissions("depositManage")
    @GetMapping("/depositManage")
    public ModelAndView depositManage() {
        return ResultUtil.view("depositManage/list");
    }

    @RequiresPermissions("arrearsAccount")
    @GetMapping("/arrearsAccount")
    public ModelAndView arrearsAccount() {
        return ResultUtil.view("arrearsAccount/list");
    }

    @RequiresPermissions("propertyDetail")
    @GetMapping("/propertyDetail")
    public ModelAndView propertyDetail() {
        return ResultUtil.view("lcProReportForm/propertyDetail");
    }

    @RequiresPermissions("dailyReport")
    @GetMapping("/dailyReport")
    public ModelAndView dailyReport() {
        return ResultUtil.view("lcProReportForm/dailyReport");
    }

    @RequiresPermissions("monthlyReport")
    @GetMapping("/monthlyReport")
    public ModelAndView monthlyReport() {
        return ResultUtil.view("lcProReportForm/monthlyReport");
    }

    @RequiresPermissions("collectionRateProperty")
    @GetMapping("/collectionRateProperty")
    public ModelAndView collectionRateProperty() {
        return ResultUtil.view("lcProReportForm/collectionRateProperty");
    }

    @RequiresPermissions("parkingFee")
    @GetMapping("/parkingFee")
    public ModelAndView parkingFee() {
        return ResultUtil.view("lcProReportForm/parkingFee");
    }

    @RequiresPermissions("marginAccount")
    @GetMapping("/marginAccount")
    public ModelAndView marginAccount() {
        return ResultUtil.view("lcProReportForm/marginAccount");
    }

    @RequiresPermissions("applicationRecord")
    @GetMapping("/applicationRecord")
    public ModelAndView applicationRecord() {
        return ResultUtil.view("applicationRecord/list");
    }

    @RequiresPermissions("approvalRecord")
    @GetMapping("/approvalRecord")
    public ModelAndView approvalRecord() {
        return ResultUtil.view("approvalRecord/list");
    }

    @RequiresPermissions("users")
    @GetMapping("/users")
    public ModelAndView user() {
        return ResultUtil.view("user/list");
    }

    @RequiresPermissions("resources")
    @GetMapping("/resources")
    public ModelAndView resources() {
        return ResultUtil.view("resources/list");
    }

    @RequiresPermissions("roles")
    @GetMapping("/roles")
    public ModelAndView roles() {
        return ResultUtil.view("role/list");
    }

    @RequiresPermissions("village")
    @GetMapping("/village")
    public ModelAndView village() {
        return ResultUtil.view("village/list");
    }

    //    @RequiresPermissions("refunds")
    @GetMapping("/ref")
    public ModelAndView refunds() {
        return ResultUtil.view("refunds/list");
    }

//    @RequiresPermissions("a")
    @GetMapping("/aaa")
    public ModelAndView a() {
        return ResultUtil.view("a/list");
    }
}
