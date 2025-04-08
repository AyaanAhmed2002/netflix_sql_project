# Netflix Movies and TV Shows Data Analysis using SQL

![](https://github.com/najirh/netflix_sql_project/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
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
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT 
type,COUNT(*)as count 
FROM netflix 
GROUP BY type;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
SELECT
type,
rating
FROM(SELECT 
     type, 
     rating,
     COUNT(*) as cnt,
     RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as rnk
     FROM netflix
     GROUP BY 1, 2) AS t1
WHERE rnk = 1;
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT 
title, type, release_year 
FROM netflix 
WHERE type = 'Movie' AND release_year = 2020;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT 
country, COUNT(*) as count 
FROM netflix 
GROUP BY country 
ORDER BY count 
DESC LIMIT 5;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT * FROM 
 (SELECT DISTINCT title as movie,
  split_part(duration,' ',1):: numeric as duration 
  FROM netflix
  WHERE type ='Movie') as subquery
WHERE duration = (SELECT MAX(split_part(duration,' ',1):: numeric ) FROM netflix)
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT *
FROM netflix
WHERE 
TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT * 
FROM netflix 
WHERE director LIKE '%Rajiv Chilaka%';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT * 
FROM (SELECT *, SPLIT_PART(duration, ' ', 1):: numeric as season 
	  FROM netflix 
	  WHERE type = 'TV Show') AS subquery
WHERE season > 5;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
SELECT
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY 1;
```

**Objective:** Count the number of content items in each genre.

### 10. List All Movies that are Documentaries

```sql
SELECT
title, listed_in 
FROM netflix
WHERE listed_in = '%Documentaries';
```

**Objective:** Retrieve all movies classified as documentaries.

### 11. Find All Content Without a Director

```sql
SELECT * FROM netflix WHERE director IS NULL;
```

**Objective:** List content that does not have a director.

### 12. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 13. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
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
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 14. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.
