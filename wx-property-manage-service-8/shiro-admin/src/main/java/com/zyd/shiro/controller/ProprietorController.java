package com.zyd.shiro.controller;

import com.github.pagehelper.PageInfo;
import com.zyd.shiro.business.entity.*;
import com.zyd.shiro.business.service.ProprietorService;
import lombok.extern.slf4j.Slf4j;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 业户管理
 */
@RestController
@Slf4j
public class ProprietorController {
    @Autowired
    private ProprietorService proprietorService;

    /**
     * 条件分页查询业户信息
     * @param houseInfo
     * @return
     */
    @PostMapping("/proprietor/queryHouse")
    public ResponseEntity<PageInfo<HouseInfo>> queryHouse(@RequestBody HouseInfo houseInfo){
        PageInfo<HouseInfo> list = proprietorService.queryHouse(houseInfo);
        return ResponseEntity.status(HttpStatus.OK).body(list);
    }

    /**
     * 通过主键查询业户详细信息
     * @param houseId
     * @param village
     * @return
     */
    @GetMapping("/proprietor/queryDetail")
    public ResponseEntity<Map<String,List<ProprietorDetail>>> queryDetail(
            @RequestParam(value = "houseId") String houseId,
            @RequestParam(value = "village") String village){
        Map<String,List<ProprietorDetail>> map = proprietorService.queryDetail(houseId,village);
        return ResponseEntity.status(HttpStatus.OK).body(map);
    }

    /**
     * 新增或修改业户信息
     * @param list
     * @return
     */
    @PostMapping("/proprietor/addOrUpdate")
    public ResponseEntity<Map<String,Object>> addOrUpdate(@RequestBody List<HouseInfo> list) {
        log.info("------业户新增或修改------");
        Map<String,Object> map = proprietorService.addOrUpdate(list);
        return ResponseEntity.status(HttpStatus.OK).body(map);
    }

    /**
     * 批量删除业户信息
     * @param list
     * @return
     */
    @PostMapping("/proprietor/deleteBatch")
    public ResponseEntity<Map<String,Object>> deleteBatch(@RequestBody List<String> list){
        log.info(list.size()+"条记录-----即将删除业户信息");
        Map<String,Object> map = new HashMap();
        try {
            proprietorService.deleteBatch(list);
            map.put("code",200);
            map.put("msg","删除成功");
        }catch (Exception e){
            map.put("code",500);
            map.put("msg",e.getMessage());
        }
        return ResponseEntity.status(HttpStatus.OK).body(map);
    }

    /**
     * 新增绑定信息
     * @param existHouse
     * @return
     */
    @PostMapping("/proprietor/addDetail")
    public ResponseEntity<Map<String,Object>> addDetail(@RequestBody ExistHouse existHouse) {
        log.info("------业户详情绑定------");
        Map<String,Object> map = new HashMap();
        try {
            proprietorService.addDetail(existHouse);
            map.put("code",200);
            map.put("msg","绑定成功");
        }catch (Exception e){
            map.put("code",500);
            map.put("msg",e.getMessage());
        }
        return ResponseEntity.status(HttpStatus.OK).body(map);
    }

    /**
     * 批量删除绑定信息
     * @param list
     * @return
     */
    @RequiresPermissions("owner:delete")
    @PostMapping("/proprietor/deleteDetail")
    public ResponseEntity<Map<String,Object>> deleteDetail(@RequestBody List<ExistHouse> list){
        log.info(list.size()+"条记录-----即将删除绑定信息");
        Map<String,Object> map = new HashMap();
        try {
            proprietorService.deleteDetail(list);
            map.put("code",200);
            map.put("msg","删除成功");
        }catch (Exception e){
            map.put("code",500);
            map.put("msg",e.getMessage());
        }
        return ResponseEntity.status(HttpStatus.OK).body(map);
    }

}
