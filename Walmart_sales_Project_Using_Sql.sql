DROP TABLE IF EXISTS table_name;

CREATE TABLE walmart_sales (
    invoice_id INT PRIMARY KEY,
    branch VARCHAR(50),
    city VARCHAR(50),
    category VARCHAR(50),
    unit_price NUMERIC(10, 2),
    quantity INT,
    date DATE,
    time TIME,
    payment_method VARCHAR(50),
    rating NUMERIC(3, 1),
    profit_margin NUMERIC(3, 2),
    total NUMERIC(10, 2)
);

select * from walmart_sales
select 
count(*)
from walmart_sales