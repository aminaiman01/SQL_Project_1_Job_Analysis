# Introduction

Dive into the data job market! Focusing on data analyst roles, this project explores & top-paying jobs, in-demand skills, and where high demand meets high salary in data analytics.
SQL queries? Check them out here: [PROJECT 1](/PROJECT%201/)


# Background
Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.

This data is packed with insights on job titles, salaries, locations, and essential skills.

### The questions I wanted to answer through my SQL queries were:
1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used

For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL:** The backbone of my analysis, enabling me to query the database and uncover critical insights.

- **PostgreSQL:** The database management system I used, well-suited for handling large volumes of job posting data.

- **Visual Studio Code:** My workspace for managing databases and executing SQL queries efficiently.

- **Git & GitHub:** Crucial for version control, sharing SQL scripts, and tracking the progress of my analysis.

- **Excel:** Used for data cleaning and visualization, including building tables and charts to highlight trends and insights clearly.

# The Analysis
Each query for this project aimed at investigating specific aspects of the job market. Here's how I approached each question:

### 1. Top Paying Data Analyst Jobs
Identify the top 10 highest-paying remote Data Analyst roles by filtering job postings with specified salaries, highlighting the most lucrative opportunities in the field.

---
```sql
SELECT
    job_id,
    company_dim.name AS company_name,
    job_title,
    job_title_short,
    job_location,
    job_country,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN 
    company_dim on company_dim.company_id=job_postings_fact.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
```
---
### 🔑 **Insights**

1. **Massive salary ranges –** The top-paying role (Data Analyst at Mantys, India) lists an average salary of $650,000/year, which is far above typical market rates. This could indicate executive-level data positions mislabeled as analyst roles or outliers in salary reporting.

2. **Geographic diversity –** High-paying roles aren’t limited to one region:

    - United States (e.g., Citigroup, Illuminate Mission Solutions)

    - Belarus (ЛАНИТ)

    - India (Mantys)

    This suggests lucrative opportunities for analysts exist globally, not just in the U.S.

3. **Seniority matters –** Many top roles are senior or specialized analyst positions (Sr Data Analyst, HC Data Analyst, Senior, Head of Infrastructure Management & Data Analytics), highlighting how job titles beyond "Data Analyst" often correspond to higher pay.

4. **Full-time dominance –** All top-paying positions are full-time, reinforcing that permanent contracts bring the best salaries in the data analytics space.

5. **Remote flexibility** – Some postings list "Anywhere" as the location, suggesting companies are open to global remote hires for top-paying roles.

![Top Paying Roles](<PROJECT 1/assets/QUERY 1.png>)
*Bar graph visualizing the salary for the top 10 salaries for data analyst; I made this graph using Excel from SQL query results.*


### 2. Top Paying Job Skills
Identify the specific skills required for the top 10 highest-paying Data Analyst roles to show which skills align with the most lucrative opportunities in the field.

---
```sql
WITH top_paying_jobs AS (

    SELECT
        job_id,
        company_dim.name AS company_name,
        job_title,
        job_title_short,
        salary_year_avg
    FROM
        job_postings_fact
    LEFT JOIN
        company_dim on company_dim.company_id=job_postings_fact.company_id
    WHERE
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT
        10000
)

    SELECT
        top_paying_jobs.*,
        skills_dim.skills
    FROM
        top_paying_jobs
    INNER JOIN
        skills_job_dim ON skills_job_dim.job_id=top_paying_jobs.job_id
    INNER JOIN
        skills_dim ON skills_dim.skill_id=skills_job_dim.skill_id
     ORDER BY
        salary_year_avg DESC
```

---
### 🔑 **Insights**
1. **SQL dominates –** Almost every top-paying role requires SQL, reinforcing it as a must-have skill.

2. **Programming languages vary –** Python, R, SAS, and even Go appear, showing that different industries value different coding stacks.

3. **Data visualization tools matter –** Tableau, Excel, and SharePoint show up, signaling that communicating insights is just as important as technical querying.

4. **Cloud & modern tech –** Skills like Snowflake and Kubernetes are listed, pointing to the growing overlap between analytics and data engineering.

5. **Specialization pays –** Roles like Lead Fraud Data Analyst and Sales Ops BI Data Architect demand niche tools (Oracle, Hadoop, BI platforms) — aligning with higher salaries.

![Top Skills](<PROJECT 1/assets/QUERY 2 (2).png>)
*This chart highlights the most in-demand skills among the top 10 highest-paying Data Analyst roles, with SQL emerging as the most consistently required skill, followed by Phyton and visualization tools like Tableau.*

### 3. Top Demanded Skills
Identify the top 5 most in-demand skills for Data Analysts across all job postings to reveal which skills are most valuable in the job market.

