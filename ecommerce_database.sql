mysql> CREATE DATABASE ecommerce_db;
Query OK, 1 row affected (0.10 sec)

mysql> USE ecommerce_db;
Database changed
mysql> CREATE TABLE customers (
    -> customer_id INT PRIMARY KEY,
    -> CUSTOMER_name VARCHAR(100),
    -> city VARCHAR(50),
    -> signup_date DATE
    -> );
Query OK, 0 rows affected (0.25 sec)
mysql> CREATE TABLE Products (
    -> product_id INT PRIMARY KEY,
    -> product_name VARCHAR(100),
    -> category VARCHAR(50),
    -> price DECIMAL(10,2)
    -> );
Query OK, 0 rows affected (0.09 sec)

mysql> CREATE TABLE Orders (
    -> order_id INT PRIMARY KEY,
    -> customer_id INT,
    -> order_date DATE,
    -> FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
    -> );
Query OK, 0 rows affected (0.11 sec)

mysql> CREATE TABLE Order_Details (
    -> order_detail_id INT PRIMARY KEY,
    -> order_id INT,
    -> product_id INT,
    -> quantity INT,
    -> FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    -> FOREIGN KEY (product_id) REFERENCES Products(product_id)
    -> );
Query OK, 0 rows affected (0.12 sec)
mysql> INSERT INTO Customers VALUES
    -> (1,'rahul','delhi','2025-01-10'),
    -> (2,'priya','mumbai','2025-02-15'),
    -> (3,'aman','lucknow','2025-03-20');
Query OK, 3 rows affected (0.02 sec)
Records: 3  Duplicates: 0  Warnings: 0
mysql> INSERT INTO Products VALUES
    -> (101,'Laptop','Electronics',55000),
    -> (102,'Headphones','Electronics',2000),
    -> (103,'Shoes', 'Fashion',2000);
Query OK, 3 rows affected (0.03 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> INSERT INTO Orders VALUES
    -> (1001,1,'2025-04-01'),
    -> (1002,2,'2025-04-05'),
    -> (1003,1,'2025-04-10');
Query OK, 3 rows affected (0.02 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> INSERT INTO Order_Details VALUES
    -> (1,1001,101,1),
    -> (2,1002,101,2),
    -> (3,1002,103,1),
    -> (4,1003,102,3);
Query OK, 4 rows affected (0.02 sec)
Records: 4  Duplicates: 0  Warnings: 0
mysql> SELECT p.product_name,
    ->        SUM(od.quantity) total_sales
    -> FROM Products p
    -> JOIN Order_Details od
    -> ON p.product_id = od.product_id
    -> GROUP BY p.product_name
    -> ORDER BY total_sales DESC;
+--------------+-------------+
| product_name | total_sales |
+--------------+-------------+
| Laptop       |           3 |
| Headphones   |           3 |
| Shoes        |           1 |
+--------------+-------------+
3 rows in set (0.04 sec)
mysql> SELECT c.customer_name,
    ->        SUM(p.price*od.quantity) total_spent
    -> FROM Customers c
    -> JOIN Orders o
    -> ON c.customer_id=o.customer_id
    -> JOIN Order_Details od
    -> ON o.order_id=od.order_id
    -> JOIN Products p
    -> ON od.product_id=p.product_id
    -> GROUP BY c.customer_name
    -> ORDER BY total_spent DESC;
+---------------+-------------+
| customer_name | total_spent |
+---------------+-------------+
| priya         |   112000.00 |
| rahul         |    61000.00 |
+---------------+-------------+
2 rows in set (0.01 sec)
mysql> SELECT MONTH(o.order_date) month,
    ->        SUM(p.price*od.quantity) revenue
    -> FROM Orders o
    -> JOIN Order_Details od
    -> ON o.order_id=od.order_id
    -> JOIN Products p
    -> ON od.product_id=p.product_id
    -> GROUP BY MONTH(o.order_date);
+-------+-----------+
| month | revenue   |
+-------+-----------+
|     4 | 173000.00 |
+-------+-----------+
1 row in set (0.01 sec)
mysql> WITH CustomerRevenue AS
    -> (
    -> SELECT c.customer_name,
    ->        SUM(p.price*od.quantity) revenue
    -> FROM Customers c
    -> JOIN Orders o
    -> ON c.customer_id=o.customer_id
    -> JOIN Order_Details od
    -> ON o.order_id=od.order_id
    -> JOIN Products p
    -> ON od.product_id=p.product_id
    -> GROUP BY c.customer_name
    -> )
    ->
    -> SELECT *
    -> FROM CustomerRevenue
    -> WHERE revenue > 10000;
+---------------+-----------+
| customer_name | revenue   |
+---------------+-----------+
| rahul         |  61000.00 |
| priya         | 112000.00 |
+---------------+-----------+
2 rows in set (0.01 sec)




