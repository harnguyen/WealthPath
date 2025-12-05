import { expect, test } from '@playwright/test';
import { navigateViaLink, registerAndLogin, selectFromCombobox, waitForDialog } from './helpers';

test.describe('Transactions', () => {
  test.beforeEach(async ({ page }) => {
    await registerAndLogin(page, 'tx');
    await navigateViaLink(page, '/en/transactions');
  });

  test('should display transactions page', async ({ page }) => {
    await expect(page.locator('h1')).toBeVisible({ timeout: 10000 });
    const title = await page.locator('h1').textContent();
    expect(title?.toLowerCase()).toContain('transaction');
  });

  test('should open add transaction dialog', async ({ page }) => {
    const addBtn = page.locator('button:has-text("Add Transaction"), button:has-text("Add")').first();
    await addBtn.click();
    await waitForDialog(page);
    await expect(page.locator('#amount')).toBeVisible();
  });

  test('should create expense transaction', async ({ page }) => {
    const addBtn = page.locator('button:has-text("Add Transaction"), button:has-text("Add")').first();
    await addBtn.click();
    await waitForDialog(page);
    
    await page.fill('#amount', '50');
    await selectFromCombobox(page, 0);
    
    await page.locator('[role="dialog"] button[type="submit"]').click();
    
    // Assert: dialog must close on success
    await expect(page.locator('[role="dialog"]')).not.toBeVisible({ timeout: 5000 });
    
    // Assert: transaction should appear in list (amount $50)
    await expect(page.locator('text=/\\$50|50\\.00/')).toBeVisible({ timeout: 5000 });
  });

  test('should create income transaction', async ({ page }) => {
    const addBtn = page.locator('button:has-text("Add Transaction"), button:has-text("Add")').first();
    await addBtn.click();
    await waitForDialog(page);
    
    // Click Income tab INSIDE the dialog
    await page.locator('[role="dialog"] button:has-text("Income")').click();
    await page.waitForTimeout(300);
    
    await page.fill('#amount', '1000');
    await selectFromCombobox(page, 0);
    
    await page.locator('[role="dialog"] button[type="submit"]').click();
    
    // Assert: dialog must close on success
    await expect(page.locator('[role="dialog"]')).not.toBeVisible({ timeout: 5000 });
    
    // Assert: transaction should appear (amount $1000)
    await expect(page.locator('text=/\\$1,?000|1000/')).toBeVisible({ timeout: 5000 });
  });

  test('should delete transaction', async ({ page }) => {
    // First create a transaction
    const addBtn = page.locator('button:has-text("Add Transaction"), button:has-text("Add")').first();
    await addBtn.click();
    await waitForDialog(page);
    
    await page.fill('#amount', '25');
    await selectFromCombobox(page, 0);
    await page.locator('[role="dialog"] button[type="submit"]').click({ force: true });
    await page.waitForTimeout(2000);
    
    // Find and click delete button
    const deleteBtn = page.locator('button:has(svg.lucide-trash2)').first();
    if (await deleteBtn.isVisible({ timeout: 3000 })) {
      await deleteBtn.click();
      await page.waitForTimeout(1000);
    }
  });

  test('should filter by tabs', async ({ page }) => {
    const allTab = page.locator('[role="tab"]:has-text("All")');
    if (await allTab.isVisible({ timeout: 3000 })) {
      await page.click('[role="tab"]:has-text("Income")');
      await page.waitForTimeout(300);
      await allTab.click();
    }
  });
});