---
```sql
    SELECT
        skills,
        job_postings_fact.job_country,
        count(skills_job_dim.job_id) as demand_count
     FROM
        job_postings_fact
    INNER JOIN
        skills_job_dim ON skills_job_dim.job_id=job_postings_fact.job_id
    INNER JOIN
        skills_dim ON skills_dim.skill_id=skills_job_dim.skill_id
    GROUP BY
        skills,
        job_postings_fact.job_country
    ORDER BY
        demand_count DESC
```
---
### 🔑 **Insights**
1. **SQL leads the way –** With 115,425 job postings, SQL is the single most in-demand skill, confirming it as the foundational requirement for Data Analysts.

2. **Python is nearly as essential –** At 107,471 postings, Python is a close second, showing its importance for data manipulation, analysis, and automation.

3. **R, Tableau, and Excel remain strong –** With 51K–45K postings, these tools reflect the balance between statistical analysis (R), data visualization (Tableau), and business reporting (Excel).

4. **Visualization & BI tools matter –** Skills like Tableau (49,722) and Power BI (26,555) demonstrate that employers place high value on analysts who can communicate insights effectively.

5. **The skill mix shows versatility –** The demand spans programming (SQL, Python, R), visualization (Tableau, Power BI), and classic tools (Excel), highlighting the need for Data Analysts to be both technical and business-oriented.

![alt text](<PROJECT 1/assets/QUERY 3.png>)
*In the United States, SQL and Python are the most in-demand skills for Data Analysts, followed by R, Tableau, Excel, and Power BI, highlighting the need for both strong programming and visualization capabilities.*


### 4. Top Paying Skills
Identify the top skills for Data Analysts based on their associated average salaries, revealing which skills are most financially rewarding to acquire or improve.

---
```sql
    SELECT
        skills,
        job_postings_fact.job_schedule_type,
        job_postings_fact.job_title_short,
        ROUND(AVG(salary_year_avg), 0) AS average_salary
     FROM
        job_postings_fact
    INNER JOIN
        skills_job_dim ON skills_job_dim.job_id=job_postings_fact.job_id
    INNER JOIN
        skills_dim ON skills_dim.skill_id=skills_job_dim.skill_id
    WHERE
        salary_year_avg IS NOT NULL
        AND
        job_title_short = 'Data Analyst'
    GROUP BY
        skills,
        job_postings_fact.job_schedule_type,
        job_postings_fact.job_title_short
    ORDER BY
        average_salary DESC
    LIMIT 10
```
---
### 🔑 **Insights**

1. **High-paying niche skills dominate the list –** Skills like SVN ($400K), Matplotlib ($234K), and Solidity ($179K) top the rankings, reflecting their association with specialized or senior-level roles rather than typical Data Analyst positions.

2. **Database and backend tools also command higher pay –** NoSQL ($167K) and Oracle ($157K) appear in the top tier, showing the value of advanced database expertise.

3. **Core skills (SQL, Excel, Python) don’t lead in salary averages –** While these are the most in-demand skills, their average salary is diluted across thousands of entry- to mid-level postings, keeping them off the very top-paying list.

4. **The trade-off between demand and salary is clear –** Niche technical skills may open fewer opportunities but often lead to higher-paying roles, while mainstream skills ensure broader job accessibility.

**👉 Takeaway:** SQL, Excel, and Python are essential to land a job, but learning complementary high-paying niche skills (like NoSQL, Matplotlib, or Solidity) can significantly boost earning potential.

![alt text](<PROJECT 1/assets/QUERY 4.png>)
*The top-paying skills for Data Analysts include SVN ($400K), Matplotlib ($234K), and Solidity ($179K), but these appear as niche or outlier skills rather than core analyst tools — unlike SQL, Excel, or Python, which dominate demand but not necessarily average salary.*

### 5. Optimal Skills
Identify the most optimal skills for Data Analysts by focusing on those that are both in high demand and associated with high salaries in remote roles, helping job seekers prioritize skills that maximize career opportunities and financial rewards.

---

```sql
WITH skills_demand AS (

SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        job_title_short,
        count(skills_job_dim.job_id) as demand_count
     FROM
        job_postings_fact
    INNER JOIN
        skills_job_dim ON skills_job_dim.job_id=job_postings_fact.job_id
    INNER JOIN
        skills_dim ON skills_dim.skill_id=skills_job_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL
    GROUP BY
        skills_dim.skill_id,
        job_title_short
), avg_salary AS (

    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg), 0) AS average_salary
     FROM
        job_postings_fact
    INNER JOIN
        skills_job_dim ON skills_job_dim.job_id=job_postings_fact.job_id
    INNER JOIN
        skills_dim ON skills_dim.skill_id=skills_job_dim.skill_id
    WHERE
        salary_year_avg IS NOT NULL
    GROUP BY
        skills_job_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    average_salary,
    skills_demand.job_title_short
FROM
    skills_demand
INNER JOIN
    avg_salary on avg_salary.skill_id=skills_demand.skill_id
WHERE
    demand_count > 10
ORDER BY
    average_salary DESC,
    demand_count DESC
LIMIT
    10;
```

