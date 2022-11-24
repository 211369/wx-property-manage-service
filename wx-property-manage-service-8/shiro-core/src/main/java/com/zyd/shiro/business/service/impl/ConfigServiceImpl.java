package com.zyd.shiro.business.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zyd.shiro.business.entity.*;
import com.zyd.shiro.business.service.ConfigService;
import com.zyd.shiro.persistence.mapper.ConfigMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.ParseException;
import java.util.*;

@Service
@Transactional
@Slf4j
public class ConfigServiceImpl implements ConfigService {
    @Autowired
    private ConfigMapper configMapper;

    @Override
    public List<String> queryVillage() {
        return configMapper.queryVillage();
    }

    @Override
    public List<String> queryVillageByUserId(Long userId) {
        return configMapper.queryVillageByUserId(userId);
    }

    @Override
    public List<String> queryVillageNotConfig() {
        return configMapper.queryVillageNotConfig();
    }

    @Override
    public List<String> queryVillageNotConfigByUserId(Long userId) {
        return configMapper.queryVillageNotConfigByUserId(userId);
    }


    @Override
    public List<Config> queryByVillage(String village) {
        return configMapper.queryByVillage(village);
    }

    @Override
    public List<String> queryCostName(String costType) {
        return configMapper.queryCostName(costType);
    }

    @Override
    public Config queryByCostId(String costId) {
        return configMapper.queryByCostId(costId);
    }

    @Override
    public Map<String, Object> add(Config config) {
        Map<String,Object> map = new HashMap<>();
        try {
            config.setCostId(UUID.randomUUID().toString().replace("-",""));
            config.setDelFlag(1);
            config.setUpdateTime(new Date());
            Config exist = configMapper.exist(config);
            if (null != exist){
                map.put("code",500);
                map.put("msg","数据已存在");
            }else {
                log.info("配置添加数据" + config.toString());
                List<Config> list = new ArrayList<>();
                list.add(config);
                configMapper.addOrUpdateConfig(list);
                map.put("code", 200);
                map.put("msg", "添加成功");
            }
        } catch (Exception e) {
            e.printStackTrace();
            map.put("code",500);
            map.put("msg","添加失败");
        }
        log.info(map.get("msg").toString());
        return map;
    }

    @Override
    public Map<String, Object> update(Config config) {
        Map<String,Object> map = new HashMap<>();
        try {
            config.setUpdateTime(new Date());
            Config exist = configMapper.exist(config);
            if (null != exist){
                map.put("code",500);
                map.put("msg","数据已存在");
            }else {
                log.info("配置修改数据" + config.toString());
                configMapper.update(config);
                map.put("code", 200);
                map.put("msg", "修改成功");
            }
        } catch (Exception e) {
            e.printStackTrace();
            map.put("code",500);
            map.put("msg","修改失败");
        }
        log.info(map.get("msg").toString());
        return map;
    }

    @Override
    public Map<String, Object> delete(String costId) {
        Map<String,Object> map = new HashMap<>();
        try {
            Config config = new Config();
            config.setCostId(costId);
            config.setDelFlag(0);
            config.setUpdateTime(new Date());
//            List<ExistHouse> existHouses = configMapper.existEffective(costId);
//            if (existHouses.size()>0){
//                map.put("code",500);
//                ExistHouse e = existHouses.get(0);
//                map.put("msg",e.getVillage()+e.getBuilding()+e.getLocation()+e.getRoom()+e.getCostName()+"费用未结清，禁止删除");
//            }else {
            log.info("配置删除数据" + config.toString());
            configMapper.update(config);
            map.put("code", 200);
            map.put("msg", "删除成功");
//            }
        } catch (Exception e) {
            e.printStackTrace();
            map.put("code",500);
            map.put("msg","删除失败");
        }
        log.info(map.get("msg").toString());
        return map;
    }

