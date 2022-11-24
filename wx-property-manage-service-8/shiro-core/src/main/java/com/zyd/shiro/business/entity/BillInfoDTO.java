package com.zyd.shiro.business.entity;

import com.github.pagehelper.PageInfo;
import lombok.Data;

@Data
public class BillInfoDTO {

    private HouseInfo houseInfo;

    private PageInfo<BillInfo> pageInfo;
}
