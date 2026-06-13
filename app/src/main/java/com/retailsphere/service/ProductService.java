package com.retailsphere.service;

import com.retailsphere.dto.ProductRequest;
import com.retailsphere.dto.ProductResponse;

import java.util.List;

public interface ProductService {

    ProductResponse createProduct(ProductRequest request);

    List<ProductResponse> getAllProducts();

    ProductResponse getProductById(Long id);

    ProductResponse updateProduct(
            Long id,
            ProductRequest request);

    void deleteProduct(Long id);
}
