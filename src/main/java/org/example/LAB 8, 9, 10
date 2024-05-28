-- Star Schema

-- Weather Fact Table
CREATE TABLE Weather_Fact (
                              weather_id SERIAL PRIMARY KEY,
                              date_id INT REFERENCES Date_Dimension(date_id),
                              location_id INT REFERENCES Location_Dimension(location_id),
                              temperature_id INT REFERENCES Temperature_Dimension(temperature_id),
                              precipitation_id INT REFERENCES Precipitation_Dimension(precipitation_id)
);

-- Date Dimension Table
CREATE TABLE Date_Dimension (
                                date_id SERIAL PRIMARY KEY,
                                date DATE,
                                day_of_week VARCHAR(10),
                                month VARCHAR(10),
                                year INT
);

-- Location Dimension Table
CREATE TABLE Location_Dimension (
                                    location_id SERIAL PRIMARY KEY,
                                    location_name VARCHAR(100),
                                    latitude NUMERIC(9, 6),
                                    longitude NUMERIC(9, 6),
                                    region VARCHAR(50)
);

-- Temperature Dimension Table
CREATE TABLE Temperature_Dimension (
                                       temperature_id SERIAL PRIMARY KEY,
                                       temperature DECIMAL(5,2),
                                       humidity DECIMAL(5,2),
                                       wind_speed DECIMAL(5,2)
);

-- Precipitation Dimension Table
CREATE TABLE Precipitation_Dimension (
                                         precipitation_id SERIAL PRIMARY KEY,
                                         precipitation_type VARCHAR(50),
                                         precipitation_intensity VARCHAR(50)
);



-- Snowflake Schema

-- Same as Star Schema, but with normalized Location Dimension

-- Normalized Location Dimension Table
CREATE TABLE Normalized_Location_Dimension (
                                               location_id SERIAL PRIMARY KEY,
                                               location_name VARCHAR(100)
);

-- Location Details Table (Normalized)
CREATE TABLE Normalized_Location_Details (
                                             location_id INT REFERENCES Normalized_Location_Dimension(location_id),
                                             latitude NUMERIC(9, 6),
                                             longitude NUMERIC(9, 6),
                                             region VARCHAR(50)
);



-- INSERT INTO STAR SCHEMA
-- Insert into Date Dimension
INSERT INTO Date_Dimension (date, day_of_week, month, year)
VALUES
    ('2024-01-01', 'Monday', 'January', 2024),
    ('2024-01-02', 'Tuesday', 'January', 2024),
    ('2024-01-03', 'Wednesday', 'January', 2024);

-- Insert into Location Dimension
INSERT INTO Location_Dimension (location_name, latitude, longitude, region)
VALUES
    ('City A', 40.7128, -74.0060, 'Northeast'),
    ('City B', 34.0522, -118.2437, 'West'),
     ('City C', 51.5074, -0.1278, 'Europe');

-- Insert into Temperature Dimension
INSERT INTO Temperature_Dimension (temperature, humidity, wind_speed)
VALUES
    (25.5, 60.0, 10.0),
    (20.3, 55.5, 8.5),
     (18.7, 65.2, 12.1);

-- Insert into Precipitation Dimension
INSERT INTO Precipitation_Dimension (precipitation_type, precipitation_intensity)
VALUES
    ('Rain', 'Light'),
    ('Snow', 'Heavy'),
    ('Thunderstorm', 'Moderate');

-- Insert into Weather Fact Table
INSERT INTO Weather_Fact (date_id, location_id, temperature_id, precipitation_id)
VALUES
    (1, 1, 1, 1), -- Sample weather measurement
    (2, 2, 2, 2),
    (3, 3, 3, 3);



-- Insert into Normalized Location Dimension
INSERT INTO Normalized_Location_Dimension (location_name)
VALUES
    ('KAZAN'),
    ('MOSCOW'),
    ('KRASNODAR'),
    ('SAINT PETERSBURG'),
    ('SIBERIA');

