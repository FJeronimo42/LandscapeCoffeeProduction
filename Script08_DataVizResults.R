# Library ----
pacman::p_load(cowplot, tidyverse)

# Data ----
perf_data <- rbind(glmr_perf, svms_perf, rand_perf, xgbb_perf, tree_perf) %>% 
  rename('Metric' = .metric,
         'Estimator' = .estimator,
         'Estimate' = .estimate,
         'Algorithm' = .algorithm) %>% 
  mutate(Algorithm = recode(Algorithm,
                            BT = 'Boost Tress',
                            DT = 'Decision Trees',
                            LR = 'Linear Regression',
                            RF = 'Random Forest',
                            SVM = 'Support Vector Machines')) %>% 
  select(-Estimator) %>% 
  pivot_wider(names_from = 'Metric', values_from = Estimate) %>% 
  glimpse()

# Performance plots 
perf_fig1 <- ggplot(data = perf_data,
       mapping = aes(x = reorder(Algorithm, (rmse)),
                     y = rmse,
                     fill = Algorithm))+
  geom_col()+
  geom_text(aes(label = round(rmse, digits = 3)), vjust = -0.25) + 
  scale_fill_viridis_d(option = 'viridis')+
  labs(x = '',
       y = 'RMSE')+
  theme_classic()+
  ylim(0, 0.75)+
  theme(legend.position = '',
        axis.title = element_text(size = 14, 
                                  face = 'bold'),
        axis.text = element_blank())

perf_fig1




perf_fig2 <- ggplot(data = perf_data,
       mapping = aes(x = reorder(Algorithm, desc(rsq)),
                     y = rsq,
                     fill = Algorithm))+
  geom_col()+
  geom_text(aes(label = round(rsq, digits = 3)), vjust = -0.25) + 
  scale_fill_viridis_d(option = 'viridis')+
  labs(x = '',
       y = 'R²')+
  theme_classic()+
  ylim(0, 0.75)+
  theme(legend.position = c(0.3, 0.75),
        axis.title = element_text(size = 14, 
                                  face = 'bold'),
        axis.text = element_blank())

perf_fig2 

perf_fig3 <- ggplot(data = perf_data,
       mapping = aes(x = reorder(Algorithm, (mae)),
                     y = mae,
                     fill = Algorithm))+
  geom_col()+
  geom_text(aes(label = round(mae, digits = 3)), vjust = -0.25) + 
  scale_fill_viridis_d(option = 'viridis')+
  labs(x = 'Algorithm',
       y = 'MAE')+
  theme_classic()+
  ylim(0, 0.75)+
  theme(legend.position = '',
        axis.title = element_text(size = 14, 
                                  face = 'bold'),
        axis.text = element_blank())

perf_fig3

perf_grid <- plot_grid(perf_fig2, perf_fig3, perf_fig1,
                       nrow = 1,
                       ncol = 3,
                       labels = c('a', 'b', 'c'))
perf_grid

ggsave(filename = 'results_ml_arabica.png',
       plot = perf_grid,
       width = 30,
       height = 10,
       units = c('cm'),
       dpi = 600)

# Prediction plots
pred_fig1 <- ggplot(data = rand_pred,
                    mapping = aes(x = Arabica,
                                  y = Predicted))+
  geom_point(color = 'forestgreen', 
             size = 3,
             alpha = 0.75)+
  geom_abline(intercept = 0, 
              slope = 1,
              color = 'black',
              linewidth = 1,
              linetype = 'dashed')+
  labs(x = 'Observed',
       y = 'Predicted')+
  lims(x = c(0, 4), 
       y = c(0, 4))+
  theme_classic()+
  theme(legend.position = '',
        axis.title = element_text(size = 14, 
                                  face = 'bold'))
  
pred_fig1

pred_fig2 <- ggplot(data = xgbb_pred,
                    mapping = aes(x = Arabica,
                                  y = Predicted))+
  geom_point(color = 'purple4', 
             size = 5,
             alpha = 0.75)+
  geom_abline(intercept = 0, 
              slope = 1,
              color = 'black',
              linewidth = 1,
              linetype = 'dashed')+
  labs(x = 'Observed',
       y = 'Predicted')+
  lims(x = c(0, 4), 
       y = c(0, 4))+
  theme_classic()+
  theme(legend.position = '',
        axis.title = element_text(size = 14, 
                                  face = 'bold'))

pred_fig2

pred_fig3 <- ggplot(data = tree_pred,
                    mapping = aes(x = Arabica,
                                  y = Predicted))+
  geom_point(color = 'steelblue3', 
             size = 5,
             alpha = 0.75)+
  geom_abline(intercept = 0, 
              slope = 1,
              color = 'black',
              linewidth = 1,
              linetype = 'dashed')+
  labs(x = 'Observed',
       y = 'Predicted')+
  lims(x = c(0, 4), 
       y = c(0, 4))+
  theme_classic()+
  theme(legend.position = '',
        axis.title = element_text(size = 14, 
                                  face = 'bold'))

pred_fig3

ggsave(filename = 'results_mlrf_arabica.png',
       plot = pred_fig1,
       width = 10,
       height = 10,
       units = c('cm'),
       dpi = 600)


# Save ----
save.image('environment_LandscapeProductivity.RData')
