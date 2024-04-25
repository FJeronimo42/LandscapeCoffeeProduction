# Library ----
pacman::p_load(tidyverse, usdm)

# Data ----
vifs_lmet <- lmet_data %>% 
  select(-c(layer, CD_MUN, path)) %>% 
  glimpse()
   
   
   
# VIF test ----
vifs_matr <- vifstep(as.data.frame(vifs_lmet),
                     th = 10)

vifs_matr
 


# VIF filtering ---
vifs_ncor <- vifcor(as.data.frame(vifs_lmet), 
              th = 0.75)
vifs_ncor
 
lmet_filt <- exclude(lmet_data, 
                     vif = vifs_matr)

glimpse(lmet_filt)

# Export ----
write_csv(lmet_filt,
          file = 'Data/landscapemetrics_data_viffiltered.csv')

# Save ----
save.image('environment_LandscapeProductivity.RData')
