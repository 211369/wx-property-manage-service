package com.zyd.shiro.business.entity;

import com.zyd.shiro.framework.object.BaseConditionVO;
import lombok.Data;

@Data
public class AccountReceiveReq extends BaseConditionVO {

    private String payBegin;

    private String payEnd;

    private String village;

    private String costType;

    private String costName;

    private Integer billType;
}
