package model

import (
	"time"

	"github.com/shopspring/decimal"
)

// InterestRate represents a bank interest rate entry
type InterestRate struct {
	ID            int64           `db:"id" json:"id"`
	BankCode      string          `db:"bank_code" json:"bankCode"`
	BankName      string          `db:"bank_name" json:"bankName"`
	BankLogo      string          `db:"bank_logo" json:"bankLogo,omitempty"`
	ProductType   string          `db:"product_type" json:"productType"` // deposit, loan, mortgage
	TermMonths    int             `db:"term_months" json:"termMonths"`
	TermLabel     string          `db:"term_label" json:"termLabel"` // "1 tháng", "3 tháng", etc.
	Rate          decimal.Decimal `db:"rate" json:"rate"`
	MinAmount     decimal.Decimal `db:"min_amount" json:"minAmount,omitempty"`
	MaxAmount     decimal.Decimal `db:"max_amount" json:"maxAmount,omitempty"`
	Currency      string          `db:"currency" json:"currency"`
	EffectiveDate time.Time       `db:"effective_date" json:"effectiveDate"`
	ScrapedAt     time.Time       `db:"scraped_at" json:"scrapedAt"`
	CreatedAt     time.Time       `db:"created_at" json:"createdAt"`
	UpdatedAt     time.Time       `db:"updated_at" json:"updatedAt"`
}

// Bank represents a Vietnamese bank
type Bank struct {
	Code    string `json:"code"`
	Name    string `json:"name"`
	NameVi  string `json:"nameVi"`
	Logo    string `json:"logo"`
	Website string `json:"website"`
}

// VietnameseBanks is a list of major Vietnamese banks
// Using UI Avatars as fallback - logos will show bank code initials with brand colors
var VietnameseBanks = []Bank{
	{Code: "vcb", Name: "Vietcombank", NameVi: "Ngân hàng TMCP Ngoại thương Việt Nam", Logo: "https://ui-avatars.com/api/?name=VCB&background=00843D&color=fff&size=64&bold=true", Website: "https://www.vietcombank.com.vn"},
	{Code: "tcb", Name: "Techcombank", NameVi: "Ngân hàng TMCP Kỹ thương Việt Nam", Logo: "https://ui-avatars.com/api/?name=TCB&background=ED1C24&color=fff&size=64&bold=true", Website: "https://techcombank.com"},
	{Code: "mb", Name: "MB Bank", NameVi: "Ngân hàng TMCP Quân đội", Logo: "https://ui-avatars.com/api/?name=MB&background=004B8D&color=fff&size=64&bold=true", Website: "https://www.mbbank.com.vn"},
	{Code: "bidv", Name: "BIDV", NameVi: "Ngân hàng TMCP Đầu tư và Phát triển Việt Nam", Logo: "https://ui-avatars.com/api/?name=BIDV&background=00539B&color=fff&size=64&bold=true", Website: "https://www.bidv.com.vn"},
	{Code: "agribank", Name: "Agribank", NameVi: "Ngân hàng Nông nghiệp và Phát triển Nông thôn", Logo: "https://ui-avatars.com/api/?name=AGR&background=E31837&color=fff&size=64&bold=true", Website: "https://www.agribank.com.vn"},
	{Code: "vpbank", Name: "VPBank", NameVi: "Ngân hàng TMCP Việt Nam Thịnh Vượng", Logo: "https://ui-avatars.com/api/?name=VPB&background=00965E&color=fff&size=64&bold=true", Website: "https://www.vpbank.com.vn"},
	{Code: "acb", Name: "ACB", NameVi: "Ngân hàng TMCP Á Châu", Logo: "https://ui-avatars.com/api/?name=ACB&background=003366&color=fff&size=64&bold=true", Website: "https://www.acb.com.vn"},
	{Code: "sacombank", Name: "Sacombank", NameVi: "Ngân hàng TMCP Sài Gòn Thương Tín", Logo: "https://ui-avatars.com/api/?name=SCB&background=0066B3&color=fff&size=64&bold=true", Website: "https://www.sacombank.com.vn"},
	{Code: "tpbank", Name: "TPBank", NameVi: "Ngân hàng TMCP Tiên Phong", Logo: "https://ui-avatars.com/api/?name=TPB&background=5C2D91&color=fff&size=64&bold=true", Website: "https://tpb.vn"},
	{Code: "hdbank", Name: "HDBank", NameVi: "Ngân hàng TMCP Phát triển TP.HCM", Logo: "https://ui-avatars.com/api/?name=HDB&background=ED1C24&color=fff&size=64&bold=true", Website: "https://www.hdbank.com.vn"},
}

// StandardTerms defines common deposit term periods in months
var StandardTerms = []struct {
	Months int
	Label  string
}{
	{0, "Không kỳ hạn"},
	{1, "1 tháng"},
	{3, "3 tháng"},
	{6, "6 tháng"},
	{9, "9 tháng"},
	{12, "12 tháng"},
	{18, "18 tháng"},
	{24, "24 tháng"},
	{36, "36 tháng"},
}
