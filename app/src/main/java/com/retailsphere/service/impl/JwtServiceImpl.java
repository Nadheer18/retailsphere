package com.retailsphere.service.impl;

import com.retailsphere.entity.User;
import com.retailsphere.service.JwtService;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import java.util.Date;

@Service
public class JwtServiceImpl implements JwtService {

    private static final String SECRET_KEY =
            "retailsphere-secret-key-retailsphere-secret-key";

    @Override
    public String generateToken(User user) {

        return Jwts.builder()
                .subject(user.getEmail())
                .claim("role", user.getRole().name())
                .issuedAt(new Date())
                .expiration(
                        new Date(
                                System.currentTimeMillis()
                                        + 86400000))
                .signWith(
                        SignatureAlgorithm.HS256,
                        SECRET_KEY.getBytes())
                .compact();
    }

    @Override
    public String extractUsername(
            String token) {

        Claims claims =
                Jwts.parser()
                        .setSigningKey(
                                SECRET_KEY.getBytes())
                        .build()
                        .parseSignedClaims(token)
                        .getPayload();

        return claims.getSubject();
    }

    @Override
    public boolean validateToken(
            String token,
            UserDetails userDetails) {

        String username =
                extractUsername(token);

        return username.equals(
                userDetails.getUsername());
    }
}
