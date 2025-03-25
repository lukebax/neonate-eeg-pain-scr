# Load required libraries
library(eegkit)
library(scales)
library(fields)

plot_electrode_frequencies <- function(electrode_data, output_pdf) {

  # Load built-in EEG layout
  data(eegcoord)
  enames <- rownames(eegcoord)
  
  # Rename expected columns
  names(electrode_data)[names(electrode_data) == "Category"] <- "electrode"
  names(electrode_data)[names(electrode_data) == "Count"] <- "count"
  electrode_data$electrode <- toupper(electrode_data$electrode)
  
  # Initialize color vector
  col_vec <- rep("grey90", length(enames))
  names(col_vec) <- enames
  counts <- setNames(electrode_data$count, electrode_data$electrode)
  
  # Build color gradient
  color_fun <- col_numeric(
    palette = c("lightblue", "darkblue"),
    domain = range(counts, na.rm = TRUE)
  )
  scaled_colors <- color_fun(counts)
  col_vec[names(counts)] <- scaled_colors
  
  # Save plot to PDF
  pdf(output_pdf, width = 7, height = 6)
  layout(matrix(1:2, ncol = 2), widths = c(4, 1))
  
  # Plot EEG head map
  eegcap2d(
    electrodes = "10-10",
    head = TRUE,
    nose = TRUE,
    ears = TRUE,
    col.point = col_vec,
    col.label = "white"
  )
  
  # Plot color bar
  image.plot(
    zlim = range(counts, na.rm = TRUE),
    legend.only = TRUE,
    col = color_fun(seq(min(counts), max(counts), length.out = 100)),
    smallplot = c(0.93, 0.95, 0.35, 0.65)
  )
  
  dev.off()
}