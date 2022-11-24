package com.zyd.shiro.business.entity;

import lombok.Data;

import java.util.List;

@Data
public class PayDTO extends WechatDTO{

    private String houseId;

    private String type;

    private Double totalMoney;

    private Double cashMoney;

    private Double cardMoney;

    private Double qrCodeMoney;

    private List<BillItem> itemList;

    private String shopId;
}
