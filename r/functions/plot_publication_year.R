# Load required libraries
library(ggplot2)
library(dplyr)

# Function to plot publication years (horizontal bars) and save as PDF
# order: "older_first" (default) or "newer_first"
plot_publication_year <- function(df, output_file, order = c("older_first", "newer_first")) {
  
  order <- match.arg(order)
  
  # Remove missing values and count occurrences of each publication per year
  years_counts <- df %>%
    dplyr::filter(!is.na(publication_year)) %>% # Ensure no missing values
    dplyr::count(publication_year) %>%
    dplyr::arrange(publication_year) # Ensure years are sorted chronologically
  
  # Check if there is any valid data to plot
  if (nrow(years_counts) == 0) {
    warning("Warning: No valid publication year data found. Skipping plot.")
    return(NULL)
  }
  
  # Factor order depending on user choice
  if (order == "newer_first") {
    # newest at top (reverse chronological)
    level_order <- rev(years_counts$publication_year)
  } else {
    # oldest at top
    level_order <- years_counts$publication_year
  }
  
  years_counts <- years_counts %>%
    mutate(publication_year_f = factor(as.character(publication_year),
                                       levels = as.character(level_order)))
  
  # Aesthetic settings
  fill_colour <- "#C398BE"
  
  # Build plot
  plot <- ggplot(years_counts, aes(x = publication_year_f, y = n)) +
    geom_col(width = 0.7, fill = fill_colour, color = NA) +  # no border
    coord_flip() +
    labs(x = "Publication Year", y = "Record Count") + # Add axis labels
    theme_minimal(base_size = 24) +  # Use a clean, minimal theme, larger base font
    theme(
      panel.grid = element_blank(),                       # remove grid
      axis.line.x = element_line(color = "black", linewidth = 0.6),  # show only x-axis line
      axis.line.y = element_blank(),                      # remove y-axis line
      axis.text.x = element_text(size = 22),
      axis.text.y = element_text(size = 22),
      axis.title.x = element_text(size = 26, face = "bold", margin = margin(t = 20)),
      axis.title.y = element_text(size = 26, face = "bold", margin = margin(r = 20)),
      axis.ticks = element_blank(),
      panel.border = element_blank(),
      plot.margin = margin(20, 30, 20, 30)
    )
  
  # Save the figure to the specified output file (optimised for pdf)
  file_ext <- tools::file_ext(output_file)
  device <- if (tolower(file_ext) == "pdf") cairo_pdf else NULL
  
  ggsave(filename = output_file,
         plot = plot,
         device = device,
         width = 7,
         height = 8,
         units = "in")
}