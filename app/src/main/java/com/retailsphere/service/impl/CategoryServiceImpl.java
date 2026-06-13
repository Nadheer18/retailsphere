package com.retailsphere.service.impl;

import com.retailsphere.dto.CategoryRequest;
import com.retailsphere.dto.CategoryResponse;
import com.retailsphere.entity.Category;
import com.retailsphere.exception.CategoryNotFoundException;
import com.retailsphere.repository.CategoryRepository;
import com.retailsphere.service.CategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CategoryServiceImpl
        implements CategoryService {

    private final CategoryRepository categoryRepository;

    @Override
    public CategoryResponse createCategory(
            CategoryRequest request) {

        Category category = Category.builder()
                .name(request.getName())
                .description(request.getDescription())
                .build();

        return mapToResponse(
                categoryRepository.save(category));
    }

    @Override
    public List<CategoryResponse> getAllCategories() {

        return categoryRepository.findAll()
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    @Override
    public CategoryResponse getCategoryById(Long id) {

        Category category =
                categoryRepository.findById(id)
                        .orElseThrow(() ->
                                new CategoryNotFoundException(id));

        return mapToResponse(category);
    }

    @Override
    public CategoryResponse updateCategory(
            Long id,
            CategoryRequest request) {

        Category category =
                categoryRepository.findById(id)
                        .orElseThrow(() ->
                                new CategoryNotFoundException(id));

        category.setName(request.getName());
        category.setDescription(request.getDescription());

        return mapToResponse(
                categoryRepository.save(category));
    }

    @Override
    public void deleteCategory(Long id) {

        Category category =
                categoryRepository.findById(id)
                        .orElseThrow(() ->
                                new CategoryNotFoundException(id));

        categoryRepository.delete(category);
    }

    private CategoryResponse mapToResponse(
            Category category) {

        return CategoryResponse.builder()
                .id(category.getId())
                .name(category.getName())
                .description(category.getDescription())
                .createdAt(category.getCreatedAt())
                .updatedAt(category.getUpdatedAt())
                .build();
    }
}
