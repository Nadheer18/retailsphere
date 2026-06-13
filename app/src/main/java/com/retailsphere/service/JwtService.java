package com.retailsphere.service;

import com.retailsphere.entity.User;

public interface JwtService {

    String generateToken(User user);

    String extractUsername(String token);

    boolean validateToken(
        String token,
        org.springframework.security.core.userdetails.UserDetails userDetails);
}