    @Override
    public void propertyImport(List<PropertyExcel> propertyExcels) throws ParseException {
        //批量查房屋小区楼栋单元房间key
        Map<String,String> existHouseMap = new HashMap<>();
        List<HouseInfo> houses = configMapper.queryHouseAll();
        for (HouseInfo houseInfo:houses) {
            String key = houseInfo.getVillage()+houseInfo.getBuilding()+houseInfo.getLocation()+houseInfo.getRoom();
            existHouseMap.put(key,houseInfo.getHouseId());
        }
        //批量查配置小区项目名称项目类型key
        Map<String,String> configMap = new HashMap<>();
        List<Config> configList = configMapper.queryConfigAll();
        for (Config config:configList) {
            String key = config.getVillage()+config.getCostName()+config.getCostType()
                    +config.getCostTypeClass()+config.getCostTypeSection()+config.getUnit();
            configMap.put(key,config.getCostId());
        }
        //批量查询费用时效
        List<ExistHouse> old = configMapper.queryExistHouse();
        Map<ExistHouse,ExistHouse> oldMap = new HashMap<>();
        for (ExistHouse existHouse:old) {
            oldMap.put(existHouse,existHouse);
        }
        //批量查询车位号
        Map<String,String> existMap = new HashMap<>();
        List<ExistHouse> existCar = configMapper.queryExistCar();
        for (ExistHouse p:existCar) {
            String key = p.getVillage()+p.getCostName()+p.getCostType()
                    +p.getCostTypeClass()+p.getCostTypeSection()+p.getCarNo();
            existMap.put(key,key);
        }
        //更新时间
        Date updateTime = new Date();
        Map<HouseInfo,String> houseInfoMap = new HashMap<>();
        Map<Config,String> costConfigMap = new HashMap<>();
        List<ExistHouse> existHouses = new ArrayList<>();
        List<Car> cars = new ArrayList<>();
        //循环excel数据
        for (PropertyExcel p:propertyExcels) {
            //车位费时车位唯一校验
//            String key = p.getVillage()+p.getCostName()+p.getCostType()
//                    +p.getCostTypeClass()+p.getCostTypeSection()+p.getCarNo();
//            if(!"".equals(p.getCarNo())){
//                if (!existMap.containsKey(key)) {
//                    existMap.put(key, key);
//                }else {
//                    throw new RuntimeException(key+"车位号重复");
//                }
//            }
            //房屋基本信息封装
            HouseInfo houseInfo = new HouseInfo();
            houseInfo.setVillage(p.getVillage());
            houseInfo.setBuilding(p.getBuilding());
            houseInfo.setLocation(p.getLocation());
            houseInfo.setRoom(p.getRoom());
            houseInfo.setRoomArea(p.getRoomArea());
            houseInfo.setOwnerName(p.getOwnerName());
            houseInfo.setOwnerPhone(p.getOwnerPhone());
            houseInfo.setIdCardNo(p.getIdCardNo());
            houseInfo.setReservePhone(p.getReservePhone());
            houseInfo.setCheckInTime(p.getCheckInTime());
            String houseId = UUID.randomUUID().toString().replace("-","");
            if (!houseInfoMap.containsKey(houseInfo)) {
                houseInfoMap.put(houseInfo, houseId);
            }
            //缴费配置封装
            Config config  = new Config();
            config.setVillage(p.getVillage());
            config.setCostName(p.getCostName());
            config.setCostType(p.getCostType());
            config.setCostTypeClass(p.getCostTypeClass());
            config.setCostTypeSection(p.getCostTypeSection());
            config.setUnit(p.getUnit());
            String costId = UUID.randomUUID().toString().replace("-","");
            if (!costConfigMap.containsKey(config)) {
                costConfigMap.put(config, costId);
            }
            String carId = UUID.randomUUID().toString().replace("-","");
            //时效处理
            ExistHouse existHouse = new ExistHouse();
            existHouse.setVillage(p.getVillage());
            existHouse.setBuilding(p.getBuilding());
            existHouse.setLocation(p.getLocation());
            existHouse.setRoom(p.getRoom());
            existHouse.setCostName(p.getCostName());
            existHouse.setCostType(p.getCostType());
            existHouse.setCostTypeClass(p.getCostTypeClass());
            existHouse.setCostTypeSection(p.getCostTypeSection());
            existHouse.setCarNo(p.getCarNo());
            existHouse.setBeginTime(p.getBeginTime());
            existHouse.setEndTime(p.getEndTime());
            existHouse.setUpdateTime(updateTime);
            existHouse.setPayFlag(0);
            //费用时效存在与否的不同逻辑
            if (oldMap.containsKey(existHouse)){
                existHouse.setHouseId(oldMap.get(existHouse).getHouseId());
                existHouse.setCostId(oldMap.get(existHouse).getCostId());
                if(null != p.getCarNo() && !"".equals(p.getCarNo())){
                    existHouse.setCarId(oldMap.get(existHouse).getCarId());
                    //车位关联处理
                    Car car = new Car();
                    car.setCarId(oldMap.get(existHouse).getCarId());
                    car.setCarNo(p.getCarNo());
                    car.setLicensePlateNo(p.getLicensePlateNo());
                    car.setCostId(oldMap.get(existHouse).getCostId());
                    car.setHouseId(oldMap.get(existHouse).getHouseId());
                    car.setUpdateTime(updateTime);
                    cars.add(car);
                }
            }else {
                //房屋存在取存在的，不存在取新的
                String houseKey = p.getVillage()+p.getBuilding()+p.getLocation()+p.getRoom();
                if (existHouseMap.containsKey(houseKey)){
                    existHouse.setHouseId(existHouseMap.get(houseKey));
                }else {
                    existHouse.setHouseId(houseInfoMap.get(houseInfo));
                }
                //配置存在去取存在的，不存在取新的
                String configKey = p.getVillage()+p.getCostName()+p.getCostType()+p.getCostTypeClass()+p.getCostTypeSection()+p.getUnit().setScale(2);
                if (configMap.containsKey(configKey)){
                    existHouse.setCostId(configMap.get(configKey));
                }else {
                    existHouse.setCostId(costConfigMap.get(config));
                }
                if(null != p.getCarNo() && !"".equals(p.getCarNo())){
                    existHouse.setCarId(carId);
                    //车位关联处理
                    Car car = new Car();
                    car.setCarId(carId);
                    car.setCarNo(p.getCarNo());
                    car.setLicensePlateNo(p.getLicensePlateNo());
                    car.setCostId(existHouse.getCostId());
                    car.setHouseId(existHouse.getHouseId());
                    car.setUpdateTime(updateTime);
                    cars.add(car);
                }
            }
            existHouses.add(existHouse);
        }
        //房屋基本信息新增或更新
        List<HouseInfo> houseInfos = new ArrayList<>();
        for (Map.Entry<HouseInfo,String> entry :houseInfoMap.entrySet()) {
            HouseInfo houseInfo = entry.getKey();
            houseInfo.setHouseId(entry.getValue());
            houseInfo.setUpdateTime(updateTime);
            houseInfos.add(houseInfo);
        }
        log.info("插入更新"+houseInfos.size()+"条房屋基本信息");
        if (houseInfos.size()>0) {
            configMapper.addOrUpdateHouse(houseInfos);
        }
        //缴费配置新增或更新
        List<Config> configs = new ArrayList<>();
        for (Map.Entry<Config,String> entry :costConfigMap.entrySet()) {
            Config config = entry.getKey();
            config.setCostId(entry.getValue());
            config.setUpdateTime(updateTime);
            configs.add(config);
        }
        log.info("插入更新"+configs.size()+"条缴费配置项信息");
        if (configs.size()>0) {
            configMapper.addOrUpdateConfig(configs);
        }
        //车位关联新增或更新
        log.info("插入更新"+cars.size()+"条车位关联信息");
        if(cars.size()>0) {
            configMapper.addOrUpdateCar(cars);
        }
        //费用时效新增或更新
        log.info("插入更新"+existHouses.size()+"条费用时效信息");
        if(existHouses.size()>0) {
            configMapper.addOrUpdateEffective(existHouses);
        }
    }

    @Override
    public PageInfo<PropertyQry> queryProperty(PropertyQry propertyQry) {
        PageHelper.startPage(propertyQry.getPageNumber(), propertyQry.getPageSize());
        List<PropertyQry> list = configMapper.queryProperty(propertyQry);
        PageInfo bean = new PageInfo(list);
        bean.setList(list);
        return bean;
    }

    @Override
    public void deleteImport(List<ExistHouse> existHouses) {
        configMapper.deleteImport(existHouses);
    }

}
