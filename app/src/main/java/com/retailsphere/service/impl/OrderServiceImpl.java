package com.retailsphere.service.impl;

import com.retailsphere.dto.OrderItemResponse;
import com.retailsphere.dto.OrderResponse;
import com.retailsphere.entity.Cart;
import com.retailsphere.entity.CartItem;
import com.retailsphere.entity.Order;
import com.retailsphere.entity.OrderItem;
import com.retailsphere.entity.OrderStatus;
import com.retailsphere.entity.Product;
import com.retailsphere.exception.CartNotFoundException;
import com.retailsphere.exception.InsufficientStockException;
import com.retailsphere.exception.OrderNotFoundException;
import com.retailsphere.repository.CartItemRepository;
import com.retailsphere.repository.CartRepository;
import com.retailsphere.repository.OrderItemRepository;
import com.retailsphere.repository.OrderRepository;
import com.retailsphere.repository.ProductRepository;
import com.retailsphere.service.OrderService;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import com.retailsphere.dto.OrderStatusRequest;

@Service
@RequiredArgsConstructor
public class OrderServiceImpl implements OrderService {

    private final CartRepository cartRepository;
    private final CartItemRepository cartItemRepository;
    private final OrderRepository orderRepository;
    private final OrderItemRepository orderItemRepository;
    private final ProductRepository productRepository;

    @Override
    @Transactional
    public OrderResponse checkout(Long cartId) {

        Cart cart = cartRepository.findById(cartId)
                .orElseThrow(() ->
                        new CartNotFoundException(cartId));

        List<CartItem> cartItems =
                cartItemRepository.findByCartId(cartId);

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

        Order order = Order.builder()
                .customer(cart.getCustomer())
                .totalAmount(totalAmount)
                .status(OrderStatus.PENDING)
                .build();

        Order savedOrder =
                orderRepository.save(order);

        for (CartItem cartItem : cartItems) {

            Product product =
                    cartItem.getProduct();

            if (product.getStockQuantity()
                    < cartItem.getQuantity()) {

                throw new InsufficientStockException(
                        product.getName());
            }

            product.setStockQuantity(
                    product.getStockQuantity()
                            - cartItem.getQuantity());

            productRepository.save(product);

            OrderItem orderItem =
                    OrderItem.builder()
                            .order(savedOrder)
                            .product(product)
                            .quantity(
                                    cartItem.getQuantity())
                            .price(product.getPrice())
                            .build();

            orderItemRepository.save(orderItem);
        }

        return getOrderById(savedOrder.getId());
    }

    @Override
    public OrderResponse getOrderById(Long orderId) {

        Order order =
                orderRepository.findById(orderId)
                        .orElseThrow(() ->
                                new OrderNotFoundException(
                                        orderId));

        List<OrderItemResponse> items =
                orderItemRepository
                        .findByOrderId(orderId)
                        .stream()
                        .map(item ->
                                OrderItemResponse.builder()
                                        .productId(
                                                item.getProduct().getId())
                                        .productName(
                                                item.getProduct().getName())
                                        .quantity(
                                                item.getQuantity())
                                        .price(
                                                item.getPrice())
                                        .build())
                        .toList();

        return OrderResponse.builder()
                .orderId(order.getId())
                .customerId(
                        order.getCustomer().getId())
                .customerName(
                        order.getCustomer().getFirstName()
                                + " "
                                + order.getCustomer().getLastName())
                .totalAmount(
                        order.getTotalAmount())
                .status(
                        order.getStatus())
                .items(items)
                .createdAt(
                        order.getCreatedAt())
                .build();
    }

    @Override
public List<OrderResponse> getOrdersByCustomerId(
        Long customerId) {

    return orderRepository
            .findByCustomerId(customerId)
            .stream()
            .map(order ->
                    getOrderById(order.getId()))
            .toList();
	}
	
    	@Override
@Transactional
public OrderResponse updateOrderStatus(
        Long orderId,
        OrderStatusRequest request) {

    Order order =
            orderRepository.findById(orderId)
                    .orElseThrow(() ->
                            new OrderNotFoundException(
                                    orderId));

    order.setStatus(
            request.getStatus());

    orderRepository.save(order);

    return getOrderById(orderId);
	}
}
