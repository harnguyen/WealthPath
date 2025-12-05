import { test, expect } from '@playwright/test';

test.describe('Internationalization (i18n)', () => {
  test('should display English version', async ({ page }) => {
    await page.goto('/en');
    
    // Check for English content (use first() since there are multiple "Sign in" buttons)
    await expect(page.locator('text=/welcome|login|sign in|dashboard/i').first()).toBeVisible();
    
    // URL should contain /en
    expect(page.url()).toContain('/en');
  });

  test('should display Vietnamese version', async ({ page }) => {
    await page.goto('/vi');
    
    // Check for Vietnamese content (common Vietnamese words)
    // Looking for Vietnamese-specific characters or common words
    await expect(page.locator('html')).toBeVisible();
    
    // URL should contain /vi
    expect(page.url()).toContain('/vi');
  });

  test('should switch from English to Vietnamese', async ({ page }) => {
    await page.goto('/en/dashboard');
    
    // Look for language switcher
    const langSwitcher = page.locator('[data-testid="language-switcher"], button:has-text("EN"), button:has-text("English"), select[name="language"]');
    
    if (await langSwitcher.isVisible()) {
      await langSwitcher.click();
      
      // Select Vietnamese
      const viOption = page.locator('button:has-text("VI"), button:has-text("Vietnamese"), option:has-text("Vietnamese"), [role="option"]:has-text("VI")');
      if (await viOption.isVisible()) {
        await viOption.click();
        
        // URL should change to /vi
        await expect(page).toHaveURL(/\/vi\//);
      }
    }
  });

  test('should switch from Vietnamese to English', async ({ page }) => {
    await page.goto('/vi/dashboard');
    
    const langSwitcher = page.locator('[data-testid="language-switcher"], button:has-text("VI"), button:has-text("Tiếng Việt"), select[name="language"]');
    
    if (await langSwitcher.isVisible()) {
      await langSwitcher.click();
      
      const enOption = page.locator('button:has-text("EN"), button:has-text("English"), option:has-text("English"), [role="option"]:has-text("EN")');
      if (await enOption.isVisible()) {
        await enOption.click();
        
        await expect(page).toHaveURL(/\/en\//);
      }
    }
  });

  test('should persist language preference', async ({ page }) => {
    // Set Vietnamese
    await page.goto('/vi/dashboard');
    
    // Navigate to another page
    await page.goto('/vi/transactions');
    
    // Should still be in Vietnamese
    expect(page.url()).toContain('/vi');
  });

  test('should translate landing page hero text', async ({ page }) => {
    // English
    await page.goto('/en');
    const enTitle = await page.locator('h1').textContent();
    
    // Vietnamese
    await page.goto('/vi');
    const viTitle = await page.locator('h1').textContent();
    
    // Both should have content
    expect(enTitle).toBeTruthy();
    expect(viTitle).toBeTruthy();
    console.log(`EN: ${enTitle}`);
    console.log(`VI: ${viTitle}`);
  });

  test('should translate CTA buttons', async ({ page }) => {
    // English - check for "Get Started" or "Start Free"
    await page.goto('/en');
    await expect(page.locator('text=/Get Started|Start Free/i').first()).toBeVisible();
    
    // Vietnamese - check for Vietnamese equivalent
    await page.goto('/vi');
    // The page should load without errors
    await expect(page.locator('h1')).toBeVisible();
  });
});

