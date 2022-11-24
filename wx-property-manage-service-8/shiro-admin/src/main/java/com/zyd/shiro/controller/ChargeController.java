package com.zyd.shiro.controller;

import com.github.pagehelper.PageInfo;
import com.zyd.shiro.business.entity.*;
import com.zyd.shiro.business.service.ChargeService;
import com.zyd.shiro.business.service.ConfigService;
import com.zyd.shiro.framework.object.ResponseVO;
import com.zyd.shiro.util.PasswordUtil;
import com.zyd.shiro.util.ResultUtil;
import lombok.extern.slf4j.Slf4j;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 收费管理
 */
@RestController
@Slf4j
public class ChargeController {
    @Autowired
    private ChargeService chargeService;
    @Autowired
    private ConfigService configService;

    /**
     * 查询全量小区
     * @return
     */
    @GetMapping("/charge/queryVillage")
    public ResponseEntity<List<String>> queryVillage(){
        //查询当前登录角色是否关联小区，若没有就全量查询，若有则查询关联小区
        Long userId = (Long) SecurityUtils.getSubject().getPrincipal();
        List<String> villages = configService.queryVillageByUserId(userId);
        if (villages.size() == 0){
            villages = configService.queryVillage();
        }
        return ResponseEntity.status(HttpStatus.OK).body(villages);
    }


    /**
     * 查询全量小区
     * @return
     */
    @GetMapping("/charge/queryVillageNotConfig")
    public ResponseEntity<List<String>> queryVillageNotConfig(){
        //查询当前登录角色是否关联小区，若没有就全量查询，若有则查询关联小区
        Long userId = (Long) SecurityUtils.getSubject().getPrincipal();
        List<String> villages = configService.queryVillageNotConfigByUserId(userId);
        if (villages.size() == 0){
            villages = configService.queryVillageNotConfig();
        }
        return ResponseEntity.status(HttpStatus.OK).body(villages);
    }

    /**
     * 通过小区查楼栋
     * @return
     */
    @GetMapping("/charge/queryBuildingByVillage")
    public ResponseEntity<List<String>> queryBuildingByVillage(@RequestParam String village){
        List<String> buildings = chargeService.queryBuildingByVillage(village);
        return ResponseEntity.status(HttpStatus.OK).body(buildings);
    }

    /**
     * 通过小区楼栋查单元
     * @return
     */
    @GetMapping("/charge/queryLocationByVillageBuilding")
    public ResponseEntity<List<String>> queryLocationByVillageBuilding(@RequestParam String village,@RequestParam String building){
        List<String> locations = chargeService.queryLocationByVillageBuilding(village,building);
        return ResponseEntity.status(HttpStatus.OK).body(locations);
    }
    /**
     * 通过小区楼栋单元查房间
     * @return
     */
    @GetMapping("/charge/queryHouse")
    public ResponseEntity<List<String>> queryHouse(@RequestParam String village,@RequestParam String building,@RequestParam String location){
        List<String> houses = chargeService.queryHouse(village,building,location);
        return ResponseEntity.status(HttpStatus.OK).body(houses);
    }

    /**
     * 小程序查询房屋id
     * @return
     */
    @PostMapping("/charge/queryHouseInfo")
    public ResponseEntity<List<HouseInfo>> queryHouseInfo(@RequestBody List<Map<String,String>> list){
        List<HouseInfo> res = new ArrayList<>();
        for (Map<String,String> map:list) {
            HouseInfo house = chargeService.queryHouseInfo(map.get("village"),
                    map.get("building"),
                    map.get("location"),
                    map.get("room"));
            res.add(house);
        }
        return ResponseEntity.status(HttpStatus.OK).body(res);
    }

    /**
     * 小程序查询业主绑定房屋
     * @return
     */
    @GetMapping("/charge/queryBind")
    public ResponseEntity<List<ChargeDTO>> queryBind(@RequestParam String phone){
        List<ChargeDTO> houses = chargeService.queryBind(phone);
        return ResponseEntity.status(HttpStatus.OK).body(houses);
    }

    /**
     * 小程序新增业主绑定房屋
     * @return
     */
    @PostMapping("/charge/addBind")
    public ResponseEntity addBind(@RequestBody List<Map<String,String>> list){
        Map<String,Object> res = new HashMap();
        try {
            for (Map<String,String> map:list) {
                log.info("业主"+map.get("phone")+"绑定房屋"+map.get("houseId"));
                chargeService.addBind(map.get("phone"),map.get("houseId"));
            }
            res.put("code",200);
            res.put("msg","操作成功");
        }catch (Exception e){
            res.put("code",500);
            res.put("msg",e.getMessage());
        }
        return ResponseEntity.status(HttpStatus.OK).body(res);
    }

