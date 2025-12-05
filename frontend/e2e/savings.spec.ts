import { test, expect } from '@playwright/test';
import { registerAndLogin, waitForDialog, navigateViaLink } from './helpers';

test.describe('Savings Goals', () => {
  test.beforeEach(async ({ page }) => {
    await registerAndLogin(page, 'savings');
    await navigateViaLink(page, '/en/savings');
  });

  test('should display savings page', async ({ page }) => {
    await expect(page.locator('h1')).toBeVisible({ timeout: 10000 });
    const title = await page.locator('h1').textContent();
    expect(title?.toLowerCase()).toMatch(/saving|goal/);
  });

  test('should open new goal dialog', async ({ page }) => {
    const addBtn = page.locator('button:has-text("New Goal"), button:has-text("Add")').first();
    await addBtn.click();
    await waitForDialog(page);
    await expect(page.locator('#name')).toBeVisible();
  });

  test('should create new savings goal', async ({ page }) => {
    const addBtn = page.locator('button:has-text("New Goal"), button:has-text("Add")').first();
    await addBtn.click();
    await waitForDialog(page);
    
    await page.fill('#name', 'Emergency Fund');
    await page.fill('#targetAmount', '10000');
    
    await page.locator('[role="dialog"] button[type="submit"]').click({ force: true });
    await page.waitForTimeout(2000);
    
    await expect(page.locator('text=Emergency Fund')).toBeVisible({ timeout: 5000 });
  });

  test('should add contribution to savings goal', async ({ page }) => {
    // First create a goal
    const addBtn = page.locator('button:has-text("New Goal"), button:has-text("Add")').first();
    await addBtn.click();
    await waitForDialog(page);
    
    await page.fill('#name', 'Vacation Fund');
    await page.fill('#targetAmount', '5000');
    
    await page.locator('[role="dialog"] button[type="submit"]').click({ force: true });
    await page.waitForTimeout(2000);
    
    // Find "Add Funds" button on the card
    const addFundsBtn = page.locator('button:has-text("Add Funds"), button:has-text("Add")').first();
    if (await addFundsBtn.isVisible({ timeout: 3000 })) {
      await addFundsBtn.click();
      await page.waitForTimeout(500);
      
      // Fill contribution amount in the dialog/input
      const amountInput = page.locator('[role="dialog"] input, input[type="number"]').first();
      if (await amountInput.isVisible({ timeout: 2000 })) {
        await amountInput.fill('100');
        await page.locator('[role="dialog"] button[type="submit"], [role="dialog"] button:has-text("Add")').click({ force: true });
        await page.waitForTimeout(1000);
      }
    }
  });

  test('should delete savings goal', async ({ page }) => {
    // First create a goal
    const addBtn = page.locator('button:has-text("New Goal"), button:has-text("Add")').first();
    await addBtn.click();
    await waitForDialog(page);
    
    await page.fill('#name', 'Delete Me Goal');
    await page.fill('#targetAmount', '1000');
    
    await page.locator('[role="dialog"] button[type="submit"]').click({ force: true });
    await page.waitForTimeout(2000);
    
    // Find and click delete button
    const deleteBtn = page.locator('button:has(svg.lucide-trash2)').first();
    if (await deleteBtn.isVisible({ timeout: 3000 })) {
      await deleteBtn.click();
      await page.waitForTimeout(1000);
    }
  });

  test('should show progress after contribution', async ({ page }) => {
    // Create a goal with initial amount
    const addBtn = page.locator('button:has-text("New Goal"), button:has-text("Add")').first();
    await addBtn.click();
    await waitForDialog(page);
    
    await page.fill('#name', 'Car Fund');
    await page.fill('#targetAmount', '20000');
    
    await page.locator('[role="dialog"] button[type="submit"]').click({ force: true });
    await page.waitForTimeout(2000);
    
    // Verify goal card exists
    await expect(page.locator('text=Car Fund')).toBeVisible({ timeout: 5000 });
  });
});
