# Library ----
pacman::p_load(tidyverse)

# Data ----
ibge_data <- read.csv('Data/ibgecensoagro_rendimentomedio_data.csv',
                      sep = ';') %>% 
  glimpse()

prod_data <- ibge_data %>%
  rename('Unity' = unidade,
         'Coffee' = cafe_total,
         'Arabica' = cafe_arabica,
         'Robusta' = cafe_cenephora,
         'Orange' = laranja,
         'Soy' = soja,
         'Year' = ano) %>% 
  mutate(Level = NA) %>% 
  mutate(Level = case_when(Unity == 'Brasil' ~ 'Country',
                           Unity %in% c('Centro-Oeste', 'Nordeste', 'Norte', 
                                        'Sudeste', 'Sul') ~ 'Region',
                           Unity %in% c('Acre', 'Alagoas', 'Amapa', 'Amazonas', 
                                        'Bahia', 'Ceara', 'Distrito_Federal', 
                                        'Espirito_Santo', 'Goias', 'Maranhao', 
                                        'Mato_Grosso', 'Mato_Grosso_do_Sul', 
                                        'Minas_Gerais', 'Para', 'Paraiba', 
                                        'Parana', 'Pernambuco', 'Piaui', 
                                        'Rio_de_Janeiro', 'Rio_Grande_do_Norte', 
                                        'Rio_Grande_do_Sul', 'Rondonia', 'Roraima', 
                                        'Santa_Catarina', 'Sao_Paulo', 'Sergipe', 
                                        'Tocantins') ~ 'State')) %>% 
  mutate(Level = replace_na(Level, 'Municipality')) %>% 
  filter(Level == 'Municipality' & Year == 2022) %>% 
  mutate(State = str_sub(Unity, start = -2),
         Municipality = str_sub(Unity, end = -4),
         Year = as.character(Year)) %>% 
  filter(!is.na(Coffee) 
         | !is.na(Arabica) 
         | !is.na(Robusta) 
         | !is.na(Orange) 
         | !is.na(Soy)) %>% 
  select(Municipality, State, Coffee, Arabica, Robusta, Orange, Soy) %>% 
  mutate(Coffee = Coffee / 1000,
         Arabica = Arabica / 1000,
         Robusta = Robusta / 1000,
         Orange = Orange / 1000,
         Soy = Soy / 1000) %>% 
  arrange(Municipality) %>% 
  glimpse()

save.image('environment_LandscapeProductivity.RData')