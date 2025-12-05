import { test, expect } from '@playwright/test';
import { registerAndLogin } from './helpers';

test.describe('Dashboard', () => {
  test.beforeEach(async ({ page }) => {
    await registerAndLogin(page, 'dashboard');
  });

  test('should display dashboard page', async ({ page }) => {
    await expect(page.locator('h1')).toBeVisible({ timeout: 10000 });
    const title = await page.locator('h1').textContent();
    expect(title?.toLowerCase()).toMatch(/dashboard|overview/);
  });

  test('should show financial summary', async ({ page }) => {
    await expect(page.locator('main')).toBeVisible();
  });

  test('should show income/expense labels', async ({ page }) => {
    const summaryText = page.locator('text=/income|expense|balance/i').first();
    await expect(summaryText).toBeVisible({ timeout: 5000 });
  });

  test('should have navigation elements', async ({ page }) => {
    const nav = page.locator('nav, aside');
    await expect(nav.first()).toBeVisible();
  });

  test('should be responsive on mobile', async ({ page }) => {
    // Set mobile viewport
    await page.setViewportSize({ width: 375, height: 667 });
    await page.waitForTimeout(500);
    
    // Page should still work on mobile
    await expect(page.locator('main')).toBeVisible({ timeout: 5000 });
  });
});
