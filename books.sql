DROP DATABASE IF EXISTS books;
CREATE DATABASE books;
USE books;

-- 
-- SERIES
-- 
CREATE TABLE SERIES (
    series_id MEDIUMINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    series_name VARCHAR(100) NOT NULL UNIQUE,
    series_description TEXT NOT NULL
);

-- 
-- GENRES
-- 
CREATE TABLE GENRES (
    genre_id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(100) NOT NULL UNIQUE
);

-- 
-- BOOKS
-- 
CREATE TABLE BOOKS (
    book_id MEDIUMINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    book_name VARCHAR(200) NOT NULL,
    isbn13 CHAR(13),
    first_published DATE,
    url_file CHAR(26) NOT NULL,
    cover_image CHAR(26) NOT NULL,
    summary TEXT NOT NULL,
    UNIQUE (isbn13)
);

-- 
-- BOOKS_SERIES
-- 
CREATE TABLE BOOKS_SERIES (
    book_id MEDIUMINT UNSIGNED NOT NULL,
    series_id MEDIUMINT UNSIGNED NOT NULL,
    series_order TINYINT UNSIGNED NOT NULL,
    PRIMARY KEY (book_id),
    UNIQUE (series_id, series_order),
    CONSTRAINT FK_BOOKS_SERIES_BOOK_id 
        FOREIGN KEY (book_id) REFERENCES BOOKS(book_id),
    CONSTRAINT FK_BOOKS_SERIES_series_id 
        FOREIGN KEY (series_id) REFERENCES SERIES(series_id)
);

-- 
-- BOOKS_SIMILAR
-- 
CREATE TABLE BOOKS_SIMILAR (
    book_id MEDIUMINT UNSIGNED NOT NULL,
    similar_book_id MEDIUMINT UNSIGNED NOT NULL,
    PRIMARY KEY (book_id, similar_book_id),
    CONSTRAINT FK_BOOKS_SIMILAR_book_id 
        FOREIGN KEY (book_id) REFERENCES BOOKS(book_id),
    CONSTRAINT FK_BOOKS_SIMILAR_similar_book_id 
        FOREIGN KEY (similar_book_id) REFERENCES BOOKS(book_id),
    CHECK (book_id < similar_book_id) -- avoid duplicate pairs (A,B) and (B,A)
);

-- 
-- BOOKS_GENRES
-- 
CREATE TABLE BOOKS_GENRES (
    book_id MEDIUMINT UNSIGNED NOT NULL,
    genre_id SMALLINT UNSIGNED NOT NULL,
    PRIMARY KEY (book_id, genre_id),
    CONSTRAINT FK_BOOKS_GENRES_book_id 
        FOREIGN KEY (book_id) REFERENCES BOOKS(book_id),
    CONSTRAINT FK_BOOKS_GENRES_genre_id 
        FOREIGN KEY (genre_id) REFERENCES GENRES(genre_id)
);
-- 
-- COUNTRIES
-- 
CREATE TABLE COUNTRIES (
    ISO3 CHAR(3) PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL UNIQUE
);

-- 
-- USERS
-- 
CREATE TABLE USERS (
    user_id MEDIUMINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    user_password VARCHAR(100) NOT NULL,
    date_birth DATE NOT NULL,
    created_at TIMESTAMP NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    ISO3 CHAR(3) NOT NULL,
    CONSTRAINT FK_USERS_ISO3 
        FOREIGN KEY (ISO3) REFERENCES COUNTRIES(ISO3)
);

-- 
-- USERS_FOLLOWERS
-- 
CREATE TABLE USERS_FOLLOWERS (
    follower_id MEDIUMINT UNSIGNED NOT NULL,
    followed_id MEDIUMINT UNSIGNED NOT NULL,
    action_date TIMESTAMP NOT NULL,
    action_type ENUM('follow', 'unfollow') NOT NULL,
    PRIMARY KEY (follower_id, followed_id, action_date),
    CONSTRAINT FK_USERS_FOLLOWERS_follower_id 
        FOREIGN KEY (follower_id) REFERENCES USERS(user_id),
    CONSTRAINT FK_USERS_FOLLOWERS_followed_id 
        FOREIGN KEY (followed_id) REFERENCES USERS(user_id),
    CHECK (follower_id <> followed_id) -- prevent self-following
);

