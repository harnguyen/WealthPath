package com.wealthpath.admin.controller;

import com.wealthpath.admin.dto.DashboardStats;
import com.wealthpath.admin.entity.User;
import com.wealthpath.admin.service.AdminService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.UUID;

@Controller
@RequiredArgsConstructor
public class AdminController {
    
    private final AdminService adminService;
    
    @GetMapping("/login")
    public String login() {
        return "login";
    }
    
    @GetMapping({"/", "/dashboard"})
    public String dashboard(Model model) {
        DashboardStats stats = adminService.getDashboardStats();
        model.addAttribute("stats", stats);
        return "dashboard";
    }
    
    @GetMapping("/users")
    public String users(
            @RequestParam(defaultValue = "") String search,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            Model model) {
        
        Page<User> users = adminService.getUsers(
            search, 
            PageRequest.of(page, size, Sort.by("createdAt").descending())
        );
        
        model.addAttribute("users", users);
        model.addAttribute("search", search);
        return "users";
    }
    
    @GetMapping("/users/{id}")
    public String userDetail(@PathVariable UUID id, Model model) {
        return adminService.getUserById(id)
            .map(user -> {
                model.addAttribute("user", user);
                return "user-detail";
            })
            .orElse("redirect:/users");
    }
    
    @PostMapping("/users/{id}/delete")
    public String deleteUser(@PathVariable UUID id, RedirectAttributes redirectAttributes) {
        try {
            adminService.deleteUser(id);
            redirectAttributes.addFlashAttribute("success", "User deleted successfully");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to delete user: " + e.getMessage());
        }
        return "redirect:/users";
    }
}