-- Insert into Location Details Table (Normalized)
INSERT INTO Normalized_Location_Details (location_id, latitude, longitude, region)
VALUES
    (1, 40.7128, -74.0060, 'Northeast'),
    (2, 34.0522, -118.2437, 'West'),
    (3, 41.8781, -87.6298, 'Midwest'),
    (4, 29.7604, -95.3698, 'South'),
    (5, 33.4484, -112.0740, 'West');









-------- LAB 9 QUERIES --------
--1
SELECT region, COUNT(*) AS measurement_count
FROM Weather_Fact wf
         JOIN Location_Dimension ld ON wf.location_id = ld.location_id
GROUP BY region;
--Explanation: This query calculates the number of weather measurements recorded in each region.
--It joins the Weather_Fact table with the Location_Dimension table on the location_id column.
--Then, it groups the results by the region column and counts the number of rows in each group using the COUNT(*) function.


--2
SELECT ld.region, EXTRACT(MONTH FROM dd.date) AS month, AVG(td.temperature) AS avg_temperature
FROM Weather_Fact wf
         JOIN Date_Dimension dd ON wf.date_id = dd.date_id
         JOIN Location_Dimension ld ON wf.location_id = ld.location_id
         JOIN Temperature_Dimension td ON wf.temperature_id = td.temperature_id
GROUP BY ld.region, EXTRACT(MONTH FROM dd.date)
HAVING COUNT(*) > 50;
--Explanation: This query calculates the average temperature for each month in regions where there are more than 50 weather measurements.
--It joins the Weather_Fact table with the Date_Dimension, Location_Dimension, and Temperature_Dimension tables.
--The results are grouped by region and month, and the HAVING clause filters out groups with fewer than 50 measurements.


--3
SELECT ld.location_name, MAX(pd.precipitation_intensity) AS max_intensity
FROM Weather_Fact wf
         JOIN Location_Dimension ld ON wf.location_id = ld.location_id
         JOIN Precipitation_Dimension pd ON wf.precipitation_id = pd.precipitation_id
GROUP BY ld.location_name;
--Explanation: This query finds the maximum precipitation intensity recorded in each location.
--It joins the Weather_Fact table with the Location_Dimension and Precipitation_Dimension tables.
--The results are grouped by location_name, and the MAX function is used to find the maximum precipitation intensity in each group.


--4
SELECT dd.day_of_week, AVG(td.humidity) AS avg_humidity
FROM Weather_Fact wf
         JOIN Date_Dimension dd ON wf.date_id = dd.date_id
         JOIN Temperature_Dimension td ON wf.temperature_id = td.temperature_id
GROUP BY dd.day_of_week;
--Explanation: This query calculates the average humidity for each day of the week.
--It joins the Weather_Fact table with the Date_Dimension and Temperature_Dimension tables.
--The results are grouped by day_of_week, and the AVG function calculates the average humidity in each group.

--5
SELECT ld.region
FROM Weather_Fact wf
         JOIN Location_Dimension ld ON wf.location_id = ld.location_id
         JOIN Temperature_Dimension td ON wf.temperature_id = td.temperature_id
GROUP BY ld.region
HAVING AVG(td.wind_speed) > 10;
--Explanation: This query identifies the regions where the average wind speed is greater than 10.
--It joins the Weather_Fact table with the Location_Dimension and Temperature_Dimension tables.
--The results are grouped by region, and the HAVING clause filters out groups where the average wind speed is not greater than 10.





---------- LAB 10 QUERIES ----------
--1
SELECT region, EXTRACT(MONTH FROM date) AS month, COUNT(*) AS measurement_count
FROM Weather_Fact wf
         JOIN Location_Dimension ld ON wf.location_id = ld.location_id
         JOIN Date_Dimension dd ON wf.date_id = dd.date_id
