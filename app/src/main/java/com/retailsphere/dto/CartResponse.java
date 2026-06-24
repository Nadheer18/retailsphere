package com.retailsphere.dto;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class CartResponse {

    private Long id;

    private Long customerId;

    private String customerName;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;
}
