# Naming convention: FileName__CodeColumn

RCB__INV_CODE <- tibble::tribble(
  ~code, ~value,
  10L, "U.S. Treasury securities",
  15L, "SBA securities",
  17L, "Other U.S. Gov't securities and Agency(excluding MBS)",
  25L, "Securities fully and unconditionally guaranteed by a GSE (excluding MBS and Farmer Mac securities)",
  29L, "Municipal securities",
  35L, "International and multilateral development bank obligations",
  40L, "Money market instruments:Federal funds sold",
  41L, "Money market instruments:Negotiable certificates of Deposit",
  60L, "Money market instruments:Banker acceptances",
  52L, "Money market instruments:Commercial paper",
  50L, "Money market instruments:Reverse repurchase agreements",
  51L, "Money market instruments:Other",
  62L, "RMBS fully and unconditionally guaranteed by U.S. government or its agencies",
  68L, "RMBS fully and unconditionally guaranteed by GSE",
  64L, "Non-Agency RMBS",
  69L, "Other RMBS",
  71L, "CMBS(excl. Farmer Mac sec.):CMBS fully and unconditionally guaranteed by U.S. government",
  72L, "CMBS(excl. Farmer Mac sec.):CMBS fully and unconditionally guaranteed by GSE",
  73L, "CMBS(excl. Farmer Mac sec.):Non-Agency CMBS",
  65L, "CMBS(excl. Farmer Mac sec.):Other CMBS",
  86L, "Farmer Mac guaranteed sec.:Farm and ranch securities (i.e., AMBS)",
  87L, "Farmer Mac guaranteed sec.:Rural utility securities",
  88L, "Farmer Mac guaranteed sec.:USDA securities",
  66L, "Farmer Mac guaranteed sec.:Other Farmer Mac debt securities",
  141L, "ABS(excl. Farmer Mac securities):Credit card receivables",
  142L, "ABS(excl. Farmer Mac securities):Home equity loans",
  143L, "ABS(excl. Farmer Mac securities):Auto Loans",
  144L, "ABS(excl. Farmer Mac securities):Student Loans",
  145L, "ABS(excl. Farmer Mac securities):Equipment loans",
  146L, "ABS(excl. Farmer Mac securities):Manufactured housing loans",
  95L, "ABS(excl. Farmer Mac securities):Other ABS",
  81L, "Other types of debt securities:Domestic debt securities",
  82L, "Other types of debt securities:Foreign debt securities",
  180L, "Allowance for Credit Losses on Debt Securities(start collecting on March 2023)",
  99L, "Total Debt Securities"
)

RCB2__AssetCodeRCB2 <- tibble::tribble(
  ~code, ~value,
  110L, "Level 1: Cash",
  120L, "Level 1: Overnight money market instruments",
  130L, "Level 1: U.S. Government obligations ? 3 years remaining maturity",
  140L, "Level 1: GSE senior debt ? 60 days remaining maturity",
  150L, "Level 1: Diversified investments funds comprised of Level 1 securities",
  160L, "Level 1: Subtotal",
  210L, "Level 2: U.S. Government obligations > 3 years remaining maturity",
  220L, "Level 2: MBS fully and explicitly guaranteed (both P&I) by U.S. Government",
  230L, "Level 2: Diversified investment funds comprised of Levels 1 and 2 securities",
  240L, "Level 2: Subtotal",
  310L, "Level 3: GSE senior debt > 60 days remaining maturity",
  320L, "Level 3: MBS fully guaranteed (both P&I) by a GSE",
  330L, "Level 3: Money market instruments ? 90 day remaining maturity",
  340L, "Level 3: Diversified investments funds comprised of Levels 1, 2, and 3 securities",
  350L, "Level 3: Subtotal",
  410L, "Supplemental liquidity buffer",
  510L, "Total"
)

RCB3__DebtMaturityCode <- tibble::tribble(
  ~code, ~value,
  110L, "<8 days",
  120L, "8-15 days",
  130L, "16-30 days",
  140L, "31-45 days",
  150L, "46-90 days",
  160L, "91-120 days",
  170L, "121-150 days",
  180L, ">150 days",
  185L, "Unamortized discount or premium and unamortized debt issuance costs",
  190L, "Total"
)

RCF__LOANSTATUS <- tibble::tribble(
  ~code, ~value,
  10L, "Accruing",
  20L, "Formally restructured accruing",
  54L, "Nonaccrual: Cash basis",
  56L, "Nonaccrual: Other",
  60L, "Total",
  80L, "Number of Loans"
)

