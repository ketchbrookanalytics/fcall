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

INST_schema <- tibble::tribble(
  ~ColumnName, ~ColumnType, ~DecimalPosition, ~Definition,
  "SYSTEM" , "numeric" , 0, "System Code",
  "DIST" , "numeric" , 0, "District Code",
  "ASSOC" , "numeric" , 0, "Association Code",
  "MONTH" , "numeric" , 0, "Month of Report",
  "YEAR" , "numeric" , 0, "Year of Report",
  "UNINUM" , "numeric" , 0, "System, district, and Association codes concatenated",
  "SHORTNAME" , "character" , 0, "Institution short name",
  "MAIL_ADDR" , "character" , 0, "Mailing address",
  "STREET_ADDR" , "character" , 0, "Street address",
  "CITY" , "character" , 0, "City name",
  "STATE" , "character" , 0, "State name",
  "ZIP" , "character" , 0, "Zip code"
)

# RC_schema <- tibble::tribble(
#
#   "SYSTEM", "Numeric", 0, "System Code",
#   "DIST", "Numeric", 0, "District Code",
#   "ASSOC", "Numeric", 0, "Association Code",
#   "MONTH", "Numeric", 0, "Month of Report",
#   "YEAR", "Numeric", 0, "Year of Report",
#   "UNINUM", "Numeric", 0, "System, District, and Association codes concatenated",
#   "CASH", "Numeric", 0, "Cash",
#   "ACTREC", "Numeric", 0, "Accounts Receivable",
#   "ACRLNS", "Numeric", 0, "Accrual Loans and Leases net of unearned income and unapplied loan payments",
#   "NTRECOFCI", "Numeric", 0, "Loans, notes, sales, contracts, and"
#   "leases",:" ",Notes ,receivable" from other"
#   "FCS", "institutions",
#   ,""ONTREC", "Numeric", 0, "Loans, notes, sales, contracts, and"
#   "leases",:"" ",Other ,notes"" receivable"
#   "ACRSCON", "Numeric"," 0, "Loans, notes, sales, contracts, and"
#   "leases",:"" ",Accrual ,Sales"" Contracts"
#   "NONACR", "Numeric", 0, "Loans, notes, sales, contracts, and"
#   "leases",:"" ",Nonaccrual ,Loans"
#   "ALLNLOSS", "Numeric"," 0, "Loans, notes, sales, contracts, and"
#   "leases",:"" ",Allowance ,for" Losses on Loans"
#   "NETLOANS", "Numeric", 0, "Loans, notes, sales, contracts, and"
#   "leases",:"" ",Net ,Loans"
#   "AIRLOANS", "Numeric"," 0, "Accrued Interest Receivable on Loans"
#   "and", "Leases",
#   ,""AIRNTRECOFCI", "Numeric"," 0, "Accrued Interest Receivable on Notes"
#   "receivable", "from"," other, "FCS Institutions"
#   "AIRONTREC", "Numeric"," 0, "Accrued Interest Receivable on Other"
#   "Notes", "receivable",
#   ,""AIRSCON", "Numeric"," 0, "Accrued Interest Receivable on Sales"
#   "Contracts",  ""                                                                ",
#   ",AIRMKTIN", "Numeric"," 0, "Accrued Interest Receivable on"
#   "Securities", "                                                                ","
#   ,""AIREC", "Numeric", 0, "Total Accrued Interest Receivable"
#   "NAQPROP", "Numeric", 0, "Other Property Owned"
#   "FIXASSET", "Numeric", 0, "Premises and Other Fixed Assets"
#   "OASSETS", "Numeric", 0, "Other Assets"
#   "ASSETS", "Numeric", 0, "Total Assets"
#   "SYSNTBDSOS", "Numeric", 0, "Interest bearing liabilities:"
#   "Systemwide", "notes", and, "bonds outstanding"
#   "NTPAYOFCI", "Numeric", 0, "Interest bearing liabilities:"
#   "Notes", "payable", to, "other FCS"
#   "OINTBEARDT", "Numeric", 0, "Interest bearing liabilities:"
#   "Other", "interest",-bearing, "debt"
#   "ACTPAY", "Numeric", 0, "Accounts Payable"
#   "AIPSYSNTBDSOS", "Numeric", 0, "Accrued interest payable on: Systemwide"
#   "notes", "and", bonds, "outstanding"
#   "AIPNTPAYOFCI", "Numeric", 0, "Accrued interest payable on: Notes"
#   "payable", "to", other, "FCS institutions"
#   "AIPOINTBEARDT", "Numeric", 0, "Accrued Interest Payable on Other"
#   "interest",-"bearing", debt,"                                                      "
#   "AIPAY", "Numeric", 0, "Total Accrued Interest Payable"
#   "OLIABS", "Numeric", 0, "Other Liabilities"
#   "LIABS", "Numeric", 0, "Total Liabilities"
#   "NETWRTH", "Numeric", 0, "Total Net Worth"
#   "TOTLICAP", "Numeric", 0, "Total Liabilities and Net Worth"
#   "ACNOCOMINC", "Numeric", 0, "Accumulated other comprehensive income (net)"
#   "LNADJFVAL", "Numeric", 0, "Loans, notes, sales, contracts, and"
#   "leases",:"" ",Loan ,adjustment" for fair value"
#   "DTADJFVAL", "Numeric"," 0, "Interest bearing liabilities:"
#   "Debt", "adjustment"," for, "fair value"
#   "TOTINTBEARLIAB", "Numeric"," 0, "Interest bearing liabilities:"
#   "Total", "interest"," bearing, "liabilities"
#   "AIRDERIVATIVE", "Numeric"," 0, "Accrued interest receivable: Derivatives"
#   "IBLSUBNOTEBOND", "Numeric"," 0, "Interest bearing liabilities:"
#   "Subordinated", "notes"," and, "bonds"
#   "AIPSUBNOTEBOND", "Numeric"," 0, "Accrued interest payable on:"
#   "Subordinated", "notes"," and, "bonds"
#   "AIPDERIVATIVE", "Numeric"," 0, "Accrued interest payable on: Derivatives"
#   "LoanLeaseHeld", "Numeric"," 0, "Loans and leases held for sale"
#   "CreditLossReserve", "Numeric"," 0, "Reserve for credit losses on off-balance"
#   "sheet", "exposures",
#   ,""TERMPERFSTK", "Numeric"," 0, "Interest bearing liabilities:"
#   "Limited",-"life"," (term,) "preferred stock"
#   "AccrdIntPayTermPrefStk", "Numeric"," 0, "Accrued interest payable on:"
#   "Limited",-"life"," (term,) "preferred stock"
#   "CapStock", "Numeric"," 0, "Capital stock"
#   "PerpetualPrefStk", "Numeric"," 0, "Perpetual Preferred stock"
#   "PAIDIN", "Numeric"," 0, "Paid-in capital"
#   "AllocSurplus", "Numeric"," 0, "Allocated Surplus"
#   "UNRETERN", "Numeric"," 0, "Unallocated retained earnings"
#   "TotInvDebtSecurities", "Numeric"," 0, "Debt securities"
#   "TotInvEquityFCSI", "Numeric"," 0, "Equity investments in System institutions"
#   "and", "Farmer"," Mac,"                                                             ""
#   "TotInvEquityNonFCSI", "Numeric"," 0, "Equity investments in non-System institutions"
#   "TotInvestments", "Numeric"," 0, "Total Investments"
# )


usethis::use_data(FileMetadata, INST_schema, overwrite = TRUE)
