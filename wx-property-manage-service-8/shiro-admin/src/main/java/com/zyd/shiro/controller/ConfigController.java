package com.zyd.shiro.controller;

import com.github.pagehelper.PageInfo;
import com.zyd.shiro.business.entity.Config;

import com.zyd.shiro.business.entity.ExistHouse;
import com.zyd.shiro.business.entity.PropertyExcel;
import com.zyd.shiro.business.entity.PropertyQry;
import com.zyd.shiro.business.service.ConfigService;
import lombok.extern.slf4j.Slf4j;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 缴费配置管理
 */
@RestController
@Slf4j
public class ConfigController {
    @Autowired
    private ConfigService configService;

    /**
     * 通过小区查询缴费配置项
     * @param village
     * @return
     */
    @GetMapping("/config/queryByVillage")
    public ResponseEntity<List<Config>> queryByVillage(@RequestParam(value = "village") String village){
        List<Config> list = configService.queryByVillage(village);
        return ResponseEntity.status(HttpStatus.OK).body(list);
    }

    /**
     * 通过缴费类型查询缴费项目
     * @param costType
     * @return
     */
    @GetMapping("/config/queryCostName")
    public ResponseEntity<List<String>> queryCostName(@RequestParam(value = "costType") String costType){
        List<String> list = configService.queryCostName(costType);
        return ResponseEntity.status(HttpStatus.OK).body(list);
    }

    /**
     * 通过主键查询缴费配置项
     * @param costId
     * @return
     */
    @GetMapping("/config/queryByCostId")
    public ResponseEntity<Config> queryByCostId(@RequestParam(value = "costId") String costId){
        Config config = configService.queryByCostId(costId);
        return ResponseEntity.status(HttpStatus.OK).body(config);
    }

    /**
     * 查询全量小区
     * @return
     */
    @GetMapping("/config/queryVillage")
    public ResponseEntity<List<String>> queryVillage(){
        //查询当前登录角色是否关联小区，若没有就全量查询，若有则查询关联小区
        Long userId = (Long)SecurityUtils.getSubject().getPrincipal();
        List<String> villages = configService.queryVillageByUserId(userId);
        if (villages.size() == 0){
            villages = configService.queryVillage();
        }
        return ResponseEntity.status(HttpStatus.OK).body(villages);
    }

    /**
     * 新增配置项
     * @param config
     * @return
     */
    @PostMapping("/config/add")
    public ResponseEntity<Map<String,Object>> add(@RequestBody Config config) {
        log.info(config.getVillage()+config.getCostName()+"-----缴费项目新增");
        Map<String,Object> map = configService.add(config);
        return ResponseEntity.status(HttpStatus.OK).body(map);
    }

    /**
     * 修改配置项
     * @param config
     * @return
     */
    @PutMapping("/config/update")
    public ResponseEntity<Map<String,Object>> update(@RequestBody Config config){
        log.info(config.getVillage()+config.getCostName()+"-----缴费项目修改");
        Map<String,Object> map = configService.update(config);
        return ResponseEntity.status(HttpStatus.OK).body(map);
    }

    /**
     * 删除配置项
     * @param costId
     * @return
     */
    @DeleteMapping("/config/delete")
    public ResponseEntity<Map<String,Object>> delete(@RequestParam(value = "costId") String costId){
        log.info(costId+"-----缴费项目删除");
        Map<String,Object> map = configService.delete(costId);
        return ResponseEntity.status(HttpStatus.OK).body(map);
    }

    /**
     * 导入物业车位费
     * @param propertyExcels
     * @return
     */
    @PostMapping("/config/propertyImport")
    public ResponseEntity<Map<String,Object>> propertyImport(@RequestBody List<PropertyExcel> propertyExcels) {
        log.info(propertyExcels.size()+"条记录-----导入物业费车位费");
        Map<String,Object> map = new HashMap();
        try {
            configService.propertyImport(propertyExcels);
            map.put("code",200);
            map.put("msg","导入成功");
        }catch (Exception e){
            map.put("code",500);
            map.put("msg",e.getMessage());
        }
        return ResponseEntity.status(HttpStatus.OK).body(map);
    }

    /**
     * 通过小区查询物业费车位费
     * @param propertyQry
     * @return
     */
    @PostMapping("/config/queryProperty")
    public ResponseEntity<PageInfo<PropertyQry>> queryProperty(@RequestBody PropertyQry propertyQry){
        PageInfo<PropertyQry> list = configService.queryProperty(propertyQry);
        return ResponseEntity.status(HttpStatus.OK).body(list);
    }

    /**
     * 批量删除导入项
     * @param existHouses
     * @return
     */
    @PostMapping("/config/deleteImport")
    public ResponseEntity<Map<String,Object>> deleteImport(@RequestBody List<ExistHouse> existHouses){
        log.info(existHouses.size()+"条记录-----即将删除导入项");
        Map<String,Object> map = new HashMap();
        try {
            configService.deleteImport(existHouses);
            map.put("code",200);
            map.put("msg","删除成功");
        }catch (Exception e){
            map.put("code",500);
            map.put("msg",e.getMessage());
        }
        return ResponseEntity.status(HttpStatus.OK).body(map);
    }

}
