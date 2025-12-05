import { Page, expect } from '@playwright/test';

/**
 * Generates a unique test email address using timestamp.
 * @param prefix - Prefix for the email (default: 'test')
 * @returns Unique email address
 */
export function generateTestEmail(prefix: string = 'test'): string {
  return `${prefix}+${Date.now()}@example.com`;
}

export const TEST_PASSWORD = 'testpassword123';
export const TEST_NAME = 'Test User';

/**
 * Registers a new user and logs them in, ensuring auth persists.
 * @param page - Playwright page object
 * @param emailPrefix - Prefix for the generated email
 * @returns The generated email address
 */
export async function registerAndLogin(page: Page, emailPrefix: string = 'test'): Promise<string> {
  const email = generateTestEmail(emailPrefix);
  
  await page.goto('/en/register');
  await page.waitForLoadState('networkidle');
  
  await page.getByLabel(/name/i).fill(TEST_NAME);
  await page.getByLabel(/email/i).fill(email);
  await page.getByLabel(/password/i).fill(TEST_PASSWORD);
  
  await page.getByRole('button', { name: /create account|sign up|register/i }).click();
  
  await expect(page).toHaveURL(/dashboard/, { timeout: 10000 });
  await page.waitForLoadState('networkidle');
  
  // Ensure auth token is stored before continuing
  await page.waitForFunction(() => {
    return localStorage.getItem('auth-storage') !== null || 
           localStorage.getItem('token') !== null ||
           document.cookie.includes('token');
  }, { timeout: 5000 }).catch(() => {});
  
  return email;
}

/**
 * Waits for a dialog to be visible.
 * @param page - Playwright page object
 */
export async function waitForDialog(page: Page): Promise<void> {
  await expect(page.getByRole('dialog')).toBeVisible();
}

/**
 * Waits for a dialog to close.
 * @param page - Playwright page object
 */
export async function waitForDialogToClose(page: Page): Promise<void> {
  await expect(page.getByRole('dialog')).not.toBeVisible();
}

/**
 * Selects the first option from a Shadcn Select component.
 * @param page - Playwright page object
 * @param triggerText - Optional text to identify the select trigger
 */
export async function selectFirstOption(page: Page, triggerText?: string | RegExp): Promise<void> {
  const dialog = page.getByRole('dialog');
  
  const trigger = triggerText 
    ? dialog.getByRole('combobox', { name: triggerText })
    : dialog.getByRole('combobox').first();
  
  await trigger.click();
  await page.getByRole('option').first().click();
}

/**
 * Navigates to a page, trying sidebar links first to preserve auth state.
 * @param page - Playwright page object
 * @param path - The path to navigate to
 */
export async function navigateTo(page: Page, path: string): Promise<void> {
  // Try to use in-app navigation first (preserves auth state better)
  const pathName = path.replace(/^\/en|^\/vi/, '').replace(/^\//, '');
  const navLink = page.getByRole('link', { name: new RegExp(pathName, 'i') });
  
  if (await navLink.first().isVisible({ timeout: 2000 }).catch(() => false)) {
    await navLink.first().click();
  } else {
    // Fall back to direct navigation
    await page.goto(path);
  }
  
  await page.waitForLoadState('networkidle');
  
  // If redirected to login, auth was lost - this shouldn't happen
  const isOnLogin = await page.url().includes('/login');
  if (isOnLogin) {
    throw new Error(`Auth state lost when navigating to ${path}`);
  }
}

/**
 * Fills a form field by label.
 * @param page - Playwright page object
 * @param label - Label text or regex
 * @param value - Value to fill
 */
export async function fillField(page: Page, label: string | RegExp, value: string): Promise<void> {
  await page.getByLabel(label).fill(value);
}

/**
 * Clicks a button by text.
 * @param page - Playwright page object
 * @param text - Button text or regex
 */
export async function clickButton(page: Page, text: string | RegExp): Promise<void> {
  await page.getByRole('button', { name: text }).click();
}
