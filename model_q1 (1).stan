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