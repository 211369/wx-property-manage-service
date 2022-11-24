package com.zyd.shiro.business.service;

import com.github.pagehelper.PageInfo;
import com.zyd.shiro.business.entity.ExistHouse;
import com.zyd.shiro.business.entity.HouseInfo;
import com.zyd.shiro.business.entity.ProprietorDetail;

import java.util.List;
import java.util.Map;

public interface ProprietorService {
    PageInfo<HouseInfo> queryHouse(HouseInfo houseInfo);
    Map<String,List<ProprietorDetail>> queryDetail(String houseId, String village);
    Map<String,Object> addOrUpdate(List<HouseInfo> list);
    void deleteBatch(List<String> list);
    void addDetail(ExistHouse existHouse);
    void deleteDetail(List<ExistHouse> list);
}
