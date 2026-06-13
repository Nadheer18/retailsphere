package com.retailsphere.controller;

import com.retailsphere.dto.ProductRequest;
import com.retailsphere.dto.ProductResponse;
import com.retailsphere.response.ApiResponse;
import com.retailsphere.service.ProductService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/products")
@RequiredArgsConstructor
public class ProductController {

    private final ProductService productService;

    @PostMapping
    public ApiResponse<ProductResponse> createProduct(
            @Valid @RequestBody ProductRequest request) {

        return ApiResponse.<ProductResponse>builder()
                .success(true)
                .message("Product created successfully")
                .data(productService.createProduct(request))
                .build();
    }

    @GetMapping
    public ApiResponse<List<ProductResponse>> getAllProducts() {

        return ApiResponse.<List<ProductResponse>>builder()
                .success(true)
                .message("Products retrieved successfully")
                .data(productService.getAllProducts())
                .build();
    }

    @GetMapping("/{id}")
    public ApiResponse<ProductResponse> getProductById(
            @PathVariable Long id) {

        return ApiResponse.<ProductResponse>builder()
                .success(true)
                .message("Product retrieved successfully")
                .data(productService.getProductById(id))
                .build();
    }

    @PutMapping("/{id}")
    public ApiResponse<ProductResponse> updateProduct(
            @PathVariable Long id,
            @Valid @RequestBody ProductRequest request) {

        return ApiResponse.<ProductResponse>builder()
                .success(true)
                .message("Product updated successfully")
                .data(productService.updateProduct(id, request))
                .build();
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> deleteProduct(
            @PathVariable Long id) {

        productService.deleteProduct(id);

        return ApiResponse.<Void>builder()
                .success(true)
                .message("Product deleted successfully")
                .build();
    }
}
