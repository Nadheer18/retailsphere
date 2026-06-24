package com.retailsphere.service;

import com.retailsphere.dto.OrderResponse;
import java.util.List;
import com.retailsphere.dto.OrderStatusRequest;

public interface OrderService {

    OrderResponse checkout(Long cartId);

    OrderResponse getOrderById(Long orderId);

List<OrderResponse> getOrdersByCustomerId(
        Long customerId);

OrderResponse updateOrderStatus(
        Long orderId,
        OrderStatusRequest request);

}
