package com.wealthpath.admin.repository;

import com.wealthpath.admin.entity.Transaction;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, UUID> {
    
    Page<Transaction> findByUserId(UUID userId, Pageable pageable);
    
    long countByType(String type);
    
    long countByDateAfter(LocalDate date);
    
    @Query("SELECT SUM(t.amount) FROM Transaction t WHERE t.type = 'income'")
    BigDecimal sumTotalIncome();
    
    @Query("SELECT SUM(t.amount) FROM Transaction t WHERE t.type = 'expense'")
    BigDecimal sumTotalExpenses();
    
    @Query("SELECT t.category, SUM(t.amount) FROM Transaction t WHERE t.type = 'expense' GROUP BY t.category ORDER BY SUM(t.amount) DESC")
    List<Object[]> sumExpensesByCategory();
    
    @Query("SELECT DATE(t.date), COUNT(t) FROM Transaction t WHERE t.date >= :startDate GROUP BY DATE(t.date) ORDER BY DATE(t.date)")
    List<Object[]> countTransactionsByDate(LocalDate startDate);
}

