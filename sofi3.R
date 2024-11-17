
packages <- c("rstan", "loo", "bridgesampling", "bayesplot", "ggplot2", "dplyr")
installed_packages <- packages %in% rownames(installed.packages())
if (any(!installed_packages)) {
  install.packages(packages[!installed_packages])
}
lapply(packages, library, character.only = TRUE)

# Load the data
data_univ <- read.csv("C:/Users/User/Desktop/עבודה מסכמת/Raw Data.csv")

# Data cleaning and renaming columns
data_univ <- data_univ %>%
  rename(Age = X1..Age,
         Gender = X2..Gender,
         University = X3..University,
         Department = X4..Department,
         Academic_Year = X5..Academic.Year,
         CGPA = X6..Current.CGPA,
         Scholarship = X7..Did.you.receive.a.waiver.or.scholarship.at.your.university.,
         Anxiety_Value = Anxiety.Value,
         Stress_Value = Stress.Value,
         Depression_Value = Depression.Value) %>%
  filter(Gender %in% c("Female", "Male"))

# Transformation and scaling
data_univ <- data_univ %>%
  mutate(Engineer = ifelse(trimws(Department) == "Engineering", 1, 0),
         Senior = ifelse(Academic_Year >= 3, 1, 0),
         CGPA = case_when(CGPA == 'Below 2.50' ~ 2.25,
                          CGPA == '2.50 - 2.99' ~ 2.75,
                          CGPA == '3.00 - 3.39' ~ 3.195,
                          CGPA == '3.40 - 3.79' ~ 3.595,
                          CGPA == '3.80 - 4.00' ~ 3.9,
                          TRUE ~ NA_real_),
         Age = case_when(Age == 'Below 18' ~ 17,
                         Age == '18-22' ~ 20,
                         Age == '23-26' ~ 24.5,
                         Age == '27-30' ~ 28.5,
                         Age == 'Above 30' ~ 35,
                         TRUE ~ NA_real_),
         Year = case_when(Academic_Year == '1' ~ 1,
                          Academic_Year == '2' ~ 2,
                          Academic_Year == '3' ~ 3,
                          Academic_Year == '4' ~ 4,
                          Academic_Year == 'Other' ~ 4,
                          TRUE ~ NA_real_)) %>%
  mutate(CGPA = scale(CGPA),
         Age = as.vector(scale(Age)),
         Year = as.vector(scale(Year))) %>%
  na.omit()

# Q1: Prepare data for Stan
stan_data_q1 <- list(N = nrow(data_univ),
                     Gender = as.integer(ifelse(data_univ$Gender == "Female", 1, 0)),
                     Depression = as.numeric(data_univ$Depression_Value))
# MCMC
fit_q1 <- stan(file = "C:/Users/User/Desktop/עבודה מסכמת/model_q1.stan", data = stan_data_q1, iter = 2000, chains = 4)

print(fit_q1)

# Posterior distribution plot 
posterior_array_q1 <- as.array(fit_q1)
mcmc_areas(posterior_array_q1, pars = "beta_gender") +
  ggtitle("Posterior Distribution of the Gender Coefficient")

# Hypothesis testing for beta_gender 
posterior_samples_q1 <- extract(fit_q1)
beta_gender_samples_q1 <- posterior_samples_q1$beta_gender
p_value_q1 <- 2 * min(mean(beta_gender_samples_q1 > 0), mean(beta_gender_samples_q1 < 0))
print(paste("P-value: ", p_value_q1))

mean_beta_q1 <- mean(beta_gender_samples_q1)
sd_beta_q1 <- sd(beta_gender_samples_q1)
ci_beta_q1 <- quantile(beta_gender_samples_q1, probs = c(0.025, 0.975))

cat("Mean of beta_gender: ", mean_beta_q1, "\n")
cat("Standard deviation of beta_gender: ", sd_beta_q1, "\n")
cat("95% Credible Interval of beta_gender: [", ci_beta_q1[1], ", ", ci_beta_q1[2], "]\n")

# EES and R-hat 
summary_fit_q1 <- summary(fit_q1)
ees_values_q1 <- summary_fit_q1$summary[,"n_eff"]
rhat_values_q1 <- summary_fit_q1$summary[,"Rhat"]
print(ees_values_q1)
print(rhat_values_q1)

# Posterior predictive check 
fit_posterior_q1 <- stan(file = "C:/Users/User/Desktop/עבודה מסכמת/posterior_model.stan", data = stan_data_q1, iter = 2000, chains = 4)

posterior_posterior_q1 <- extract(fit_posterior_q1)
y_rep_posterior_q1 <- posterior_posterior_q1$y_rep

y_numeric_q1 <- as.numeric(data_univ$Depression_Value)

ppc_dens_overlay(y = y_numeric_q1, yrep = y_rep_posterior_q1) +
  ggtitle("Posterior Predictive Check")


# Q2: Prepare data for Stan
stan_data_q2 <- list(N = nrow(data_univ),
                     Age = as.vector(data_univ$Age),
                     Engineer = as.vector(data_univ$Engineer),
                     Senior = as.vector(data_univ$Senior),
                     Stress = as.vector(data_univ$Stress_Value),
                     Anxiety = as.vector(data_univ$Anxiety_Value))

# MCMC 
fit_q2 <- stan(file = "C:/Users/User/Desktop/עבודה מסכמת/model_q2.stan", data = stan_data_q2, iter = 2000, chains = 4)

