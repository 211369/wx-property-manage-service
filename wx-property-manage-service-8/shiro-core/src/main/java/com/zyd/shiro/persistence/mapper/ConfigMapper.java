package com.zyd.shiro.persistence.mapper;

import com.zyd.shiro.business.entity.*;
import com.zyd.shiro.plugin.BaseMapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ConfigMapper extends BaseMapper<Config> {
    List<String> queryVillage();

    List<String> queryVillageByUserId(Long userId);

    List<String> queryVillageNotConfig();

    List<String> queryVillageNotConfigByUserId(Long userId);

    List<Config> queryByVillage(String village);

    List<String> queryCostName(@Param("costType") String costType);

    Config queryByCostId(String costId);

    Config exist(Config config);

    void add(Config config);

    void update(Config config);

    void addOrUpdateHouse(List<HouseInfo> list);

    void addOrUpdateConfig(List<Config> list);

    List<ExistHouse> queryExistHouse();

    List<ExistHouse> queryExistCar();

    List<ExistHouse> existEffective(String costId);

    void addOrUpdateCar(List<Car> list);

    void addOrUpdateEffective(List<ExistHouse> list);

    List<PropertyQry> queryProperty(PropertyQry propertyQry);

    List<Config> queryConfigAll();

    List<HouseInfo> queryHouseAll();

    void deleteImport(List<ExistHouse> list);
}
