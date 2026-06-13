package com.retailsphere.service.impl;

import com.retailsphere.dto.AddCartItemRequest;
import com.retailsphere.dto.CartItemResponse;
import com.retailsphere.dto.CartRequest;
import com.retailsphere.dto.CartResponse;
import com.retailsphere.entity.Cart;
import com.retailsphere.entity.CartItem;
import com.retailsphere.entity.Customer;
import com.retailsphere.entity.Product;
import com.retailsphere.exception.CartNotFoundException;
import com.retailsphere.exception.CustomerNotFoundException;
import com.retailsphere.exception.ProductNotFoundException;
import com.retailsphere.repository.CartItemRepository;
import com.retailsphere.repository.CartRepository;
import com.retailsphere.repository.CustomerRepository;
import com.retailsphere.repository.ProductRepository;
import com.retailsphere.service.CartService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import com.retailsphere.dto.ViewCartResponse;
import java.math.BigDecimal;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CartServiceImpl implements CartService {

    private final CartRepository cartRepository;
    private final CustomerRepository customerRepository;
    private final CartItemRepository cartItemRepository;
    private final ProductRepository productRepository;

    @Override
    public CartResponse createCart(
            CartRequest request) {

        Customer customer =
                customerRepository.findById(
                        request.getCustomerId())
                        .orElseThrow(() ->
                                new CustomerNotFoundException(
                                        request.getCustomerId()));

        Cart cart = Cart.builder()
                .customer(customer)
                .build();

        return mapToResponse(
                cartRepository.save(cart));
    }

    @Override
    public CartResponse getCartById(Long id) {

        Cart cart =
                cartRepository.findById(id)
                        .orElseThrow(() ->
                                new CartNotFoundException(id));

        return mapToResponse(cart);
    }

    @Override
    public CartItemResponse addItemToCart(
            Long cartId,
            AddCartItemRequest request) {

        Cart cart =
                cartRepository.findById(cartId)
                        .orElseThrow(() ->
                                new CartNotFoundException(cartId));

        Product product =
                productRepository.findById(
                        request.getProductId())
                        .orElseThrow(() ->
                                new ProductNotFoundException(
                                        request.getProductId()));

        CartItem cartItem = CartItem.builder()
                .cart(cart)
                .product(product)
                .quantity(request.getQuantity())
                .build();

        CartItem savedItem =
                cartItemRepository.save(cartItem);

        return CartItemResponse.builder()
                .id(savedItem.getId())
                .productId(product.getId())
                .productName(product.getName())
                .quantity(savedItem.getQuantity())
                .build();
    }

    private CartResponse mapToResponse(
            Cart cart) {

        return CartResponse.builder()
                .id(cart.getId())
                .customerId(cart.getCustomer().getId())
                .customerName(
                        cart.getCustomer().getFirstName()
                                + " "
                                + cart.getCustomer().getLastName())
                .createdAt(cart.getCreatedAt())
                .updatedAt(cart.getUpdatedAt())
                .build();
    }
    @Override
public ViewCartResponse viewCart(Long cartId) {

    Cart cart = cartRepository.findById(cartId)
            .orElseThrow(() ->
                    new CartNotFoundException(cartId));

    List<CartItem> cartItems =
            cartItemRepository.findByCartId(cartId);

    List<CartItemResponse> items =
            cartItems.stream()
                    .map(item ->
                            CartItemResponse.builder()
                                    .id(item.getId())
                                    .productId(
                                            item.getProduct().getId())
                                    .productName(
                                            item.getProduct().getName())
                                    .quantity(
                                            item.getQuantity())
                                    .build())
                    .toList();

    BigDecimal totalAmount =
            cartItems.stream()
                    .map(item ->
                            item.getProduct()
                                    .getPrice()
                                    .multiply(
                                            BigDecimal.valueOf(
                                                    item.getQuantity())))
                    .reduce(
                            BigDecimal.ZERO,
                            BigDecimal::add);

    return ViewCartResponse.builder()
            .cartId(cart.getId())
            .customerName(
                    cart.getCustomer().getFirstName()
                            + " "
                            + cart.getCustomer().getLastName())
            .items(items)
            .totalAmount(totalAmount)
            .build();
}
}