print(fit_q2)

# Posterior predictive checks 
posterior_samples_q2 <- extract(fit_q2)
y_rep_stress_q2 <- posterior_samples_q2$y_rep_stress
y_rep_anxiety_q2 <- posterior_samples_q2$y_rep_anxiety



# Posterior Predictive Distribution Stress
ppc_intervals(y = stan_data_q2$Stress, yrep = y_rep_stress_q2) +
  ggtitle("Posterior Predictive Distribution for Stress (Q2)") +
  xlab("Observation") + ylab("Stress Value")

# Posterior Predictive Distribution Anxiety
ppc_intervals(y = stan_data_q2$Anxiety, yrep = y_rep_anxiety_q2) +
  ggtitle("Posterior Predictive Distribution for Anxiety (Q2)") +
  xlab("Observation") + ylab("Anxiety Value")

# Summary and diagnostics 
summary_fit_q2 <- summary(fit_q2)
print(summary_fit_q2)
ees_values_q2 <- mean(summary_fit_q2$summary[,"n_eff"])
rhat_values_q2 <- mean(summary_fit_q2$summary[,"Rhat"])

#R-hat
cat("Rhat values Q2:", rhat_values_q2, "\n")
#EES
cat("EES Q2:",ees_values_q2, "\n")




# Q3: Prepare data for Stan
stan_data_q3_1 <- list(N = nrow(data_univ),
                       Depression_Value = as.vector(data_univ$Depression_Value),
                       Age = as.vector(data_univ$Age),
                       CGPA = as.vector(data_univ$CGPA),
                       Year = as.vector(data_univ$Year))

stan_data_q3_2 <- list(N = nrow(data_univ),
                       Depression_Value = as.vector(data_univ$Depression_Value),
                       Age = as.vector(data_univ$Age),
                       CGPA = as.vector(data_univ$CGPA),
                       Year = as.vector(data_univ$Year),
                       Anxiety_Value = as.vector(data_univ$Anxiety_Value),
                       Stress_Value = as.vector(data_univ$Stress_Value))
#MCMC
fit_q3_1 <- stan(file = "C:/Users/User/Desktop/עבודה מסכמת/model_q3_1.stan", data = stan_data_q3_1, iter = 2000, chains = 4,seed = 1234 ,model_name = "model_q3_1")
fit_q3_2 <- stan(file = "C:/Users/User/Desktop/עבודה מסכמת/model_q3_2.stan", data = stan_data_q3_2, iter = 2000, chains = 4, seed = 1234 , model_name = "model_q3_2")

# Model comparison using LOO
log_lik_q3_1 <- extract_log_lik(fit_q3_1, parameter_name = "log_lik")
log_lik_q3_2 <- extract_log_lik(fit_q3_2, parameter_name = "log_lik")

loo_q3_1 <- loo(log_lik_q3_1)
loo_q3_2 <- loo(log_lik_q3_2)

loo_comparison_q3 <- loo_compare(loo_q3_1, loo_q3_2)

print(loo_comparison_q3)

# Posterior Predictive Checks
y_rep_q3_1 <- as.matrix(fit_q3_1, pars = "y_rep")
y_rep_q3_2 <- as.matrix(fit_q3_2, pars = "y_rep")

# Density overlay plot for Model 1 
ppc_dens_overlay(y = data_univ$Depression_Value, yrep = y_rep_q3_1) +
  ggtitle("Posterior Predictive Check: Model 1 (Q3)") +
  xlab("Depression Value") +
  ylab("Density") +
  theme_minimal()

# Density overlay plot for Model 2
ppc_dens_overlay(y = data_univ$Depression_Value, yrep = y_rep_q3_2) +
  ggtitle("Posterior Predictive Check: Model 2 (Q3)") +
  xlab("Depression Value") +
  ylab("Density") +
  theme_minimal()

# Compare the mean of y and y_rep for Model 1 
ppc_stat(y = data_univ$Depression_Value, yrep = y_rep_q3_1, stat = "mean") +
  ggtitle("Posterior Predictive Mean Comparison: Model 1 (Q3)") +
  xlab("Mean of Depression Value") +
  ylab("Frequency") +
  theme_minimal()

# Compare the mean of y and y_rep for Model 2 
ppc_stat(y = data_univ$Depression_Value, yrep = y_rep_q3_2, stat = "mean") +
  ggtitle("Posterior Predictive Mean Comparison: Model 2 (Q3)") +
  xlab("Mean of Depression Value") +
  ylab("Frequency") +
  theme_minimal()

# EES and R_hat
ees_q3_1 <- mean(summary(fit_q3_1)$summary[,"n_eff"])
ees_q3_2 <- mean(summary(fit_q3_2)$summary[,"n_eff"])

#EES1
cat("\n EES for Model 1 :",ees_q3_1,"\n")
#EES2
cat("\n EES for Model 2",ees_q3_2,":\n")


rhat_q3_1 <- mean(summary(fit_q3_1)$summary[,"Rhat"])
rhat_q3_2 <- mean(summary(fit_q3_2)$summary[,"Rhat"])
#R-hat1
cat("\n Rhat for Model 1:",rhat_q3_1,"\n")
#R_hat2
cat("\n Rhat for Model 2:",rhat_q3_2,"\n")

