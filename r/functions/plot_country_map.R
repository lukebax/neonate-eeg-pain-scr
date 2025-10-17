# Load required libraries
library(ggplot2)          # For visualization
library(dplyr)            # For data manipulation
library(rnaturalearth)    # Provides world map data
library(rnaturalearthdata) # Supplementary world map dataset
library(sf)               # Simple Features for spatial ops (centroids/points)

# Function to generate a world map showing the distribution of studies by country
# and add ISO 2-letter country codes as labels for represented countries
plot_country_map <- function(country_count_table, output_file) {
  # Load world map data and remove Antarctica
  world <- ne_countries(scale = "medium", returnclass = "sf") %>%
    dplyr::filter(name != "Antarctica")
  
  # Standardize country names in the input table to lowercase for matching
  country_count_table <- country_count_table %>%
    dplyr::rename(name = Category) %>%
    dplyr::mutate(name = tolower(name)) %>%
    dplyr::filter(!is.na(name))  # Remove any NA values before merging
  
  # Standardize country names in the world map dataset
  world <- world %>%
    dplyr::mutate(name = tolower(name))
  
  # Merge study count data with world map data
  world_data <- dplyr::left_join(world, country_count_table, by = "name")
  
  # Replace missing values (countries with no recorded studies) with zero
  world_data$Count[is.na(world_data$Count)] <- 0
  
  # If all counts are zero, generate a warning
  if (all(world_data$Count == 0)) {
    warning("Warning: No valid country study data found. The map will display only base geography.")
  }
  
  # Prepare label positions (only for represented countries)
  label_df <- world_data %>%
    dplyr::filter(Count > 0 & !is.na(iso_a2_eh) & iso_a2_eh != "-99")
  
  if (nrow(label_df) > 0) {
    pts <- sf::st_point_on_surface(label_df$geometry)
    coords <- sf::st_coordinates(pts)
    label_df$lon <- coords[, 1]
    label_df$lat <- coords[, 2]
    label_df_nogeo <- sf::st_set_geometry(label_df, NULL)
  } else {
    label_df_nogeo <- NULL
  }
  
  # Get the minimum and maximum study count values for color scaling
  min_count <- min(world_data$Count, na.rm = TRUE)
  max_count <- max(world_data$Count, na.rm = TRUE)
  
  # Create the world map plot
  plot <- ggplot(world_data) +
    geom_sf(aes(fill = Count), color = "white", size = 0.2) +  # Plot countries with fill based on Count
    scale_fill_gradientn(
      colors = c("#D3D3D3", "#D6EAF8", "#1B4F72"),  # Gradient from light to dark blue
      values = scales::rescale(c(0, 1, max(world_data$Count))),  # Rescale color mapping
      breaks = c(min_count, max_count),  # Define legend breaks
      labels = c(min_count, max_count),  # Label legend values
      guide = guide_colourbar(barwidth = 0.3, barheight = 2, title = NULL)  # Customize legend appearance
    ) +
    theme_minimal(base_size = 12) +  # Use minimal theme with base font size
    theme(
      legend.position = "right",  # Position legend to the right
      legend.justification = c(1, 0.5),  # Adjust legend alignment
      legend.text = element_text(size = 7),  # Adjust legend text size
      legend.title = element_blank(),  # Remove legend title
      axis.text = element_blank(),  # Remove axis text
      axis.title = element_blank(),      # Remove axis titles ("lat"/"lon")
      axis.ticks = element_blank(),  # Remove axis ticks
      panel.background = element_rect(fill = "white", color = NA),  # Set panel background to white
      plot.background = element_rect(fill = "white", color = NA),  # Set plot background to white
      panel.grid = element_blank()  # Remove panel grid lines
    )
  
  # Add ISO labels
  if (!is.null(label_df_nogeo) && nrow(label_df_nogeo) > 0) {
    plot <- plot +
      geom_text(
        data = label_df_nogeo,
        aes(x = lon, y = lat, label = iso_a2_eh),
        size = 1.5,
        fontface = "plain",
        check_overlap = TRUE
      )
  }
  
  # Display the plot
  print(plot)
  
  # Save the plot to the specified output file
  ggsave(output_file, plot = plot, width = 6, height = 4)
}
