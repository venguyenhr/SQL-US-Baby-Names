-- OBJECTIVE 1: Track changes in name popularity

-- 1. Find the overall most popular girl and boy names and Show how they have changed in popularity rankings over the years

-- 1.1.a. Popular girl name:
SELECT Name, SUM(Births) AS num_babies
FROM names
WHERE Gender = 'F'
GROUP BY Name
ORDER BY num_babies DESC
LIMIT 1; -- Jessica

-- 1.1.b. How popular girl name has changed in popularity rankings over the years
SELECT * FROM
(WITH girl_names AS (SELECT Year, Name, SUM(Births) AS num_babies
FROM names
WHERE Gender = 'F'
GROUP BY Year, Name)

SELECT Year, Name, 
	   row_number() OVER (PARTITION BY year ORDER BY num_babies DESC) AS popularity
FROM girl_names) AS Populariy_girl_names

WHERE Name = 'Jessica';

-- 1.2.a. Popular boy name:
SELECT Name, SUM(Births) AS num_babies
FROM names
WHERE Gender = 'M'
GROUP BY Name
ORDER BY num_babies DESC
LIMIT 1;  -- Michael

-- 1.2.b. How popular boy name has changed in popularity rankings over the years

SELECT * FROM
(WITH boy_names AS (SELECT Year, Name, SUM(Births) AS num_babies
FROM names
WHERE Gender = 'M'
GROUP BY Year, Name)

SELECT Year, Name, 
	   row_number() OVER (PARTITION BY year ORDER BY num_babies DESC) AS popularity
FROM boy_names) AS Populariy_boy_names

WHERE Name = 'Michael';




-- 2. Find the names with the biggest jumps in popularity from the first year of the data set to the last year

-- 2.1. TO find the year period in data base
Select Year
FROM names
GROUP BY Year;
-- From 1980 - 2009

-- 2.2. To find the jumps in the names' rankings over the years

WITH 	Sub_Ranking_Table AS 
		(WITH 	Ranking_1980 AS (SELECT Name, 
				row_number () OVER (ORDER BY SUM(Births) DESC) AS Ranking_in_1980
FROM names
WHERE Year = 1980
GROUP BY Name),
		Ranking_2009 AS (SELECT Name, 
				row_number () OVER (ORDER BY SUM(Births) DESC) AS Ranking_in_2009
FROM names
WHERE Year = 2009
GROUP BY Name)
SELECT Ranking_1980.Name, Ranking_in_1980, Ranking_in_2009
FROM Ranking_1980
JOIN Ranking_2009 ON Ranking_1980.Name = Ranking_2009.Name)
SELECT Name, Ranking_in_1980, Ranking_in_2009, CAST(Ranking_in_1980 AS SIGNED) - CAST(Ranking_in_2009 AS SIGNED) AS Jumps
FROM Sub_Ranking_Table
GROUP BY Name
ORDER BY Jumps DESC
LIMIT 10;


-- Objective 2: Compare popularity across decades - Your second objective is to find the top 3 girl names and top 3 boy names for each year, and also for each decade.

-- 1. For each year, return the 3 most popular girl names and 3 most popular boy names

WITH 	Sub_Male_Ranking_Table AS (SELECT 	
		Year, 
		Name, 
        Gender,
        SUM(Births) AS total_births,
        row_number() OVER (partition by Year Order by SUM(Births) DESC) AS popularity
From names
WHERE Gender = 'M'
GROUP BY Year, Name, Gender
ORDER BY Year DESC),
		Male_Ranking_Table AS (SELECT *
FROM Sub_Male_Ranking_Table
WHERE popularity <=3
ORDER BY Year ASC),
		Sub_Female_Ranking_Table AS (SELECT 	
		Year, 
		Name, 
        Gender,
        SUM(Births) AS total_births,
        row_number() OVER (partition by Year Order by SUM(Births) DESC) AS popularity
From names
WHERE Gender = 'F'
GROUP BY Year, Name, Gender
ORDER BY Year DESC),
		Female_Ranking_Table AS (SELECT *
FROM Sub_Female_Ranking_Table
WHERE popularity <=3
ORDER BY Year ASC)
		SELECT 
        Male_Ranking_Table.Year,
		MAX(CASE WHEN Male_Ranking_Table.Gender = 'M' AND Male_Ranking_Table.popularity = 1 THEN Male_Ranking_Table.Name END) AS Male_1st,
		MAX(CASE WHEN Male_Ranking_Table.Gender = 'M' AND Male_Ranking_Table.popularity = 2 THEN Male_Ranking_Table.Name END) AS Male_2nd,
		MAX(CASE WHEN Male_Ranking_Table.Gender = 'M' AND Male_Ranking_Table.popularity = 3 THEN Male_Ranking_Table.Name END) AS Male_3rd,
		MAX(CASE WHEN Female_Ranking_Table.Gender = 'F' AND Female_Ranking_Table.popularity = 1 THEN Female_Ranking_Table.Name END) AS Female_1st,
		MAX(CASE WHEN Female_Ranking_Table.Gender = 'F' AND Female_Ranking_Table.popularity = 2 THEN Female_Ranking_Table.Name END) AS Female_2nd,
		MAX(CASE WHEN Female_Ranking_Table.Gender = 'F' AND Female_Ranking_Table.popularity = 3 THEN Female_Ranking_Table.Name END) AS Female_3rd
