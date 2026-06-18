package com.retailsphere.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI retailSphereOpenAPI() {

        return new OpenAPI()
                .info(
                        new Info()
                                .title("RetailSphere API")
                                .version("1.0")
                                .description(
                                        "RetailSphere E-Commerce Backend API")
                                .contact(
                                        new Contact()
                                                .name("Nadheer")
                                                .email("admin@retailsphere.com")
                                )
                );
    }
}
