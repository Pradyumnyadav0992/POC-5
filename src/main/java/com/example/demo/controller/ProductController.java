package com.example.demo.controller;

import com.example.demo.model.Product;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/products")
public class ProductController {

    @GetMapping
    public List<Product> getProducts() {
        return List.of(
            new Product(1, "Laptop", 50000),
            new Product(2, "Smartphone", 30000),
            new Product(3, "Tablet", 20000)
        );
    }

    @GetMapping("/hello")
    public String hello() {
        return "Welcome to Java Web App!";
    }
}