-- 
-- AUTHORS
-- 
CREATE TABLE AUTHORS (
    author_id MEDIUMINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(200) NOT NULL,
    ISO3 CHAR(3) NOT NULL,
    summary TEXT NOT NULL,
    CONSTRAINT FK_AUTHORS_ISO3 
        FOREIGN KEY (ISO3) REFERENCES COUNTRIES(ISO3)
);

-- 
-- USERS_AUTHORS_CORRESPONDENCE
-- 
CREATE TABLE USERS_AUTHORS_CORRESPONDENCE (
    user_id MEDIUMINT UNSIGNED NOT NULL,
    author_id MEDIUMINT UNSIGNED NOT NULL UNIQUE,
    verification_date TIMESTAMP NOT NULL,
    PRIMARY KEY (user_id),
    CONSTRAINT FK_USERS_AUTHORS_CORRESPONDENCE_user_id 
        FOREIGN KEY (user_id) 
        REFERENCES USERS(user_id),
    CONSTRAINT FK_USERS_AUTHORS_CORRESPONDENCE_author_id 
        FOREIGN KEY (author_id) REFERENCES AUTHORS(author_id)
);
-- 
-- BOOKS_AUTHORS
-- 
CREATE TABLE BOOKS_AUTHORS (
    book_id MEDIUMINT UNSIGNED NOT NULL,
    author_id MEDIUMINT UNSIGNED NOT NULL,
    PRIMARY KEY (book_id, author_id),
    CONSTRAINT FK_BOOKS_AUTHORS_book_id 
        FOREIGN KEY (book_id) REFERENCES BOOKS(book_id),
    CONSTRAINT FK_BOOKS_AUTHORS_author_id 
        FOREIGN KEY (author_id) REFERENCES AUTHORS(author_id)
);


-- 
-- USERS_BOOKS_READLIST
-- 
CREATE TABLE USERS_BOOKS_READLIST (
    user_id MEDIUMINT UNSIGNED NOT NULL,
    book_id MEDIUMINT UNSIGNED NOT NULL,
    finished BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL,
    PRIMARY KEY (user_id, book_id),
    CONSTRAINT FK_USERS_BOOKS_READLIST_user_id 
        FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    CONSTRAINT FK_USERS_BOOKS_READLIST_book_id 
        FOREIGN KEY (book_id) REFERENCES BOOKS(book_id)
);

-- 
-- USERS_BOOKS_WISHLIST
-- 
CREATE TABLE USERS_BOOKS_WISHLIST (
    user_id MEDIUMINT UNSIGNED NOT NULL,
    book_id MEDIUMINT UNSIGNED NOT NULL,
    created_at TIMESTAMP NOT NULL,
    PRIMARY KEY (user_id, book_id),
    CONSTRAINT FK_USERS_BOOKS_WISHLIST_user_id 
        FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    CONSTRAINT FK_USERS_BOOKS_WISHLIST_book_id 
        FOREIGN KEY (book_id) REFERENCES BOOKS(book_id)
);

-- 
-- USERS_BOOKS_FAVORITELIST
-- 
CREATE TABLE USERS_BOOKS_FAVORITELIST (
    user_id MEDIUMINT UNSIGNED NOT NULL,
    book_id MEDIUMINT UNSIGNED NOT NULL,
    created_at TIMESTAMP NOT NULL,
    PRIMARY KEY (user_id, book_id),
    CONSTRAINT FK_USERS_BOOKS_FAVORITELIST_user_id 
        FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    CONSTRAINT FK_USERS_BOOKS_FAVORITELIST_book_id 
        FOREIGN KEY (book_id) REFERENCES BOOKS(book_id)
);

-- 
-- USERS_BOOKS_FAVORITE_GENRES
-- 
CREATE TABLE USERS_BOOKS_FAVORITE_GENRES (
    user_id MEDIUMINT UNSIGNED NOT NULL,
    genre_id SMALLINT UNSIGNED NOT NULL,
    created_at TIMESTAMP NOT NULL,
    PRIMARY KEY (user_id, genre_id),
    CONSTRAINT FK_USERS_BOOKS_FAVORITE_GENRES_user_id 
        FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    CONSTRAINT FK_USERS_BOOKS_FAVORITE_GENRES_genre_id 
        FOREIGN KEY (genre_id) REFERENCES GENRES(genre_id)
);

