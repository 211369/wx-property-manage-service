package com.zyd.shiro.persistence.mapper;

import com.zyd.shiro.business.entity.*;
import com.zyd.shiro.plugin.BaseMapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProprietorMapper extends BaseMapper<HouseInfo> {
    List<HouseInfo> queryHouse(@Param("villages") List<String> villages, @Param("houseInfo") HouseInfo houseInfo);
    List<ProprietorDetail> queryDetail(String houseId);
    void deleteEffective(List<String> list);
    void deleteHouse(List<String> list);
    int existDetail(ExistHouse existHouse);
    int existCar(ExistHouse existHouse);
    int existRent(ExistHouse existHouse);
    void addEffective(ExistHouse existHouse);
    void addCar(ExistHouse existHouse);
    void deleteDetail(List<ExistHouse> list);
    void deleteCar(List<String> list);
}
