import { Page, expect } from '@playwright/test';

export function generateTestEmail(prefix: string = 'test'): string {
  return `${prefix}+${Date.now()}@example.com`;
}

export const TEST_PASSWORD = 'testpassword123';
export const TEST_NAME = 'Test User';

export async function registerAndLogin(page: Page, emailPrefix: string = 'test'): Promise<string> {
  const email = generateTestEmail(emailPrefix);
  
  await page.goto('/en/register');
  await expect(page.locator('#name')).toBeVisible({ timeout: 5000 });
  
  await page.fill('#name', TEST_NAME);
  await page.fill('#email', email);
  await page.fill('#password', TEST_PASSWORD);
  
  await page.click('button:has-text("Create account"), button[type="submit"]');
  await expect(page).toHaveURL(/dashboard/, { timeout: 8000 });
  await page.waitForLoadState('networkidle');
  await page.waitForTimeout(300);
  
  return email;
}

export async function waitForDialog(page: Page): Promise<void> {
  await expect(page.locator('[role="dialog"]')).toBeVisible({ timeout: 3000 });
  // Wait for dialog animation to complete
  await page.waitForTimeout(300);
}

export async function selectFromCombobox(page: Page, index: number = 0): Promise<void> {
  // Wait for dialog overlay animation to complete
  await page.waitForTimeout(400);
  
  const combobox = page.locator('[role="dialog"] [role="combobox"]').nth(index);
  await expect(combobox).toBeVisible({ timeout: 2000 });
  
  // Click to open dropdown - force to bypass any overlay
  await combobox.click({ force: true });
  await page.waitForTimeout(200);
  
  // Wait for listbox to appear
  const listbox = page.locator('[role="listbox"]');
  await expect(listbox).toBeVisible({ timeout: 2000 });
  
  // Click first option
  const option = page.locator('[role="option"]').first();
  await expect(option).toBeVisible({ timeout: 2000 });
  await option.click({ force: true });
  await page.waitForTimeout(200);
}

export async function navigateViaLink(page: Page, href: string): Promise<void> {
  const link = page.locator(`a[href="${href}"]`);
  if (await link.isVisible({ timeout: 2000 })) {
    await link.click();
  } else {
    await page.goto(href);
  }
  await page.waitForLoadState('networkidle');
  await page.waitForTimeout(200);
}
