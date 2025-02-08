-- 1) Створення бази даних та таблиць в ній, для керування бібліотекою книг:

CREATE DATABASE LibraryManagement;
USE LibraryManagement;

CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(255) NOT NULL
);

CREATE TABLE genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(255) NOT NULL
);

CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    publication_year YEAR NOT NULL,
    author_id INT,
    genre_id INT,
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE borrowed_books (
    borrow_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    user_id INT,
    borrow_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


-- 2 Заповнення таблиць простими тестовими даними:
INSERT INTO authors (author_name) VALUES ('Gabriel García Márquez'), ('Julia Alvarez');

INSERT INTO genres (genre_name) VALUES ('Magic Realism'), ('Historical Fiction');

INSERT INTO books (title, publication_year, author_id, genre_id) VALUES ('One Hundred Years of Solitude', 1967, 1, 1), ('In the Time of Butterflies', 1994, 2, 2);

INSERT INTO users (username, email) VALUES ('Antony', 'antony@example.com'), ('Paula', 'paula@example.com');

INSERT INTO borrowed_books (book_id, user_id, borrow_date, return_date) VALUES (1, 1, '2025-02-01', '2025-02-15'), (2, 2, '2025-02-05', NULL);
