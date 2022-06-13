select *
from Covid..CovidDeaths
where continent is not null
order by 3,4

--select *
--from Covid..CovidVaccinations
--where continent is not null
--order by 3,4

--Select location, date, total_cases, new_cases, total_deaths, population
--from Covid..CovidDeaths
--where continent is not null
--order by 1,2

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from Covid..CovidDeaths
where location like '%Greece%' and continent is not null
order by 1,2

Select location, date, total_cases, population, (total_cases/population)*100 as PopulationPercentage
from Covid..CovidDeaths
--where location like '%Greece%'
order by 1,2

Select location,population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PopulationPercentage
from Covid..CovidDeaths
where continent is not null 
--and
--location like '%Greece%'
group by population,location
order by PopulationPercentage desc

Select location, MAX(cast(total_deaths as bigint)) as TotalDeathCount
from Covid..CovidDeaths
where continent is not null
--where location like '%Greece%'
group by location
order by TotalDeathCount desc

Select location, MAX(cast(total_deaths as bigint)) as TotalDeathCount
from Covid..CovidDeaths
where continent is  null
--where location like '%Greece%'
group by location
order by TotalDeathCount desc

Select continent, MAX(cast(total_deaths as bigint)) as TotalDeathCount
from Covid..CovidDeaths
where continent is not null
--where location like '%Greece%'
group by continent
order by TotalDeathCount desc

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as bigint)) as total_deaths, 
	SUM(cast(new_deaths as bigint))/SUM(new_Cases)*100 as DeathPercentage
From Covid..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) 
OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Covid..CovidDeaths dea
Join Covid..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Covid..CovidDeaths dea
Join Covid..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as RollingPeopleVaccinatedPercentege
From PopvsVac

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Covid..CovidDeaths dea
Join Covid..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100 RollingPeopleVaccinatedPercentege
From #PercentPopulationVaccinated

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Covid..CovidDeaths dea
Join Covid..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
