package com.zyd.shiro.persistence.beans;

import com.zyd.shiro.framework.object.AbstractDO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class SysVillage extends AbstractDO {
    private String villageName;

    private String shopCode;

    private String mark;

    private String staffCode;
}
