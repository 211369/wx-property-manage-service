package com.zyd.shiro.business.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zyd.shiro.business.entity.*;
import com.zyd.shiro.business.service.ConfigService;
import com.zyd.shiro.business.service.ProprietorService;
import com.zyd.shiro.persistence.mapper.ConfigMapper;
import com.zyd.shiro.persistence.mapper.ProprietorMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.ParseException;
import java.util.*;

@Service
@Transactional
@Slf4j
public class ProprietorServiceImpl implements ProprietorService {
    @Autowired
    private ProprietorMapper proprietorMapper;

    @Autowired
    private ConfigMapper configMapper;

    @Override
    public PageInfo<HouseInfo> queryHouse(HouseInfo houseInfo) {
        //查询当前登录角色是否关联小区，若没有就全量查询，若有则查询关联小区
        Long userId = (Long) SecurityUtils.getSubject().getPrincipal();
        List<String> villages = configMapper.queryVillageByUserId(userId);
        if (villages.size() == 0){
            villages = configMapper.queryVillage();
        }
        PageHelper.startPage(houseInfo.getPageNumber(), houseInfo.getPageSize());
        List<HouseInfo> list = proprietorMapper.queryHouse(villages,houseInfo);
        PageInfo bean = new PageInfo(list);
        bean.setList(list);
        return bean;
    }

    @Override
    public Map<String,List<ProprietorDetail>> queryDetail(String houseId,String village) {
        List<ProprietorDetail> exists =  proprietorMapper.queryDetail(houseId);
        List<Config> all = configMapper.queryByVillage(village);
        List<ProprietorDetail> bind = new ArrayList<>();
        List<ProprietorDetail> unBind = new ArrayList<>();
        Map<String,Config> configMap = new HashMap<>();
        Map<String,ProprietorDetail> detailMap = new HashMap<>();
        for (Config config:all) {
            configMap.put(config.getCostId(),config);
        }
        for (ProprietorDetail p:exists) {
            p.setFlag(true);
            bind.add(p);
            detailMap.put(p.getCostId(),p);
        }
        for (String key:configMap.keySet()) {
            if (!detailMap.containsKey(key)){
                ProprietorDetail proprietorDetail = new ProprietorDetail();
                Config config = configMap.get(key);
                proprietorDetail.setHouseId(houseId);
                proprietorDetail.setCostId(config.getCostId());
                proprietorDetail.setCostName(config.getCostName());
                proprietorDetail.setCostType(config.getCostType());
                proprietorDetail.setCostTypeClass(config.getCostTypeClass());
                proprietorDetail.setCostTypeSection(config.getCostTypeSection());
                proprietorDetail.setUnit(config.getUnit());
                proprietorDetail.setVillage(config.getVillage());
                proprietorDetail.setFlag(false);
                unBind.add(proprietorDetail);
            }
        }
        Map<String,List<ProprietorDetail>> map = new HashMap<>();
        map.put("bind",bind);
        map.put("unBind",unBind);
        return map;
    }

    @Override
    public Map<String, Object> addOrUpdate(List<HouseInfo> list) {
        Map<String,Object> map = new HashMap<>();
        try {
            List<HouseInfo> houseInfos = new ArrayList<>();
            Date now = new Date();
            for (HouseInfo houseInfo:list) {
                houseInfo.setHouseId(UUID.randomUUID().toString().replace("-",""));
                houseInfo.setUpdateTime(now);
                houseInfos.add(houseInfo);
            }
            configMapper.addOrUpdateHouse(houseInfos);
            map.put("code", 200);
            map.put("msg", "操作成功");
        } catch (Exception e) {
            e.printStackTrace();
            map.put("code",500);
            map.put("msg","操作失败");
        }
        log.info(map.get("msg").toString());
        return map;
    }

    @Override
    public void deleteBatch(List<String> list) {
        proprietorMapper.deleteEffective(list);
        proprietorMapper.deleteHouse(list);
    }

    @Override
    public void addDetail(ExistHouse existHouse) {
        existHouse.setUpdateTime(new Date());
        existHouse.setPayFlag(0);
        if (!"".equals(existHouse.getCarNo())) {
//            if ("车位租赁费".equals(existHouse.getCostName())){
//                int existRent = proprietorMapper.existRent(existHouse);
//                if (existRent != 0){
//                    throw new RuntimeException("车位已被他人租用，绑定失败");
//                }
//                existHouse.setCarId(UUID.randomUUID().toString().replace("-",""));
//                proprietorMapper.addCar(existHouse);
//            }else {
                int existCar = proprietorMapper.existCar(existHouse);
                if (existCar == 0) {
                    existHouse.setCarId(UUID.randomUUID().toString().replace("-", ""));
                    proprietorMapper.addCar(existHouse);
                } else {
                    throw new RuntimeException("车位已被绑定，绑定失败");
                }
//            }
        }
        int existEffective = proprietorMapper.existDetail(existHouse);
        if (existEffective == 0) {
            proprietorMapper.addEffective(existHouse);
        }else {
            throw new RuntimeException("费用信息已存在，绑定失败");
        }
    }

    @Override
    public void deleteDetail(List<ExistHouse> list) {
        proprietorMapper.deleteDetail(list);
        List<String> cars = new ArrayList<>();
        for (ExistHouse e:list) {
            if (!"".equals(e.getCarId())){
                cars.add(e.getCarId());
            }
        }
        if(cars.size()>0){
            proprietorMapper.deleteCar(cars);
        }
    }
}
