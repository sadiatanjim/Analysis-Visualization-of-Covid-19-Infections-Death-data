Select *
From SQL_Data_Exploration..CovidDeaths
Where continent is not null
Order by 3,4
Delete From SQL_Data_Exploration..CovidDeaths 
Where location = 'High income' AND location='Upper middle income' AND location='Lower middle income' AND location='Low income'
--Select *
--From SQL_Data_Exploration..CovidVaccination
--Order by 3,4

--Select data that we are going to use

Select location, date, population, total_cases, new_cases, total_deaths
From SQL_Data_Exploration..CovidDeaths
Order by 1,2


--Looking at Total Cases vs. Total Deaths
--Shows likelihood of dying in your country if you contract covid 

Select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as death_percentage
From SQL_Data_Exploration..CovidDeaths
Where location like '%desh%'
Order by 1,2


--Looking at Total Cases vs. Population
--Shows what percentage of population contracted covid

Select location, date, population, total_cases, (total_cases/population) * 100 as contract_percentage
From SQL_Data_Exploration..CovidDeaths
--Where location like '%desh%'
Order by 1,2

--Looking at Countries with Highest Infection Rate compared to population

Select location, population, MAX(total_cases) as max_total_cases, MAX((total_cases/population)) * 100 as max_contract_percentage
From SQL_Data_Exploration..CovidDeaths
--Where location like '%desh%'
Group by location, population
Order by max_contract_percentage desc 

--Showing Countries with Highest Death Count per Country

Select location, MAX(cast(total_deaths as int)) as total_deaths_count
From SQL_Data_Exploration..CovidDeaths
Where continent is not null
Group by location
Order by total_deaths_count desc 


--Let's break thing down by continent
Select continent, MAX(cast(total_deaths as int)) as total_deaths_count
From SQL_Data_Exploration..CovidDeaths
Where continent is not null
Group by continent
Order by total_deaths_count desc 

-- GLOBAL NUMBERS

Select SUM(new_cases) as sum_new_cases, Sum(cast(new_deaths as int)) as sum_new_deaths, 
  Sum(cast(new_deaths as int))/SUM(new_cases)*100 as new_deaths_percentage
From SQL_Data_Exploration..CovidDeaths
Where continent is not null
--Group by date
Order by 1,2


--Join two tables here
--Looking at Total Population vs. Vaccinations
Select Death.continent, Death.location, Death.date, Death.population, Vaccine.new_vaccinations,
  Sum(CONVERT(bigint, Vaccine.new_vaccinations)) OVER (Partition by Death.location ORDER BY Death.location, Death.date) as rolling_people_vaccinated
From SQL_Data_Exploration..CovidDeaths as Death
Join SQL_Data_Exploration..CovidVaccination as Vaccine
  On Death.location = Vaccine.location
  And Death.date = Vaccine.date
Where Death.continent is not null
Order by 2,3


--USE CTE

WITH PopVsVac ( continent, location, date, population, new_vaccinations, rolling_new_vaccinated)
as
(
SELECT Death.continent, Death.location, Death.date, Death.population, Vaccine.new_vaccinations,
  Sum(CONVERT(bigint, Vaccine.new_vaccinations)) OVER (Partition by Death.location ORDER BY Death.location, Death.date) as rolling_new_vaccinated
FROM SQL_Data_Exploration..CovidDeaths as Death
Join SQL_Data_Exploration..CovidVaccination as Vaccine
  ON Death.location = Vaccine.location
  And Death.date = Vaccine.date
WHERE Death.continent is not null
--ORDER BY 2,3
)
SELECT*, (rolling_new_vaccinated/population)*100 as rolling_vaccinated_percentage
FROM PopVsVac


-- TEMP Table

Drop Table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime, 
population numeric, 
new_vaccinations numeric, 
rolling_new_vaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated

SELECT Death.continent, Death.location, Death.date, Death.population, Vaccine.new_vaccinations,
  Sum(CONVERT(bigint, Vaccine.new_vaccinations)) OVER (Partition by Death.location ORDER BY Death.location, Death.date) as rolling_new_vaccinated
FROM SQL_Data_Exploration..CovidDeaths as Death
Join SQL_Data_Exploration..CovidVaccination as Vaccine
  ON Death.location = Vaccine.location
  And Death.date = Vaccine.date
--WHERE Death.continent is not null
--ORDER BY 2,3

SELECT*, (rolling_new_vaccinated/population)*100 as rolling_vaccinated_percentage
FROM #PercentPopulationVaccinated


--Creating View to store data for later visualizations

USE SQL_Data_Exploration
GO
CREATE VIEW PercentPopulationVaccinated
AS
Select Death.continent, Death.location, Death.date, Death.population, Vaccine.new_vaccinations,
  Sum(CONVERT(bigint, Vaccine.new_vaccinations)) OVER (Partition by Death.location ORDER BY Death.location, Death.date) as rolling_new_vaccinated
  --, (rolling_new_vaccinated/population)*100 as rolling_vaccinated_percentage
From SQL_Data_Exploration..CovidDeaths as Death
Join SQL_Data_Exploration..CovidVaccination as Vaccine
  On Death.location = Vaccine.location
  And Death.date = Vaccine.date
Where Death.continent is not null
--ORDER BY 2,3
GO

--DROP View PercentPopulationVaccinated

SELECT *
FROM PercentPopulationVaccinated



--EXTRA: Stored procedure (alternative of create view)

/*CREATE PROCEDURE PercentPopulationVaccinated
AS
Select Death.continent, Death.location, Death.date, Death.population, Vaccine.new_vaccinations,
  Sum(CONVERT(bigint, Vaccine.new_vaccinations)) OVER (Partition by Death.location ORDER BY Death.location, Death.date) as rolling_new_vaccinated
  --, (rolling_new_vaccinated/population)*100 as rolling_vaccinated_percentage
From SQL_Data_Exploration..CovidDeaths as Death
Join SQL_Data_Exploration..CovidVaccination as Vaccine
  On Death.location = Vaccine.location
  And Death.date = Vaccine.date
Where Death.continent is not null
--ORDER BY 2,3 */

--EXEC PercentPopulationVaccinated 
--DROP PROCEDURE PercentPopulationVaccinated


