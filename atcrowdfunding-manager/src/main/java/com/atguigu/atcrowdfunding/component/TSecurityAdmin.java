package com.atguigu.atcrowdfunding.component;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;

import java.util.Set;

/**
 * @author clh
 * @description
 * @date
 */
public class TSecurityAdmin  extends User {

    private TAdmin tAdmin;
    private Set<GrantedAuthority> authorities;

    public TSecurityAdmin(TAdmin admin,Set<GrantedAuthority> authorities){

        super(admin.getLoginacct(),admin.getUserpswd(),true,true,true,true,authorities);
        this.authorities  = authorities;
        this.tAdmin = admin;

    }

    public TAdmin gettAdmin() {
        return tAdmin;
    }

    public void settAdmin(TAdmin tAdmin) {
        this.tAdmin = tAdmin;
    }

    @Override
    public Set<GrantedAuthority> getAuthorities() {
        return authorities;
    }

    public void setAuthorities(Set<GrantedAuthority> authorities) {
        this.authorities = authorities;
    }
}
   