SELECT *
FROM PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4

Select Location, date, total_cases, New_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
order by 1,2

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
where location like '%Philippines%'
Where continent is not null
order by 1,2

-- Total Cases vs Population 

Select Location, date, Population, total_cases, (total_cases/population)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
where location like '%states%'
Where continent is not null
order by 1,2

-- Looking at countries with highest infection rate compare to population 

SELECT Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as 
 PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected desc

-- Showing Countries with highest death count per population 


SELECT Location, Max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
Where continent is not null
GROUP BY Location, Population
ORDER BY TotalDeathCount desc

--Broke down by continent

SELECT location, Max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
Where continent is null
GROUP BY location
ORDER BY TotalDeathCount desc

-- Continents with highest death counts 

SELECT continent, Max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
Where continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc

-- Global Numbers

SELECT SUM(new_cases) as Total_Cases, SUM(cast(new_deaths as integer))as Total_deaths, SUM(cast(new_deaths as integer))/SUM(new_cases)* 100 as
DeathPercentage
FROM PortfolioProject..CovidDeaths
Where continent is not null
--Group by continent 
order by 1,2

-- Population VS Vaccinations



--  USE CTE

With PopVsVac (Continent, Location, Date, Population,new_vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

Select *, (RollingPeopleVaccinated/Population)*100
From PopVsVac

-- temp table


)
Drop table if exists #PercentpPopulationVaccinated
Create Table #PercentpPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date Datetime,
Population numeric,
New_Vaccination numeric,
RollingPeopleVaccinated numeric,
)

insert into #PercentpPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentpPopulationVaccinated

-- View to store data for later visualizations 

Create View PercentpPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select * 
From PercentpPopulationVaccinated









