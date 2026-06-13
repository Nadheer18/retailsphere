package com.retailsphere.controller;

import com.retailsphere.dto.OrderResponse;
import com.retailsphere.response.ApiResponse;
import com.retailsphere.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import com.retailsphere.dto.OrderStatusRequest;

@RestController
@RequestMapping("/api/v1/orders")
@RequiredArgsConstructor
public class OrderController {

    private final OrderService orderService;

    @PostMapping("/checkout/{cartId}")
    public ApiResponse<OrderResponse> checkout(
            @PathVariable Long cartId) {

        return ApiResponse.<OrderResponse>builder()
                .success(true)
                .message("Order placed successfully")
                .data(orderService.checkout(cartId))
                .build();
    }

    @GetMapping("/{orderId}")
    public ApiResponse<OrderResponse> getOrderById(
            @PathVariable Long orderId) {

        return ApiResponse.<OrderResponse>builder()
                .success(true)
                .message("Order retrieved successfully")
                .data(orderService.getOrderById(orderId))
                .build();
    }

    @GetMapping("/customer/{customerId}")
public ApiResponse<List<OrderResponse>>
getOrdersByCustomerId(
        @PathVariable Long customerId) {

    return ApiResponse
            .<List<OrderResponse>>builder()
            .success(true)
            .message(
                    "Orders retrieved successfully")
            .data(
                    orderService
                            .getOrdersByCustomerId(
                                    customerId))
            .build();
	}

	@PutMapping("/{orderId}/status")
public ApiResponse<OrderResponse>
updateOrderStatus(
        @PathVariable Long orderId,
        @RequestBody OrderStatusRequest request) {

    return ApiResponse.<OrderResponse>builder()
            .success(true)
            .message(
                    "Order status updated successfully")
            .data(
                    orderService.updateOrderStatus(
                            orderId,
                            request))
            .build();
	}

}
