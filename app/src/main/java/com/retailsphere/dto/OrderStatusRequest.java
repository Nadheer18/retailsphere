package com.retailsphere.dto;

import com.retailsphere.entity.OrderStatus;
import lombok.Data;

@Data
public class OrderStatusRequest {

    private OrderStatus status;
}
