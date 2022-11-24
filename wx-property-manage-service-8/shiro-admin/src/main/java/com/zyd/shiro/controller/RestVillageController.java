package com.zyd.shiro.controller;

import com.github.pagehelper.PageInfo;
import com.zyd.shiro.business.enums.ResponseStatus;
import com.zyd.shiro.business.service.ShiroService;
import com.zyd.shiro.business.service.SysVillageService;
import com.zyd.shiro.business.vo.ResourceConditionVO;
import com.zyd.shiro.framework.object.PageResult;
import com.zyd.shiro.framework.object.ResponseVO;
import com.zyd.shiro.persistence.beans.SysVillage;
import com.zyd.shiro.util.ResultUtil;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 小区管理
 *
 * @author yadong.zhang (yadong.zhang0415(a)gmail.com)
 * @version 1.0
 * @website https://www.zhyd.me
 * @date 2018/4/24 14:37
 * @since 1.0
 */
@RestController
@RequestMapping("/village")
public class RestVillageController {

    @Autowired
    private SysVillageService villageService;

    @Autowired
    private ShiroService shiroService;

    @RequiresPermissions("village")
    @PostMapping("/list")
    public PageResult getAll(ResourceConditionVO vo) {
        PageInfo<SysVillage> pageInfo = villageService.findPageBreakByCondition(vo);
        return ResultUtil.tablePage(pageInfo);
    }
//
//    @RequiresPermissions("role:allotResource")
//    @PostMapping("/villageWithSelected")
//    public ResponseVO resourcesWithSelected(Long rid) {
//        return ResultUtil.success(null, villageService.queryResourcesListWithSelected(rid));
//    }
//
    @RequiresPermissions("village:add")
    @PostMapping(value = "/add")
    public ResponseVO add(SysVillage sysVillage) {
        villageService.insert(sysVillage);
        //更新权限
        shiroService.updatePermission();
        return ResultUtil.success("成功");
    }

    @RequiresPermissions(value = {"village:batchDelete", "village:delete"}, logical = Logical.OR)
    @PostMapping(value = "/remove")
    public ResponseVO remove(Long[] ids) {
        if (null == ids) {
            return ResultUtil.error(500, "请至少选择一条记录");
        }
        for (Long id : ids) {
            villageService.removeByPrimaryKey(id);
        }

        //更新权限
        shiroService.updatePermission();
        return ResultUtil.success("成功删除小区");
    }

    @RequiresPermissions("village:edit")
    @PostMapping("/get/{id}")
    public ResponseVO get(@PathVariable Long id) {
        return ResultUtil.success(null, this.villageService.getByPrimaryKey(id));
    }
//
    @RequiresPermissions("village:edit")
    @PostMapping("/edit")
    public ResponseVO edit(SysVillage sysVillage) {
        try {
            villageService.updateSelective(sysVillage);
        } catch (Exception e) {
            e.printStackTrace();
            return ResultUtil.error("资源修改失败！");
        }
        return ResultUtil.success(ResponseStatus.SUCCESS);
    }
}
