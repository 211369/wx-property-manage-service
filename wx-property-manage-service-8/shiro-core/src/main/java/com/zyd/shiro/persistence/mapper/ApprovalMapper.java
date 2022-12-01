package com.zyd.shiro.persistence.mapper;

import com.zyd.shiro.business.entity.*;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface ApprovalMapper {
    List<Map> listUsers(Approval approval);

    List<Approval> queryToApproval(@Param("villages") List<String> villages, @Param("a")Approval approval);

    List<Approval> queryApproval1(@Param("villages") List<String> villages, @Param("a")Approval approval);

    List<Approval> queryApproval2(@Param("villages") List<String> villages, @Param("a")Approval approval);

    Approval queryDetail(String id);

    int existApproval(Approval approval);

    void insertApproval(Approval approval);

    void insertRefundApproval(Approval approval);

    void insertNewRefundApproval(Approval approval);

    void insertDiscountApproval(Approval approval);

    int existRefundApproval(Approval approval);

    String getId(Approval approval);

//    String getNextUserName(Approval approval);

    String getNickname(String username);

    List<String> getNextApproveUser();

    void updateStatus(Approval approval);

    void updateApprovalStatus(Approval approval);

    void updateRefundApprovalStatus(Approval approval);

    void updateApproval(Approval approval);

    void updateRefundApproval(Approval approval);

    BillInfo getBillInfo(Approval approval);

    BillItem getBillItem(Approval approval);

//    void changeRefundStatus(Approval approval);

    void updateRefundType(Approval approval);

    void updateApprovalRefundType(Approval approval);

    void updateDiscount(Approval approval);

//    void deleteApproval(@Param("ids") List<String> ids);

    void deleteDiscountApproval(@Param("ids") List<String> ids);

    void deleteRefundApproval(@Param("ids") List<String> ids);

    void deleteApprovals(@Param("ids") List<String> ids);

    String getDescriptionByNickname(@Param("nickname") String nickname);
}
