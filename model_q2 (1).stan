// model_q2
data {
  int<lower=0> N;
  vector[N] Age;
  vector[N] Engineer;
  vector[N] Senior;
  vector[N] Stress;
  vector[N] Anxiety;
}
parameters {
  real alpha_stress;
  real beta_age_stress;
  real beta_engineer_stress;
  real beta_senior_stress;
  real<lower=0> sigma_stress;
 
  real alpha_anxiety;
  real beta_age_anxiety;
  real beta_engineer_anxiety;
  real beta_senior_anxiety;
  real<lower=0> sigma_anxiety;
}
model {
  alpha_stress ~ normal(0, 10);
  beta_age_stress ~ normal(-5, 2);
  beta_engineer_stress ~ normal(5, 2);
  beta_senior_stress ~ normal(5, 2);
  sigma_stress ~ normal(0, 5);

  alpha_anxiety ~ normal(0, 10);
  beta_age_anxiety ~ normal(-5, 2);
  beta_engineer_anxiety ~ normal(5, 2);
  beta_senior_anxiety ~ normal(5, 2);
  sigma_anxiety ~ normal(0, 5);

  Stress ~ normal(alpha_stress + beta_age_stress * Age +
                  beta_engineer_stress * Engineer +
                  beta_senior_stress * Senior, sigma_stress);

  Anxiety ~ normal(alpha_anxiety + beta_age_anxiety * Age +
                   beta_engineer_anxiety * Engineer +
                   beta_senior_anxiety * Senior, sigma_anxiety);
}
generated quantities {
  vector[N] y_rep_stress;
  vector[N] y_rep_anxiety;
  for (n in 1:N) {
    y_rep_stress[n] = normal_rng(alpha_stress + beta_age_stress * Age[n] +
                                 beta_engineer_stress * Engineer[n] +
                                 beta_senior_stress * Senior[n], sigma_stress);
    y_rep_anxiety[n] = normal_rng(alpha_anxiety + beta_age_anxiety * Age[n] +
                                  beta_engineer_anxiety * Engineer[n] +
                                  beta_senior_anxiety * Senior[n], sigma_anxiety);
  }
}



