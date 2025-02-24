SELECT TOP (1000) [iso_code]
      ,[continent]
      ,[location]
      ,[date]
      ,[population]
      ,[total_cases]
      ,[new_cases]
      ,[new_cases_smoothed]
      ,[total_deaths]
      ,[new_deaths]
      ,[new_deaths_smoothed]
      ,[total_cases_per_million]
      ,[new_cases_per_million]
      ,[new_cases_smoothed_per_million]
      ,[total_deaths_per_million]
      ,[new_deaths_per_million]
      ,[new_deaths_smoothed_per_million]
      ,[reproduction_rate]
      ,[icu_patients]
      ,[icu_patients_per_million]
      ,[hosp_patients]
      ,[hosp_patients_per_million]
      ,[weekly_icu_admissions]
      ,[weekly_icu_admissions_per_million]
      ,[weekly_hosp_admissions]
      ,[weekly_hosp_admissions_per_million]
      ,[new_tests]
      ,[total_tests]
      ,[total_tests_per_thousand]
      ,[new_tests_per_thousand]
      ,[new_tests_smoothed]
      ,[new_tests_smoothed_per_thousand]
      ,[positive_rate]
      ,[tests_per_case]
      ,[tests_units]
      ,[total_vaccinations]
      ,[people_vaccinated]
      ,[people_fully_vaccinated]
      ,[new_vaccinations]
      ,[new_vaccinations_smoothed]
      ,[total_vaccinations_per_hundred]
      ,[people_vaccinated_per_hundred]
      ,[people_fully_vaccinated_per_hundred]
      ,[new_vaccinations_smoothed_per_million]
      ,[stringency_index]
      ,[population_density]
      ,[median_age]
      ,[aged_65_older]
      ,[aged_70_older]
      ,[gdp_per_capita]
      ,[extreme_poverty]
      ,[cardiovasc_death_rate]
      ,[diabetes_prevalence]
      ,[female_smokers]
      ,[male_smokers]
      ,[handwashing_facilities]
      ,[hospital_beds_per_thousand]
      ,[life_expectancy]
      ,[human_development_index]
  FROM [portfolio project].[dbo].[CovidDeaths$]


  SELECT *
  FROM CovidDeaths$

  
  SELECT *
  FROM CovidVaccinations$

  
  SELECT location,date,total_cases,new_cases,total_deaths,population
  FROM CovidDeaths$
  ORDER BY 1,2


---LOOKING AT TOTAL CASES VS TOTAL DEATH
---SHOWS LIKELIHOD OF DYING IF YOU CONTRACT COVID IN YOUR COUNTRY
SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DEATHPERCENTAGE
FROM CovidDeaths$
WHERE location LIKE '%NIGERIA%' AND  continent IS NOT NULL
ORDER BY 1,2

---LOOKING AT TOTAL CASES VS POPULATION
SELECT location,date,population,total_cases,(total_cases/population)*100 AS PERCENTPOPULATION
FROM CovidDeaths$
WHERE location LIKE '%NIGERIA%' AND  continent IS NOT NULL
ORDER BY 1,2

---LOOKING AT COUNTRIES WITH INFECTION RATE COMPARED TO POPULATION
SELECT location,population,MAX(total_cases) AS HIGHESTINFECTIONCOUNT,MAX((total_cases/population))*100 AS  PERCENTPOPULATIONINFECTED
FROM CovidDeaths$
--WHERE location LIKE '%NIGERIA%'
WHERE continent IS NOT NULL
GROUP BY location,population
ORDER BY  PERCENTPOPULATIONINFECTED DESC

--SHOWING COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATI0N
SELECT Location, MAX(CAST(Total_deaths AS int)) as Totaldeathcount
FROM CovidDeaths$
WHERE continent IS NOT  NULL
GROUP BY Location
ORDER BY Totaldeathcount DESC

-- BREAKING DOWN BY CONTINENT
--SHOWING CONTINENTS WITH HIGHEST DEATH COUNT PER POPULATION
SELECT continent, MAX(CAST(Total_deaths AS int)) as Totaldeathcount
FROM CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Totaldeathcount DESC

---BREAKING GLOBAL NUMBERS 
SELECT date,SUM(New_cases) AS TOTALCASES,SUM(CAST(new_deaths as int)) AS TOTALDEATHS, SUM(CAST(new_deaths as int))/SUM(new_cases) *100 AS DEATHPERCENTAGE---total_cases,total_deaths,(total_deaths/total_cases)*100 AS DEATHPERCENTAGE
FROM CovidDeaths$
--WHERE location LIKE '%NIGERIA%' AND  
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

--LOOKING AT TOTAL POPULATION VS NEW VACCINATIONS
SELECT dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.Location order by dea.location,dea.date) as Rollingpeoplevaccinated
FROM CovidDeaths$ dea
JOIN CovidVaccinations$ vac
ON dea.location = vac.location
and dea.date = vac.date
order by 2,3 


--use CTE
WITH POPVSVAC AS
(
SELECT dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.Location order by dea.location,dea.date) as Rollingpeoplevaccinated
FROM CovidDeaths$ dea
JOIN CovidVaccinations$ vac
ON dea.location = vac.location
and dea.date = vac.date
--order by 2,3 
)
SELECT *, (Rollingpeoplevaccinated/population) * 100 AS PERCENTAGE
FROM POPVSVAC

---CREATING VIEW TO STORE DATA FOR LATER VISUALIZATION
CREATE VIEW PercentPopulationVaccinated2 AS
SELECT dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.Location order by dea.location,dea.date) as Rollingpeoplevaccinated
FROM CovidDeaths$ dea
JOIN CovidVaccinations$ vac
ON dea.location = vac.location
and dea.date = vac.date
--order by 2,3 







