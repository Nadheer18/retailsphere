package com.retailsphere.service;

import com.retailsphere.dto.ProductRequest;
import com.retailsphere.dto.ProductResponse;
import com.retailsphere.entity.Category;
import com.retailsphere.entity.Product;
import com.retailsphere.repository.CategoryRepository;
import com.retailsphere.repository.ProductRepository;
import com.retailsphere.service.impl.ProductServiceImpl;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ProductServiceTest {

    @Mock
    private ProductRepository productRepository;

    @Mock
    private CategoryRepository categoryRepository;

    @InjectMocks
    private ProductServiceImpl productService;

    private Category createCategory() {

        return Category.builder()
                .id(1L)
                .name("Laptops")
                .description("Laptop Category")
                .build();
    }

    private Product createProduct() {

        return Product.builder()
                .id(1L)
                .name("HP Victus")
                .description("Gaming Laptop")
                .price(BigDecimal.valueOf(85000))
                .stockQuantity(10)
                .category(createCategory())
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();
    }

    @Test
    void testGetProductById() {

        when(productRepository.findById(1L))
                .thenReturn(Optional.of(createProduct()));

        ProductResponse response =
                productService.getProductById(1L);

        assertNotNull(response);
        assertEquals("HP Victus", response.getName());

        verify(productRepository, times(1))
                .findById(1L);
    }

    @Test
    void testGetAllProducts() {

        when(productRepository.findAll())
                .thenReturn(List.of(createProduct()));

        List<ProductResponse> products =
                productService.getAllProducts();

        assertEquals(1, products.size());

        verify(productRepository, times(1))
                .findAll();
    }

    @Test
    void testCreateProduct() {

        ProductRequest request =
                new ProductRequest();

        request.setName("HP Victus");
        request.setDescription("Gaming Laptop");
        request.setPrice(BigDecimal.valueOf(85000));
        request.setStockQuantity(10);
        request.setCategoryId(1L);

        when(categoryRepository.findById(1L))
                .thenReturn(Optional.of(createCategory()));

        when(productRepository.save(any(Product.class)))
                .thenReturn(createProduct());

        ProductResponse response =
                productService.createProduct(request);

        assertNotNull(response);
        assertEquals("HP Victus", response.getName());

        verify(productRepository, times(1))
                .save(any(Product.class));
    }

    @Test
    void testDeleteProduct() {

        when(productRepository.findById(1L))
                .thenReturn(Optional.of(createProduct()));

        productService.deleteProduct(1L);

        verify(productRepository, times(1))
                .delete(any(Product.class));
    }
}
