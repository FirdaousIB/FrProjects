select *
from PortfolioProject..Covid_death
order by 3,4

Select *
from PortfolioProject..Covid_vac
order by 3,4

Select location, date, total_cases, total_deaths_per_million, total_cases_per_million, (total_deaths_per_million/total_cases_per_million)*100 As DeathPercentage
From PortfolioProject..Covid_death
Where location LIKE '%state%'
order by 1,2

--Percentage of US Population with Covid
Select location, date, total_cases, population, (total_cases/population)*100 As CovidPercentage
From PortfolioProject..Covid_death
Where location LIKE '%state%'
order by 1,2

--Country with highest infection rate
Select location, population, MAX(total_cases) As Maximum_Case, MAX(total_cases/population)*100  AS Percent_Infected
From PortfolioProject..Covid_death
Group by location, population
order by Percent_Infected desc

Select location, MAX(cast(total_deaths as int)) AS TotalDeathCount 
From PortfolioProject..Covid_death
where continent is not Null
Group by location
order by TotalDeathCount Desc


--Continents with hihgest death count
Select continent, MAX(cast(total_deaths as int)) AS TotalDeathCount 
From PortfolioProject..Covid_death
where continent is not Null
Group by continent
order by TotalDeathCount Desc

--Global Numbers
select SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as total_death,
sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From PortfolioProject..Covid_death
where continent is not null
order by 1,2



--Total Polpulation Vs Vaccinations
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) AS RollingPeopleVaccinated
From  PortfolioProject..Covid_death dea
Join  PortfolioProject..Covid_vac vac
ON dea.location = vac.location
AND dea.date = vac.date
Where dea.continent is not null
order by 2,3


--Use CTE
With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
AS (
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
From  PortfolioProject..Covid_death dea
Join  PortfolioProject..Covid_vac vac
ON dea.location = vac.location
AND dea.date = vac.date
Where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


-- Temp Table
Drop Table if exists #PercentPopulationVaccinated
Create Table  #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime, 
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert Into  #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(CONVERT(numeric,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
From  PortfolioProject..Covid_death dea
Join  PortfolioProject..Covid_vac vac
ON dea.location = vac.location
AND dea.date = vac.date
Where dea.continent is not null 

Select *, (RollingPeopleVaccinated/Population)*100
From PercentPopulationVaccinated

--Creating views
Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
From  PortfolioProject..Covid_death dea
Join  PortfolioProject..Covid_vac vac
ON dea.location = vac.location
AND dea.date = vac.date
Where dea.continent is not null


