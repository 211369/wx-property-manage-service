package com.zyd.shiro.business.service.impl;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zyd.shiro.business.entity.*;
import com.zyd.shiro.business.service.ApprovalService;
import com.zyd.shiro.business.service.ChargeService;
import com.zyd.shiro.persistence.mapper.ApprovalMapper;
import com.zyd.shiro.persistence.mapper.ConfigMapper;
import com.zyd.shiro.util.SessionUtil;
import com.zyd.shiro.util.UUIDUtil;
import lombok.extern.slf4j.Slf4j;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@Transactional
@Slf4j
public class ApprovalServiceImpl implements ApprovalService {
    @Autowired
    private ApprovalMapper approvalMapper;
    @Autowired
    private ConfigMapper configMapper;

    @Autowired
    private ChargeService chargeService;

    @Override
    public List<Map> listUsers(Approval approval) {
        return approvalMapper.listUsers(approval);
    }

    @Override
    public PageInfo<Approval> queryToApproval(Approval approval) {
        //查询当前登录角色是否关联小区，若没有就全量查询，若有则查询关联小区
        Long userId = (Long) SecurityUtils.getSubject().getPrincipal();
        List<String> villages = configMapper.queryVillageByUserId(userId);
        if (villages.size() == 0){
            villages = configMapper.queryVillage();
        }
        //分页
        PageHelper.startPage(approval.getPageNumber(), approval.getPageSize());
        approval.setUserName(SessionUtil.getUser().getUsername());
        List<Approval> list = approvalMapper.queryToApproval(villages,approval);
        PageInfo bean = new PageInfo(list);
        return bean;
    }

    @Override
    public PageInfo<Approval> queryApproval(Approval approval) {
        //查询当前登录角色是否关联小区，若没有就全量查询，若有则查询关联小区
        Long userId = (Long) SecurityUtils.getSubject().getPrincipal();
        List<String> villages = configMapper.queryVillageByUserId(userId);
        if (villages.size() == 0){
            villages = configMapper.queryVillage();
        }
        //分页
        PageHelper.startPage(approval.getPageNumber(), approval.getPageSize());
        approval.setUserName(SessionUtil.getUser().getUsername());
        List<String> nextApproveUserList = approvalMapper.getNextApproveUser();
        approval.setNextApproveUserList(nextApproveUserList);
        List<Approval> list1 = approvalMapper.queryApproval1(villages, approval);
        List<Approval> list2 = approvalMapper.queryApproval2(villages, approval);
        list1.addAll(list2);
        PageInfo bean = new PageInfo(list1);
        return bean;
    }

    @Override
    public Approval queryDetail(String id) {
        return approvalMapper.queryDetail(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> update(Approval approval) {
        Map<String, Object> map = new HashMap<>();
        String nickname = approvalMapper.getNickname(SessionUtil.getUser().getUsername());
        //审批同意或拒绝
        if(approval.getStatus() == 1){
            //审批同意，审批人分类
//            List<Map> approvers=listUsers(approval);
            String descrition=approvalMapper.getDescriptionByNickname(nickname);
            if (descrition.contains("负责人")||descrition.contains("管理")) {
                //如果不是最后一级审批，更新审批人，进入下一级审批
                List<String> nextApproveUserList = approvalMapper.getNextApproveUser();
                approval.setNextApproveUserList(nextApproveUserList);
                //List<String> nextApproveUserList = approvalMapper.getNextApproveUser();
                String nextApproveUser = "";
                for(String approveUser : nextApproveUserList){
                    nextApproveUser += "," + approveUser;
                }
                nextApproveUser = nextApproveUser.substring(1);
                approval.setNextApproveUser(nextApproveUser); //多个用户用逗号隔开
                approval.setUpdateTime(new Date());
                approvalMapper.updateStatus(approval);
                approval.setRefundId(UUIDUtil.getUUID());
                if(approval.getRefundType().equals("原路退回")){
                    approval.setRefundType("0");
                }else if(approval.getRefundType().equals("指定收款账户退款")) {
                    approval.setRefundType("1");
                }else {
                    approval.setRefundType("2");
                }
                approval.setApprovalLevel(2);
                approvalMapper.insertNewRefundApproval(approval);
                map.put("code",200);
                map.put("msg","退款审批通过，进行下一级审批");
            } else if(descrition.contains("财务")){
                //如果是最后一级财务审批，更新申请内容和审批状态
                approval.setUpdateTime(new Date());
                approval.setApprovalFlag("1");  //审批完成标记

                if(approval.getRefundType().equals("原路退回")){
                    //调用退款接口
                    BillInfo billInfo = approvalMapper.getBillInfo(approval);
                    BillItem billItem = approvalMapper.getBillItem(approval);
//                billInfo.setBillItem(billItem);
                    map = chargeService.depositRefund(billInfo,billItem);  //修改接口

                    if(!map.get("code").toString().equals("200")){
                        return map;
                    }else{
                        approvalMapper.updateApproval(approval);
                        approvalMapper.updateRefundApproval(approval);
                    }
                }else{
                    map.put("code",200);
                    map.put("msg","审批完成，可进行退款");
                }
            }
        }else {
            //审批拒绝，更改状态
            approval.setUpdateTime(new Date());
            approvalMapper.updateApprovalStatus(approval);
            approvalMapper.updateRefundApprovalStatus(approval);
            map.put("code",200);
            map.put("msg","退款审批拒绝，审批流程结束");
        }
        return map;
    }
    @Override
    public void updateRefundType(Approval approval) {
        if(approval.getRefundType().equals("原路退回")){
            approval.setRefundType("0");
        }else if(approval.getRefundType().equals("指定收款账户退款")) {
            approval.setRefundType("1");
        }else {
            approval.setRefundType("2");
        }
        approvalMapper.updateRefundType(approval);
        approvalMapper.updateApprovalRefundType(approval);
    }

    @Override
    public void updateDiscount(Approval approval) {
        approvalMapper.updateDiscount(approval);
    }

    @Override
    public void add(Approval approval) {
        approval.setId(UUIDUtil.getUUID());
        approval.setDiscountId(UUIDUtil.getUUID());
        approval.setStatus(0);
        approval.setInsertTime(new Date());
        approval.setApprovalType("折扣申请");
        approval.setApprovalFlag("0");  //审批开始标记
        approvalMapper.insertDiscountApproval(approval);
        approvalMapper.insertApproval(approval);
    }

    @Override
    public Map<String, Object> addRefundApply(Approval approval) {
        Map<String, Object> map = new HashMap<>();

        approval.setStatus(0);
        approval.setInsertTime(new Date());
        approval.setApprovalType("退款审批");
        approval.setApprovalFlag("0");
        //判断是否重复发起审批
        int exist = approvalMapper.existRefundApproval(approval);
        int num = approvalMapper.existApproval(approval);
        if(exist > 0 || num>0){
            map.put("code", 500);
            map.put("msg", "退款审批发起失败，存在重复退款审批");
        }else{
            //发起退款审批
            approval.setId(UUIDUtil.getUUID());
            approvalMapper.insertApproval(approval);
            approval.setRefundId(UUIDUtil.getUUID());
            approval.setApprovalLevel(1);
            approvalMapper.insertRefundApproval(approval);
            map.put("code",200);
            map.put("msg","退款审批发起成功");
        }
        return map;
    }

    @Override
    public void delete(List<String> ids) {
//        approvalMapper.deleteApproval(ids);
        approvalMapper.deleteDiscountApproval(ids);
        approvalMapper.deleteRefundApproval(ids);
    }
}
