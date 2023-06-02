SELECT *  
FROM `my-project-32123-381318.COVID_Project.COVID_DEATHS` 
ORDER BY 3,4

--Select Data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM `my-project-32123-381318.COVID_Project.COVID_DEATHS` 
ORDER BY 1,2

-- Looking at Total Cases vs. Total Deaths
--Reveals the likelihood of dying if contracted COVID in the United States 
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
FROM `my-project-32123-381318.COVID_Project.COVID_DEATHS`
WHERE location = 'United States'
ORDER BY 1,2

--Looking at Total Cases vs Population
--Reveals what percentage of population that contracted COVID in the United States
SELECT location, date, population, total_cases, (total_cases/population)*100 as Contraction_Percentage
FROM `my-project-32123-381318.COVID_Project.COVID_DEATHS`
WHERE location = 'United States'
ORDER BY 1,2

--What Countries have the highest Contraction Rate compaored to Population

SELECT location, population, MAX(total_cases) as Highest_Infection_Count, MAX(total_cases/population)*100 as Percent_Population_Infected
FROM `my-project-32123-381318.COVID_Project.COVID_DEATHS`
GROUP BY location, population 
ORDER BY Percent_Population_Infected desc

--Reveals Countries with Highest Death Count per Population

SELECT location, MAX(cast(total_deaths as int)) as Total_Death_Count 
FROM `my-project-32123-381318.COVID_Project.COVID_DEATHS`
WHERE continent is not null
GROUP BY location, population 
ORDER BY Total_Death_Count desc

-- Breaking It Down by Continent

SELECT location, MAX(cast(total_deaths as int)) as Total_Death_Count 
FROM `my-project-32123-381318.COVID_Project.COVID_DEATHS`
WHERE continent is null
GROUP BY location
ORDER BY Total_Death_Count desc


-- Displaying the Continents with the highest death count per population

SELECT continent, MAX(cast(total_deaths as int)) as Total_Death_Count 
FROM `my-project-32123-381318.COVID_Project.COVID_DEATHS`
WHERE continent is not null
GROUP BY continent
ORDER BY Total_Death_Count desc


-- GLOBAL NUMBERS by date
SELECT date, SUM(new_cases) as Total_Cases, SUM(CAST(new_deaths as int)) as Total_Death
FROM `my-project-32123-381318.COVID_Project.COVID_DEATHS`
GROUP BY date
ORDER BY 1,2

--Global Total Number 

SELECT SUM(new_cases) as Total_Cases, SUM(CAST(new_deaths as int)) as Total_Death
FROM `my-project-32123-381318.COVID_Project.COVID_DEATHS`
ORDER BY 1,2

-- Switching over to Covid Vaccination Table

SELECT *
FROM `my-project-32123-381318.COVID_Project.COVID_VACCINATIONS`

--Joining the two tables

SELECT *
FROM `my-project-32123-381318.COVID_Project.COVID_DEATHS` dea
JOIN `my-project-32123-381318.COVID_Project.COVID_VACCINATIONS` vac
      ON dea.location = vac.location
      and dea.date = vac.date

--Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location Order by dea.location, dea.date) as Rolling_People_Vaccinated
FROM `my-project-32123-381318.COVID_Project.COVID_DEATHS` dea
JOIN `my-project-32123-381318.COVID_Project.COVID_VACCINATIONS` vac
      ON dea.location = vac.location
      and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

