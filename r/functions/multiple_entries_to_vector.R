# Function to process a string containing multiple comma-separated entries 
# and convert it into a cleaned character vector
multiple_entries_to_vector <- function(x) {
  # Ensure input is in character format and handle NULL cases
  if (is.null(x) || length(x) == 0) {
    return(character(0))  # Return an empty character vector
  }
  
  x <- as.character(x)
  
  # Remove NA values before processing
  x <- x[!is.na(x)]
  
  # Split the string into individual entries using a comma as the delimiter
  x_new <- unlist(strsplit(x, ",")) 
  
  # Remove leading and trailing whitespace from each entry
  x_new <- trimws(x_new)
  
  # Remove empty strings and entries labeled as "NI" (Not Identified)
  x_new <- x_new[x_new != "" & x_new != "NI"]
  
  # Return the cleaned vector of individual entries
  return(x_new)
}