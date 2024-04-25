# Library ----
pacman::p_load(terra, tidyterra, tidyverse)

# Data ----
bras_muni <- vect('Geo/BR_Municipios_2022.shp') %>% 
  glimpse()

bras_muni_df <- as.data.frame(bras_muni)

names(prod_data)[names(arab_data) == "Code"] <- "CD_MUN"

merged_data <- merge(bras_muni, arab_data, by = "CD_MUN")

class(merged_data)

#plot(merged_data, col = merged_data$Arabica)

glimpse(merged_data)

save.image('environment_LandscapeProductivity.RData')
