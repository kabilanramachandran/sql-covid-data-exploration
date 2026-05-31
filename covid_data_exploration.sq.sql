USE PortfolioProject;

-- 1. Death % by country
SELECT location, continent,
  MAX(CAST(NULLIF(total_cases,'') AS UNSIGNED)) AS total_cases,
  MAX(CAST(NULLIF(total_deaths,'') AS UNSIGNED)) AS total_deaths,
  ROUND(MAX(CAST(NULLIF(total_deaths,'') AS UNSIGNED)) /
    MAX(CAST(NULLIF(total_cases,'') AS UNSIGNED)) * 100, 2) AS death_pct
FROM covid_data
WHERE continent != ''
GROUP BY location, continent
ORDER BY death_pct DESC;

-- 2. Infection rate vs population
SELECT location,
  MAX(CAST(NULLIF(total_cases,'') AS UNSIGNED)) AS total_cases,
  MAX(CAST(NULLIF(population,'') AS UNSIGNED)) AS population,
  ROUND(MAX(CAST(NULLIF(total_cases,'') AS UNSIGNED)) /
    MAX(CAST(NULLIF(population,'') AS UNSIGNED)) * 100, 2) AS infection_pct
FROM covid_data
WHERE continent != ''
GROUP BY location
ORDER BY infection_pct DESC;

-- 3. Total deaths by country
SELECT location,
  MAX(CAST(NULLIF(total_deaths,'') AS UNSIGNED)) AS total_deaths
FROM covid_data
WHERE continent != ''
GROUP BY location
ORDER BY total_deaths DESC;

-- 4. Deaths by continent
SELECT continent,
  SUM(CAST(NULLIF(new_deaths,'') AS UNSIGNED)) AS total_deaths
FROM covid_data
WHERE continent != ''
GROUP BY continent
ORDER BY total_deaths DESC;

-- 5. Global death percentage
SELECT
  SUM(CAST(NULLIF(new_cases,'') AS UNSIGNED)) AS total_cases,
  SUM(CAST(NULLIF(new_deaths,'') AS UNSIGNED)) AS total_deaths,
  ROUND(SUM(CAST(NULLIF(new_deaths,'') AS UNSIGNED)) /
    SUM(CAST(NULLIF(new_cases,'') AS UNSIGNED)) * 100, 2) AS death_pct
FROM covid_data
WHERE continent != '';

-- 6. USA monthly trend
SELECT date, total_cases, total_deaths, new_cases
FROM covid_data
WHERE location = 'United States'
ORDER BY date;

-- 7. Final summary view
CREATE OR REPLACE VIEW v_covid_summary AS
SELECT location, continent,
  MAX(CAST(NULLIF(total_cases,'') AS UNSIGNED)) AS total_cases,
  MAX(CAST(NULLIF(total_deaths,'') AS UNSIGNED)) AS total_deaths,
  ROUND(MAX(CAST(NULLIF(total_deaths,'') AS UNSIGNED)) /
    NULLIF(MAX(CAST(NULLIF(total_cases,'') AS UNSIGNED)),0)*100,2) AS death_pct,
  ROUND(MAX(CAST(NULLIF(total_cases,'') AS UNSIGNED)) /
    NULLIF(MAX(CAST(NULLIF(population,'') AS UNSIGNED)),0)*100,2) AS infection_pct,
  MAX(CAST(NULLIF(gdp_per_capita,'') AS DECIMAL(10,2))) AS gdp_per_capita,
  MAX(CAST(NULLIF(life_expectancy,'') AS DECIMAL(10,2))) AS life_expectancy
FROM covid_data
WHERE continent != ''
GROUP BY location, continent;

SELECT * FROM v_covid_summary ORDER BY total_cases DESC;