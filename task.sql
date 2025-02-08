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

-- 3 Об’єднання даних всіх таблиць, за допомогою операторів FROM та INNER JOIN

SELECT 
    orders.id AS order_id,
    customers.name AS customer_name,
    employees.first_name AS employee_first_name,
    employees.last_name AS employee_last_name,
    orders.date AS order_date,
    shippers.name AS shipper_name,
    products.name AS product_name,
    categories.name AS category_name,
    suppliers.name AS supplier_name,
    order_details.quantity AS quantity,
    products.price AS unit_price
FROM orders
INNER JOIN customers ON orders.customer_id = customers.id
INNER JOIN employees ON orders.employee_id = employees.employee_id
INNER JOIN shippers ON orders.shipper_id = shippers.id
INNER JOIN order_details ON orders.id = order_details.order_id
INNER JOIN products ON order_details.product_id = products.id
INNER JOIN categories ON products.category_id = categories.id
INNER JOIN suppliers ON products.supplier_id = suppliers.id;

-- 4.1 Визначення, скільки рядків отримано (за допомогою оператора COUNT):

SELECT COUNT(*) AS total_rows
FROM orders
INNER JOIN customers ON orders.customer_id = customers.id
INNER JOIN employees ON orders.employee_id = employees.employee_id
INNER JOIN shippers ON orders.shipper_id = shippers.id
INNER JOIN order_details ON orders.id = order_details.order_id
INNER JOIN products ON order_details.product_id = products.id
INNER JOIN categories ON products.category_id = categories.id
INNER JOIN suppliers ON products.supplier_id = suppliers.id;

-- 4.2 Зміна декількох операторів INNER на LEFT чи RIGHT.
-- При зміні операторів INNER на LEFT чи RIGHT, кількість рядків у виводі не змінюється та становить 518 в усіх 3-х випадках, це свідчить про те, що всі зв'язки між таблицями є повними, тобто наприклад, кожен запис у orders має відповідного customer_id у customers, employee_id у employees, shipper_id у shippers і т.д. Якщо у таблицях немає "сирітських" записів (наприклад, продуктів без постачальників або замовлень без клієнтів), то RIGHT JOIN та LEFT JOIN поводяться так само, як INNER JOIN. В даному випадку, оскільки всі дані мають відповідні зв’язки, зміна INNER JOIN на LEFT JOIN або RIGHT JOIN не впливає на загальну кількість рядків (518).

SELECT COUNT(*) AS total_rows
FROM orders
LEFT JOIN customers ON orders.customer_id = customers.id
LEFT JOIN employees ON orders.employee_id = employees.employee_id
LEFT JOIN shippers ON orders.shipper_id = shippers.id
INNER JOIN order_details ON orders.id = order_details.order_id
INNER JOIN products ON order_details.product_id = products.id
LEFT JOIN categories ON products.category_id = categories.id
LEFT JOIN suppliers ON products.supplier_id = suppliers.id;

SELECT COUNT(*) AS total_rows
FROM orders
RIGHT JOIN customers ON orders.customer_id = customers.id
RIGHT JOIN employees ON orders.employee_id = employees.employee_id
INNER JOIN shippers ON orders.shipper_id = shippers.id
RIGHT JOIN order_details ON orders.id = order_details.order_id
INNER JOIN products ON order_details.product_id = products.id
INNER JOIN categories ON products.category_id = categories.id
RIGHT JOIN suppliers ON products.supplier_id = suppliers.id;

-- 4.3 Вибірка тільки тих рядків, де employee_id > 3 та ≤ 10:

SELECT 
    orders.id AS order_id,
    customers.name AS customer_name,
    employees.first_name AS employee_first_name,
    employees.last_name AS employee_last_name,
    orders.date AS order_date,
    shippers.name AS shipper_name,
    products.name AS product_name,
    categories.name AS category_name,
    suppliers.name AS supplier_name,
    order_details.quantity AS quantity,
    products.price AS unit_price
FROM orders
INNER JOIN customers ON orders.customer_id = customers.id
INNER JOIN employees ON orders.employee_id = employees.employee_id
INNER JOIN shippers ON orders.shipper_id = shippers.id
INNER JOIN order_details ON orders.id = order_details.order_id
INNER JOIN products ON order_details.product_id = products.id
INNER JOIN categories ON products.category_id = categories.id
INNER JOIN suppliers ON products.supplier_id = suppliers.id
WHERE employees.employee_id > 3 AND employees.employee_id <= 10;

-- 4.4 Групування за іменем категорії, прорахунок кількості рядків у групі, середньої кількості товару:

SELECT 
    categories.name AS category_name,
    COUNT(*) AS total_orders,
    AVG(order_details.quantity) AS avg_quantity_per_order
FROM orders
INNER JOIN customers ON orders.customer_id = customers.id
INNER JOIN employees ON orders.employee_id = employees.employee_id
INNER JOIN shippers ON orders.shipper_id = shippers.id
INNER JOIN order_details ON orders.id = order_details.order_id
INNER JOIN products ON order_details.product_id = products.id
INNER JOIN categories ON products.category_id = categories.id
INNER JOIN suppliers ON products.supplier_id = suppliers.id
GROUP BY categories.name;

-- 4.5 фільтрування рядків, де середня кількість товару більша за 21:

SELECT 
    categories.name AS category_name,
    COUNT(*) AS total_orders,
    AVG(order_details.quantity) AS avg_quantity_per_order
FROM orders
INNER JOIN customers ON orders.customer_id = customers.id
INNER JOIN employees ON orders.employee_id = employees.employee_id
INNER JOIN shippers ON orders.shipper_id = shippers.id
INNER JOIN order_details ON orders.id = order_details.order_id
INNER JOIN products ON order_details.product_id = products.id
INNER JOIN categories ON products.category_id = categories.id
INNER JOIN suppliers ON products.supplier_id = suppliers.id
GROUP BY categories.name
HAVING AVG(order_details.quantity) > 21;

-- 4.6 Сортування рядків за спаданням кількості рядків:

SELECT 
    categories.name AS category_name,
    COUNT(*) AS total_orders,
    AVG(order_details.quantity) AS avg_quantity_per_order
FROM orders
INNER JOIN customers ON orders.customer_id = customers.id
INNER JOIN employees ON orders.employee_id = employees.employee_id
INNER JOIN shippers ON orders.shipper_id = shippers.id
INNER JOIN order_details ON orders.id = order_details.order_id
INNER JOIN products ON order_details.product_id = products.id
INNER JOIN categories ON products.category_id = categories.id
INNER JOIN suppliers ON products.supplier_id = suppliers.id
GROUP BY categories.name
HAVING AVG(order_details.quantity) > 21
ORDER BY total_orders DESC;

-- 4.7 Виведення чотирьох рядків з пропущеним першим рядком:

SELECT 
    categories.name AS category_name,
    COUNT(*) AS total_orders,
    AVG(order_details.quantity) AS avg_quantity_per_order
FROM orders
INNER JOIN customers ON orders.customer_id = customers.id
INNER JOIN employees ON orders.employee_id = employees.employee_id
INNER JOIN shippers ON orders.shipper_id = shippers.id
INNER JOIN order_details ON orders.id = order_details.order_id
INNER JOIN products ON order_details.product_id = products.id
INNER JOIN categories ON products.category_id = categories.id
INNER JOIN suppliers ON products.supplier_id = suppliers.id
GROUP BY categories.name
HAVING AVG(order_details.quantity) > 21
ORDER BY total_orders DESC
LIMIT 4 OFFSET 1;

