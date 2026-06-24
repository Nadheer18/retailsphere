package com.retailsphere.service;

import com.retailsphere.dto.AuthResponse;
import com.retailsphere.dto.LoginRequest;
import com.retailsphere.dto.RegisterRequest;

public interface AuthService {

    AuthResponse register(
            RegisterRequest request);

    AuthResponse login(
            LoginRequest request);
}
