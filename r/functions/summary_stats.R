# Function to compute summary statistics (min, quartiles, median, max) for a numeric dataset
summary_stats <- function(data, row_name) {
  # Convert input data to numeric format (if not already)
  data <- as.numeric(data)
  
  # Check if all values are NA; return empty statistics if true
  if (all(is.na(data))) {
    warning(paste("Warning: No valid numeric data found for", row_name, ". Returning NA values."))
    stats <- c(Min = NA, Q1 = NA, Median = NA, Q3 = NA, Max = NA)
  } else {
    # Compute key summary statistics while handling missing values
    stats <- c(
      Min = min(data, na.rm = TRUE),               # Minimum value
      Q1 = quantile(data, 0.25, na.rm = TRUE),     # First quartile (25th percentile)
      Median = median(data, na.rm = TRUE),         # Median (50th percentile)
      Q3 = quantile(data, 0.75, na.rm = TRUE),     # Third quartile (75th percentile)
      Max = max(data, na.rm = TRUE)                # Maximum value
    )
  }
  
  # Convert the computed statistics into a transposed data frame
  stats_table <- data.frame(t(stats))
  
  # Assign the specified row name to the summary statistics table
  rownames(stats_table) <- row_name
  
  # Return the formatted summary statistics table
  return(stats_table)
}