RCF1__LOANSTATUS <- tibble::tribble(
  ~code, ~value,
  100L, "Production Agriculture: Real Estate",
  105L, "Production Agriculture: Production and Intermediate Term",
  110L, "Agribusiness",
  115L, "Communication",
  120L, "Energy",
  125L, "Water/Waste disposal",
  130L, "Rural residential real estate",
  135L, "International",
  140L, "Lease receivables",
  145L, "Direct loans to associations",
  150L, "Discounted loans to OFIs",
  152L, "Other loans",
  155L, "Total"
)

RCI2B__DerivCode <- tibble::tribble(
  ~code, ~value,
  10L, "Cleared Derivatives (Notional): Swap contracts",
  20L, "Cleared Derivatives (Notional): Option contracts ? purchased",
  30L, "Cleared Derivatives (Notional): Option contracts ? written (sold)",
  40L, "Cleared Derivatives (Notional): Futures contracts",
  50L, "Cleared Derivatives (Notional): Total cleared derivative contracts",
  60L, "Non-cleared Derivatives (Notional): Swap contracts",
  70L, "Non-cleared Derivatives (Notional): Option contracts ? purchased",
  80L, "Non-cleared Derivatives (Notional): Option contracts ? written (sold)",
  90L, "Non-cleared Derivatives (Notional): Forward contracts",
  100L, "Non-cleared Derivatives (Notional): Total non-cleared derivative contracts",
  110L, "Total Derivative Contracts (Notional) (sum of 3(e) and 4(e))",
  120L, "Derivatives included in Line 5 that are on behalf of customers (Notional)",
  130L, "Cleared Derivatives (Fair Value): Swap contracts",
  140L, "Cleared Derivatives (Fair Value): Option contracts ? purchased",
  150L, "Cleared Derivatives (Fair Value): Option contracts ? written (sold)",
  160L, "Cleared Derivatives (Fair Value): Futures contracts",
  170L, "Cleared Derivatives (Fair Value): Total cleared derivative contracts",
  180L, "Non-cleared Derivatives (Fair Value): Swap contracts",
  190L, "Non-cleared Derivatives (Fair Value): Option contracts ? purchased",
  200L, "Non-cleared Derivatives (Fair Value): Option contracts ? written (sold)",
  210L, "Non-cleared Derivatives (Fair Value): Forward contracts",
  220L, "Non-cleared Derivatives (Fair Value): Total non-cleared derivative contracts",
  230L, "Total derivative contracts (Fair Value ? sum of 7(e) and 8(e))"
)

RCI2C__ExposureCode <- tibble::tribble(
  ~code, ~value,
  10L, "Institution?s Exposure to Counterparties after netting: Derivative contracts in a gain position",
  20L, "Institution?s Exposure to Counterparties after netting: Initial margin posted by counterparties - Cash",
  30L, "Institution?s Exposure to Counterparties after netting: Initial margin posted by counterparties - Securities",
  40L, "Institution?s Exposure to Counterparties after netting: Variation margin or settlement payments posted by counterparties - Cash",
  50L, "Institution?s Exposure to Counterparties after netting: Variation margin or settlement payments posted by counterparties - Securities",
  70L, "Institution?s Exposure to Counterparties after netting: Institution?s exposure to counterparties (item 10(a) minus (items 10(b) through 10(e)))",
  80L, "Counterparties? Exposure to Institution after netting: Derivative contracts in a loss position",
  90L, "Counterparties? Exposure to Institution after netting: Initial margin posted by counterparties - Cash",
  100L, "Counterparties? Exposure to Institution after netting: Initial margin posted by counterparties - Securities",
  110L, "Counterparties? Exposure to Institution after netting: Variation margin or settlement payments posted by counterparties - Cash",
  120L, "Counterparties? Exposure to Institution after netting: Variation margin or settlement payments posted by counterparties - Securities",
  140L, "Counterparties? Exposure to Institution after netting: Counterparty exposure to institution (item 11(a) minus (items 11(b) through 11(e)))"
)

RCI2D__DerivRMCode <- tibble::tribble(
  ~code, ~value,
  10L, "Cleared derivatives: Interest rate risk",
  20L, "Cleared derivatives: Foreign exchange",
  30L, "Cleared derivatives: Credit",
  40L, "Cleared derivatives: Others",
  50L, "Cleared derivatives: Total cleared",
  60L, "Non-cleared derivatives: Interest rate risk",
  70L, "Non-cleared derivatives: Foreign exchange",
  80L, "Non-cleared derivatives: Credit",
  90L, "Non-cleared derivatives: Others",
  100L, "Non-cleared derivatives: Total non-cleared",
  110L, "Total derivative contracts (sum 12(e) + 13(e))"
)

