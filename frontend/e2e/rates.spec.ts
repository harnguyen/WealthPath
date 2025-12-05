import { test, expect } from '@playwright/test';
import { registerAndLogin, navigateTo } from './helpers';

test.describe('Interest Rates Page', () => {
  test.beforeEach(async ({ page }) => {
    await registerAndLogin(page);
    await navigateTo(page, 'rates');
  });

  test('should display interest rates page', async ({ page }) => {
    // Check page title
    await expect(page.getByText('Lãi suất ngân hàng')).toBeVisible();

    // Check tabs exist
    await expect(page.getByRole('tab', { name: /tiết kiệm/i })).toBeVisible();
    await expect(page.getByRole('tab', { name: /vay tiêu dùng/i })).toBeVisible();
    await expect(page.getByRole('tab', { name: /vay mua nhà/i })).toBeVisible();
  });

  test('should display stat cards', async ({ page }) => {
    // Wait for stats to load
    await expect(page.getByText('Lãi suất cao nhất')).toBeVisible();
    await expect(page.getByText('Lãi suất trung bình')).toBeVisible();
    await expect(page.getByText('Lãi suất thấp nhất')).toBeVisible();
  });

  test('should have term selector', async ({ page }) => {
    // Check term selector exists
    const termSelector = page.getByRole('combobox');
    await expect(termSelector).toBeVisible();

    // Click to open term options
    await termSelector.click();

    // Verify term options are available
    await expect(page.getByRole('option', { name: '1 tháng' })).toBeVisible();
    await expect(page.getByRole('option', { name: '6 tháng' })).toBeVisible();
    await expect(page.getByRole('option', { name: '12 tháng' })).toBeVisible();
  });

  test('should have sort buttons', async ({ page }) => {
    await expect(page.getByRole('button', { name: /theo lãi suất/i })).toBeVisible();
    await expect(page.getByRole('button', { name: /theo ngân hàng/i })).toBeVisible();
  });

  test('should switch between product types', async ({ page }) => {
    // Default should be deposit (Tiết kiệm)
    const depositTab = page.getByRole('tab', { name: /tiết kiệm/i });
    await expect(depositTab).toHaveAttribute('data-state', 'active');

    // Switch to loan tab
    const loanTab = page.getByRole('tab', { name: /vay tiêu dùng/i });
    await loanTab.click();
    await expect(loanTab).toHaveAttribute('data-state', 'active');

    // Switch to mortgage tab
    const mortgageTab = page.getByRole('tab', { name: /vay mua nhà/i });
    await mortgageTab.click();
    await expect(mortgageTab).toHaveAttribute('data-state', 'active');
  });

  test('should change term filter', async ({ page }) => {
    const termSelector = page.getByRole('combobox');
    await termSelector.click();

    // Select 6 months term
    await page.getByRole('option', { name: '6 tháng' }).click();

    // Verify selection
    await expect(termSelector).toContainText('6 tháng');
  });

  test('should toggle sort order', async ({ page }) => {
    const sortByRate = page.getByRole('button', { name: /theo lãi suất/i });

    // Click to toggle sort
    await sortByRate.click();

    // Should show arrow indicator
    await expect(sortByRate).toContainText('↓');

    // Click again to reverse sort
    await sortByRate.click();
    await expect(sortByRate).toContainText('↑');
  });

  test('should load sample data when no rates exist', async ({ page }) => {
    // Check if sample data button is visible (when no data)
    const seedButton = page.getByRole('button', { name: /tải dữ liệu mẫu/i });

    // If the button exists, click it to load data
    if (await seedButton.isVisible({ timeout: 2000 }).catch(() => false)) {
      await seedButton.click();

      // Wait for rates to load
      await page.waitForTimeout(2000);

      // Verify rates are displayed
      await expect(page.getByText(/vietcombank|techcombank|mb bank/i).first()).toBeVisible();
    }
  });

  test('should display bank cards in rates list', async ({ page }) => {
    // Wait for data to load - either rates exist or we need to seed
    const seedButton = page.getByRole('button', { name: /tải dữ liệu mẫu/i });

    if (await seedButton.isVisible({ timeout: 2000 }).catch(() => false)) {
      await seedButton.click();
      await page.waitForTimeout(2000);
    }

    // Check for bank names in the list
    const bankNames = ['Vietcombank', 'Techcombank', 'MB Bank', 'BIDV', 'VPBank'];
    let foundBank = false;

    for (const bankName of bankNames) {
      if (await page.getByText(bankName).first().isVisible({ timeout: 1000 }).catch(() => false)) {
        foundBank = true;
        break;
      }
    }

    expect(foundBank).toBe(true);
  });

  test('should have refresh button', async ({ page }) => {
    const refreshButton = page.getByRole('button', { name: /cập nhật/i });
    await expect(refreshButton).toBeVisible();
  });

  test('should display supported banks section', async ({ page }) => {
    // Scroll down to see the supported banks section
    await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));

    // Check for the supported banks heading
    await expect(page.getByText('Ngân hàng được hỗ trợ')).toBeVisible();
  });
});

