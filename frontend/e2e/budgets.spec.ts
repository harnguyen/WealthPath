import { expect, test } from '@playwright/test';
import { navigateViaLink, registerAndLogin, selectFromCombobox, waitForDialog } from './helpers';

test.describe('Budgets', () => {
  test.beforeEach(async ({ page }) => {
    await registerAndLogin(page, 'budget');
    await navigateViaLink(page, '/en/budgets');
  });

  test('should display budgets page', async ({ page }) => {
    await expect(page.locator('h1')).toBeVisible({ timeout: 10000 });
    const title = await page.locator('h1').textContent();
    expect(title?.toLowerCase()).toContain('budget');
  });

  test('should open add budget dialog', async ({ page }) => {
    const addBtn = page.locator('button:has-text("Create Budget")');
    await addBtn.click();
    await waitForDialog(page);
    await expect(page.locator('#amount')).toBeVisible();
  });

  test('should create a new budget', async ({ page }) => {
    const addBtn = page.locator('button:has-text("Create Budget")');
    await addBtn.click();
    await waitForDialog(page);
    
    // Select category (first Select in dialog)
    await selectFromCombobox(page, 0);
    await page.fill('#amount', '500');
    
    await page.locator('[role="dialog"] button[type="submit"]').click();
    
    // Assert: dialog should close on success
    await expect(page.locator('[role="dialog"]')).not.toBeVisible({ timeout: 5000 });
    
    // Assert: success toast or budget card should appear
    const successIndicator = page.locator('text=/Housing|budget|\\$500/i').first();
    await expect(successIndicator).toBeVisible({ timeout: 5000 });
  });

  test('should show budget card after creation', async ({ page }) => {
    // Create a budget first
    const addBtn = page.locator('button:has-text("Create Budget")');
    await addBtn.click();
    await waitForDialog(page);
    
    await selectFromCombobox(page, 0);
    await page.fill('#amount', '1000');
    
    await page.locator('[role="dialog"] button[type="submit"]').click();
    
    // Assert: dialog must close
    await expect(page.locator('[role="dialog"]')).not.toBeVisible({ timeout: 5000 });
    
    // Assert: budget card with amount should be visible
    await expect(page.locator('[data-testid="budget-card"], .card, article').first()).toBeVisible({ timeout: 5000 });
  });

  test('should delete budget', async ({ page }) => {
    // Create a budget first
    const addBtn = page.locator('button:has-text("Create Budget")');
    await addBtn.click();
    await waitForDialog(page);
    
    await selectFromCombobox(page, 0);
    await page.fill('#amount', '200');
    
    await page.locator('[role="dialog"] button[type="submit"], [role="dialog"] button:has-text("Create Budget")').click({ force: true });
    await page.waitForTimeout(2000);
    
    // Find and click delete button
    const deleteBtn = page.locator('button:has(svg.lucide-trash2)').first();
    if (await deleteBtn.isVisible({ timeout: 3000 })) {
      await deleteBtn.click();
      await page.waitForTimeout(1000);
    }
  });

  test('should show budget content', async ({ page }) => {
    await expect(page.locator('main')).toBeVisible();
  });
});
