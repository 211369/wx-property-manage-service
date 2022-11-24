package com.zyd.shiro.business.entity;

import lombok.Data;

import java.util.Date;
import java.util.List;


@Data
public class BuildVillage {

    private Long roleId;

    private List<String> villages;

    private Date updateTime;
}
