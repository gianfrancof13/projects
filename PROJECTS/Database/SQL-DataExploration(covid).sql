--- SELECCIONO LOS DATOS QUE VOY A USAR

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 1, 2

--- TOTAL CASES VS TOTAL DEATHS
--- Muestra las probabilidades de morir al contrar COVID

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) 
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 1, 2

--- ERROR en tipo de dato, no puede realizar esa operacion
--- SOLUCION: Procedo a crear una columna donde pueda modificar el tipo de dato a decimal

ALTER TABLE CovidDeaths
ADD total_deaths_d decimal
ALTER TABLE CovidDeaths
ADD total_cases_d decimal

--- Copio los valores de la columna original a las nuevas

UPDATE CovidDeaths
SET total_deaths_d = CAST(total_deaths AS decimal);
UPDATE CovidDeaths
SET total_cases_d = CAST(total_cases AS decimal);

--- Reviso que tenga los datos agregados y volvemos a probar la operacion

SELECT total_cases_d, total_deaths_d
FROM PortfolioProject..coviddeaths
SELECT location, date, total_cases_d, total_deaths_d, (total_deaths_d/total_cases_d) 
FROM PortfolioProject..CovidDeaths
ORDER BY 1, 2

--- Elimino las columnas con el tipo de dato que no vamos a usar

ALTER TABLE coviddeaths
DROP COLUMN total_cases, total_deaths;

--- Agrego un nombre a la nueva columna con el porcentaje y lo multiplico por 100

SELECT location, date, total_cases_d, total_deaths_d, (total_deaths_d/total_cases_d)*100 as deathpercentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%argentina%'
WHERE continent is not null
ORDER BY 1, 2

--- TOTAL CASES VS POPULATION
--- Muestra el porcentaje de la poblacion que se contagio de COVID

SELECT location, date, population, total_cases_d, (total_cases_d/population)*100 as populationcases_percentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%argentina%'
WHERE continent is not null
ORDER BY 1, 2


--- PAISES CON LA TASA DE CONTAGIO MAS ALTA COMPARADO CON LA POBLACION

SELECT location, population, MAX(total_cases_d) AS HighestInfectionCount, MAX((total_cases_d/population))*100 as populationInfected_percentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%argentina%'
WHERE continent is not null
GROUP BY location, population
ORDER BY populationInfected_percentage desc

--- PAISES CON EL MAYOR CONTEO DE MUERTES COMPARADO CON LA POBLACION

SELECT location, MAX(total_deaths_d) AS totaldeathcount
FROM PortfolioProject..CovidDeaths
--WHERE location like '%argentina%'
--WHERE continent is not null
WHERE continent is not null
GROUP BY location
ORDER BY totaldeathcount desc

--- CONTINENTES CON EL MAYOR CONTEO DE MUERTES COMPARADO CON LA POBLACION

--Con NULLIF verifico si la columna no es nula y no contiene solo espacios en blanco 
--Con LTRIM y RTRIM elimino espacios desde izquierda y desde derecha
--Otra opcion es la funcion COALESCE(columna, '') != ''; para reemplazar valor nulos por una cadena vacia

SELECT continent, MAX(total_deaths_d) AS totaldeathcount
FROM PortfolioProject..CovidDeaths
--WHERE location like '%argentina%'
WHERE continent is not null AND NULLIF(LTRIM(RTRIM(continent)),'') IS NOT NULL
GROUP BY continent
ORDER BY totaldeathcount desc

--- NUMEROS GLOBALES
--- Dejo dos metodos para realizar la consulta

/*
WITH AggregatedData AS (
    SELECT date,
           SUM(new_cases) AS total_cases,
           SUM(CAST(new_deaths AS INT)) AS total_deaths
    FROM PortfolioProject..CovidDeaths
    WHERE continent IS NOT NULL
    GROUP BY date
)
SELECT date,
       total_cases,
       total_deaths,
       (total_deaths * 100.0) / NULLIF(total_cases, 0) AS deathpercentage
FROM AggregatedData
ORDER BY date;
*/

SELECT
	SUM(new_cases) as total_cases,
	SUM(cast(new_deaths as int)) as total_deaths,
	(SUM(cast(new_deaths as int)) / NULLIF(SUM(new_cases),0))*100 as deathpercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 1, 2

--- TOTAL POPULATION VS VACCINATIONS

WITH PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
AS (
SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	(SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)) as rollingpeoplevaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
)
SELECT 
	continent,
	location,
	date,
	population,
	new_vaccinations,
	(RollingPeopleVaccinated/Population)*100 as percentagevaccinated
FROM PopvsVac

--- TABLA TEMPORAL

DROP TABLE IF EXISTS #Percentagepopulationvaccinated
CREATE TABLE #Percentpopulationvaccinated (
	continent nvarchar(255),
	Location nvarchar(255),
	Date datetime,
	population numeric,
	new_vaccinations numeric,
	rollingpeoplevaccinated numeric, )

INSERT INTO #Percentpopulationvaccinated
SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	(SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)) as rollingpeoplevaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null


--- CREANDO VISTAS PARA LAS VISUALIZACIONES QUE SE REALIZARAN MAS ADELANTE

CREATE VIEW Percentpopulationvaccinate2 as
	SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	(SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)) as rollingpeoplevaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null

SELECT * FROM Percentpopulationvaccinate2