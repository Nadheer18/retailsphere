package com.retailsphere.exception;

import com.retailsphere.response.ApiResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ProductNotFoundException.class)
    public ResponseEntity<ApiResponse<Object>> handleProductNotFound(
            ProductNotFoundException ex) {

        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(ApiResponse.builder()
                        .success(false)
                        .message(ex.getMessage())
                        .build());
    }

    @ExceptionHandler(CategoryNotFoundException.class)
public ResponseEntity<ApiResponse<Object>> handleCategoryNotFound(
        CategoryNotFoundException ex) {

    return ResponseEntity.status(HttpStatus.NOT_FOUND)
            .body(ApiResponse.builder()
                    .success(false)
                    .message(ex.getMessage())
                    .build());
	}

    @ExceptionHandler(CustomerNotFoundException.class)
public ResponseEntity<ApiResponse<Object>> handleCustomerNotFound(
        CustomerNotFoundException ex) {

    return ResponseEntity.status(HttpStatus.NOT_FOUND)
            .body(ApiResponse.builder()
                    .success(false)
                    .message(ex.getMessage())
                    .build());
	}
    @ExceptionHandler(CartNotFoundException.class)
public ResponseEntity<ApiResponse<Object>> handleCartNotFound(
        CartNotFoundException ex) {

    return ResponseEntity.status(HttpStatus.NOT_FOUND)
            .body(ApiResponse.builder()
                    .success(false)
                    .message(ex.getMessage())
                    .build());
	}

    @ExceptionHandler(CartItemNotFoundException.class)
public ResponseEntity<ApiResponse<Object>> handleCartItemNotFound(
        CartItemNotFoundException ex) {

    return ResponseEntity.status(HttpStatus.NOT_FOUND)
            .body(ApiResponse.builder()
                    .success(false)
                    .message(ex.getMessage())
                    .build());
	}
	
    @ExceptionHandler(OrderNotFoundException.class)
public ResponseEntity<ApiResponse<Object>> handleOrderNotFound(
        OrderNotFoundException ex) {

    return ResponseEntity.status(HttpStatus.NOT_FOUND)
            .body(ApiResponse.builder()
                    .success(false)
                    .message(ex.getMessage())
                    .build());
	}
	
    	@ExceptionHandler(InsufficientStockException.class)
public ResponseEntity<ApiResponse<Object>>
handleInsufficientStock(
        InsufficientStockException ex) {

    return ResponseEntity.badRequest()
            .body(ApiResponse.builder()
                    .success(false)
                    .message(ex.getMessage())
                    .build());
	}
	
	@ExceptionHandler(InvalidCredentialsException.class)
public ResponseEntity<ApiResponse<Object>>
handleInvalidCredentials(
        InvalidCredentialsException ex) {

    return ResponseEntity.badRequest()
            .body(ApiResponse.builder()
                    .success(false)
                    .message(ex.getMessage())
                    .build());
	}

}
