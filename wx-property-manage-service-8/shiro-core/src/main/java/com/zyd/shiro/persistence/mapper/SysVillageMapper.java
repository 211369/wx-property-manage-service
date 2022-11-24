package com.zyd.shiro.persistence.mapper;

import com.zyd.shiro.business.entity.VillageDTO;
import com.zyd.shiro.business.vo.ResourceConditionVO;
import com.zyd.shiro.persistence.beans.SysResources;
import com.zyd.shiro.persistence.beans.SysVillage;
import com.zyd.shiro.plugin.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface SysVillageMapper extends BaseMapper<SysVillage> {

    List<SysVillage>  findPageBreakByCondition(ResourceConditionVO vo);
}
