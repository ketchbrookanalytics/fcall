## code to prepare `file_metadata` dataset goes here

# List of different tables provided to FCA each quarter and file prefixes in the .zip archive data
# See https://ww3.fca.gov/fcsinfo/CRS/CallReportFiles/UCR%20Call%20Report%20Instructions.pdf
# Some descriptions were extracted from D_ files headers
file_metadata <- tibble::tribble(
  ~file_prefix, ~description,
  "INST", "Institution Information",
  "RC", "Balance Sheet",
  "RC1", "Memoranda",
  "RCB", "Debt Securities (excluding investments in Farm Credit institutions and diversified investment funds)",
  "RCB2", "Assets Held for Liquidity (Applicable to banks only)",
  "RCB3", "Demands on Liquidity (Applicable to banks and block-funded associations only)",
  "RCB4", "Equity Securities",
  "RCB5", "Investments Memoranda",
  "RCF", "Performance of Loans, Notes, Sales Contracts, and Leases",
  "RCF1", "Performance of Loans, Notes, Sales Contracts, and Leases Loan Performance by Loan Type",
  "RCG", "Average Daily Amounts for the Quarter",
  "RCH", "Reconcilement of Net Worth",
  "RCI1", "Off-Balance Sheet Commitments, Contingencies, and Other Items (Excluding Derivatives)",
  "RCI2A", "Off-Balance Sheet Derivative Contracts: Credit Derivative Contracts Section",
  "RCI2B", "Off-Balance Sheet Derivative Contracts: Derivative Contracts (exclude credit derivatives) Section",
  "RCI2C", "Off-Balance Sheet Derivative Contracts: Fair Value Counterparty Exposures Including Impact of Netting Agreements)",
  "RCI2D", "Off-Balance Sheet Derivative Contracts: Derivatives by Remaining Maturity (Notional) Section",
  "RCK", "Accrual Loan Activity Reconcilement for Loans, Leases, Notes Receivable (excluding Intra-System Loan), and Sales Contracts",
  "RCL", "Nonaccrual Loan Activity Reconcilement",
  "RCM", "Other-Property-Owned (Net of Depreciation) Activity Reconcilement",
  "RCO", "Asset Purchase and Sales",
  "RCR1", "Summary - Regulatory Capital",
  "RCR2", "Summary - Regulatory Capital Ratios",
  "RCR3", "Common Cooperative Equities",
  "RCR4", "Tier 1/Tier 2 Numerator",
  "RCR5", "Miscellaneous Tier 1/Tier 2 Calculations",
  "RCR6", "Permanent Capital Numerator",
  "RCR7", "Risk-Weighted Assets (RWAs)",
  "RI", "Income and Comprehensive Income Statement",
  "RIA", "Operating Income",
  "RIB", "Net Gains and Losses",
  "RIC", "Operating Expenses",
  "RIC1", "Other Noninterest Expenses",
  "RID", "Changes in Net Worth",
  "RIE1", "Changes in Allowances for Credit Losses",
  "RIE2", "Analysis of Allowance for Credit Losses—Loans, Notes, Sales Contracts, and Leases"
)

usethis::use_data(file_metadata, overwrite = TRUE)
