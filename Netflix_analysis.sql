-- NETFLIX PROJECT

create database netflix;
use netflix;

create table netflix
	( 
		show_id	VARCHAR(6) PRIMARY KEY,
        type VARCHAR(10),	
        title VARCHAR(150),
        director VARCHAR(250),
        cast VARCHAR(1000),
        country	VARCHAR(150),
        date_added	VARCHAR(50),
        release_year INT,	
        rating VARCHAR(10),
        duration VARCHAR(20),
        listed_in VARCHAR(100),
        description VARCHAR(300)
	);

select * from netflix;    
drop table netflix;

select count(*) from netflix;    

select 
	distinct type
    from netflix; 


-- Business Problems

-- Q1 Count the number of movies and TV shows
select 
	type,
    count(*) as count 
    from netflix group by type;
    
-- Q2 Find the most common rating for movies and TV shows
SELECT 
    type, 
    rating,
    rating_count 
FROM (
    SELECT 
        type, 	
        rating,
        COUNT(*) AS rating_count,
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rnk
    FROM netflix
    GROUP BY type, rating
) AS t1
WHERE rnk = 1;

-- Q3 List all movies released in a specific year (ex: 2020)
select * from netflix 
where 
	type = 'Movie' 
    and 
	release_year = 2020;

-- Q4 Find top 5 countries with the most content on netflix
select 
	country,
    count(show_id) as no_of_movies 
    from netflix 
    group by country
    order by 2 desc limit 5;
    
-- Q5 Identify the longest movie
SELECT 
   *
FROM netflix
WHERE type = 'Movie'
ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC LIMIT 1;

-- converting a string to int using substring_index function
select * from netflix
order by cast(substring_index(show_id, 's', 1)as unsigned);

-- Q6 Find content added in last 5 years
select * 
from netflix 
where 
		str_to_date(date_added, '%M %d, %Y') >= CURDATE() - INTERVAL 5 year;
        
-- Q7 Find all the movies/TV shows by director 'Rajiv Chilaka'
select * from netflix
where
	director LIKE '%Rajiv Chilaka%';
    
-- Q8 List all TV shows with more than 5 seasons
select * from netflix
where 
	type = 'TV Show'
    and
    SUBSTRING_INDEX(duration, ' ', 1) > 5;
    
-- Q9 Count the number of content items in each genre
WITH RECURSIVE genre_split AS (
  SELECT 
    show_id,
    TRIM(SUBSTRING_INDEX(listed_in, ',', 1)) AS genre,
    SUBSTRING_INDEX(listed_in, ',', -1) AS remaining
  FROM netflix
  WHERE listed_in IS NOT NULL

  UNION ALL

  SELECT 
    show_id,
    TRIM(SUBSTRING_INDEX(remaining, ',', 1)),
    SUBSTRING_INDEX(remaining, ',', -1)
  FROM genre_split
  WHERE remaining LIKE '%,%'
)

SELECT 
  genre,
  COUNT(DISTINCT show_id) AS show_count
FROM genre_split
GROUP BY genre;

-- Q10 Find each year and the avg number of content release by India on netlfix.
-- return top 5 year with highest avg content release;
select 
	extract(year from str_to_date(date_added, '%M %d, %Y')) as year,
    count(*) as total_in_year,
    round(
    count(*)/(select count(*) from netflix where country='India') * 100, 2) as average
from netflix 
where country = 'India'
group by year
order by average desc limit 5;

-- Q11 List all movies that are documentaries
select * from netflix 
where type='Movie'
and
listed_in like '%documentaries%';

-- Q12 Find all the content without a director
select * from netflix 
where 
	trim(director) = '';
    
-- Q13 Find how many movies actor 'Salman Khan' appeared in last 10 years
select count(*) as ct_of_SK_movies from netflix 
where 
	cast like '%Salman Khan%'
    and
    release_year >= year(curdate()) - 10;

-- Q14 Find the top 10 actors who have appeared in the highest number of movies produced in India
WITH RECURSIVE actor_split AS (
  SELECT 
    show_id,
    TRIM(SUBSTRING_INDEX(cast, ',', 1)) AS actor,
    SUBSTRING_INDEX(cast, ',', -1) AS remaining,
    country
  FROM netflix
  WHERE cast IS NOT NULL AND country LIKE '%India%'

  UNION ALL

  SELECT 
    show_id,
    TRIM(SUBSTRING_INDEX(remaining, ',', 1)),
    SUBSTRING_INDEX(remaining, ',', -1),
    country
  FROM actor_split
  WHERE remaining LIKE '%,%'
)

SELECT 
  actor,
  COUNT(DISTINCT show_id) AS total_content
FROM actor_split
WHERE actor IS NOT NULL AND actor != ''
GROUP BY actor
ORDER BY total_content DESC
LIMIT 10;

-- Q15 categorize the content based on the presence of keywords 'kill' and 'violence' in the description field. Lable content containg 
-- keywords as 'bad' and all other content as 'Good'. Count how many items fall into each category.
with new_table
as
(
	select *,
		case
			when description like '%kill%' or 
            description like '%violence%' then 'Bad'
            else 'Good'
            end as category
		from netflix
)
select 
	category,
	count(*) as total_content
from new_table
group by category;
