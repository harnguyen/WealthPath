package com.wealthpath.admin.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.util.Map;

@Data
public class DashboardStats {
    // User stats
    private long totalUsers;
    private long newUsersToday;
    private long newUsersThisWeek;
    private long oAuthUsers;
    
    // Transaction stats
    private long totalTransactions;
    private long incomeTransactions;
    private long expenseTransactions;
    private long transactionsToday;
    
    // Financial totals
    private BigDecimal totalIncome = BigDecimal.ZERO;
    private BigDecimal totalExpenses = BigDecimal.ZERO;
    
    // Breakdowns
    private Map<String, BigDecimal> expensesByCategory;
    private Map<String, Long> usersByCurrency;
    
    public BigDecimal getNetFlow() {
        return totalIncome.subtract(totalExpenses);
    }
}

