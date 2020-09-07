package com.atguigu.atcrowdfunding.listener;

import com.atguigu.atcrowdfunding.util.Const;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class AppStartUpListener implements ServletContextListener {
    Logger logger = LoggerFactory.getLogger(getClass());
    /**
     * 项目启动调用
     */
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext servletContext = sce.getServletContext();
        String contextPath = servletContext.getContextPath();
        //保存项目路径
        servletContext.setAttribute(Const.PATH, contextPath);
        logger.info("项目启动完成....");
    }
    /**
     * 项目停止调用
     */
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }


}
