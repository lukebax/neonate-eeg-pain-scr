# Function to save a ggplot figure to a specified file
save_figure <- function(plot, output_file, fig_size = c(10, 3)) {
  library(ggplot2)  # Load ggplot2 for saving figures
  
  # Ensure results directory exists before saving
  results_folder <- dirname(output_file)
  if (!dir.exists(results_folder)) {
    dir.create(results_folder, recursive = TRUE)
  }
  
  # Check if plot is valid before saving
  if (is.null(plot) || !inherits(plot, "gg")) {
    warning(paste("Warning: The plot object is invalid or missing. Skipping save for", output_file))
    return(NULL)
  }
  
  # Save the plot to the specified output file
  ggsave(output_file, 
         plot = plot, 
         width = fig_size[1],   # Set figure width (default: 10 inches)
         height = fig_size[2],  # Set figure height (default: 3 inches)
         units = "in")          # Specify units as inches
}