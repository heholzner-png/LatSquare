
<!-- README.md is generated from README.Rmd. Please edit that file -->

# LatSquare

<!-- badges: start -->

<!-- badges: end -->

## Overview

`LatSquare` provides functions for the statistical analysis of **Latin
square experimental designs**, including ANOVA, least significant
difference (LSD) tests, and summary statistics.

The package is designed for agricultural and experimental research
applications where balanced Latin square designs are used.

------------------------------------------------------------------------

## Installation

### From CRAN

``` r
install.packages("LatSquare")
```

### Development version (GitHub)

``` r
# install.packages("devtools")
devtools::install_github("USERNAME/LatSquare")
```

------------------------------------------------------------------------

## Example

The following example demonstrates how to analyse a Latin square dataset
stored in an Excel file.

``` r
library(LatSquare)

# Example call (user must provide own dataset)
res <- LQuad(
  file_path = "your_data.xlsx",
  sheet_name = "Sheet1",
  block_col = "Block",
  column_col = "Column",
  treatment_col = "Treatment",
  response_cols = c("Yield")
)

res
```

------------------------------------------------------------------------

## Expected data structure

The input dataset must contain:

- one column for **Block (row position)**
- one column for **Column**
- one column for **Treatment**
- one or more **response variables**

Each treatment must appear exactly once in each row and column (standard
Latin square design).

------------------------------------------------------------------------

## Output

The function returns, for each response variable:

- ANOVA table (SS, DF, MS, F, p-values)
- LSD values (5% and 1%)
- Means:
  - overall mean
  - block means
  - column means
  - treatment means

------------------------------------------------------------------------

## Notes

- The function assumes a **balanced Latin square design** without
  missing values.
- No internal validation of design structure is performed.
- Incorrect or unbalanced input data may lead to invalid results.

------------------------------------------------------------------------

## Author

Heinrich Holzner
