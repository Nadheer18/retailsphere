package com.retailsphere.controller;

import com.retailsphere.dto.CustomerRequest;
import com.retailsphere.dto.CustomerResponse;
import com.retailsphere.response.ApiResponse;
import com.retailsphere.service.CustomerService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/customers")
@RequiredArgsConstructor
public class CustomerController {

    private final CustomerService customerService;

    @PostMapping
    public ApiResponse<CustomerResponse> createCustomer(
            @Valid @RequestBody CustomerRequest request) {

        return ApiResponse.<CustomerResponse>builder()
                .success(true)
                .message("Customer created successfully")
                .data(customerService.createCustomer(request))
                .build();
    }

    @GetMapping
    public ApiResponse<List<CustomerResponse>> getAllCustomers() {

        return ApiResponse.<List<CustomerResponse>>builder()
                .success(true)
                .message("Customers retrieved successfully")
                .data(customerService.getAllCustomers())
                .build();
    }

    @GetMapping("/{id}")
    public ApiResponse<CustomerResponse> getCustomerById(
            @PathVariable Long id) {

        return ApiResponse.<CustomerResponse>builder()
                .success(true)
                .message("Customer retrieved successfully")
                .data(customerService.getCustomerById(id))
                .build();
    }

    @PutMapping("/{id}")
    public ApiResponse<CustomerResponse> updateCustomer(
            @PathVariable Long id,
            @Valid @RequestBody CustomerRequest request) {

        return ApiResponse.<CustomerResponse>builder()
                .success(true)
                .message("Customer updated successfully")
                .data(customerService.updateCustomer(id, request))
                .build();
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> deleteCustomer(
            @PathVariable Long id) {

        customerService.deleteCustomer(id);

        return ApiResponse.<Void>builder()
                .success(true)
                .message("Customer deleted successfully")
                .build();
    }
}
