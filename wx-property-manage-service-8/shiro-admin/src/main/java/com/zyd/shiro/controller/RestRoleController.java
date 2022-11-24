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

import com.github.pagehelper.PageInfo;
import com.zyd.shiro.business.entity.BuildVillage;
import com.zyd.shiro.business.entity.Config;
import com.zyd.shiro.business.entity.Role;
import com.zyd.shiro.business.entity.User;
import com.zyd.shiro.business.enums.ResponseStatus;
import com.zyd.shiro.business.service.ShiroService;
import com.zyd.shiro.business.service.SysRoleResourcesService;
import com.zyd.shiro.business.service.SysRoleService;
import com.zyd.shiro.business.vo.RoleConditionVO;
import com.zyd.shiro.framework.object.PageResult;
import com.zyd.shiro.framework.object.ResponseVO;
import com.zyd.shiro.persistence.beans.SysRole;
import com.zyd.shiro.util.ResultUtil;
import lombok.extern.slf4j.Slf4j;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 系统角色管理
 *
 * @author yadong.zhang (yadong.zhang0415(a)gmail.com)
 * @version 1.0
 * @website https://www.zhyd.me
 * @date 2018/4/24 14:37
 * @since 1.0
 */
@RestController
@Slf4j
@RequestMapping("/roles")
public class RestRoleController {
    @Autowired
    private SysRoleService roleService;
    @Autowired
    private SysRoleResourcesService roleResourcesService;
    @Autowired
    private ShiroService shiroService;

    @RequiresPermissions("roles")
    @PostMapping("/list")
    public PageResult getAll(RoleConditionVO vo) {
        PageInfo<Role> pageInfo = roleService.findPageBreakByCondition(vo);
        return ResultUtil.tablePage(pageInfo);
    }

    @RequiresPermissions("user:allotRole")
    @PostMapping("/rolesWithSelected")
    public ResponseVO<List<Role>> rolesWithSelected(Integer uid) {
        return ResultUtil.success(null, roleService.queryRoleListWithSelected(uid));
    }

    @RequiresPermissions("role:allotResource")
    @PostMapping("/saveRoleResources")
    public ResponseVO saveRoleResources(Long roleId, String resourcesId) {
        if (StringUtils.isEmpty(roleId)) {
            return ResultUtil.error("error");
        }
        roleResourcesService.addRoleResources(roleId, resourcesId);
        // 重新加载所有拥有roleId的用户的权限信息
        shiroService.reloadAuthorizingByRoleId(roleId);
        return ResultUtil.success("成功");
    }

    @RequiresPermissions("role:add")
    @PostMapping(value = "/add")
    public ResponseVO add(Role role) {
        SysRole u = roleService.getByRoleName(role.getDescription());
        if (u != null) {
            return ResultUtil.error("该角色[" + role.getDescription() + "]已存在！");
        }
        roleService.insert(role);
        return ResultUtil.success("成功");
    }

    @RequiresPermissions(value = {"role:batchDelete", "role:delete"}, logical = Logical.OR)
    @PostMapping(value = "/remove")
    public ResponseVO remove(Long[] ids) {
        if (null == ids) {
            return ResultUtil.error(500, "请至少选择一条记录");
        }
        for (Long id : ids) {
            roleService.removeByPrimaryKey(id);
            roleResourcesService.removeByRoleId(id);
        }
        return ResultUtil.success("成功删除 [" + ids.length + "] 个角色");
    }

    @RequiresPermissions("role:edit")
    @PostMapping("/get/{id}")
    public ResponseVO get(@PathVariable Long id) {
        return ResultUtil.success(null, this.roleService.getByPrimaryKey(id));
    }

    @RequiresPermissions("role:edit")
    @PostMapping("/edit")
    public ResponseVO edit(Role role) {
        try {
            roleService.updateSelective(role);
        } catch (Exception e) {
            e.printStackTrace();
            return ResultUtil.error("角色修改失败！");
        }
        return ResultUtil.success(ResponseStatus.SUCCESS);
    }

    /**
     * 查询角色已绑定社区
     * @param roleId
     * @return
     */
    @GetMapping("/queryBuildVillage")
    public ResponseVO<List<Map<String,Object>>> queryBuildVillage(Long roleId) {
        List<Map<String,Object>>villages = roleService.queryVillageByRoleId(roleId);
        return ResultUtil.success(null,villages);
    }

    /**
     * 角色绑定社区
     * @param buildVillage
     * @return
     */
    @PostMapping("/buildVillage")
    public ResponseVO buildVillage(@RequestBody BuildVillage buildVillage) {
        try {
            log.info(buildVillage.getRoleId()+"-----角色绑定小区");
            roleService.buildVillage(buildVillage);
        } catch (Exception e) {
            e.printStackTrace();
            return ResultUtil.error("绑定失败！");
        }
        return ResultUtil.success(ResponseStatus.SUCCESS);
    }

}
