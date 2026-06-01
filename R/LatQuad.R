#' Analyse eines lateinischen Quadrats
#'
#' Führt eine ANOVA für ein lateinisches Quadrat durch und berechnet LSD sowie Mittelwerte.
#'
#' @param file_path Pfad zur Excel-Datei
#' @param sheet_name Tabellenblatt
#' @param block_col Spaltenname für Block
#' @param column_col Spaltenname für Column
#' @param treatment_col Spaltenname für Treatment
#' @param response_cols Vektor mit Response-Spalten
#'
#' @return Liste mit ANOVA, LSD und Mittelwerten je Response
#' @import openxlsx
#' @export
LQuad <- function(file_path, sheet_name, block_col, column_col, treatment_col, response_cols) {
  data <- openxlsx::read.xlsx(file_path, sheet = sheet_name)

  results <- list()

  for (response_col in response_cols) {
    if (!is.null(data[[response_col]])) {

      block_numbers <- data[[block_col]]
      column_numbers <- data[[column_col]]
      treatment_labels <- data[[treatment_col]]
      response_variable <- data[[response_col]]

      df <- data.frame(
        Block = block_numbers,
        Column = column_numbers,
        Treatment = treatment_labels,
        Response = response_variable
      )

      total_sum <- sum(df$Response)
      total_mean <- mean(df$Response)

      block_sum <- tapply(df$Response, df$Block, sum)
      column_sum <- tapply(df$Response, df$Column, sum)
      treatment_sum <- tapply(df$Response, df$Treatment, sum)

      n <- length(unique(df$Block))
      N <- n^2

      total_ss <- sum(df$Response^2) - (total_sum^2 / N)
      block_ss <- sum(block_sum^2) / n - (total_sum^2 / N)
      column_ss <- sum(column_sum^2) / n - (total_sum^2 / N)
      treatment_ss <- sum(treatment_sum^2) / n - (total_sum^2 / N)
      residual_ss <- total_ss - block_ss - column_ss - treatment_ss

      total_df <- N - 1
      block_df <- n - 1
      column_df <- n - 1
      treatment_df <- n - 1
      residual_df <- (n - 1) * (n - 2)

      block_ms <- block_ss / block_df
      column_ms <- column_ss / column_df
      treatment_ms <- treatment_ss / treatment_df
      residual_ms <- residual_ss / residual_df

      block_f <- block_ms / residual_ms
      column_f <- column_ms / residual_ms
      treatment_f <- treatment_ms / residual_ms

      block_p <- pf(block_f, block_df, residual_df, lower.tail = FALSE)
      column_p <- pf(column_f, column_df, residual_df, lower.tail = FALSE)
      treatment_p <- pf(treatment_f, treatment_df, residual_df, lower.tail = FALSE)

      lsd_5 <- qt(0.975, residual_df) * sqrt(2 * residual_ms / n)
      lsd_1 <- qt(0.995, residual_df) * sqrt(2 * residual_ms / n)

      block_means <- tapply(df$Response, df$Block, mean)
      column_means <- tapply(df$Response, df$Column, mean)
      treatment_means <- tapply(df$Response, df$Treatment, mean)

      results[[response_col]] <- list(
        ANOVA = data.frame(
          Source = c("Block", "Column", "Treatment", "Residual", "Total"),
          DF = c(block_df, column_df, treatment_df, residual_df, total_df),
          SS = c(block_ss, column_ss, treatment_ss, residual_ss, total_ss),
          MS = c(block_ms, column_ms, treatment_ms, residual_ms, NA),
          F = c(block_f, column_f, treatment_f, NA, NA),
          P = c(block_p, column_p, treatment_p, NA, NA)
        ),
        LSD = data.frame(
          Alpha = c(0.05, 0.01),
          LSD = c(lsd_5, lsd_1)
        ),
        Means = list(
          Total = total_mean,
          Block = block_means,
          Column = column_means,
          Treatment = treatment_means
        )
      )
    }
  }

  results <- Filter(Negate(is.null), results)
  return(results)
}
