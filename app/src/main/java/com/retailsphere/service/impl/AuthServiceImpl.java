package com.retailsphere.service.impl;

import com.retailsphere.dto.AuthResponse;
import com.retailsphere.dto.LoginRequest;
import com.retailsphere.dto.RegisterRequest;
import com.retailsphere.entity.User;
import com.retailsphere.entity.UserRole;
import com.retailsphere.repository.UserRepository;
import com.retailsphere.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import com.retailsphere.exception.InvalidCredentialsException;
import com.retailsphere.service.JwtService;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public AuthResponse register(
            RegisterRequest request) {

        User user = User.builder()
                .name(request.getName())
                .email(request.getEmail())
                .password(
                        passwordEncoder.encode(
                                request.getPassword()))
		 .role(
	request.getRole() != null
        ? UserRole.valueOf(
            request.getRole().toUpperCase())
        : UserRole.USER)
                .build();

        userRepository.save(user);

        return AuthResponse.builder()
        .token(
                jwtService.generateToken(user))
        .build();
    }

    @Override
public AuthResponse login(
        LoginRequest request) {

    User user = userRepository
            .findByEmail(request.getEmail())
            .orElseThrow(
                    InvalidCredentialsException::new);

    if (!passwordEncoder.matches(
            request.getPassword(),
            user.getPassword())) {

        throw new InvalidCredentialsException();
    }

    return AuthResponse.builder()
        .token(
                jwtService.generateToken(user))
        .build();
	}

private final JwtService jwtService;

}
