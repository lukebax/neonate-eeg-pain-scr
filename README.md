
# Neonatal EEG Pain Scoping Review – Data & Analysis Repository

This repository supports a scoping review of EEG-based studies of neonatal pain. It includes all the data, scripts, and visualizations used in the analysis and publication.

The repository is organized into three folders:
- `r/`: Main R-based data analysis and figure generation
- `jasp/`: Pre-configured JASP files for producing raincloud plots
- `vosviewer/`: Co-authorship network analysis using VOSviewer

Each folder contains its own `README.md` file with detailed usage instructions.

## Folder Structure

```
📁 r/           # R analysis: runs statistics and creates figures
📁 jasp/        # JASP raincloud plots: visual summaries of key variables
📁 vosviewer/   # VOSviewer network: co-authorship map of included studies
```

## How to Use This Repository

1. Start with the `r/` folder:
   - Run the main analysis script to generate all summary statistics and outputs.
   - This will create two CSV files for raincloud plotting.

2. Open the `jasp/` folder:
   - Use the included `.jasp` files to load the raincloud data.
   - Plots are pre-configured and ready to view or export.

3. Explore the `vosviewer/` folder:
   - Recreate or view the co-authorship network from the included `.ris` file or the exported map and network files.
   - Instructions are provided to reproduce the simplified version used in the paper.

Each folder has its own `README.md` with step-by-step guidance.

## Software Requirements

To use this repository fully, you’ll need:

- [R](https://www.r-project.org/) and [RStudio](https://posit.co/downloads/)  
- [JASP](https://jasp-stats.org/)  
- [VOSviewer](https://www.vosviewer.com/)

These tools are all freely available and work on most systems (Windows, macOS, Linux).

## Summary

This repository provides a fully reproducible workflow for the descriptive analysis of studies included in a scoping review on neonatal EEG and pain. It combines R-based data analysis, interactive plotting via JASP, and bibliometric visualization using VOSviewer.

For questions or collaboration, please contact the repository maintainer.
