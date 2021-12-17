/*
Queries used for Tableau Project
*/



-- 1. 

SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int)) AS total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 AS DeathPercentage
FROM SQL_Data_Exploration..CovidDeaths
--Where location like '%states%'
WHERE continent is not null 
--Group By date
ORDER BY 1,2

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

SELECT location, SUM(cast(new_deaths as int)) AS TotalDeathCount
FROM SQL_Data_Exploration..CovidDeaths
--Where location like '%states%'
WHERE continent is null 
and location not in ('World', 'European Union', 'International', 'Upper middle income', 'High income', 'Lower middle income', 'Low income')
GROUP BY location
ORDER BY TotalDeathCount DESC


-- 3.

SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount,  Max((total_cases/population))*100 AS PercentPopulationInfected
FROM SQL_Data_Exploration..CovidDeaths
--Where location like '%states%'
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC


-- 4.


SELECT Location, Population,date, MAX(total_cases) AS HighestInfectionCount,  Max((total_cases/population))*100 AS PercentPopulationInfected
FROM SQL_Data_Exploration..CovidDeaths
--Where location like '%states%'
GROUP BY Location, Population, date
ORDER BY PercentPopulationInfected DESC












-- Queries I originally had, but excluded some 
-- Here only in case you want to check them out


-- 1.

SELECT death.continent, death.location, death.date, death.population
, MAX(vaccine.total_vaccinations) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM SQL_Data_Exploration..CovidDeaths death
Join SQL_Data_Exploration..CovidVaccination vaccine
	ON death.location = vaccine.location
	and death.date = vaccine.date
WHERE death.continent is not null 
GROUP BY death.continent, death.location, death.date, death.population
ORDER BY 1,2,3




-- 2.
SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int)) AS total_deaths, 
  SUM(cast(new_deaths as int))/SUM(New_Cases)*100 AS DeathPercentage
FROM SQL_Data_Exploration..CovidDeaths
--Where location like '%states%'
WHERE continent is not null 
--Group By date
ORDER BY 1,2


-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2


-- 3.

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

SELECT location, SUM(cast(new_deaths as int)) AS TotalDeathCount
FROM SQL_Data_Exploration..CovidDeaths
--Where location like '%states%'
WHERE continent is null 
and location not in ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC



-- 4.

SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount,  
  Max((total_cases/population))*100 AS PercentPopulationInfected
FROM SQL_Data_Exploration..CovidDeaths
--Where location like '%states%'
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC



-- 5.

--Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where continent is not null 
--order by 1,2

-- took the above query and added population
SELECT Location, date, population, total_cases, total_deaths
FROM SQL_Data_Exploration..CovidDeaths
--Where location like '%states%'
WHERE continent is not null 
ORDER BY 1,2


-- 6. 


WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT death.continent, death.location, death.date, death.population, vaccine.new_vaccinations
, SUM(CONVERT(int,vaccine.new_vaccinations)) OVER (Partition by death.Location ORDER BY death.location, death.Date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM SQL_Data_Exploration..CovidDeaths death
Join SQL_Data_Exploration..CovidVaccination vaccine
	ON death.Location = vaccine.Location
	and death.date = vaccine.date
WHERE death.continent is not null 
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100 AS PercentPeopleVaccinated
FROM PopvsVac


-- 7. 

SELECT Location, Population,date, MAX(total_cases) AS HighestInfectionCount, 
  Max((total_cases/population))*100 AS PercentPopulationInfected
FROM SQL_Data_Exploration..CovidDeaths
--Where location like '%states%'
GROUP BY Location, Population, date
ORDER BY PercentPopulationInfected DESC
