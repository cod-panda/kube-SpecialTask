
              package com.example.demo;
              import org.springframework.boot.SpringApplication;
              import org.springframework.boot.autoconfigure.SpringBootApplication;
              import org.springframework.web.bind.annotation.GetMapping;
              import org.springframework.web.bind.annotation.RequestParam;
              import org.springframework.web.bind.annotation.RestController;
              
              @SpringBootApplication
              @RestController
              public class DemoAppName {
                
                  
                  public static void main(String[] args) {
                  SpringApplication.run(DemoAppName.class, args);
                  }
                  
                  @GetMapping("/hello")
                  public String hello(@RequestParam(value = "name", defaultValue = "World") String name) {
                  return String.format("<h1>Hello %s!</h1> <br><br> Version 1.0", name);
                  }
                
              }
            
