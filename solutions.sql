-- Netflix Project
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	 show_id VARCHAR(6),	
	 type VARCHAR(10),
	 title VARCHAR(120),
	 director VARCHAR(208),
	 casts VARCHAR(800),
	 country VARCHAR(150),
	 date_added	VARCHAR(50),
	 release_year INT,
	 rating	VARCHAR(10),
	 duration VARCHAR(15),
	 listed_in	VARCHAR(100),
	 description VARCHAR(250)
);

SELECT * FROM netflix;

SELECT
Count(*)
as Total_content
FROM netflix;

SELECT
DISTINCT type
FROM netflix;

-- 15 Business Problems
--1. Count the number of Movies vs TV Shows

SELECT 
type,COUNT(*)as count 
from netflix 
GROUP BY type;


--2. Find the most common rating for movies and TV shows

SELECT
type,
rating
FROM
(SELECT 
type, 
rating,
COUNT(*) as cnt,
RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as rnk
FROM netflix
GROUP BY 1, 2) AS t1
WHERE rnk = 1;

--3. List all movies released in a specific year (e.g., 2020)

SELECT 
title, type, release_year 
FROM netflix 
WHERE type = 'Movie' AND release_year = 2020;

--4. Find the top 5 countries with the most content on Netflix

SELECT 
country, COUNT(*) as count 
FROM netflix 
GROUP BY country 
ORDER BY count 
DESC LIMIT 5;

--5. Identify the longest movie

SELECT * FROM 
 (SELECT DISTINCT title as movie,
  split_part(duration,' ',1):: numeric as duration 
  FROM netflix
  WHERE type ='Movie') as subquery
WHERE duration = (SELECT MAX(split_part(duration,' ',1):: numeric ) FROM netflix)


--6. Find content added in the last 5 years
SELECT *
FROM netflix
WHERE 
TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT * 
FROM netflix 
WHERE director LIKE '%Rajiv Chilaka%';

--8. List all TV shows with more than 5 seasons
SELECT * 
FROM (SELECT *, SPLIT_PART(duration, ' ', 1):: numeric as season 
	  FROM netflix 
	  WHERE type = 'TV Show') AS subquery
WHERE season > 5;


--9. Count the number of content items in each genre

SELECT
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY 1;


--10. List all movies that are documentaries

SELECT 
title, listed_in 
FROM netflix 
WHERE listed_in = 'Documentaries'

--11. Find all content without a director

SELECT * FROM netflix WHERE director IS NULL

--12. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT * FROM netflix WHERE casts LIKE '%Salman Khan%'

--13. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT 
actors, COUNT(actors)
FROM(SELECT
	 title,
	 UNNEST(STRING_TO_ARRAY(casts, ',')) as actors
	 FROM netflix
	 WHERE country = 'India')
GROUP BY(actors)
ORDER BY count DESC
LIMIT 10

--14.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.

SELECT Category, COUNT(Category) as total_content
FROM(SELECT *,
	 CASE
	 WHEN description ILIKE '%kill%'
	 	  OR
	 	  description ILIKE '%violence%'
	 	  THEN 'Bad'
	 ELSE 'Good'
	 END Category
	 FROM netflix)
GROUP BY Category