GROUP BY GROUPING SETS ((region, EXTRACT(MONTH FROM date)), (region), (EXTRACT(MONTH FROM date)));
--Explanation: This query calculates the total number of weather measurements recorded by region and month.
--It joins the Weather_Fact table with the Location_Dimension and Date_Dimension tables to get the region and month information.
--The EXTRACT function extracts the month from the date.
--The GROUP BY clause with GROUPING SETS specifies multiple grouping sets to calculate
--the measurement count for each combination of region and month, region only, and month only.

--2
SELECT region, day_of_week, AVG(temperature) AS avg_temperature
FROM Weather_Fact wf
         JOIN Location_Dimension ld ON wf.location_id = ld.location_id
         JOIN Date_Dimension dd ON wf.date_id = dd.date_id
         JOIN Temperature_Dimension td ON wf.temperature_id = td.temperature_id
GROUP BY GROUPING SETS ((region, day_of_week), (region), (day_of_week));
--Explanation: This query calculates the average temperature for each combination of region and day of the week.
--It joins the Weather_Fact table with the Location_Dimension, Date_Dimension,
--and Temperature_Dimension tables to get the region, day of the week, and temperature information.
--The GROUP BY clause with GROUPING SETS specifies multiple grouping sets to calculate
--the average temperature for each combination of region and day of the week, region only, and day of the week only.

--3
SELECT location_name, EXTRACT(MONTH FROM date) AS month,
       SUM(CASE WHEN pd.precipitation_intensity ~ '^\d+(\.\d+)?$' THEN precipitation_intensity::numeric ELSE 0 END) AS total_intensity
FROM Weather_Fact wf
         JOIN Location_Dimension ld ON wf.location_id = ld.location_id
         JOIN Date_Dimension dd ON wf.date_id = dd.date_id
         JOIN Precipitation_Dimension pd ON wf.precipitation_id = pd.precipitation_id
GROUP BY ROLLUP (location_name, EXTRACT(MONTH FROM date));
--Explanation: This query calculates the total precipitation intensity recorded by location and month.
--It retrieves data from the Weather_Fact table, which contains information about weather measurements,
--and joins it with other dimension tables such as Location_Dimension, Date_Dimension,
--and Precipitation_Dimension to fetch the relevant attributes.


--4
SELECT region, precipitation_type, MAX(wind_speed) AS max_wind_speed
FROM Weather_Fact wf
         JOIN Location_Dimension ld ON wf.location_id = ld.location_id
         JOIN Precipitation_Dimension pd ON wf.precipitation_id = pd.precipitation_id
         JOIN Temperature_Dimension td ON wf.temperature_id = td.temperature_id
GROUP BY GROUPING SETS ((region, precipitation_type), (region), (precipitation_type));
--Explanation: This query finds the maximum wind speed recorded for each combination of region and precipitation type.
--It joins the Weather_Fact table with the Location_Dimension, Precipitation_Dimension, and Temperature_Dimension tables
--to get the region, precipitation type, and wind speed information.
--The GROUP BY clause with GROUPING SETS specifies multiple grouping sets to find the maximum wind speed
--for each combination of region and precipitation type, region only, and precipitation type only.


--5
SELECT EXTRACT(MONTH FROM date) AS month, AVG(humidity) AS avg_humidity
FROM Weather_Fact wf
         JOIN Date_Dimension dd ON wf.date_id = dd.date_id
         JOIN Temperature_Dimension td ON wf.temperature_id = td.temperature_id
GROUP BY GROUPING SETS ((EXTRACT(MONTH FROM date)), ());
--Explanation: This query calculates the average humidity for each month across all regions.
--It joins the Weather_Fact table with the Date_Dimension and Temperature_Dimension tables to get the month and humidity information.
--The GROUP BY clause with GROUPING SETS specifies multiple grouping sets to calculate the average humidity
--for each month and an additional grouping set to calculate the overall average humidity across all months.


