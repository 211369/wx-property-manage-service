package com.zyd.shiro.business.service;

import com.github.pagehelper.PageInfo;
import com.zyd.shiro.business.entity.*;

import java.util.List;
import java.util.Map;

public interface ApprovalService {
    List<Map> listUsers(Approval approval);
    PageInfo<Approval> queryToApproval(Approval approval);
    PageInfo<Approval> queryApproval(Approval approval);
    Approval queryDetail(String id);
    Map<String, Object> update(Approval approval);
    void updateRefundType(Approval approval);
    void updateDiscount(Approval approval);
    void add(Approval approval);
    Map<String, Object> addRefundApply(Approval approval);
    void delete(List<String> ids);
}
