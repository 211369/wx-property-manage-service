package com.zyd.shiro.business.service;

import com.github.pagehelper.PageInfo;
import com.zyd.shiro.business.entity.Config;
import com.zyd.shiro.business.entity.ExistHouse;
import com.zyd.shiro.business.entity.PropertyExcel;
import com.zyd.shiro.business.entity.PropertyQry;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

public interface ConfigService {
    List<String> queryVillage();
    List<String> queryVillageByUserId(Long userId);
    List<String> queryVillageNotConfig();
    List<String> queryVillageNotConfigByUserId(Long userId);
    List<Config> queryByVillage(String village);
    List<String> queryCostName(String costType);
    Config queryByCostId(String CostId);
    Map<String,Object> add(Config config);
    Map<String,Object> update(Config config);
    Map<String,Object> delete(String costId);
    void propertyImport(List<PropertyExcel> propertyExcels) throws ParseException;
    PageInfo<PropertyQry> queryProperty(PropertyQry propertyQry);
    void deleteImport(List<ExistHouse> existHouses);
}