FROM Male_Ranking_Table
LEFT JOIN Female_Ranking_Table ON Male_Ranking_Table.Year = Female_Ranking_Table.Year
GROUP BY Male_Ranking_Table.Year
ORDER BY Male_Ranking_Table.Year ASC;

-- OR

SELECT 
    Year,
    MAX(CASE WHEN Gender = 'M' AND popularity = 1 THEN Name END) AS Male_1st,
    MAX(CASE WHEN Gender = 'M' AND popularity = 2 THEN Name END) AS Male_2nd,
    MAX(CASE WHEN Gender = 'M' AND popularity = 3 THEN Name END) AS Male_3rd,
    MAX(CASE WHEN Gender = 'F' AND popularity = 1 THEN Name END) AS Female_1st,
    MAX(CASE WHEN Gender = 'F' AND popularity = 2 THEN Name END) AS Female_2nd,
    MAX(CASE WHEN Gender = 'F' AND popularity = 3 THEN Name END) AS Female_3rd
FROM (
    SELECT 
        Year, 
        Name, 
        Gender,
        ROW_NUMBER() OVER (PARTITION BY Year, Gender ORDER BY SUM(Births) DESC) AS popularity
    FROM names
    GROUP BY Year, Name, Gender
) AS Ranking_Table
WHERE popularity <= 3
GROUP BY Year
ORDER BY Year ASC;

-- 2. For each decade, return the 3 most popular girl names and 3 most popular boy names

SELECT 
    Decade,
    MAX(CASE WHEN Gender = 'M' AND popularity = 1 THEN Name END) AS Male_1st,
    MAX(CASE WHEN Gender = 'M' AND popularity = 2 THEN Name END) AS Male_2nd,
    MAX(CASE WHEN Gender = 'M' AND popularity = 3 THEN Name END) AS Male_3rd,
    MAX(CASE WHEN Gender = 'F' AND popularity = 1 THEN Name END) AS Female_1st,
    MAX(CASE WHEN Gender = 'F' AND popularity = 2 THEN Name END) AS Female_2nd,
    MAX(CASE WHEN Gender = 'F' AND popularity = 3 THEN Name END) AS Female_3rd
FROM (
	WITH Decade_Table AS (SELECT *,
		CASE
			WHEN Year < 1990 THEN '1980s' 
            WHEN Year < 2000 THEN '1990s'
            ELSE '2000s'
		END AS Decade
	From Names)
    SELECT 
        Decade,
        Name, 
        Gender,
        ROW_NUMBER() OVER (PARTITION BY Decade, Gender ORDER BY SUM(Births) DESC) AS popularity
    FROM Decade_Table
    GROUP BY Decade, Name, Gender
) AS Ranking_Table
WHERE popularity <= 3
GROUP BY Decade
ORDER BY Decade ASC;
            
 
 
 
-- Objective 3: Compare popularity across regions, is to find the number of babies born in each region, and also return the top 3 girl names and top 3 boy names within each region.

-- 1. Return the number of babies born in each of the six regions

WITH adjusted_regions AS (
		SELECT 	State,
				CASE WHEN Region = 'New England' THEN 'New_England' ELSE Region END AS adjusted_region
		FROM regions
        UNION
        SELECT 	'MI' AS State, 'Midwest' AS REgion
        FROM regions),
Total_Table AS (SELECT 			t1.State,
								t2.adjusted_region,
								t1.Year,
								t1.Name,
                                t1.Births
From names t1
JOIN adjusted_regions t2
		ON t1.State = t2.State)     
SELECT 	adjusted_region AS Region,
		SUM(births) AS Total_births
FROM Total_Table
GROUP BY Region
ORDER BY Total_births DESC;

-- 2. Return the 3 most popular girl names and 3 most popular boy names within each region

