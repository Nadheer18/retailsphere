package com.retailsphere.controller;

import com.retailsphere.dto.AddCartItemRequest;
import com.retailsphere.dto.CartItemResponse;
import com.retailsphere.dto.CartRequest;
import com.retailsphere.dto.CartResponse;
import com.retailsphere.response.ApiResponse;
import com.retailsphere.service.CartService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import com.retailsphere.dto.ViewCartResponse;

@RestController
@RequestMapping("/api/v1/carts")
@RequiredArgsConstructor
public class CartController {

    private final CartService cartService;

    @PostMapping
    public ApiResponse<CartResponse> createCart(
            @Valid @RequestBody CartRequest request) {

        return ApiResponse.<CartResponse>builder()
                .success(true)
                .message("Cart created successfully")
                .data(cartService.createCart(request))
                .build();
    }

    @GetMapping("/{id}")
    public ApiResponse<CartResponse> getCartById(
            @PathVariable Long id) {

        return ApiResponse.<CartResponse>builder()
                .success(true)
                .message("Cart retrieved successfully")
                .data(cartService.getCartById(id))
                .build();
    }

    @PostMapping("/{cartId}/items")
    public ApiResponse<CartItemResponse> addItemToCart(
            @PathVariable Long cartId,
            @Valid @RequestBody AddCartItemRequest request) {

        return ApiResponse.<CartItemResponse>builder()
                .success(true)
                .message("Item added to cart successfully")
                .data(
                        cartService.addItemToCart(
                                cartId,
                                request))
                .build();
    }
    @GetMapping("/{cartId}/items")
public ApiResponse<ViewCartResponse> viewCart(
        @PathVariable Long cartId) {

    return ApiResponse.<ViewCartResponse>builder()
            .success(true)
            .message("Cart retrieved successfully")
            .data(cartService.viewCart(cartId))
            .build();
}
}
