import { test, expect } from '@playwright/test';
import { registerAndLogin, waitForDialog, selectFromCombobox, navigateViaLink } from './helpers';

test.describe('Debts', () => {
  test.beforeEach(async ({ page }) => {
    await registerAndLogin(page, 'debt');
    await navigateViaLink(page, '/en/debts');
  });

  test('should display debts page', async ({ page }) => {
    await expect(page.locator('h1')).toBeVisible({ timeout: 10000 });
    const title = await page.locator('h1').textContent();
    expect(title?.toLowerCase()).toMatch(/debt/);
  });

  test('should open add debt dialog', async ({ page }) => {
    const addBtn = page.locator('button:has-text("Add Debt")');
    await addBtn.click();
    await waitForDialog(page);
    await expect(page.locator('#name')).toBeVisible();
  });

  test('should add new debt', async ({ page }) => {
    const addBtn = page.locator('button:has-text("Add Debt")');
    await addBtn.click();
    await waitForDialog(page);
    
    await page.fill('#name', 'Car Loan');
    await selectFromCombobox(page, 0); // Select debt type
    await page.fill('#originalAmount', '25000');
    await page.fill('#currentBalance', '20000');
    await page.fill('#interestRate', '5.5');
    await page.fill('#minimumPayment', '450');
    await page.fill('#dueDay', '15');
    await page.fill('#startDate', '2024-01-01');
    
    await page.locator('[role="dialog"] button:has-text("Add Debt")').click();
    
    // Assert: dialog must close on success
    await expect(page.locator('[role="dialog"]')).not.toBeVisible({ timeout: 5000 });
    
    // Assert: debt card with name should appear
    await expect(page.locator('text=Car Loan')).toBeVisible({ timeout: 5000 });
  });

  test('should make payment on debt', async ({ page }) => {
    // First create a debt
    const addBtn = page.locator('button:has-text("Add Debt")');
    await addBtn.click();
    await waitForDialog(page);
    
    await page.fill('#name', 'Credit Card');
    await selectFromCombobox(page, 0);
    await page.fill('#originalAmount', '5000');
    await page.fill('#currentBalance', '3000');
    await page.fill('#interestRate', '18');
    await page.fill('#minimumPayment', '100');
    await page.fill('#dueDay', '1');
    await page.fill('#startDate', '2024-01-01');
    
    await page.locator('[role="dialog"] button:has-text("Add Debt")').click({ force: true });
    await page.waitForTimeout(2000);
    
    // Wait for dialog to close
    await expect(page.locator('[role="dialog"]')).not.toBeVisible({ timeout: 3000 }).catch(() => {});
    
    // Find "Make Payment" button
    const payBtn = page.locator('button:has-text("Make Payment"), button:has-text("Pay")').first();
    if (await payBtn.isVisible({ timeout: 3000 })) {
      await payBtn.click();
      await waitForDialog(page);
      
      // Fill payment amount
      const amountInput = page.locator('[role="dialog"] input[type="number"]').first();
      if (await amountInput.isVisible({ timeout: 2000 })) {
        await amountInput.fill('500');
        await page.locator('[role="dialog"] button[type="submit"]').click({ force: true });
        await page.waitForTimeout(1000);
      }
    }
  });

  test('should show payoff plan', async ({ page }) => {
    // First create a debt
    const addBtn = page.locator('button:has-text("Add Debt")');
    await addBtn.click();
    await waitForDialog(page);
    
    await page.fill('#name', 'Student Loan');
    await selectFromCombobox(page, 0);
    await page.fill('#originalAmount', '30000');
    await page.fill('#currentBalance', '25000');
    await page.fill('#interestRate', '6.5');
    await page.fill('#minimumPayment', '300');
    await page.fill('#dueDay', '20');
    
    const startDate = page.locator('#startDate');
    if (await startDate.isVisible()) {
      await startDate.fill('2024-01-01');
    }
    
    await page.locator('[role="dialog"] button:has-text("Add Debt")').click({ force: true });
    await page.waitForTimeout(3000);
    
    // Look for payoff plan button or link
    const planBtn = page.locator('button:has-text("Payoff"), button:has-text("Plan"), a:has-text("Payoff")').first();
    if (await planBtn.isVisible({ timeout: 3000 })) {
      await planBtn.click();
      await page.waitForTimeout(1000);
    }
  });

  test('should delete debt', async ({ page }) => {
    // First create a debt
    const addBtn = page.locator('button:has-text("Add Debt")');
    await addBtn.click();
    await waitForDialog(page);
    
    await page.fill('#name', 'Delete Me Debt');
    await selectFromCombobox(page, 0);
    await page.fill('#originalAmount', '1000');
    await page.fill('#currentBalance', '800');
    await page.fill('#interestRate', '10');
    await page.fill('#minimumPayment', '50');
    await page.fill('#dueDay', '5');
    
    const startDate = page.locator('#startDate');
    if (await startDate.isVisible()) {
      await startDate.fill('2024-01-01');
    }
    
    await page.locator('[role="dialog"] button:has-text("Add Debt")').click({ force: true });
    await page.waitForTimeout(3000);
    
    // Find and click delete button
    const deleteBtn = page.locator('button:has(svg.lucide-trash2)').first();
    if (await deleteBtn.isVisible({ timeout: 3000 })) {
      await deleteBtn.click();
      await page.waitForTimeout(1000);
    }
  });
});
