# Library ----
pacman::p_load(tidyverse, tidymodels, yardstick)



# Data ----
glimpse(arab_data)

glimpse(lmet_filt)



# Data wrangling ----
quantile(arab_data$Arabica)

anls_data <- arab_data %>% 
  mutate(CD_MUN = as.character(CD_MUN),
         Code = as.character(Code)) %>%
  mutate(Level = case_when(Arabica >= 0.167 & Arabica < 1.000 ~ 'Low',
                           Arabica >= 1.000 & Arabica < 1.250 ~ 'Mid-Low',
                           Arabica >= 1.250 & Arabica < 1.571 ~ 'Mid-High',
                           Arabica >= 1.571 & Arabica <= 3.874 ~ 'High')) %>% 
  inner_join(lmet_filt, by = 'CD_MUN') %>% 
  select(Arabica, Level, 9:24) %>% 
  glimpse()


  
# Data split ----
set.seed(42)

splt_data <- initial_split(anls_data,
                           prop = 0.75,
                           strata = Level) %>% 
  glimpse()

# Training data
trai_data <- splt_data %>%
  training() %>% 
  select(-Level) %>% 
  glimpse()

# Test data
test_data <- splt_data %>%
  testing() %>% 
  select(-Level) %>% 
  glimpse()

# ML LR - Linear Regression ----
# Training
glmr_regr <- linear_reg() %>%
  set_engine('glm') %>%
  set_mode('regression') %>%
  fit(formula = Arabica ~ ., 
      data = trai_data)

# tidy(glmr_regr) %>% 
#   print(n = 50)
# 
# tidy(glmr_regr, 
#      exponentiate = TRUE) %>% 
#   print(n = 50)

# Test
glmr_pred <- predict(glmr_regr, 
                     test_data) %>%
  bind_cols(test_data) %>%
  rename(Predicted = .pred) %>% 
  glimpse()

# Performance
glmr_perf <- as.data.frame(metrics(glmr_pred, 
                                   truth = Arabica,
                                   estimate = Predicted)) %>% 
  mutate(.algorithm = 'LR') %>% 
  print()



# ML SVM - Support Vector Machine ----
# Training
require('kernlab')

svms_svms <- svm_poly() %>%
  set_engine('kernlab') %>%
  set_mode('regression') %>%
  fit(formula = Arabica ~ ., 
      data = trai_data)

# Test
svms_pred <- predict(svms_svms, 
                     test_data) %>%
  bind_cols(test_data) %>%
  rename(Predicted = .pred) %>% 
  glimpse()

# Performance
svms_perf <- as.data.frame(metrics(svms_pred, 
                                   truth = Arabica,
                                   estimate = Predicted)) %>% 
  mutate(.algorithm = 'SVM') %>% 
  print()

# ML RF - Random Forest ----
# Training
require('kknn')

rand_frst <- rand_forest() %>%
  set_engine('ranger') %>%
  set_mode('regression') %>%
  fit(formula = Arabica ~ ., 
      data = trai_data)

# Test
rand_pred <- predict(rand_frst, 
                     test_data) %>%
  bind_cols(test_data) %>%
  rename(Predicted = .pred) %>% 
  glimpse()

# Performance
rand_perf <- as.data.frame(metrics(rand_pred, 
                                   truth = Arabica,
                                   estimate = Predicted)) %>% 
  mutate(.algorithm = 'RF') %>% 
  print()

# ML XGB - X Gradient Boost Machine ----
# Training
require('xgboost')

xgbb_bost <- boost_tree() %>%
  set_engine('xgboost', verbose = FALSE) %>%
  set_mode('regression') %>%
  fit(formula = Arabica ~ ., 
      data = trai_data)

# Test
xgbb_pred <- predict(xgbb_bost, 
                    test_data) %>%
  bind_cols(test_data) %>%
  rename(Predicted = .pred) %>% 
  glimpse()

# Performance
xgbb_perf <- as.data.frame(metrics(xgbb_pred, 
                                   truth = Arabica,
                                   estimate = Predicted)) %>% 
  mutate(.algorithm = 'XGBM') %>% 
  print()


# ML DT  - Decision Trees ----
# Training
deci_tree <- decision_tree() %>%
  set_engine('rpart') %>%
  set_mode('regression') %>%
  fit(formula = Arabica ~ ., 
      data = trai_data)

# Test
tree_pred <- predict(deci_tree, 
                     test_data) %>%
  bind_cols(test_data) %>%
  rename(Predicted = .pred) %>% 
  glimpse()

# Performance
tree_perf <- as.data.frame(metrics(tree_pred, 
                                   truth = Arabica,
                                   estimate = Predicted)) %>% 
  mutate(.algorithm = 'DT') %>% 
  print()

# Save ----
save.image('environment_LandscapeProductivity.RData')
