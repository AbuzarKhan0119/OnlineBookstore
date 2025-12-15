 # OnlineBookstore


-- Create Database
CREATE DATABASE OnlineBookstore;

-- Use Database
use OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

Select * from books;
select * from customers;
select * from orders;

-- 1) Retrieve all books in the "Fiction" genre:

Select * from books
where genre = 'Fiction';

-- 2) Find books published after the year 1950:

select * from books
where Published_Year > 1950

-- 3) List all customers from the Canada:

Select * from customers where Country = 'Canada';

-- 4) Show orders placed in November 2023:

Select * from Orders Where Order_Date between '2023-11-01' and '2023-10-01';

-- 5) Retrieve the total stock of books available:

select sum(Stock) as Total_Stock from books;


-- 6) Find the details of the most expensive book:

select * from Books where Price = (select max(price) as Most_Expensive_Book from Books);

-- 7) Show all customers who ordered more than 1 quantity of a book:

select * from orders where Quantity > 1;

-- 8) Retrieve all orders where the total amount exceeds $20:

select * from orders where Total_Amount > 20;

-- 9) List all genres available in the Books table:

select Distinct Genre from Books;

-- 10) Find the book with the lowest stock:

select * from books where stock = (select Min(stock) from books)

-- 11) Calculate the total revenue generated from all orders:
 
Select sum(Total_Amount) as Total_Revenue from Orders;

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:

select * from Orders;

select b.Genre,sum(o.Quantity) as Total_Books_sold
from orders o
Join Books b on o.book_id = b.book_id
group by b.Genre;

-- 2) Find the average price of books in the "Fantasy" genre:

select avg(price) as Average_Books_Price from Books where Genre = 'Fantasy';


-- 3) List customers who have placed at least 2 orders:

select o.customer_id,c.name,Count(o.order_id) as Order_Count
from orders o
join customers c on c.customer_id = o.customer_id
group by o.customer_id , c.name
having count(order_id) >=2;

-- 4) Find the most frequently ordered book:

select o.book_id,b.title,count(order_id) as Order_Count
from orders o
join books b on o.Book_id = b.Book_id
group by o.book_id , title
order by order_count desc limit 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :

select * from books
where Genre = 'Fantasy'
order by price desc limit 3;

-- 6) Retrieve the total quantity of books sold by each author:

select b.author,sum(o.Quantity) as Total_books_Sold
from books b
join orders o on b.book_id = o.book_id
group by b.Author;

-- 7) List the cities where customers who spent over $30 are located:

select distinct c.city,o.total_amount
from orders o
join customers c on c.customer_id = o.customer_id
where o.total_amount > 30


-- 8) Find the customer who spent the most on orders:

select c.customer_id,c.name,sum(o.Total_Amount) as Total_spent
from Customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id,c.name
order by Total_Spent desc limit 1;


-- 9) Calculate the stock remaining after fulfilling all orders:

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;