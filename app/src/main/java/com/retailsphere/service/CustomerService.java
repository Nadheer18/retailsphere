package com.retailsphere.service;

import com.retailsphere.dto.CustomerRequest;
import com.retailsphere.dto.CustomerResponse;

import java.util.List;

public interface CustomerService {

    CustomerResponse createCustomer(
            CustomerRequest request);

    List<CustomerResponse> getAllCustomers();

    CustomerResponse getCustomerById(Long id);

    CustomerResponse updateCustomer(
            Long id,
            CustomerRequest request);

    void deleteCustomer(Long id);
}
