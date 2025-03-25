
# Neonatal EEG Pain Analysis (R)

This folder contains the R-based analysis used in a scoping review of neonatal EEG and pain. It generates all summary statistics, figures, and output data files included in the published article, based on the extracted data provided in this repository.

The analysis is designed to be run in a single step. All figures and tables will be saved automatically to an output folder.

## Folder contents

```
r/
├── SR_Baby_EEG_Pain.Rproj       # RStudio project file (sets working directory)
├── data/
│   └── data_extraction_form.csv # Dataset used in the analysis
├── scripts/
│   └── analyse_data.R           # Main script to run the analysis
├── functions/
│   └── *.R                      # Helper functions called by the script
└── results/                     # Created automatically when the script is run
```

## How to use this folder

1. Open `SR_Baby_EEG_Pain.Rproj` in RStudio. This sets the correct working directory.
2. Open the script `scripts/analyse_data.R`.
3. Run the script. All outputs will be saved to the `results/` folder.

## Output files and usage

Running the script generates:

- `summary_stats.csv`: Descriptive statistics across studies
- `plot_publication_year.pdf`: Publication trend over time
- `plot_country_map.pdf`: Choropleth map of studies by country
- `plot_electrode_frequencies.pdf`: Frequency of EEG electrode use
- `raincloud_data_single.csv`: Data for JASP raincloud plots (sample size, EEG data loss)
- `raincloud_data_paired.csv`: Data for JASP raincloud plots (postmenstrual age, sex)

## Summary

This R folder provides a fully automated pipeline for generating descriptive summaries and publication-ready visualizations based on the extracted dataset.
