/****** Script for SelectTopNRows command from SSMS  ******/
----------------------------Total Cases Vs Total Deaths------------------------
CREATE VIEW TotalDeathsPerPopulation as
SELECT
	 location,
	 date,
	 continent,
	 total_cases,
	 total_deaths
	 new_cases,
	(total_deaths/total_cases)*100 as death_Percentage
FROM [covidAnalysis].[dbo].[covid_deaths]
WHERE continent is not null
--ORDER by 1,2;
----------------------------Total Cases Vs Population------------------------
CREATE VIEW TotalCasesPerPopulation as
SELECT
	 location,
	 date,
	 continent,
	 total_cases,
	 population,
	(total_cases/[covid_deaths].population)*100 as infected_covid_Percentage
FROM [covidAnalysis].[dbo].[covid_deaths]
WHERE continent is not null
--ORDER by 1,2;
----------------------------Highest infection rate------------------------
CREATE VIEW HighestInfectionRateContinent as
SELECT
	 location,
	 population,
	 max(total_cases) as Highest_infection_count_per_location,
	 max(total_cases/[covid_deaths].population)*100 as Highest_infected_covid_Percentage
FROM [covidAnalysis].[dbo].[covid_deaths]
WHERE continent is not null
group by population, location
--ORDER by Highest_infected_covid_Percentage desc;
----------------------------Highest death rate per population------------------------
CREATE VIEW HighestDeathRatePopulation as
SELECT
	 location,
	 population,
	 max(cast(total_deaths as int)) as Highest_Death_count_per_location,
	 max(total_deaths/total_cases)*100 as Highest_covid_death_Percentage
FROM [covidAnalysis].[dbo].[covid_deaths]
WHERE continent is not null
group by population, location
--ORDER by Highest_Death_count_per_location desc;

----------------------------Highest Death count per Continent------------------------
CREATE VIEW HighestDeathCountContinent AS 
SELECT
	 continent,
	 max(cast(total_deaths as int)) as Highest_Death_count_per_continent
FROM [covidAnalysis].[dbo].[covid_deaths]
WHERE continent is not null
group by continent
--ORDER by Highest_Death_count_per_continent desc;
----------------------------Global Numbers---------------------------
CREATE VIEW GlobalNumbers AS 
SELECT
     --date,
	 sum(new_cases) world_total_cases,
	 sum(cast(new_deaths as int)) as world_death_cases,
	 sum(cast(new_deaths as int))/sum(new_cases)*100 as world_death_rate
FROM [covidAnalysis].[dbo].[covid_deaths]
WHERE continent is not null
;
----------------------------Global Numbers by date---------------------------
CREATE VIEW GlobalNumbersPerDate AS 
SELECT
     date,
	 sum(new_cases) world_total_new_cases,
	 sum(CAST(new_deaths as int)) as world_new_death_cases,
	 sum(cast(new_deaths as int))/sum(new_cases)*100 as world_death_rate
FROM [covidAnalysis].[dbo].[covid_deaths]
WHERE continent is not null
group by date;

----------------------------Vaccination Vs Population ---------------------------
CREATE VIEW VaccinationPerPopulation AS 
with popVsVacc as
(SELECT 
	 dth.continent,dth.location, dth.date,dth.population,vacc.new_vaccinations,
	 sum(cast(vacc.new_vaccinations as int))over(partition by dth.location order by dth.date) as rolling_vaccination
FROM [covidAnalysis].[dbo].[covid_deaths] dth
join [covidAnalysis].[dbo].[covid_vac]  vacc 
on dth.location =vacc.location and dth.date = vacc.date
)
SELECT
	 continent,
	 location,
	 population,
	 new_vaccinations,
	 rolling_vaccination,
	 rolling_vaccination/population *100 as number_ppl_vacinated_population
FROM popVsVacc
--ORDER BY location;
--------------------------creating views for later---------------------