library(sf)
library(dplyr)
library(DatawRappr)
library(dotenv)
library(lubridate)


#EATON
# Load  GeoJSON from URL
eaton_url <- "https://services1.arcgis.com/jUJYIo9tSA7EHvfZ/arcgis/rest/services/DINS_2025_Eaton_Public_View/FeatureServer/0/query?where=0%3D0&objectIds=&geometry=&geometryType=esriGeometryPolygon&inSR=&spatialRel=esriSpatialRelIntersects&resultType=none&distance=0.0&units=esriSRUnit_Meter&relationParam=&returnGeodetic=false&outFields=*&returnGeometry=true&featureEncoding=esriDefault&multipatchOption=xyFootprint&maxAllowableOffset=&geometryPrecision=&outSR=&defaultSR=&datumTransformation=&applyVCSProjection=false&returnIdsOnly=false&returnUniqueIdsOnly=false&returnCountOnly=false&returnExtentOnly=false&returnQueryGeometry=false&returnDistinctValues=false&cacheHint=false&collation=&orderByFields=&groupByFieldsForStatistics=&outStatistics=&having=&resultOffset=&resultRecordCount=&returnZ=false&returnM=false&returnTrueCurves=false&returnExceededLimitFeatures=true&quantizationParameters=&sqlFormat=none&f=pgeojson&token="
eaton <- st_read(eaton_url)

# Split by the 'damage' attribute
split_eaton <- eaton %>%
  group_by(DAMAGE) %>%
  group_split()

# Export each split layer to a separate GeoJSON file
lapply(seq_along(split_eaton), function(i) {
  damage_name <- unique(split_eaton[[i]]$DAMAGE)  # Get the unique damage name
  sanitized_name <- gsub("[^[:alnum:]_]", "_", damage_name)  # Replace non-alphanumeric characters with underscores
  st_write(
    split_eaton[[i]], 
    paste0("output/eaton/", sanitized_name, "_damage.geojson"),
    delete_dsn = TRUE,  # Ensures the file is overwritten
    quiet = TRUE        # Suppresses messages
  )
})

# PALISADES
# Load  GeoJSON from URL
palisades_url <- "https://services1.arcgis.com/jUJYIo9tSA7EHvfZ/arcgis/rest/services/DINS_2025_Palisades_Public_View/FeatureServer/0/query?where=0%3D0&objectIds=&geometry=&geometryType=esriGeometryPolygon&inSR=&spatialRel=esriSpatialRelIntersects&resultType=none&distance=0.0&units=esriSRUnit_Meter&relationParam=&returnGeodetic=false&outFields=*&returnGeometry=true&featureEncoding=esriDefault&multipatchOption=xyFootprint&maxAllowableOffset=&geometryPrecision=&outSR=&defaultSR=&datumTransformation=&applyVCSProjection=false&returnIdsOnly=false&returnUniqueIdsOnly=false&returnCountOnly=false&returnExtentOnly=false&returnQueryGeometry=false&returnDistinctValues=false&cacheHint=false&collation=&orderByFields=&groupByFieldsForStatistics=&outStatistics=&having=&resultOffset=&resultRecordCount=&returnZ=false&returnM=false&returnTrueCurves=false&returnExceededLimitFeatures=true&quantizationParameters=&sqlFormat=none&f=pgeojson&token="
palisades <- st_read(palisades_url)

# Split by the 'damage' attribute
split_palisades <- palisades %>%
  group_by(DAMAGE) %>%
  group_split()

# Export each split layer to a separate GeoJSON file
lapply(seq_along(split_palisades), function(i) {
  damage_name <- unique(split_palisades[[i]]$DAMAGE)  # Get the unique damage name
  sanitized_name <- gsub("[^[:alnum:]_]", "_", damage_name)  # Replace non-alphanumeric characters with underscores
  st_write(
    split_eaton[[i]], 
    paste0("output/eaton/", sanitized_name, "_damage.geojson"),
    delete_dsn = TRUE,  # Ensures the file is overwritten
    quiet = TRUE        # Suppresses messages
  )
})

# Checking each main file to make sure it changed
damage_summary_palisades <- palisades %>%
  group_by(DAMAGE) %>%
  summarize(count = n(), .groups = "drop")

damage_summary_eaton <- eaton %>%
  group_by(DAMAGE) %>%
  summarize(count = n(), .groups = "drop")
