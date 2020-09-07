package com.atguigu.atcrowdfunding.component;

import com.atguigu.atcrowdfunding.bean.*;
import com.atguigu.atcrowdfunding.mapper.TAdminMapper;
import com.atguigu.atcrowdfunding.mapper.TAdminRoleMapper;
import com.atguigu.atcrowdfunding.mapper.TPermissionMapper;
import com.atguigu.atcrowdfunding.mapper.TRoleMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * @author clh
 * @description
 * @date
 */
@Component
public class UserDetailsServiceImpl implements UserDetailsService {
    @Autowired
    TAdminMapper adminMapper;

    @Autowired
    TRoleMapper roleMapper;

    @Autowired
    TPermissionMapper permissionMapper;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        //1.查询用户
        TAdminExample example = new TAdminExample();
        example.createCriteria().andLoginacctEqualTo(username);
        List<TAdmin> list = adminMapper.selectByExample(example);

        if(list == null || list.size() == 0){
            return null; //如果用户不存在，返回null给框架，框架就会抛异常。
        }

        TAdmin admin = list.get(0);
        Integer adminId = admin.getId();

        //2.查询用户的角色
        List<TRole> myRoleList = roleMapper.listRoleByAdminId(adminId);

        //3.查询用户的权限
        List<TPermission> myPermissionList = permissionMapper.listPermissionByAdminId(adminId);


        //4.构建用户的权限的集合
        Set<GrantedAuthority> authorities = new HashSet<GrantedAuthority>();

        for (TRole role : myRoleList) {//角色加ROLE_
            authorities.add(new SimpleGrantedAuthority("ROLE_"+role.getName()));
        }

        for (TPermission permission : myPermissionList) {//权限本身就行
            authorities.add(new SimpleGrantedAuthority(permission.getName()));
        }

        System.out.println(admin.getLoginacct());
        System.out.println(authorities);

        //5.返回用户信息及这个用户的权限集合

        return new User(admin.getLoginacct(),admin.getUserpswd(),authorities);
    }
}
   