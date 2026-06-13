package com.retailsphere.service;

import com.retailsphere.dto.CartRequest;
import com.retailsphere.dto.CartResponse;
import com.retailsphere.dto.AddCartItemRequest;
import com.retailsphere.dto.CartItemResponse;
import com.retailsphere.dto.ViewCartResponse;

public interface CartService {

    CartResponse createCart(
            CartRequest request);

    CartResponse getCartById(Long id);

    CartItemResponse addItemToCart(
        Long cartId,
        AddCartItemRequest request);
    ViewCartResponse viewCart(Long cartId);
}
