library(rgdal)
library(leaflet)
library(leaflet.extras)
library(htmltools)
library(tigris)
library(htmlwidgets)
library(dplyr)

r16 <- read.csv("2016 results by precinct.csv")

p16 <- readOGR(
  dsn = "Precinct_2016/PRECINCT_REDISTRICTING_region.shp",
  layer = "PRECINCT_REDISTRICTING_region"
)

m16 <- geo_join(
  spatial_data = readOGR(
    dsn = "Precinct_2016/PRECINCT_REDISTRICTING_region.shp",
    layer = "PRECINCT_REDISTRICTING_region"
  ),
  data_frame = read.csv("2016 results by precinct.csv"),
  by_sp = "PRECINCT",
  by_df = "Precinct",
  how = "inner"
)

label16 <- sprintf(
  fmt = "<strong>Precinct %s</strong><br>
        Hillary Clinton: %g (%g%%) <br>
        Donald Trump: %g (%g%%) <br>",
  m16$Precinct, m16$Hillary.Rodham.Clinton, m16$Percent.Clinton, m16$Donald.J..Trump, m16$Percent.Trump
) %>% lapply(htmltools::HTML)

leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addPolygons(
    data = m16,
    group = "2016",
    label = label16
  ) %>%
  addSearchFeatures( # Search help: https://rdrr.io/cran/leaflet.extras/src/inst/examples/search.R
    targetGroups = "2016",
    options = searchFeaturesOptions(
      textPlaceholder = "Search precinct"
    )
  )