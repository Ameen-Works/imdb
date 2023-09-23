CREATE DATABASE imdb;

USE imdb;

CREATE TABLE Movie (movie_id INT AUTO_INCREMENT PRIMARY KEY,title VARCHAR(255) NOT NULL,release_date DATE,director VARCHAR(255),runtime INT,description TEXT);

CREATE TABLE Genre (genre_id INT AUTO_INCREMENT PRIMARY KEY,genre_name VARCHAR(255) NOT NULL);

CREATE TABLE MovieGenre (movie_id INT,genre_id INT,PRIMARY KEY (movie_id, genre_id),FOREIGN KEY (movie_id)REFERENCES Movie(movie_id),FOREIGN KEY (genre_id) REFERENCES Genre(genre_id));

CREATE TABLE Media (media_id INT AUTO_INCREMENT PRIMARY KEY,movie_id INT,media_type ENUM('Video', 'Image') NOT NULL,media_url VARCHAR(255) NOT NULL,FOREIGN KEY (movie_id) REFERENCES Movie(movie_id));

CREATE TABLE User (user_id INT AUTO_INCREMENT PRIMARY KEY,username VARCHAR(255) NOT NULL,password VARCHAR(255) NOT NULL,email VARCHAR(255) NOT NULL);

CREATE TABLE Review (review_id INT AUTO_INCREMENT PRIMARY KEY,user_id INT,movie_id INT,rating INT CHECK (rating >= 1 AND rating <= 5),review_text TEXT,FOREIGN KEY (user_id) REFERENCES User(user_id),FOREIGN KEY (movie_id) REFERENCES Movie(movie_id));

CREATE TABLE Artist (artist_id INT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(255) NOT NULL,birth_date DATE,biography TEXT);

CREATE TABLE Skill (skill_id INT AUTO_INCREMENT PRIMARY KEY,skill_name VARCHAR(255) NOT NULL);

CREATE TABLE ArtistSkill (artist_id INT,skill_id INT,PRIMARY KEY (artist_id, skill_id),FOREIGN KEY (artist_id) REFERENCES Artist(artist_id),FOREIGN KEY (skill_id) REFERENCES Skill(skill_id));

CREATE TABLE Role (role_id INT AUTO_INCREMENT PRIMARY KEY,role_name VARCHAR(255) NOT NULL);

CREATE TABLE MovieArtist (movie_id INT,artist_id INT,role_id INT,PRIMARY KEY (movie_id, artist_id, role_id), FOREIGN KEY (movie_id) REFERENCES Movie(movie_id),FOREIGN KEY (artist_id) REFERENCES Artist(artist_id),FOREIGN KEY (role_id) REFERENCES Role(role_id));


-- Inserting sample genres
INSERT INTO Genre (genre_name) VALUES ('Action');
INSERT INTO Genre (genre_name) VALUES ('Drama');
-- Inserting sample movies
INSERT INTO Movie (title, release_date, director, runtime, description) VALUES ('Movie 1', '2023-09-23', 'Director 1', 120, 'Description for Movie 1');
-- Inserting sample media
INSERT INTO Media (movie_id, media_type, media_url) VALUES (1, 'Image', 'image1.jpg');
INSERT INTO Media (movie_id, media_type, media_url) VALUES (1, 'Video', 'video1.mp4');
-- Inserting sample users
INSERT INTO User (username, password, email) VALUES ('user1', 'hashed_password1', 'user1@example.com');
-- Inserting sample reviews
INSERT INTO Review (user_id, movie_id, rating, review_text) VALUES (1, 1, 4, 'A good movie!');
-- Inserting sample artists
INSERT INTO Artist (name, birth_date, biography) VALUES ('Actor 1', '1990-01-01', 'Biography for Actor 1');
-- Inserting sample skills
INSERT INTO Skill (skill_name) VALUES ('Acting');
-- Inserting sample artist skills (many-to-many)
INSERT INTO ArtistSkill (artist_id, skill_id) VALUES (1, 1);
-- Inserting sample roles
INSERT INTO Role (role_name) VALUES ('Actor');
-- Inserting sample movie-artist relationships (many-to-many with roles)
INSERT INTO MovieArtist (movie_id, artist_id, role_id) VALUES (1, 1, 1);


SELECT
    M.title AS Movie_Title,
    M.release_date AS Release_Date,
    M.director AS Director,
    M.runtime AS Runtime,
    M.description AS Description,
    GROUP_CONCAT(G.genre_name) AS Genres,
    GROUP_CONCAT(MD.media_type, ': ', MD.media_url) AS Media,
    U.username AS User_Name,
    MAX(R.rating) AS Rating, -- Use MAX() aggregate function
    GROUP_CONCAT(R.review_text) AS Review_Text,
    A.name AS Artist_Name,
    GROUP_CONCAT(S.skill_name) AS Skills,
    GROUP_CONCAT(RO.role_name) AS Roles
FROM
    Movie AS M
LEFT JOIN
    MovieGenre AS MG ON M.movie_id = MG.movie_id
LEFT JOIN
    Genre AS G ON MG.genre_id = G.genre_id
LEFT JOIN
    Media AS MD ON M.movie_id = MD.movie_id
LEFT JOIN
    Review AS R ON M.movie_id = R.movie_id
LEFT JOIN
    User AS U ON R.user_id = U.user_id
LEFT JOIN
    MovieArtist AS MA ON M.movie_id = MA.movie_id
LEFT JOIN
    Artist AS A ON MA.artist_id = A.artist_id
LEFT JOIN
    ArtistSkill AS ASK ON A.artist_id = ASK.artist_id
LEFT JOIN
    Skill AS S ON ASK.skill_id = S.skill_id
LEFT JOIN
    Role AS RO ON MA.role_id = RO.role_id
GROUP BY
    M.movie_id, U.user_id, A.artist_id;






