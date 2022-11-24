package com.zyd.shiro.business.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PageResult<T> {
    private List<T> items; // 返回结果
    private Long total; //总条数
    private Long totalPage; //总页数
}
