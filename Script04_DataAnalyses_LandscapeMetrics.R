# Library ----
pacman::p_load(doParallel,
               foreach,
               landscapemetrics, 
               terra, 
               tidyterra, 
               tidyverse)



# Rasters ----
mapb_path <- 'X:/RDirectory/DSBD/LandscapeProductivity/Geo/Clipped'

mapb_clps <- list.files(mapb_path, 
                        pattern = '\\.tif$', 
                        full.names = TRUE)

mapb_rast <- list()

for (muni_clip in mapb_clps) {
  munic_prod <- rast(muni_clip)
  mapb_rast[[basename(muni_clip)]] <- munic_prod
}

check_landscape(mapb_rast[[42]])



# Landscape metrics ----
land_metr <- c('lsm_l_ai',
               'lsm_l_area_mn',
               'lsm_l_cai_mn',
               'lsm_l_circle_mn',
               'lsm_l_cohesion',
               'lsm_l_condent',
               'lsm_l_contag',
               'lsm_l_contig_mn',
               'lsm_l_core_mn',
               'lsm_l_dcad',
               'lsm_l_dcore_mn',
               'lsm_l_division',
               'lsm_l_ed',
               'lsm_l_enn_mn',
               'lsm_l_ent',
               'lsm_l_frac_mn',
               # 'lsm_l_gyrate_mn', # metric with error Error in names(object) <- nm : 
               # atributo 'names' [3] deve ter o mesmo comprimento que o vetor [2]
               'lsm_l_iji',
               'lsm_l_joinent',
               'lsm_l_lpi',
               'lsm_l_lsi',
               'lsm_l_mesh',
               'lsm_l_msidi',
               'lsm_l_msiei',
               'lsm_l_mutinf',
               'lsm_l_ndca',
               'lsm_l_np',
               'lsm_l_pafrac',
               'lsm_l_para_mn',
               'lsm_l_pd',
               'lsm_l_pladj',
               'lsm_l_pr',
               'lsm_l_prd',
               'lsm_l_relmutinf',
               'lsm_l_rpr',
               'lsm_l_shape_mn',
               'lsm_l_shdi',
               'lsm_l_shei',
               'lsm_l_sidi',
               'lsm_l_siei',
               'lsm_l_split',
               'lsm_l_ta',
               'lsm_l_tca',
               'lsm_l_te')



# Geoprocessing ----
lmet_land <- calculate_lsm(landscape = mapb_rast,
                           directions = 8,
                           edge_depth = 1,
                           neighbourhood = 8,
                           classes_max = 62,
                           what = land_metr,
                           progress = T,
                           verbose = T,
                           full_name = F)

str(lmet_land)



# Saving environment ----
save.image('environment_LandscapeProductivity.RData')
