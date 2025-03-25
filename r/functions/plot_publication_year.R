# Load required libraries
library(ggplot2)  # For data visualization
library(dplyr)    # For data manipulation

# Function to generate a bar plot of publication years
plot_publication_year <- function(df, output_file) {
  
  # Remove missing values and count occurrences of each publication year
  years_counts <- df %>%
    dplyr::filter(!is.na(publication_year)) %>%  # Ensure no missing values
    dplyr::count(publication_year) %>%
    dplyr::arrange(publication_year)  # Ensure years are sorted chronologically
  
  # Check if there is any valid data to plot
  if (nrow(years_counts) == 0) {
    warning("Warning: No valid publication year data found. Skipping publication year plot.")
    return(NULL)
  }
  
  # Define color for bars
  blue_colour <- "#AECDE1"
  
  # Create the bar plot of publication years
  plot <- ggplot(years_counts, aes(x = publication_year, y = n)) +
    geom_bar(stat = "identity", fill = blue_colour, color = "black", width = 0.75) +  # Create bars with black borders
    theme_minimal() +  # Use a clean, minimal theme
    labs(x = "Publication Year", y = "Record Count") +  # Add axis labels
    scale_x_continuous(
      breaks = seq(min(years_counts$publication_year), max(years_counts$publication_year), by = 1)
    ) +
    theme(
      axis.text.x = element_text(size = 12, angle = 45, hjust = 1),  # Rotate x-axis labels for readability
      axis.text.y = element_text(size = 12),  # Set y-axis label size
      axis.title.x = element_text(size = 14, face = "bold"),  # Style x-axis title
      axis.title.y = element_text(size = 14, face = "bold"),  # Style y-axis title
      panel.grid.major.x = element_blank(),  # Remove major vertical grid lines
      panel.grid.minor = element_blank()  # Remove minor grid lines
    )
  
  # Save the figure to the specified output file
  save_figure(plot, output_file)
}