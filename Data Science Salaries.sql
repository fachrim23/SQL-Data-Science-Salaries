CREATE DATABASE ds_salaries;
SELECT * FROM ds_salaries;

-- 1. Apakah ada data yang NULL ?
SELECT * FROM ds_salaries 
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
    -- Hasilnya data tidak ada yang NULL
    
-- 2. Sebutkan job_title apa saja ?
SELECT DISTINCT job_title FROM ds_salaries ORDER BY job_title;

-- 3. Sebutkan job_title apa saja yang berkaitan dengan data analyst ?
SELECT DISTINCT job_title FROM ds_salaries WHERE job_title LIKE "%Data Analyst%" ORDER BY job_title;

-- 4. Berapa rata-rata gaji data analyst keseluruhan posisi ?
SELECT AVG(salary_in_usd * 15000)/12 AS salary_idr_monthly FROM ds_salaries;

-- 4.1 Berapa rata-rata gaji data analyst berdasarkan experience_level ?
SELECT AVG(salary_in_usd * 15000)/12 AS salary_idr_monthly, experience_level 
FROM ds_salaries
GROUP BY experience_level;

-- 4.2 Berapa rata-rata gaji data analyst berdasarkan experience_level dan employment_type ?
SELECT experience_level, employment_type, AVG(salary_in_usd * 15000)/12 AS salary_idr_monthly
FROM ds_salaries
GROUP BY experience_level, employment_type
ORDER BY experience_level, employment_type;

-- 5. Negara dengan gaji yang menarik untuk posisi yang berkaitan dengan data analyst, Full Time, dan exp level entry dan mid ?
SELECT company_location, AVG(salary_in_usd) as avg_salary_usd FROM ds_salaries 
	WHERE job_title LIKE "%Data Analyst%" 
    AND employment_type = "FT" 
    AND experience_level IN ("MI", "EN")
GROUP BY company_location HAVING avg_salary_usd >= 20000;

-- 6. Di tahun berapa kenaikan gaji dari mid level ke senior level yang memiliki kenaikan yang tertinggi 
-- (untuk pekerjaan yang berkaitan dengan data analyst dan full time)?

WITH ds_1 AS (
	SELECT work_year, AVG(salary_in_usd) salary_usd_ex
    FROM ds_salaries 
    WHERE employment_type = 'FT'
    AND experience_level = 'EX'
    AND job_title LIKE '%Data Analyst%'
GROUP BY work_year
),
ds_2 AS (
	SELECT work_year, AVG(salary_in_usd) salary_usd_mi
    FROM ds_salaries 
    WHERE employment_type = 'FT'
    AND experience_level = 'MI'
    AND job_title LIKE '%Data Analyst%'
GROUP BY work_year
) 
SELECT ds_1.work_year, ds_1.salary_usd_ex, ds_2.salary_usd_mi, ds_1.salary_usd_ex -  ds_2.salary_usd_mi differences
FROM ds_1 LEFT OUTER JOIN ds_2 ON ds_1.work_year = ds_2.work_year;
-- Dalam hasil dari sintak di atas, work_year pada tahun 2020 tidak terdeteksi sehingga data tidak lengkap

-- Maka dari itu diperlukan full outter join untuk mendapatkan data yang lengkap

WITH 
ds_1 AS (
	SELECT work_year, AVG(salary_in_usd) salary_usd_ex
    FROM ds_salaries 
    WHERE employment_type = 'FT'
    AND experience_level = 'EX'
    AND job_title LIKE '%Data Analyst%'
GROUP BY work_year
),
ds_2 AS (
	SELECT work_year, AVG(salary_in_usd) salary_usd_mi
    FROM ds_salaries 
    WHERE employment_type = 'FT'
    AND experience_level = 'MI'
    AND job_title LIKE '%Data Analyst%'
GROUP BY work_year
),
t_year AS (
	SELECT work_year FROM ds_salaries
)
SELECT DISTINCT 
	t_year.work_year, 
	ds_1.salary_usd_ex, 
    ds_2.salary_usd_mi, 
    ds_1.salary_usd_ex -  ds_2.salary_usd_mi differences
FROM t_year 
	LEFT JOIN ds_1 ON ds_1.work_year = t_year.work_year
    LEFT JOIN ds_2 ON ds_2.work_year = t_year.work_year;

