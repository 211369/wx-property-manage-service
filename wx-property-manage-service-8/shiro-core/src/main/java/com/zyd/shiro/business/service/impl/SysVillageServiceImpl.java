package com.zyd.shiro.business.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zyd.shiro.business.entity.Resources;
import com.zyd.shiro.business.entity.VillageDTO;
import com.zyd.shiro.business.service.SysVillageService;
import com.zyd.shiro.business.vo.ResourceConditionVO;
import com.zyd.shiro.persistence.beans.SysResources;
import com.zyd.shiro.persistence.beans.SysVillage;
import com.zyd.shiro.persistence.mapper.SysVillageMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class SysVillageServiceImpl implements SysVillageService {

    @Autowired
    private SysVillageMapper sysVillageMapper;

    public PageInfo<SysVillage> findPageBreakByCondition(ResourceConditionVO vo) {
        PageHelper.startPage(vo.getPageNumber(), vo.getPageSize());

        List<SysVillage> sysVillages = sysVillageMapper.findPageBreakByCondition(vo);
        if (CollectionUtils.isEmpty(sysVillages)) {
            return null;
        }
//        List<VillageDTO> villageDTOs = new ArrayList<>();
//        for (SysVillage v : sysVillages) {
//            villageDTOs.add((VillageDTO)(v));
//        }
        PageInfo bean = new PageInfo<SysVillage>(sysVillages);
        bean.setList(sysVillages);
        return bean;
    }

    @Override
    public SysVillage insert(SysVillage entity) {
        Assert.notNull(entity, "SysVillage不可为空！");
        sysVillageMapper.insert(entity);
        return entity;
    }

    @Override
    public void insertList(List<SysVillage> entities) {
        Assert.notNull(entities, "SysVillage不可为空！");
        sysVillageMapper.insertList(entities);
    }

    @Override
    public boolean removeByPrimaryKey(Long primaryKey) {
        return sysVillageMapper.deleteByPrimaryKey(primaryKey)>0;
    }

    @Override
    public boolean update(SysVillage entity) {
        Assert.notNull(entity, "entity不可为空！");
        entity.setUpdateTime(new Date());
        return sysVillageMapper.updateByPrimaryKey(entity) > 0;
    }

    @Override
    public boolean updateSelective(SysVillage entity) {
        Assert.notNull(entity, "entity不可为空！");
        entity.setUpdateTime(new Date());
        return sysVillageMapper.updateByPrimaryKey(entity) > 0;
    }

    @Override
    public SysVillage getByPrimaryKey(Long primaryKey) {
        Assert.notNull(primaryKey, "entity不可为空！");
        SysVillage sysVillage=sysVillageMapper.selectByPrimaryKey(primaryKey);
        return sysVillage;
    }

    @Override
    public SysVillage getOneByEntity(SysVillage entity) {
        Assert.notNull(entity, "entity不可为空！");
        SysVillage sysVillage=sysVillageMapper.selectOne(entity);
        return sysVillage;
    }

    @Override
    public List<SysVillage> listAll() {
        List<SysVillage> sysVillages=sysVillageMapper.selectAll();
        return sysVillages;
    }

    @Override
    public List<SysVillage> listByEntity(SysVillage entity) {
        List<SysVillage> sysVillages=sysVillageMapper.select(entity);
        return sysVillages;
    }
}
