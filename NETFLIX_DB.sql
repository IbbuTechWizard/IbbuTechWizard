CREATE DATABASE Netflix_db
USE Netflix_db;
CREATE TABLE users (
user_id INT PRIMARY KEY auto_increment,
name VARCHAR(100) NOT NULL,
email varchar(100) unique not null,
registration_date Date not null,
plan ENUM('BASIC','STANDARD','PREMIUM') DEFAULT 'BASIC'
);
CREATE TABLE Movies (
 movie_id INT PRIMARY KEY AUTO_INCREMENT,
 title VARCHAR(200) NOT NULL,
 genre VARCHAR(100) NOT NULL,
 release_year YEAR NOT NULL,
 rating DECIMAL(3, 1) NOT NULL
 );
 CREATE TABLE WatchHistory (
 watch_id INT PRIMARY KEY AUTO_INCREMENT,
 user_id INT,
 movie_id INT,
 watched_date DATE NOT NULL,
 completion_percentage INT CHECK (completion_percentage >= 0 AND completion_percentage <= 100),
 FOREIGN KEY (user_id) REFERENCES Users(user_id),
 FOREIGN KEY (movie_id) REFERENCES Movies(movie_id)
);
CREATE TABLE Reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    movie_id INT,
    user_id INT,
    review_text TEXT,
    rating DECIMAL(2, 1) CHECK (rating >= 0 AND rating <= 5),
    review_date DATE NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
INSERT INTO Users (name, email, registration_date, plan) 
VALUES
('John Doe', 'john.doe@example.com', '2024-01-10', 'Premium'),
('Jane Smith', 'jane.smith@example.com', '2024-01-15', 'Standard'),
('Alice Johnson', 'alice.johnson@example.com', '2024-02-01', 'Basic'),
('Bob Brown', 'bob.brown@example.com', '2024-02-20', 'Premium');

INSERT INTO Movies (title, genre, release_year, rating) 
VALUES
('Stranger Things', 'Drama', 2016, 8.7),
('Breaking Bad', 'Crime', 2008, 9.5),
('The Crown', 'History', 2016, 8.6),
('The Witcher', 'Fantasy', 2019, 8.2),
('Black Mirror', 'Sci-Fi', 2011, 8.8);

INSERT INTO WatchHistory (user_id, movie_id, watched_date, completion_percentage) 
VALUES
(1, 1, '2024-02-05', 100),
(2, 2, '2024-02-06', 80),
(3, 3, '2024-02-10', 50),
(4, 4, '2024-02-15', 100),
(1, 5, '2024-02-18', 90);

INSERT INTO Reviews (movie_id, user_id, review_text, rating, review_date) 
VALUES
(1, 1, 'Amazing storyline and great characters!', 4.5, '2024-02-07'),
(2, 2, 'Intense and thrilling!', 5.0, '2024-02-08'),
(3, 3, 'Good show, but slow at times.', 3.5, '2024-02-12'),
(4, 4, 'Fantastic visuals and acting.', 4.8, '2024-02-16');

1. List all users subscribed to the Premium plan:

SELECT name, email 
FROM Users 
WHERE plan = 'Premium';

Retrieve all movies in the Drama genre with a rating higher than 8.5:

SELECT title,genre,rating
from movies
where rating > 8.5

SELECT title, genre, rating 
FROM Movies 
WHERE genre = 'Drama' AND rating > 8.5;

Find the average rating of all rating for released after 2015:


SELECT AVG(rating) AS average_rating, movie_id
FROM reviews
WHERE review_date > '2015-01-01'
GROUP BY movie_id;

Find the average rating of all movies released after 2015:

SELECT AVG(rating) AS average_rating 
FROM Movies 
WHERE release_year > 2015;

-- 4. List the names of users who have watched the movie Stranger Things along with their completion percentage:

