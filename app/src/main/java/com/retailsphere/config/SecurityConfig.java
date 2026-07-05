package com.retailsphere.config;

import com.retailsphere.security.JwtAuthenticationFilter;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter;

    @Bean
    public PasswordEncoder passwordEncoder() {

        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(
            HttpSecurity http)
            throws Exception {

        http
                .csrf(csrf -> csrf.disable())

                .sessionManagement(session ->
                        session.sessionCreationPolicy(
                                SessionCreationPolicy.STATELESS))

                .authorizeHttpRequests(auth ->
 			       auth

			       		.requestMatchers(
                				"/actuator/health",
                				"/actuator/prometheus")
					.permitAll()

			                .requestMatchers(
                			        "/api/v1/auth/**")
                			.permitAll()

                			.requestMatchers(
                        			"/api/v1/products")
                			.hasAnyRole("USER", "ADMIN")

                			.requestMatchers(
                        			"/api/v1/orders/**")
                			.hasAnyRole("USER", "ADMIN")

                			.requestMatchers(
                        			"/api/v1/carts/**")
                			.hasAnyRole("USER", "ADMIN")

                			.requestMatchers(
                        			"/api/v1/categories/**")
                			.hasRole("ADMIN")

                			.anyRequest()
                			.authenticated()
				)

                .addFilterBefore(
                        jwtAuthenticationFilter,
                        UsernamePasswordAuthenticationFilter.class)

                .httpBasic(Customizer.withDefaults());

        return http.build();
    }
}
