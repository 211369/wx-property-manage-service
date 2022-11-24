package com.zyd.shiro.business.service.impl;

import com.zyd.shiro.business.service.ReportService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;

import java.text.ParseException;

@Configuration      //1.主要用于标记配置类，兼备Component的效果。
@EnableScheduling   //2.开启定时任务
@Slf4j
public class ReportJobServiceImpl {
    @Autowired
    private ReportService reportService;
    //3.添加定时任务
//    @Scheduled(cron = "5 * * * * ?")
    @Scheduled(cron = "0 12 12 * * ?")
    private void configureTasks() throws ParseException {
        log.info("========开始执行报表计算==========");
        reportService.houseBillForJob();
        log.info("========结束执行报表计算==========");
    }
}