    /**
     * 小程序删除业主绑定房屋
     * @return
     */
    @PostMapping("/charge/deleteBind")
    public ResponseEntity deleteBind(@RequestBody List<Map<String,String>> list){
        Map<String,Object> res = new HashMap();
        try {
            for (Map<String,String> map:list) {
                log.info("业主"+map.get("phone")+"解绑房屋"+map.get("houseId"));
                chargeService.deleteBind(map.get("phone"),map.get("houseId"));
            }
            res.put("code",200);
            res.put("msg","操作成功");
        }catch (Exception e){
            res.put("code",500);
            res.put("msg",e.getMessage());
        }
        return ResponseEntity.status(HttpStatus.OK).body(res);
    }

    /**
     * 查询欠费信息
     * @return
     */
    @GetMapping("/charge/queryCharge")
    public ResponseEntity<ChargeDTO> queryCharge(@RequestParam String village, @RequestParam String building,
                                                 @RequestParam String location,@RequestParam String room,
                                                 @RequestParam int year){
        ChargeDTO chargeDTO = chargeService.queryCharge(village,building,location,room,year);
        return ResponseEntity.status(HttpStatus.OK).body(chargeDTO);
    }

    /**
     * 查询欠费金额
     * @return
     */
    @PostMapping("/charge/countPay")
    public ResponseEntity<Double> countPay(@RequestBody BillItem billItem) {
        Double money = chargeService.countPay(billItem);
        return ResponseEntity.status(HttpStatus.OK).body(money);
    }

    /**
     * 支付
     * @return
     */
    @PostMapping("/charge/pay")
    public ResponseEntity<Map<String,Object>> pay(@RequestBody PayDTO payDTO) {
        Map<String,Object> map = chargeService.pay(payDTO);
        return ResponseEntity.status(HttpStatus.OK).body(map);
    }

    /**
     * 支付回调
     * @return
     */
    @PostMapping("/order/notify")
    public ResponseEntity<Void> notifyOrder(@RequestBody OrderResult orderResult) {
        log.info("回调传参:{}",orderResult);
        chargeService.notifyOrder(orderResult);
        return ResponseEntity.noContent().build();
    }


    /**
     * 查询已缴明细
     * @return
     */
    @GetMapping("/charge/queryBill")
    public ResponseEntity<BillInfoDTO> queryBill(@RequestParam String village, @RequestParam String building,
                                                        @RequestParam String location, @RequestParam String room,
                                                        @RequestParam Integer page,@RequestParam Integer pageSize){
        BillInfoDTO billInfoDTO = chargeService.queryBill(village,building,location,room,page,pageSize);
        return ResponseEntity.status(HttpStatus.OK).body(billInfoDTO);
    }

    /**
     * 查询退款金额
     * @return
     */
    @PostMapping("/charge/countRefundMoney")
    public ResponseEntity<Double> countRefundMoney(@RequestBody BillItem billItem) {
        Double money = chargeService.countRefundMoney(billItem);
        return ResponseEntity.status(HttpStatus.OK).body(money);
    }

    /**
     * 退款
     * @return
     */
    @PostMapping("/charge/refund")
    public ResponseEntity<Map<String,Object>> refund(@RequestBody BillInfo billInfo) {
        Map<String,Object> map = chargeService.refund(billInfo);
        return ResponseEntity.status(HttpStatus.OK).body(map);
    }

    /**
     * 查询押金台账
     * @return
     */
    @PostMapping("/charge/queryDeposit")
    public ResponseEntity<PageInfo<Deposit>> queryDeposit(@RequestBody Deposit deposit){
        PageInfo<Deposit> list = chargeService.queryDeposit(deposit);
        return ResponseEntity.status(HttpStatus.OK).body(list);
    }

    /**
     * 查询退款管理列表
     * @return
     */
    @PostMapping("/charge/queryRefundList")
    public ResponseEntity<PageInfo<Deposit>> queryRefundList(@RequestBody Deposit deposit){
        PageInfo<Deposit> list = chargeService.queryRefundList(deposit);
        return ResponseEntity.status(HttpStatus.OK).body(list);
    }

    /**
     * 小程序相关
     */
    @GetMapping("/order/getAuth")
    public ResponseEntity<Map<String,String>> getAuth(@RequestParam String code){
        Map<String,String> map = chargeService.getAuth(code);
        return ResponseEntity.status(HttpStatus.OK).body(map);
    }

    /**
     * 解密，保存手机及openid
     * @param auth
     * @return
     */
    @PostMapping("/order/saveAuth")
    public ResponseEntity<String> saveAuth(@RequestBody Auth auth){
        String phone = chargeService.saveAuth(auth);
        return ResponseEntity.status(HttpStatus.OK).body(phone);
    }

    @PostMapping("/order/wechatPay")
    public ResponseEntity<Map<String,Object>> wechatPay(@RequestBody PayDTO payDTO){
        Map<String,Object> map = chargeService.pay(payDTO);
        return ResponseEntity.status(HttpStatus.OK).body(map);
    }

}
