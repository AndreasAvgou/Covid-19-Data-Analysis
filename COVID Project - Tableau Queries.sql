Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as bigint)) as total_deaths, 
	SUM(cast(new_deaths as bigint))/SUM(new_Cases)*100 as DeathPercentage
From Covid..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

Select continent, MAX(cast(total_deaths as bigint)) as TotalDeathCount
from Covid..CovidDeaths
where continent is not null
--where location like '%Greece%'
group by continent
order by TotalDeathCount desc

Select location,population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PopulationPercentage
from Covid..CovidDeaths
where continent is not null 
--and
--location like '%Greece%'
group by population,location
order by PopulationPercentage desc

Select location,population,date, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PopulationPercentage
from Covid..CovidDeaths
where continent is not null 
group by population,location,date
order by PopulationPercentage desc