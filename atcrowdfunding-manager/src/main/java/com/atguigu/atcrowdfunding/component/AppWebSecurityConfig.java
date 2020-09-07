package com.atguigu.atcrowdfunding.component;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Configurable;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.annotation.web.reactive.EnableWebFluxSecurity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.security.web.authentication.rememberme.JdbcTokenRepositoryImpl;


import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;
import java.io.IOException;

/**
 * @author clh
 * @description
 * @date
 */
@Configurable //配置类 相当于xml文件
@EnableWebFluxSecurity //开启权限框架
@EnableGlobalMethodSecurity(prePostEnabled = true)  //开启细粒度的权限控制功能。
public class AppWebSecurityConfig extends WebSecurityConfigurerAdapter {
    //WebSecurityConfigurerAdapter 适配器


    @Autowired
    UserDetailsService userDetailsService;

    @Autowired
    DataSource dataSource;//数据源


    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        //默认 认证处理 ，任何登录信息都无法认证。
        //super.configure(auth);

        //基于数据库的认证
        auth.userDetailsService(userDetailsService).passwordEncoder(new BCryptPasswordEncoder());
    }


    @Override
    protected void configure(HttpSecurity httpSecurity) throws Exception {


        //1.基于角色的访问控制
        httpSecurity.authorizeRequests()
                //login页面直接放行 静态资源
                .antMatchers("/login.jsp","/static/**").permitAll()
                    .anyRequest().authenticated();//authenticated 已认证翻译


//        自定义登录表单
        httpSecurity.formLogin()
                .loginPage("/login.jsp")//登录页面
                .loginProcessingUrl("/login")
                .usernameParameter("loginacct")
                .passwordParameter("userpswd")
                .defaultSuccessUrl("/main");//登录成功到main
        //用户注销
        httpSecurity.logout()
                .logoutUrl("/logoutUrl")
                .logoutSuccessUrl("login.jsp");


        //自定义访问拒绝处理页面
        httpSecurity.exceptionHandling().accessDeniedHandler(new AccessDeniedHandler() {
            @Override
            public void handle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, AccessDeniedException e) throws IOException, ServletException {
                //需要考虑，同步，异步两种不同请求的处理？？？？？

                httpServletRequest.getRequestDispatcher("/WEB-INF/jsp/unauth.jsp").forward(httpServletRequest,httpServletResponse);
            }
        });


        //记住我功能 - 数据库版
        JdbcTokenRepositoryImpl ptr = new JdbcTokenRepositoryImpl();
        ptr.setDataSource(dataSource);
        httpSecurity.rememberMe().tokenRepository(ptr);


        //暂时禁用csrf (防止跨站请求伪造)
        httpSecurity.csrf().disable();
    }
}