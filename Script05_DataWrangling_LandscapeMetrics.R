# Library ----
pacman::p_load(tidyverse)

# Data ----
str(lmet_land)

str(mapb_clps)

# Wrangling ----

# Base
mapb_file <- mapb_clps %>%
  as_tibble() %>%
  mutate(layer = row_number()) %>% 
  rename('path' = value) %>% 
  glimpse()

# Join 
lmet_path <- lmet_land %>%
  inner_join(mapb_file, by = 'layer') %>% 
  select(layer, path, metric, value) %>% 
  mutate(CD_MUN = str_extract(path, "(?<=MUN_)\\d{7}(?=\\.tif)")) %>% 
  select(layer, CD_MUN, metric, value, path) %>%
  mutate(value = format(value, scientific = FALSE),
         value = as.numeric(value),
         value = round(value, 3)) %>% 
  filter(metric != 'enn_mn') %>% 
  glimpse()

# Export ----
write_csv(lmet_path,
          file = 'Data/landscapemetrics_data.csv')

# Save ----
save.image('environment_LandscapeProductivity.RData')
