package com.zyd.shiro.business.entity;

import lombok.Data;

import java.util.List;
import java.util.Map;


@Data
public class BillDetailDTO {

    private BillInfo billInfo;
    
    private Map<String,List<BillItem>> items;
    
}
