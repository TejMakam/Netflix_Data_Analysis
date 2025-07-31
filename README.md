📊 Netflix Data Analysis Project (MySQL)
This project contains SQL queries to explore and analyze Netflix content data using MySQL. The dataset includes movies and TV shows with details like title, director, cast, country, date added, rating, genre, and more.

🛠️ Database Setup
sql
Copy
Edit
CREATE DATABASE netflix;
USE netflix;

CREATE TABLE netflix (
    show_id VARCHAR(6) PRIMARY KEY,
    type VARCHAR(10),
    title VARCHAR(150),
    director VARCHAR(250),
    cast VARCHAR(1000),
    country VARCHAR(150),
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(20),
    listed_in VARCHAR(100),
    description VARCHAR(300)
);



📌 Business Questions Answered
No.	Question
Q1	Count the number of movies and TV shows
Q2	Find the most common rating for each content type
Q3	List all movies released in a specific year (e.g., 2020)
Q4	Find top 5 countries with the most content
Q5	Identify the longest movie
Q6	Find content added in the last 5 years
Q7	Find all content by director ‘Rajiv Chilaka’
Q8	List all TV shows with more than 5 seasons
Q9	Count content in each genre (multi-value split using recursion)
Q10	Find average content added per year by India and return top 5 years
Q11	List all movies that are documentaries
Q12	Find content with no director listed
Q13	Count movies featuring Salman Khan in the last 10 years
Q14	Top 10 most frequent actors in Indian content
Q15	Categorize content as “Good” or “Bad” based on keywords (kill, violence) in description

🧠 Key Concepts Used

JOINs
GROUP BY, ORDER BY, LIMIT
Window Functions: RANK(), ROW_NUMBER()
String Functions: SUBSTRING_INDEX(), STR_TO_DATE()
Recursive CTEs for splitting multi-valued fields (cast, genre)
CASE Statements for categorization
Date Calculations using CURDATE() and INTERVAL



