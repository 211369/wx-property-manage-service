package com.zyd.shiro.business.service;

import com.github.pagehelper.PageInfo;
import com.zyd.shiro.business.entity.Resources;
import com.zyd.shiro.business.entity.VillageDTO;
import com.zyd.shiro.business.vo.ResourceConditionVO;
import com.zyd.shiro.framework.object.AbstractService;
import com.zyd.shiro.persistence.beans.SysVillage;

import java.util.List;
import java.util.Map;

public interface SysVillageService extends AbstractService<SysVillage, Long> {

    /**
     * 分页查询
     *
     * @param vo
     * @return
     */
    PageInfo<SysVillage> findPageBreakByCondition(ResourceConditionVO vo);


}
