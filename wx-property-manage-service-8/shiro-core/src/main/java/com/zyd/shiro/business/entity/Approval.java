package com.zyd.shiro.business.entity;

import com.zyd.shiro.framework.object.BaseConditionVO;
import lombok.Data;

import java.util.Date;
import java.util.List;


@Data
public class Approval extends BaseConditionVO {
    private String id;

    private String discountId;

    private String refundId;

    private String applyUser;

    private String approveUser;

    private String nextApproveUser;

    private String discountRate;

    private String discount;

    private Integer status;

    private Date insertTime;

    private Date updateTime;

    private String orderId;

    private String houseId;

    private String village;

    private String building;

    private String location;

    private String room;

    private String ownerName;

    private String ownerPhone;

    private String approvalType;

    private String refundType;

    private String costName;

    private String costType;

    private String pay;

    private Long userId;

    private Integer billType;

    private String remark;

    private String approvalFlag;

    private String userName;

    private String costId;

    private List<String> nextApproveUserList;

    private Integer approvalLevel;
}
