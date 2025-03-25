# Function to count occurrences of unique values in a categorical variable
count_occurrences <- function(data, output_file, sort_order = "desc") {
  library(dplyr)  # Load dplyr for data manipulation
  
  # Ensure data is in character format to avoid issues
  data <- as.character(data)
  
  # Remove NA values before further processing
  data <- data[!is.na(data)]
  
  # Expand multiple comma-separated entries into individual values
  data <- multiple_entries_to_vector(data)
  
  # Check if data is empty after processing
  if (length(data) == 0) {
    warning(paste("Warning: No valid data found for", output_file, ". Empty file will be created."))
    write.csv(data.frame(Category = character(), Count = integer()), output_file, row.names = FALSE)
    return(data.frame(Category = character(), Count = integer()))
  }
  
  # Count occurrences of each unique category
  count_table <- as.data.frame(table(data))
  colnames(count_table) <- c("Category", "Count")  # Rename columns for clarity
  
  # Sort the table in ascending or descending order based on user input
  if (sort_order == "asc") {
    count_table <- arrange(count_table, Count)
  } else {
    count_table <- arrange(count_table, desc(Count))
  }
  
  # Save the count table as a CSV file
  write.csv(count_table, output_file, row.names = FALSE)
  
  # Return the count table for further use
  return(count_table)
}