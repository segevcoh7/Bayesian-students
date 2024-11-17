// model_q3_1
data {
  int<lower=0> N;
  vector[N] Depression_Value;
  vector[N] Age;
  vector[N] CGPA;
  vector[N] Year;
}
parameters {
  real B0;
  real B_Age;
  real B_CGPA;
  real B_Year;
  real<lower=0> sigma;
}
model {
  target += normal_lpdf(B0 | 10, 3);
  target += normal_lpdf(B_Age | 5, 2);
  target += normal_lpdf(B_CGPA | -5, 2);
  target += normal_lpdf(B_Year | 5, 2);
  target += exponential_lpdf(sigma | 1);

  target += normal_lpdf(Depression_Value | B0 + B_Age * Age + B_CGPA * CGPA + B_Year * Year, sigma);
}
generated quantities {
  vector[N] log_lik;
  vector[N] y_rep;
  for (n in 1:N) {
    real mu = B0 + B_Age * Age[n] + B_CGPA * CGPA[n] + B_Year * Year[n];
    log_lik[n] = normal_lpdf(Depression_Value[n] | mu, sigma);
    y_rep[n] = normal_rng(mu, sigma);
  }
}

