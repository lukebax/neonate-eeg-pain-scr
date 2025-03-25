
# Co-Authorship Network (VOSviewer)

This folder contains files used to generate a co-authorship network for the neonatal EEG pain scoping review using *VOSviewer*.

## Folder contents

- `included_studies.ris`: Exported from EPPI-Reviewer (included references)
- `map_file.csv`: VOSviewer map file (author positions and cluster assignments)
- `network_file.csv`: VOSviewer network file (co-authorship links)

## How to use this folder

You can visualize the co-authorship network in two ways:

### Option 1: Create the network from the `.ris` file

1. Open *VOSviewer*
2. Select `Create` → `Create a map based on bibliographic data`
3. Choose `Read data from reference manager files` and select `included_studies.ris`
4. On the analysis setup:
   - Type of analysis: `Co-authorship`
   - Counting method: `Full counting`
   - Deselect: `Ignore documents with a large number of authors`
5. Set “Minimum number of documents of an author” to `1`
6. Leave default on number of authors
7. When prompted about unconnected items, click `No`
8. Switch to the **Analysis** tab:
   - Set `Clustering Resolution` to `0.5` → click `Update Clustering`
   - Set `Normalization Method` to `No normalization` → click `Update Layout`
9. Go to `File` → `Save` → choose `*.csv` to export:
   - `map_file.csv`
   - `network_file.csv`

### Option 2: Load the exported `.csv` files

- Open *VOSviewer* → `File` → `Open`
- Load `map_file.csv` and `network_file.csv` to view the network

## Creating the simplified figure for publication

To prepare the final figure used in the paper:

1. On the right panel:
   - Visualization → Set `Scale` to `2`, `Weights` to `Documents`
   - Labels → Set `Size variation` to `0`, `Max. length` to `0` (removes names)
   - Lines → `Size variation` to `0`, `Max. lines` to `10000`
   - Colors → Set the same RGB value (e.g. `[174, 205, 225]`) for all clusters

2. On the left panel:
   - Go to `File` → `Screenshot` → Save the image (e.g. as PNG or PDF)

## Output files and usage

- The `.ris` file is the raw input from EPPI-Reviewer
- The `.csv` files define the network layout and links
- The simplified image is not included here, but is used in the publication
- Full author names and clusters are listed in the supplementary material

## Summary

This folder enables reconstruction and exploration of the co-authorship network using *VOSviewer*, with clear steps to reproduce or adapt the network visualization.
