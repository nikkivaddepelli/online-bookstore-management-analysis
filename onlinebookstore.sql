CREATE DATABASE online_bookstore;
USE online_bookstore;
SELECT DATABASE();


-- create tables

create table if not exists books(
Book_ID int auto_increment primary key,
Title varchar(100),
Author varchar(100),
genre varchar(50),
published_Yeqar int,
Price decimal(10,2),
stock int
); 
desc books;

create table if not exists Customers(
Customer_ID int auto_increment primary key,
Name varchar(100),
Email varchar(100),
Phone Varchar(15),
City varchar(50),
Country varchar(150)
);
desc customers;

CREATE TABLE IF NOT EXISTS Orders (
    Order_ID INT AUTO_INCREMENT PRIMARY KEY,
    Customer_ID INT,
    Book_ID INT,
    Order_Date DATE,
    Quantity INT,
    Total_amount DECIMAL(10,2),

    FOREIGN KEY (Customer_ID)
            REFERENCES Customers(Customer_ID),
    FOREIGN KEY (Book_ID) 
            REFERENCES Books(Book_ID)
);
desc orders;

select * from Books;
select * from customers;
select * from orders;
 
 -- imported bbok.csv file directly
 select * from books;
 SELECT COUNT(*) AS total_books
FROM books;
 
 -- imported customers file directlt
 select * from customers;
 SELECT COUNT(*) AS total_customers
FROM customers;
 
 -- imported oredrs file directly
  select * from orders;
   SELECT COUNT(*) AS total_orders
FROM orders;
  
  
-- after import data and before analysis we need to check our data is there any null or duplicates is there our not
-- check null values
SELECT * FROM books
WHERE title IS NULL
   OR author IS NULL
   OR price IS NULL;
   
   SELECT * FROM customers
WHERE name IS NULL
   OR email IS NULL
   OR city IS NULL;

SELECT * FROM orders
WHERE customer_id IS NULL
   OR book_id IS NULL
   OR order_date IS NULL
   OR quantity IS NULL;
   
   
   -- Check Duplicate IDs
   SELECT book_id, COUNT(*)
FROM books
GROUP BY book_id
HAVING COUNT(*) > 1;

SELECT customer_id, COUNT(*)
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT order_id, COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

alter table books 
rename column published_yeqar to published_year;

-- 1) retrive all books in the "Fiction" genre
select * from books 
    where genre = 'fiction';
    
    -- 2) find books published after the year 1950
    select * from books 
    where published_Year > 1950;
    
    -- 3) list all customers from canada
    select * from customers 
    where country = 'canada';
    
    -- 4) Show orders placed in November 2023:
    select * from orders 
    where order_date between  '2023-11-01' and '2023-11-30';
    
    -- 5) Retrieve the total stock of books available:
    select sum(stock) as  Total_stock_ofbooks_available
    from books ;
    
    -- 6) Find the details of the most expensive book:
    select * from books
	order by price desc
    limit 5;
    
    -- 7) Show all customers who ordered more than 1 quantity of a book:
select * from orders
where quantity > 1;

-- 8) Retrieve all orders where the total amount exceeds $20:
select * from orders
where total_amount > 20;

-- 9) List all genres available in the Books table:
select distinct genre from books;

-- 10) Find the book with the lowest stock:
select * from books
order by stock asc
limit 10;

-- 11) Calculate the total revenue generated from all orders:
select sum(Total_amount) as Revenue
 from orders;

-- advance questions :
-- 1) Retrieve the total number of books sold for each genre:
    select b.genre, sum(o.quantity) as total_books_sold 
    from orders o
    join books b on o.book_id = b.book_id
    group by b.genre ;
    
-- 2) Find the average price of books in the "Fantasy" genre:
select  avg(price) as Avg_price
from books
where  genre ='fantasy';

-- 3) List customers who have placed at least 2 orders:
select o.customer_id, c.name, count(o.order_id) as order_count
from orders o 
join customers c on
  o.customer_id = c.Customer_id
 group by o.customer_id, c.name
having count(order_id) >=2;

-- 4) Find the most frequently ordered book:
select  o.book_id, b.title, count(o.order_id) as order_count 
from orders o
join books b on
o.book_id = b.book_id
group by o.book_id, b.title
order by order_count desc limit 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
select * from books
where genre = 'Fantasy' 
order by price desc limit 3;

-- 6) Retrieve the total quantity of books sold by each author:
select  b.author, sum(o.quantity) as total_sold
from orders o
join books b on
o.book_id = b.book_id
group by b.author;

-- 7) List the cities where customers who spent over $30 are located:
select  distinct c.city, total_amount
from orders o
join customers c on
o.customer_id = c.customer_id
where o.total_amount> 30;

-- 8) Find the customer who spent the most on orders:
select c.customer_id, c.name,  sum(o.total_amount) as total_spent
from orders o  join customers c on o.customer_id = c.customer_id
group by c.customer_id, c.name
order by total_spent desc limit 3;


-- 9) Calculate the stock remaining after fulfilling all orders:
select b.book_id, b.title, b.stock, coalesce(sum(o.quantity),0) as order_quantity,
b.stock-coalesce(sum(o.quantity),0) as remaininng_quantity
from books b
left join orders o on b.book_id = o.book_id
group by b.book_id
order by b.book_id ;