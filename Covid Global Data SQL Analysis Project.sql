
SELECT LOCATION, DATE, TOTAL_CASES, NEW_CASES, TOTAL_DEATHS, POPULATION
FROM DEATHS
ORDER BY 1,2

--Looking at Total Cases vs Total Deaths
--Shows the likely hood of dying if you attract covid in your country
SELECT LOCATION, DATE, TOTAL_CASES,TOTAL_DEATHS, 
(Total_Deaths/Total_cases)* 100 AS 'Death_Percentage'
FROM DEATHS
WHERE LOCATION LIKE '%STATES%'
ORDER BY 1,2

--Looking at total cases vs population
-- Shows what percentage of population got Covid
SELECT LOCATION, DATE, TOTAL_CASES,POPULATION, 
(Total_CASES/POPULATION)* 100 AS 'Percent_Population_Infected'
FROM DEATHS
WHERE LOCATION LIKE '%STATES%'
ORDER BY 1,2;

-- Looking at countries with highest infection rate compared to population

SELECT 
LOCATION,
POPULATION, 
MAX(TOTAL_CASES) AS 'Total_Infection',
MAX((Total_CASES/POPULATION))* 100 AS 'Highest_Infection_%'
FROM DEATHS
GROUP BY LOCATION, POPULATION
ORDER BY 4 DESC;

--Showing countries with highest death count per population
SELECT 
LOCATION,
POPULATION, 
MAX(cast(TOTAL_DEATHS as int)) AS 'Total_death'
FROM DEATHS
WHERE continent IS NOT NULL
GROUP BY LOCATION, POPULATION
ORDER BY 3 DESC;

--Showing continent with highest death count per population
SELECT 
LOCATION,
POPULATION, 
MAX(cast(TOTAL_DEATHS as int)) AS 'Total_death'
FROM DEATHS
WHERE continent IS NULL and location NOT LIKE '%INCOME%' and location NOT LIKE '%INTERNATIONAL%'
GROUP BY LOCATION, POPULATION
ORDER BY 3 DESC;

--Global numbers, New Death per New case globally.
SELECT 
DATE, 
SUM(NEW_CASES) as 'Total New Cases', 
SUM(CAST (NEW_DEATHS AS INT))  AS 'Total New Deaths', 
SUM(CAST(NEW_DEATHS AS INT))/SUM(NEW_CASES)*100 AS 'Death_Per_Case_%'
FROM DEATHS
WHERE CONTINENT IS NOT NULL
GROUP BY DATE
ORDER BY 1;

-- Looking at total population vs vaccinations
SELECT 
*,
(S1.RollingVaccine/S1.population)*100 AS 'Percent'
FROM 
	(SELECT 
	D.CONTINENT, 
	D.LOCATION, 
	D.DATE,
	D.POPULATION, 
	V.NEW_VACCINATIONS,
	SUM(CAST(V.NEW_VACCINATIONS AS FLOAT)) OVER (PARTITION BY D.LOCATION ORDER BY D.LOCATION, D.DATE) AS 'RollingVaccine'
	FROM DEATHS AS D
	FULL JOIN VACCINE AS V
	ON V.location = d.location and v.date = d.date
	WHERE D.CONTINENT IS NOT NULL) S1 

--Create View for Vaccinated Population Percentage

CREATE VIEW VACCINATED_POPULATION_PERCENTAGE AS
SELECT 
*,
(S1.RollingVaccine/S1.population)*100 AS 'Percent'
FROM 
	(SELECT 
	D.CONTINENT, 
	D.LOCATION, 
	D.DATE,
	D.POPULATION, 
	V.NEW_VACCINATIONS,
	SUM(CAST(V.NEW_VACCINATIONS AS FLOAT)) OVER (PARTITION BY D.LOCATION ORDER BY D.LOCATION, D.DATE) AS 'RollingVaccine'
	FROM DEATHS AS D
	FULL JOIN VACCINE AS V
	ON V.location = d.location and v.date = d.date
	WHERE D.CONTINENT IS NOT NULL) S1 