package com.retailsphere.controller;

import com.retailsphere.service.JwtService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/test")
@RequiredArgsConstructor
public class TestController {

    private final JwtService jwtService;

    @GetMapping("/username")
    public String getUsername(
            @RequestParam String token) {

        return jwtService
                .extractUsername(token);
    }
}
