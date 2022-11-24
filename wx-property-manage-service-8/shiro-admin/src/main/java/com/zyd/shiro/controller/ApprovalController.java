package com.zyd.shiro.controller;

import com.github.pagehelper.PageInfo;
import com.zyd.shiro.business.entity.Approval;
import com.zyd.shiro.business.entity.BillInfo;
import com.zyd.shiro.business.service.ApprovalService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 审批管理
 */
@RestController
@Slf4j
public class ApprovalController {
    @Autowired
    private ApprovalService approvalService;

    /**
     * 查询全量用户
     * @param approval
     * @return
     */
    @PostMapping("/approval/listUsers")
    public ResponseEntity<List<Map>> listUsers(@RequestBody Approval approval){
        List<Map> list = approvalService.listUsers(approval);
        return ResponseEntity.status(HttpStatus.OK).body(list);
    }

    /**
     * 条件分页查询审批
     * @param approval
     * @return
     */
    @PostMapping("/approval/queryByPage")
    public ResponseEntity<PageInfo<Approval>> queryToApproval(@RequestBody Approval approval){
        PageInfo<Approval> list = approvalService.queryToApproval(approval);
        return ResponseEntity.status(HttpStatus.OK).body(list);
    }

    /**
     * 条件分页查询审批记录
     * @param approval
     * @return
     */
    @PostMapping("/approval/queryApproval")
    public ResponseEntity<PageInfo<Approval>> queryApproval(@RequestBody Approval approval){
        PageInfo<Approval> list = approvalService.queryApproval(approval);
        return ResponseEntity.status(HttpStatus.OK).body(list);
    }

    /**
     * 通过主键查询审批
     * @param id
     * @return
     */
    @GetMapping("/approval/queryDetail")
    public ResponseEntity<Approval> queryDetail(@RequestParam(value = "id") String id){
        Approval approval = approvalService.queryDetail(id);
        return ResponseEntity.status(HttpStatus.OK).body(approval);
    }

    /**
     * 新增审批
     * @param approval
     * @return
     */
    @PostMapping("/approval/add")
    public ResponseEntity<Map<String,Object>> add(@RequestBody Approval approval) {
        log.info("------提交审批------");
        Map<String,Object> map = new HashMap();
        try {
            approvalService.add(approval);
            map.put("code",200);
            map.put("msg","操作成功");
        }catch (Exception e){
            map.put("code",500);
            map.put("msg",e.getMessage());
        }
        return ResponseEntity.status(HttpStatus.OK).body(map);
    }

    /**
     * 退款审批流程发起
     * @return
     */
    @PostMapping("/approval/addRefundApply")
    public ResponseEntity<Map<String,Object>> addRefundApply(@RequestBody Approval approval) {
        log.info("------提交退款审批------");
        Map<String,Object> map = new HashMap();
        try {
            map = approvalService.addRefundApply(approval);
        }catch (Exception e){
            map.put("code",500);
            map.put("msg",e.getMessage());
        }
        return ResponseEntity.status(HttpStatus.OK).body(map);
    }

    /**
     * 审批退款折扣
     * @param approval
     * @return
     */
    @PostMapping("/approval/update")
    public ResponseEntity<Map<String,Object>> update(@RequestBody Approval approval) {
        log.info("------审批审批信息------");
        Map<String,Object> map = new HashMap();
        try {
            map = approvalService.update(approval);
//            map.put("code",200);
//            map.put("msg","操作成功");
        }catch (Exception e){
            map.put("code",500);
            map.put("msg",e.getMessage());
        }
        return ResponseEntity.status(HttpStatus.OK).body(map);
    }

    /**
     * 修改审批
     * @param approval
     * @return
     */
    @PostMapping("/approval/updateRefundType")
    public ResponseEntity<Map<String,Object>> updateRefundType(@RequestBody Approval approval) {
        log.info("------修改审批信息------");
        Map<String,Object> map = new HashMap();
        try {
            approvalService.updateRefundType(approval);
            map.put("code",200);
            map.put("msg","操作成功");
        }catch (Exception e){
            map.put("code",500);
            map.put("msg",e.getMessage());
        }
        return ResponseEntity.status(HttpStatus.OK).body(map);
    }

    /**
     * 修改申请
     * @param approval
     * @return
     */
    @PostMapping("/approval/updateDiscount")
    public ResponseEntity<Map<String,Object>> updateDiscount(@RequestBody Approval approval) {
        log.info("------修改审批信息------");
        Map<String,Object> map = new HashMap();
        try {
            approvalService.updateDiscount(approval);
            map.put("code",200);
            map.put("msg","操作成功");
        }catch (Exception e){
            map.put("code",500);
            map.put("msg",e.getMessage());
        }
        return ResponseEntity.status(HttpStatus.OK).body(map);
    }

    /**
     * 批量删除审批
     * @param ids
     * @return
     */
    @PostMapping("/approval/delete")
    public ResponseEntity<Map<String,Object>> delete(@RequestBody List<String> ids){
        log.info(ids.size()+"条记录-----即将删除审批记录");
        Map<String,Object> map = new HashMap();
        try {
            approvalService.delete(ids);
            map.put("code",200);
            map.put("msg","操作成功");
        }catch (Exception e){
            map.put("code",500);
            map.put("msg",e.getMessage());
        }
        return ResponseEntity.status(HttpStatus.OK).body(map);
    }

}