RCO__ASSET_CODE <- tibble::tribble(
  ~code, ~value,
  10L, "Loan participations: Purchased",
  20L, "Loan participations: Sold",
  30L, "Similar entity transactions: Acquired On Interest Held",
  40L, "Similar entity transactions: Sold",
  50L, "Lease interest purchases and sales: Purchased",
  60L, "Lease interest purchases and sales: Sold",
  70L, "Other asset purchases and sales: Purchased",
  80L, "Other asset purchases and sales: Sold",
  90L, "Participations in Notes Receivables: Purchased",
  100L, "Participations in Notes Receivables: Sold",
  110L, "Asset Purchases and Sales - Certain Pool Items: Purchased",
  120L, "Asset Purchases and Sales - Certain Pool Items: Sold"
)

RCR3__RegCapCode <- tibble::tribble(
  ~code, ~value,
  100L, "Purchased Statutory Required Stock",
  210L, "Purchased Other Required Stock < 5 years",
  220L, "Purchased Other Required Stock >= 5 years but < 7 years",
  230L, "Purchased Other Required Stock >= 7 years",
  310L, "Allocated Stock < 5 years",
  320L, "Allocated Stock >= 5 years but < 7 years",
  330L, "Allocated Stock >= 7 years",
  410L, "Qualified Allocated Surplus < 5 years",
  420L, "Qualified Allocated Surplus >= 5 years but < 7 years",
  430L, "Qualified Allocated Surplus >= 7 years",
  510L, "Nonqualified Allocated Surplus < 5 years",
  520L, "Nonqualified Allocated Surplus >= 5 years but < 7 years",
  530L, "Nonqualified Allocated Surplus >= 7 years",
  540L, "Not subject to redemption or revolvement",
  600L, "Total Common Cooperative Equities"
)

RCR7__RegCapCode <- tibble::tribble(
  ~code, ~value,
  100L, "Cash and cash balances due from depository institutions or Federal Reserve",
  210L, "Federal funds sold",
  220L, "Securities purchased under agreement to resell",
  310L, "Securities Held-to-Maturity",
  320L, "Securities Available-for-Sale",
  410L, "On-balance sheet securitization exposures Held-to-Maturity",
  420L, "On-balance sheet securitization Available-for-Sale",
  430L, "On-balance sheet securitization All other",
  510L, "Loans and leases, net of unearned income Retail exposures",
  520L, "Loans and leases, net of unearned income Wholesale exposures",
  600L, "Loans & Leases Held for Sale",
  700L, "All other assets",
  800L, "Total On-Balance Sheet Exposures",
  900L, "Financial standby letters of credit",
  1000L, "Performance standby letters of credit and transaction-related contingent items",
  1110L, "Commercial and similar letters of credit Original maturity of 14 months or less",
  1120L, "Commercial and similar letters of credit Original maturity exceeding 14 months",
  1200L, "Repo-styled transactions",
  1310L, "Unused commitments Original maturity of 14 months or less",
  1320L, "Unused commitments Original maturity exceeding 14 months",
  1330L, "Unused commitments Original Wholesale exposures",
  1400L, "Over-the-counter derivatives",
  1500L, "Centrally cleared derivatives",
  1600L, "Unsettled Transactions",
  1700L, "All other off-balance sheet exposures",
  1800L, "Total Off-Balance Sheet Exposures",
  1900L, "Total On- and Off-Balance Sheet Exposures",
  2000L, "Risk Weight Factor",
  2100L, "Risk Weighted Assets before deductions"
)

RID__CAP_CODE <- tibble::tribble(
  ~code, ~value,
  10L, "Beginning balance",
  25L, "Prior Period & Accounting Adjustments",
  35L, "Net Income",
  45L, "Other Comprehensive Income",
  80L, "Patronage Distributions",
  70L, "Dividends",
  75L, "Stock Issued",
  85L, "Stock Retired",
  95L, "Paid-in Capital Adjustments",
  105L, "Allocated Equity Retired",
  120L, "Other",
  130L, "Ending balance"
)

RIE1__ACLCode <- tibble::tribble(
  ~code, ~value,
  10L, "Allowances for Credit Losses, beginning of period",
  20L, "Net increase (or decrease (-)) resulting from provision for credit losses (current period)",
  30L, "Less: Charge-offs",
  40L, "Less: Write-downs arising from transfer of financial assets",
  50L, "Recoveries",
  60L, "Other",
  70L, "Allowances for credit losses, end of period"
)