SELECT u.name,w.completion_percentage
from users u
join watchHistory w on u.user_id=w.user_id
join movies m on w.movie_id=m.movie_id
where title='Stranger Things';
 5. Find the name of the user(s) who rated a movie the highest among all reviews:
 select u.name
 from users u
 join reviews r on u.user_id=r.user_id
 WHERE R.rating = (SELECT MAX(rating) FROM Reviews);
 
 SELECT U.name 
FROM Users U 
JOIN Reviews R ON U.user_id = R.user_id 
WHERE R.rating = (SELECT MAX(rating) FROM Reviews);

6 Calculate the number of movies watched by each user and sort by the highest count:

SELECT U.name, COUNT(W.watch_id) AS movies_watched 
FROM Users U 
JOIN WatchHistory W ON U.user_id = W.user_id 
GROUP BY U.user_id 
ORDER BY movies_watched DESC;

.List all movies watched by John Doe, including their genre, rating, and his completion percentage:
Select u.name,m.genre,m.rating,w.completion_percentage
From Movies M
JOIN WatchHistory W ON M.movie_id = W.movie_id
JOIN Users U ON W.user_id = U.user_id
WHERE U.name = 'John Doe';


8.Update the movies rating for Stranger Things
SET SQL_SAFE_UPDATES = 0;

Update Movies
set rating = 8.9
where title ='Stranger Things';

 9.Remove all reviews for movies with a rating below 4.0:
 Delete reviews


WHERE movie_id IN (SELECT movie_id FROM Movies WHERE rating < 4.0);
10 Fetch all users who have reviewed a movie but have not watched it completely (completion percentage < 100
 select u.name,M.title,r.review_text
 From Users u
 join Reviews r on u.user_id=r.user_id
 JOIN Movies M ON R.movie_id = M.movie_id
 left join WatchHistory w on m.movie_id=w.movie_id
 where w.completion_percentage > 100;
 
 
 SELECT U.name, M.title, R.review_text 
FROM Users U
JOIN Reviews R ON U.user_id = R.user_id
JOIN Movies M ON R.movie_id = M.movie_id
LEFT JOIN WatchHistory W ON U.user_id = W.user_id AND M.movie_id = W.movie_id
WHERE (W.completion_percentage IS NULL OR W.completion_percentage < 100);


 11. List all movies watched by John Doe along with their genre and his completion percentage:
 Select m.title,m.genre,w.completion_percentage
 From Movies m
 JOin WatchHistory W ON M.movie_id = W.movie_id
 join Users u on W.user_id=u.user_id
 Where u.name='John Doe';
 
.Retrieve all users who have reviewed the movie Stranger Things, including their review text and rating:

Select U.name,r.rating,r.review_text
from reviews r
Join movies m on r.movie_id=m.movie_id
join USERS u on r.user_id=u.user_id
WHERE M.title = 'Stranger Things';
 
SELECT U.name, R.review_text, R.rating 
FROM Users U
JOIN Reviews R ON U.user_id = R.user_id
JOIN Movies M ON R.movie_id = M.movie_id
WHERE M.title = 'Stranger Things';

13.Fetch the watch history of all users, including their name, email, movie title, genre, watched date, and completion percentage:
Select u.name,u.email,m.title,m.genre,w.watched_date,w.completion_percentage
from users u
join WatchHistory W ON U.user_id = W.user_id
join  movies m on w.movie_id = m.movie_id;

SELECT U.name, U.email, M.title, M.genre, W.watched_date, W.completion_percentage 
FROM Users U
JOIN WatchHistory W ON U.user_id = W.user_id
JOIN Movies M ON W.movie_id = M.movie_id;

List all movies along with the total number of reviews and average rating for each movie, including only movies with at least two reviews:






SELECT M.title, COUNT(R.review_id) AS total_reviews, AVG(R.rating) AS average_rating 
FROM Movies M
JOIN Reviews R ON M.movie_id = R.movie_id
GROUP BY M.movie_id
HAVING COUNT(R.review_id) >= 2;