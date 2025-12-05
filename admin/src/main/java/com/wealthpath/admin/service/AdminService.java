package com.wealthpath.admin.service;

import com.wealthpath.admin.dto.DashboardStats;
import com.wealthpath.admin.entity.User;
import com.wealthpath.admin.repository.TransactionRepository;
import com.wealthpath.admin.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

@Service
@RequiredArgsConstructor
public class AdminService {
    
    private final UserRepository userRepository;
    private final TransactionRepository transactionRepository;
    
    public DashboardStats getDashboardStats() {
        DashboardStats stats = new DashboardStats();
        
        // User stats
        stats.setTotalUsers(userRepository.count());
        stats.setNewUsersToday(userRepository.countByCreatedAtAfter(
            LocalDateTime.now().minusDays(1)));
        stats.setNewUsersThisWeek(userRepository.countByCreatedAtAfter(
            LocalDateTime.now().minusWeeks(1)));
        stats.setOAuthUsers(userRepository.countOAuthUsers());
        
        // Transaction stats
        stats.setTotalTransactions(transactionRepository.count());
        stats.setIncomeTransactions(transactionRepository.countByType("income"));
        stats.setExpenseTransactions(transactionRepository.countByType("expense"));
        stats.setTransactionsToday(transactionRepository.countByDateAfter(
            LocalDate.now().minusDays(1)));
        
        // Financial totals
        BigDecimal totalIncome = transactionRepository.sumTotalIncome();
        BigDecimal totalExpenses = transactionRepository.sumTotalExpenses();
        stats.setTotalIncome(totalIncome != null ? totalIncome : BigDecimal.ZERO);
        stats.setTotalExpenses(totalExpenses != null ? totalExpenses : BigDecimal.ZERO);
        
        // Category breakdown
        List<Object[]> categoryData = transactionRepository.sumExpensesByCategory();
        Map<String, BigDecimal> expensesByCategory = new LinkedHashMap<>();
        for (Object[] row : categoryData) {
            expensesByCategory.put((String) row[0], (BigDecimal) row[1]);
        }
        stats.setExpensesByCategory(expensesByCategory);
        
        // Currency distribution
        List<Object[]> currencyData = userRepository.countUsersByCurrency();
        Map<String, Long> usersByCurrency = new HashMap<>();
        for (Object[] row : currencyData) {
            usersByCurrency.put((String) row[0], (Long) row[1]);
        }
        stats.setUsersByCurrency(usersByCurrency);
        
        return stats;
    }
    
    public Page<User> getUsers(String search, Pageable pageable) {
        if (search != null && !search.isBlank()) {
            return userRepository.findByNameContainingIgnoreCaseOrEmailContainingIgnoreCase(
                search, search, pageable);
        }
        return userRepository.findAll(pageable);
    }
    
    public Optional<User> getUserById(UUID id) {
        return userRepository.findById(id);
    }
    
    public void deleteUser(UUID id) {
        userRepository.deleteById(id);
    }
}

