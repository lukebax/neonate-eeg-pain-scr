# Load required libraries
library(dplyr)   # Data manipulation
library(readr)   # CSV reading and writing
library(tidyr)   # Data reshaping

# Ensure the results directory exists; create it if missing
if (!dir.exists("results")) {
  dir.create("results")
}

# Function to export single-variable raincloud data
export_single_raincloud_data <- function(data) {
  # Filter dataset to include only rows where analysis_group == 3
  df_single <- data %>% 
    select(sample_size, eeg_data_loss_pct) %>%  # Select relevant variables
    rename(Count = sample_size, Percent = eeg_data_loss_pct)  # Rename columns for clarity
  
  # Check if there is valid data to export
  if (nrow(df_single) == 0) {
    warning("Warning: No valid data found for single raincloud export. Empty file will be created.")
    write_csv(data.frame(Count = numeric(0), Percent = numeric(0)), "results/raincloud_data_single.csv", na = "")
    return(NULL)
  }
  
  # Replace NA values safely based on column type
  df_single <- df_single %>%
    mutate(
      across(where(is.character), ~replace_na(., "")),
      across(where(is.numeric), ~replace_na(., NA_real_))
    )
  
  # Save the single-variable raincloud dataset as a CSV file
  write_csv(df_single, "results/raincloud_data_single.csv", na = "")
}

# Function to export paired raincloud data (age and sex)
export_paired_raincloud_data <- function(data) {
  # Filter dataset to include only rows where analysis_group == 3 and add an ID column
  df_filtered <- data %>% mutate(ID = row_number())
  
  # Check if there is valid data to export
  if (nrow(df_filtered) == 0) {
    warning("Warning: No valid data found for paired raincloud export. Empty file will be created.")
    write_csv(data.frame(ID = integer(0), Condition = integer(0), Weeks = numeric(0), 
                         `Postmenstrual age` = character(0), Percent = numeric(0), Sex = character(0)), 
              "results/raincloud_data_paired.csv", na = "")
    return(NULL)
  }
  
  # Reshape age data from wide to long format
  df_age <- df_filtered %>% 
    select(ID, pma_birth_avg, pma_study_avg) %>% 
    pivot_longer(cols = c(pma_birth_avg, pma_study_avg), names_to = "Condition", values_to = "Weeks") %>% 
    mutate(Condition = ifelse(Condition == "pma_birth_avg", 1, 2),  # Encode birth vs. study age
           `Postmenstrual age` = ifelse(Condition == 1, "Birth", "Study"))  # Add descriptive labels
  
  # Reshape sex data from wide to long format
  df_sex <- df_filtered %>% 
    select(ID, sex_male_pct, sex_female_pct) %>% 
    pivot_longer(cols = c(sex_male_pct, sex_female_pct), names_to = "Condition", values_to = "Percent") %>% 
    mutate(Condition = ifelse(Condition == "sex_male_pct", 1, 2),  # Encode male vs. female
           Sex = ifelse(Condition == 1, "Male", "Female"))  # Add descriptive labels
  
  # Merge age and sex datasets on ID and Condition
  df_combined <- inner_join(df_age, df_sex, by = c("ID", "Condition"))
  
  # Replace NA values safely based on column type
  df_combined <- df_combined %>%
    mutate(
      across(where(is.character), ~replace_na(., "")),
      across(where(is.numeric), ~replace_na(., NA_real_))
    )
  
  # Select and order final columns for output
  df_combined <- df_combined %>% 
    select(ID, Condition, Weeks, `Postmenstrual age`, Percent, Sex)
  
  # Save the paired raincloud dataset as a CSV file
  write_csv(df_combined, "results/raincloud_data_paired.csv", na = "")
}