### 🔑 **Insights**
I’ve analyzed your dataset, and here are some **insights about the most optimal skills to learn for specific jobs** (in this case, *Data Analyst*):

---

### 🔑 Key Observations

1. **High Demand Skills** (good for employability):

   * **Apache Spark (187 postings)** – Most in demand, widely used for big data processing.
   * **Amazon Redshift (90 postings)** – Strong need for cloud data warehousing.
   * **Apache Airflow (71 postings)** – Orchestration and workflow automation are very relevant.

2. **High Salary Skills** (good for maximizing earning potential):

   * **Cassandra (\$154,124)** – High-paying, though niche demand (11 postings).
   * **Neo4j (\$147,708)** – Graph databases; valuable for specialized roles.
   * **Kafka (\$144,754)** and **PyTorch (\$144,470)** – Strong salaries, used in real-time streaming & machine learning.

3. **Balanced Skills (Good mix of demand + salary)**:

   * **Scala (\$145,120, 59 postings)** – Valued for big data and analytics.
   * **Shell scripting (\$143,370, 44 postings)** – Practical and often required across roles.
   * **TensorFlow (\$142,370, 24 postings)** – Key ML framework, strong salary, rising demand.

---

### 📌 Insights for Career Strategy

* **If your goal is employability (getting hired fast):** Focus on **Spark, Redshift, Airflow** since they have the highest demand.
* **If your goal is higher salary (specialized roles):** Learn **Cassandra, Neo4j, Kafka, PyTorch**, since they pay a premium even if demand is smaller.
* **If you want balance:** **Scala, Shell, TensorFlow** give you both decent demand and strong pay.

---

✅ So, the **most optimal path** depends on your priority:

* **Job security & employability →** Spark, Redshift, Airflow
* **High earning potential →** Cassandra, Neo4j, PyTorch
* **Future-proof balance →** Scala + TensorFlow

![alt text](<PROJECT 1/assets/QUERY 5.png>)
*For a Data Analyst role, beyond the most popular tools like SQL, Python, and Excel, the most optimal skills to learn are Spark, Redshift, and Airflow for high demand, Cassandra, Neo4j, and PyTorch for higher salary potential, and Scala with TensorFlow for a strong balance of both.*

# What I Learned
1. **Data Cleaning with Excel** – Learned how to organize and prepare raw datasets by handling missing values, duplicates, and formatting issues to make the data ready for analysis.
2. **Advanced Excel Analysis** – Applied features like  pivot charts, slicers and Power Query to summarize, explore, and visualize data effectively.
3. **Data Manipulation with SQL** – Gained experience in extracting, filtering, and transforming datasets using SQL queries to answer business questions.
4. **Problem-Solving & Insights** – Developed the ability to approach data challenges critically, draw meaningful conclusions, and connect analysis results to real-world decision-making.



#  Summary & Conclusions

1. **Top-Paying Roles** – While some outliers (like \$650K listings) exist, the highest salaries for Data Analysts often reflect **senior or specialized positions** across different countries, with full-time and sometimes remote flexibility offering the best pay.

2. **Skills for Top-Paying Jobs** – **SQL remains non-negotiable**, but top-paying roles also require a mix of programming (Python, R, SAS, Go), visualization (Tableau, Excel), and advanced technologies (Snowflake, Kubernetes, Hadoop, Oracle).

3. **Most In-Demand Skills** – **SQL and Python dominate** job postings, followed by R, Tableau, Excel, and Power BI. Employers clearly want analysts who combine **technical depth with business communication skills**.

4. **Skills Linked to Higher Salaries** – Specialized tools like **NoSQL, Matplotlib, Solidity, and Oracle** command much higher salaries than mainstream tools, though opportunities are fewer. This reflects a **trade-off between demand and earning potential**.

5. **Most Optimal Skills to Learn** – For employability, focus on **Spark, Redshift, Airflow**; for higher salaries, specialize in **Cassandra, Neo4j, PyTorch, Kafka**; and for balance, invest in **Scala, TensorFlow, and Shell scripting**.

---

✅ **Overall Conclusion:** To succeed as a Data Analyst, **SQL, Python, and Excel are essential foundations**, but building on them with **high-demand big data tools** and **niche, high-paying technologies** provides the best career strategy. The right skill mix depends on whether your priority is **job security, higher pay, or future-proof versatility**.
