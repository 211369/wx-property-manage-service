package com.zyd.shiro.business.entity;

import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
public class BillGather {

    private String costName;

    private String costTypeSection;

    private BigDecimal perSum = new BigDecimal(0);

    private BigDecimal cash = new BigDecimal(0);

    private BigDecimal qrCode = new BigDecimal(0);

    private BigDecimal card = new BigDecimal(0);

    private String remark;

}