WITH adjusted_regions AS (
		SELECT 	State,
				CASE WHEN Region = 'New England' THEN 'New_England' ELSE Region END AS adjusted_region
		FROM regions
        UNION
        SELECT 	'MI' AS State, 'Midwest' AS REgion
        FROM regions),
Total_Table AS (SELECT 			t1.State,
								t2.adjusted_region,
								t1.Year,
								t1.Name,
								t1.Gender,
                                t1.Births
From names t1
JOIN adjusted_regions t2
		ON t1.State = t2.State),
Regions_Birth_popularity AS (SELECT 	adjusted_region AS Region,
		Name,
		Gender,
		SUM(births) AS Total_births,
        ROW_NUMBER() OVER (PARTITION BY adjusted_region, Gender ORDER BY SUM(births) DESC) AS Regions_popularity	
FROM Total_Table
GROUP BY Region, Gender, Name
ORDER BY Total_births DESC)
SELECT 	Region,
		MAX(CASE WHEN Gender ='M' AND Regions_popularity ='1' THEN Name END) AS 1st_Regions_Male_Name,
        MAX(CASE WHEN Gender ='M' AND Regions_popularity ='2' THEN Name END) AS 2nd_Regions_Male_Name,
        MAX(CASE WHEN Gender ='M' AND Regions_popularity ='3' THEN Name END) AS 3rd_Regions_Male_Name,
        MAX(CASE WHEN Gender ='F' AND Regions_popularity ='1' THEN Name END) AS 1st_Regions_Female_Name,
        MAX(CASE WHEN Gender ='F' AND Regions_popularity ='2' THEN Name END) AS 2nd_Regions_Female_Name,
        MAX(CASE WHEN Gender ='F' AND Regions_popularity ='3' THEN Name END) AS 3rd_Regions_Female_Name
FROM Regions_Birth_popularity
WHERE Regions_popularity <=3
GROUP BY Region;




-- Objective 4: Explore unique names in the dataset, objective is to find the most popular androgynous names, the shortest and longest names, and the state with the highest percent of babies named "Chris".

-- 4.1. Find the 10 most popular androgynous names (names given to both females and males)

SELECT
			ROW_NUMBER() OVER (ORDER BY total_births DESC) AS Name_Popularity,
			Name,
            total_births
FROM  		(SELECT
            Name,
            COUNT(DISTINCT Gender) AS num_Genders,
			SUM(Births) AS total_births
FROM		Names
GROUP BY	Name
HAVING		num_Genders ='2'
ORDER BY	total_births DESC
LIMIT 		10) AS Total_Name_Births
ORDER BY 	total_births DESC;


-- 4.2. Find the length of the shortest and longest names, and identify the most popular short names (those with the fewest characters) and long names (those with the most characters)

WITH Unique_Names AS (
    SELECT DISTINCT Name, CHAR_LENGTH(Name) AS Name_Length, SUM(Births) AS total_Births
    FROM Names
    GROUP BY Name
),
Length_Limits AS (
    SELECT
        MAX(Name_Length) AS Max_Length,
        MIN(Name_Length) AS Min_Length
    FROM Unique_Names
)
SELECT u.Name, u.Name_Length, u.total_Births
FROM Unique_Names u
JOIN Length_Limits l
    ON u.Name_Length = l.Max_Length OR u.Name_Length = l.Min_Length
ORDER BY u.Name_Length, total_Births DESC;


-- 4.3. The founder of Maven Analytics is named Chris. Find the state with the highest percent of babies named "Chris"

WITH 	adjusted_regions AS (
		SELECT 	State,
				CASE WHEN Region = 'New England' THEN 'New_England' ELSE Region END AS adjusted_region
		FROM regions
        UNION
        SELECT 	'MI' AS State, 'Midwest' AS adjusted_region
        FROM regions),
		Chris_Names AS(
		SELECT 		State,
					Name,
                    SUM(births) AS Chris_total_Births
		FROM		Names
        WHERE 		Name = 'Chris'
        GROUP BY 	State, Name
        ORDER BY	State ASC),
        Names_Total_Births AS(
        SELECT		State,
					SUM(births) AS total_Births
		FROM 		Names
        GROUP BY	State
		ORDER BY 	State ASC)
SELECT		t1.State,
			t3.adjusted_region,
			t1.Chris_total_Births,
            t2.total_Births,
            CONCAT((t1.Chris_total_Births / t2.total_Births * 100),'%')  AS percentages_Chris_Name
FROM		Chris_Names t1
JOIN		Names_Total_Births t2   		ON			t1.State = t2.State
JOIN		adjusted_regions t3				ON 			t1.State = t3.State
ORDER BY 	percentages_Chris_Name DESC;

            
		
					
        





