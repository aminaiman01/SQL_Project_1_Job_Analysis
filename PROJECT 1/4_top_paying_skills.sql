-- Question: What are the top skills based on salary?
-- - Look at the average salary associated with each skill for Data Analyst positions
-- - Focuses on roles with specified salaries, regardless of job_location
-- - Why? It reveals how different skills impact salary levels for Data Analyst and
--   helps identify the most financially rewarding skills to acquire or improve

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