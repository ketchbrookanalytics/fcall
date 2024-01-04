## code to prepare `FileMetadata` dataset goes here

# List of different tables provided to FCA each quarter and file prefixes in the
# .zip archive data
# See https://ww3.fca.gov/fcsinfo/CRS/CallReportFiles/UCR%20Call%20Report%20Instructions.pdf
FileMetadata <- tibble::tribble(
  ~FilePrefix, ~TableName,
  "RC", "Balance Sheet",
  "RC1", "Memoranda",
  "RCB", "Debt Securities (excluding investments in Farm Credit institutions and diversified investment funds)",
  "RCB2", "Assets Held for Liquidity (Applicable to banks only)",
  "RCB3", "Demands and Liquidity (Applicable to banks only)",
  "RCB4", "Equity Securities",
  "RCB5", "Investments Memoranda",
  "RCF", "Performance of Loans, Notes, Sales Contracts, and Leases",
  "RCF1", "Performance of Loans, Notes, Sales Contracts, and Leases Loan Performance by Loan Type",
  "RCF2", "Performance of Loans, Notes, Sales Contracts, and Leases and Classified Assets Classifications by Asset Type (Non-FOIA Schedule)",
  "RCF3", "Risk Ratings for Retail Loans, Notes, Sales Contracts, and Leases (Non-FOIA Schedule)",
  "RCF4", "Risk Ratings for Direct LOans from FCS Banks to FCS Associations (Non-FOIA Schedule)",
  "RCF5", "Risk Ratings for Discounted Loans to OFI's (Non-FOIA Schedule)",
  "RCG", "Average Daily Amounts for the Quarter",
  "RCH", "Accumulated Other Comprehensive Income",
  "RCI1", "Off-Balance Sheet Commitments, Contingencies, and Other Items (Excluding Derivatives)",
  "RCI2", "Off-Balance Sheet Derivatives Contracts",
  "RCJ", "Collateral Position (Non-FOIA Schedule)",
  "RCK", "Accrual Loan Activity REconcilement for LOans, Leases, Notes Receivable (excluding Intra-System Loan), and Sales Contracts",
  "RCL", "Nonaccrual Loan Activity Reconcilement",
  "RCM", "Other-Property-Owned (Net of Depreciation) Activity Reconcilement",
  "RCN1", "Repricing Opportunities and Relationships (Non-FOIA Schedule)",
  "RCN2", "Interest Rate Risk Measurements (Non-FOIA Schedule)",
  "RCO", "Asset Purchase and Sales",
  "RI", "Income and Comprehensive Income Statement",
  "RIA", "Operating Income",
  "RIB", "Net Gains and Losses",
  "RIC", "Operating Expenses",
  "RIC1", "Other Noninterest Expenses",
  "RID", "Changes in Net Worth",
  "RIE", "Analysis of Allowance for Losses--Loans, Notes, Sales Contracts, and Leases",
  "RCR1", "Summary of Regulatory Capital",
  "RCR2", "Summary--Regulatory Capital Ratios",
  "RCR3", "Common Cooperative Equities",
  "RCR4", "Tier 1/Tier 2 Numerator",
  "RCR5", "Miscellaneous Tier 1/Tier 2 Calculations",
  "RCR6", "Permanent Capital Numerator",
  "RCR7", "Risk-Weighted Assets (RWAs)"
)

usethis::use_data(FileMetadata, overwrite = TRUE)
