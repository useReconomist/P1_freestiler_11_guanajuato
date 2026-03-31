library(sf)
library(freestiler)
library(tidyverse)

nc <- st_transform(
  st_read("C:/Users/osorion1759/OneDrive - ARCADIS/Proyectos/Datos/MARCO_GEOESTADISTICO_2020/mg_2020_integrado/conjunto_de_datos/00mun.shp"),
  crs=4326
  ) %>% 
  filter(CVE_ENT==11)


nc_agebs <- st_transform(
  st_read("C:/Users/osorion1759/OneDrive - ARCADIS/Proyectos/Datos/MARCO_GEOESTADISTICO_2020/mg_2020_integrado/conjunto_de_datos/00a.shp"),
  crs=4326
) %>% 
  filter(CVE_ENT==11)

# Crea los tiles
freestile(nc, "nc_counties.pmtiles", layer_name = "CVEGEO",simplification = TRUE,generate_ids = TRUE)
freestile(nc_agebs, "nc_agebs.pmtiles", layer_name = "CVEGEO",simplification = FALSE,generate_ids = TRUE)



maplibre(
  center = c(-101, 20.8),
  zoom = 7
) |>
  add_pmtiles_source(
    id = "agebs-src",
    url = "https://usereconomist.github.io/P1_freestiler_11_guanajuato/nc_agebs.pmtiles",
    promote_id = "CVEGEO"
  ) |>
  add_fill_layer(
    id = "agebs-fill",
    source = "agebs-src",
    source_layer = "CVEGEO",
    fill_color = "navy",
    fill_opacity = 0.5,
    hover_options = list(
      fill_color = "#00bfff",
      fill_opacity = 0.9
    ),
    tooltip = "CVEGEO"
  ) |>
  add_pmtiles_source(
    id = "counties-src",
    url = "https://usereconomist.github.io/P1_freestiler_11_guanajuato/nc_counties.pmtiles",
    promote_id = "NOMGEO"
  ) |>
  add_fill_layer(
    id = "counties-fill",
    source = "counties-src",
    source_layer = "CVEGEO",
    fill_color = "transparent",
    fill_opacity = 0
  ) |>
  add_line_layer(
    id = "counties-line",
    source = "counties-src",
    source_layer = "CVEGEO",
    line_color = "red",
    line_width = 1.5
  ) %>% 
  add_globe_minimap()
