
-- Question: What are the top-paying data analyst jobs?
-- - Identify the top 10 highest-paying Data Analyst roles that are available remotely.
-- - Focuses on job postings with specified salaries (remove nulls).
-- - Why? Highlight the top-paying opportunities for Data Analysts

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
LEFT JOIN company_dim on company_dim.company_id=job_postings_fact.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC