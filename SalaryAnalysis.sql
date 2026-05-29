SELECT * FROM ds.ds_salaries;

-- 1. Apakah ada data yang NULL?
SELECT * FROM ds.ds_salaries
WHERE work_year IS NULL
OR experience_level IS NULL
OR employment_type IS NULL
OR job_title IS NULL
OR salary IS NULL
OR salary_currency IS NULL
OR salary_in_usd IS NULL
OR employee_residence IS NULL
OR remote_ratio IS NULL
OR company_location IS NULL
OR company_size IS NULL;

-- 2. melihat ada job title apa saja
SELECT DISTINCT job_title 
FROM ds.ds_salaries 
ORDER BY job_title;

-- 3. Job title apa saja yang berkaitan dengan data analyst
SELECT DISTINCT job_title 
FROM ds.ds_salaries 
WHERE job_title LIKE '%data analyst%' 
ORDER BY job_title;

-- 4. Berapa rata-rata gaji data analyst?
SELECT AVG(salary_in_usd) AS avg_salaryDA
FROM ds.ds_salaries
WHERE job_title LIKE '%data analyst%';

-- 4.1 Berapa rata-rata gaji analyst berdasarkan experience levelnya?
SELECT experience_level, AVG(salary_in_usd) AS avg_SalaryDA
FROM ds.ds_salaries 
WHERE job_title LIKE '%data analyst%'
GROUP BY experience_level
ORDER BY avg_SalaryDA DESC;

-- 4.2 Berapa rata-rata gaji analyst berdasarkan experience levelnya dan jenis empoyment?
SELECT experience_level, employment_type, AVG(salary_in_usd) AS avg_SalaryDA
FROM ds_salaries 
WHERE job_title LIKE '%data analyst%'
GROUP BY experience_level, employment_type
ORDER BY avg_SalaryDA DESC;

-- 5. Negara dengan gaji yang menarik untuk posisi data analyst, full time, exp kerjanya entry level dan menengah
SELECT company_location, AVG(salary_in_usd) AS avg_salaryDA
FROM ds_salaries
WHERE job_title LIKE '%data analyst%'
	AND employment_type = 'FT'
    AND experience_level IN ('EN', 'MI')
GROUP BY company_location
HAVING avg_salaryDA >= 50000
ORDER BY avg_salaryDA DESC;

-- 6. di tahun berapa kenaikan gaji dari mid ke senior itu memiliki kenaikan yang tertinggi? (untuk pekerjaan yang berkaitan denagan data analyst yang penuh waktu

SELECT work_year,
    AVG(CASE WHEN experience_level = 'MI' THEN salary_in_usd END) AS avg_salary_MI,
    AVG(CASE WHEN experience_level = 'SE' THEN salary_in_usd END) AS avg_salary_SE,
    AVG(CASE WHEN experience_level = 'SE' THEN salary_in_usd END) - 
    AVG(CASE WHEN experience_level = 'MI' THEN salary_in_usd END) AS salary_increase
FROM ds_salaries
WHERE employment_type = 'FT'
  AND job_title LIKE '%data analyst%'
  AND experience_level IN ('MI', 'SE')
GROUP BY work_year
ORDER BY salary_increase DESC
LIMIT 1;