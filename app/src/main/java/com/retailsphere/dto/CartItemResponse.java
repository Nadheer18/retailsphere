package com.retailsphere.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CartItemResponse {

    private Long id;

    private Long productId;

    private String productName;

    private Integer quantity;
}
