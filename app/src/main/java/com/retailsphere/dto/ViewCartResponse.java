package com.retailsphere.dto;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
@Builder
public class ViewCartResponse {

    private Long cartId;

    private String customerName;

    private List<CartItemResponse> items;

    private BigDecimal totalAmount;
}
