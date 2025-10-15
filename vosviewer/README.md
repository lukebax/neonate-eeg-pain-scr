
# Co-Authorship Network (VOSviewer)

This folder contains files used to generate a co-authorship network for the neonatal EEG pain scoping review using *VOSviewer*.

## Folder contents

- `publications_pre-ScR.ris`: Exported from EPPI-Reviewer (included references)
- `publications_post-ScR.ris`: Same as publications_pre-ScR.ris, but with an entry added for this scoping review author group

## Create networks from `.ris` files

To prepare the networks used in the paper:

1. Open *VOSviewer*
2. Select `Create` → `Create a map based on bibliographic data`
3. Choose `Read data from reference manager files` and select `publications_pre-ScR.ris` (or `publications_post-ScR.ris`)
4. On the analysis setup:
   - Type of analysis: `Co-authorship`
   - Counting method: `Full counting`
   - Deselect: `Ignore documents with a large number of authors`
5. Set “Minimum number of documents of an author” to `1`
6. Leave default on number of authors
7. When prompted about unconnected items, click `No`
8. Switch to the **Analysis** tab:
   - Set `Clustering Resolution` to `0.03` → click `Update Clustering`
   - Set `Normalization Method` to `No normalization` → click `Update Layout`
9. Go to `File` → `Save` → choose `*.csv` to export:
   - `map_file.csv`
   - `network_file.csv`

## Creating figures for publication

To prepare the figure used in the paper:

1. On the right panel:
   - Visualization → Set `Scale` to `2`, `Weights` to `Documents`
   - Labels → Set `Size variation` to `0`, `Max. length` to `0` (removes names)
   - Lines → `Size variation` to `0`, `Max. lines` to `10000`
   - Colors → Set the desired RGB values for each cluster

2. On the left panel:
   - Go to `File` → `Screenshot` → Save the image (e.g. as PNG or PDF)

## Output files and usage

- The `.ris` files are the raw inputs primarily from EPPI-Reviewer
- The `.csv` files define the network layout and links
- Full author names and clusters are listed in the supplementary material

## Summary

This folder enables reconstruction and exploration of the co-authorship network using *VOSviewer*, with clear steps to reproduce or adapt the network visualization.
