//model_code_posterior_q1
data {
  int<lower=0> N;
  vector[N] Gender;
  vector[N] Depression;
}
parameters {
  real alpha;
  real beta_gender;
  real<lower=0> sigma;
}
model {
  alpha ~ normal(0, 10);
  beta_gender ~ normal(5, 2);
  sigma ~ normal(0, 5);
  Depression ~ normal(alpha + beta_gender * Gender, sigma);
}
generated quantities {
  vector[N] y_rep;
  for (n in 1:N)
    y_rep[n] = normal_rng(alpha + beta_gender * Gender[n], sigma);
}

