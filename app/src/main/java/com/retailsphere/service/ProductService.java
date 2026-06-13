package com.retailsphere.service;

import com.retailsphere.dto.ProductRequest;
import com.retailsphere.entity.Product;

import java.util.List;

public interface ProductService {

    Product createProduct(ProductRequest request);

    List<Product> getAllProducts();

    Product getProductById(Long id);

    void deleteProduct(Long id);
}
