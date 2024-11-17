# Bayesian Analysis of Stress, Anxiety, and Depression Among Bangladeshi University Students

## 📘 Project Overview

This project investigates the relationship between demographic and academic characteristics of students and their levels of stress, anxiety, and depression. Using advanced Bayesian statistical models, the analysis provides insights into how variables such as gender, age, academic year, and CGPA influence mental health among university students in Bangladesh. The dataset was sourced from a mental health survey conducted among students from multiple universities in Bangladesh.

---

## 🔍 Key Research Questions

1. **Gender and Depression**: Is there a significant relationship between gender and depression levels?
2. **Demographic and Academic Factors**: How do age, engineering discipline, and academic year impact stress and anxiety levels?
3. **Enhanced Prediction Models**: Does adding stress and anxiety metrics to demographic and academic variables improve predictions of depression levels?

---

## 📂 Repository Structure


---

## 📊 Methods and Approach

### **Data Source**
- Dataset: [`Raw Data.csv`](Raw%20Data.csv)
- Variables include:
  - Demographic: Gender, Age
  - Academic: University, Academic Year, CGPA
  - Mental health metrics: Stress, Anxiety, Depression

### **Bayesian Models**
1. **Question 1**: [`model_q1 (1).stan`](model_q1%20(1).stan) examines the relationship between gender and depression levels.
2. **Question 2**: [`model_q2 (1).stan`](model_q2%20(1).stan) assesses the impact of age, engineering discipline, and academic year on stress and anxiety levels.
3. **Question 3**:
   - Baseline: [`model_q3_1 (1).stan`](model_q3_1%20(1).stan) predicts depression using demographic and academic factors.
   - Enhanced: [`model_q3_2 (1).stan`](model_q3_2%20(1).stan) includes stress and anxiety metrics.

### **Posterior Distributions and Checks**
- Posterior model: [`posterior_model (1).stan`](posterior_model%20(1).stan)
- Conducted posterior predictive checks to evaluate model fit and assess robustness.

---

## 📈 Visualizations

- **Stress by University**: Average stress levels across different universities.
- **Stress by Gender and Age**: Tree map showing stress distribution among gender and age groups.
- **Stress to CGPA Relationship**: Visualizing stress levels by academic performance (CGPA).
- **Depression by Gender**: Comparison of depression levels among male and female students.

**Dashboard Visualization**:
![Dashboard](Students%20in%20bangaladash%20dashboared%20tabluea.png)

---

## 🛠 Tools and Technologies

- **Programming**: R, Python
- **Statistical Modeling**: Bayesian inference with Stan
- **Visualization**: Tableau, Matplotlib
- **Posterior Analysis**: MCMC simulations and predictive checks

---

## 📋 Key Findings

### **Question 1: Gender and Depression**
- Women reported significantly higher levels of depression compared to men.
- The Bayesian model showed a strong positive coefficient for gender as a predictor of depression.

### **Question 2: Demographics and Stress/Anxiety**
- Older students experienced lower stress and anxiety levels.
- Engineering students reported slightly lower anxiety but higher stress levels.
- Students in advanced academic years exhibited elevated stress and anxiety.

### **Question 3: Enhanced Prediction of Depression**
- Adding stress and anxiety metrics improved depression prediction significantly.
- Enhanced model had better posterior predictive accuracy and fit compared to the baseline model.

---

## 🚀 How to Run

### Prerequisites
1. Install R and required libraries for Bayesian analysis (`rstan`, `ggplot2`, etc.).
2. Install Python and relevant libraries (`pandas`, `matplotlib`, etc.).

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/Bayesian-Mental-Health-Analysis.git


Rscript sofi3.R


### How to Use:
1. Replace `your-username` in the `git clone` command with your GitHub username.
2. Update `[segev777701@gmail.com]` with your actual contact email.
3. Add additional details or findings to the `README.md` as the project evolves.

Let me know if you need further modifications or assistance! 😊