-- 
-- USERS_BOOKS_RATE
-- 
CREATE TABLE USERS_BOOKS_RATE (
    user_id MEDIUMINT UNSIGNED NOT NULL,
    book_id MEDIUMINT UNSIGNED NOT NULL,
    rating TINYINT UNSIGNED NOT NULL CHECK (rating BETWEEN 1 AND 5),
    rate_date TIMESTAMP NOT NULL,
    PRIMARY KEY (user_id, book_id),
    CONSTRAINT FK_USERS_BOOKS_RATE_user_id 
        FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    CONSTRAINT FK_USERS_BOOKS_RATE_book_id 
        FOREIGN KEY (book_id) REFERENCES BOOKS(book_id)
);

-- 
-- USERS_BOOKS_REVIEW
-- 
CREATE TABLE USERS_BOOKS_REVIEW (
    user_id MEDIUMINT UNSIGNED NOT NULL,
    book_id MEDIUMINT UNSIGNED NOT NULL,
    review_text TEXT NOT NULL,
    review_date TIMESTAMP NOT NULL,
    PRIMARY KEY (user_id, book_id),
    CONSTRAINT FK_USERS_BOOKS_REVIEW_user_id 
        FOREIGN KEY (user_id, book_id) REFERENCES USERS_BOOKS_RATE(user_id, book_id)
);

-- 
-- USERS_REVIEWS_COMMENTS
-- 
CREATE TABLE USERS_REVIEWS_COMMENTS (
    review_user_id MEDIUMINT UNSIGNED NOT NULL,
    book_id MEDIUMINT UNSIGNED NOT NULL,
    comment_user_id MEDIUMINT UNSIGNED NOT NULL,
    comment_text TEXT NOT NULL,
    comment_date TIMESTAMP NOT NULL,
    PRIMARY KEY (review_user_id, book_id, comment_user_id),
    CONSTRAINT FK_USERS_REVIEWS_COMMENTS_comment_user_id 
        FOREIGN KEY (comment_user_id) REFERENCES USERS(user_id),
    CONSTRAINT FK_USERS_REVIEWS_COMMENTS_review_user_id 
        FOREIGN KEY (review_user_id, book_id) REFERENCES USERS_BOOKS_REVIEW(user_id, book_id)
);

-- 
-- COMMENTS_LIKES
-- 
CREATE TABLE COMMENTS_LIKES (
    review_user_id MEDIUMINT UNSIGNED NOT NULL,
    book_id MEDIUMINT UNSIGNED NOT NULL,
    comment_user_id MEDIUMINT UNSIGNED NOT NULL,
    like_user_id MEDIUMINT UNSIGNED NOT NULL,

    like_date TIMESTAMP NOT NULL,
    PRIMARY KEY (review_user_id, book_id, comment_user_id, like_user_id),
    CONSTRAINT FK_COMMENTS_LIKES_like_user_id 
        FOREIGN KEY (like_user_id) REFERENCES USERS(user_id),
    CONSTRAINT FK_COMMENTS_LIKES_review_user_id 
        FOREIGN KEY (review_user_id, book_id, comment_user_id) REFERENCES USERS_REVIEWS_COMMENTS(review_user_id, book_id, comment_user_id)
);

-- 
-- REVIEWS_LIKES
-- 
CREATE TABLE REVIEWS_LIKES (
    review_user_id MEDIUMINT UNSIGNED NOT NULL,
    book_id MEDIUMINT UNSIGNED NOT NULL,
    like_user_id MEDIUMINT UNSIGNED NOT NULL,
    like_date TIMESTAMP NOT NULL,
    PRIMARY KEY (review_user_id, book_id, like_user_id),
    CONSTRAINT FK_REVIEWS_LIKES_like_user_id 
        FOREIGN KEY (like_user_id) REFERENCES USERS(user_id),
    CONSTRAINT FK_REVIEWS_LIKES_review_user_id 
        FOREIGN KEY (review_user_id, book_id)
            REFERENCES USERS_BOOKS_REVIEW(user_id, book_id)
);