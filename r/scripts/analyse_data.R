# Load required functions from external scripts
source("functions/count_occurrences.R")          # Function to count categorical variable values
source("functions/multiple_entries_to_vector.R") # Function to split comma-separated values
source("functions/save_figure.R")                # Wrapper for saving figures to file
source("functions/summary_stats.R")              # Function to calculate summary statistics
source("functions/plot_country_map.R")           # Function to create country distribution map
source("functions/plot_publication_year.R")      # Function to plot histogram of publication years
source("functions/export_raincloud_data.R")      # Function to export CSVs for raincloud plotting
source("functions/plot_electrode_frequencies.R") # Function to create electrode distribution map

# Load required libraries
library(readr)   # Efficient CSV reading
library(ggplot2) # Data visualization
library(dplyr)   # Data manipulation
library(tidyr)   # Data reshaping

# Define the results folder for output files
results_folder <- "results/"

# Create results folder if it doesn't exist
if (!dir.exists(results_folder)) {
  dir.create(results_folder)
}

# Load dataset from CSV file
data_path <- "data/data_extraction_form.csv"  
df <- read_csv(data_path, show_col_types = FALSE)

# Define consistent color scheme and font size for plots
blue_colour <- "#AECDE1"   
axis_font_size <- 12

# Filter dataset to include only relevant groups for descriptive figures
df_analysis_1 <- df %>% dplyr::filter(analysis_group %in% c(1, 2, 3))

# Generate and save country count table and map
country_count_table <- count_occurrences(df_analysis_1$data_country, paste0(results_folder, "fig_country_count_table.csv"))
plot_country_map(country_count_table, paste0(results_folder, "fig_country_map.pdf"))

# Generate and save publication year plot
years_range <- seq(min(df_analysis_1$publication_year, na.rm = TRUE), 
                   max(df_analysis_1$publication_year, na.rm = TRUE), by = 1)

years_counts <- df_analysis_1 %>%
  dplyr::filter(!is.na(publication_year)) %>%
  count(publication_year) %>%
  right_join(data.frame(publication_year = years_range), by = "publication_year") %>%
  dplyr::mutate(n = replace_na(n, 0))

plot_publication_year(df_analysis_1, paste0(results_folder, "fig_publication_year.pdf"))


# Filter for primary analysis group (group 3)
df_analysis_2 <- df %>% dplyr::filter(analysis_group == 3)

# Export CSV files for external raincloud plotting in JASP
export_single_raincloud_data(df_analysis_2)
export_paired_raincloud_data(df_analysis_2)

# Compute summary statistics and export summary statistics table
summary_vars <- c("Sample Size (N)", "Age at Birth (weeks)", "Age at Study (weeks)", 
                  "EEG Data Loss (%)", "Males (%)", "Females (%)")

T_summary_stats <- data.frame(
  Min = numeric(length(summary_vars)),
  Q1 = numeric(length(summary_vars)),
  Median = numeric(length(summary_vars)),
  Q3 = numeric(length(summary_vars)),
  Max = numeric(length(summary_vars)),
  row.names = summary_vars
)

T_summary_stats["Sample Size (N)", ] <- summary_stats(df_analysis_2$sample_size, "Sample Size (N)")
T_summary_stats["Age at Birth (weeks)", ] <- summary_stats(df_analysis_2$pma_birth_avg, "Age at Birth (weeks)")
T_summary_stats["Age at Study (weeks)", ] <- summary_stats(df_analysis_2$pma_study_avg, "Age at Study (weeks)")
T_summary_stats["EEG Data Loss (%)", ] <- summary_stats(df_analysis_2$eeg_data_loss_pct, "EEG Data Loss (%)")

write.csv(T_summary_stats, paste0(results_folder, "summary_stats.csv"), row.names = TRUE)

# Generate and save electrode count table and map
electrode_count_table <- count_occurrences(df_analysis_2$electrode_positions, paste0(results_folder, "fig_electrode_count_table.csv"))

plot_electrode_frequencies(
  electrode_data = electrode_count_table,
  output_pdf = paste0(results_folder, "electrode_frequency_map.pdf")
)

# Plot and export selected categorical variables
categorical_vars <- c("pain_procedure", "analgesic_intervention", "epoch_rej_method", 
                      "clinical_pain_scale", "non_eeg_recording", "electrode_placement_method")

file_names <- c("fig_pain_procedure.pdf", "fig_analgesic_intervention.pdf", "fig_epoch_rej_method.pdf", 
                "fig_clinical_pain_scale.pdf", "fig_non_eeg_recording.pdf", "fig_electrode_placement_method.pdf")

for (i in seq_along(categorical_vars)) {
  var_name <- categorical_vars[i]
  file_name <- paste0(results_folder, file_names[i])
  csv_file <- gsub(".pdf", ".csv", file_name)
  
  count_table <- count_occurrences(df_analysis_2[[var_name]], csv_file) %>% dplyr::arrange(Count)
  
  plot_categorical <- ggplot(count_table, aes(x = reorder(Category, Count), y = Count)) +
    geom_bar(stat = "identity", fill = blue_colour, color = "black") +
    coord_flip() +
    theme_minimal() +
    labs(x = "", y = "Count") +
    theme(axis.text.x = element_text(size = axis_font_size),
          axis.text.y = element_text(size = axis_font_size))
  
  save_figure(plot_categorical, file_name)
}
