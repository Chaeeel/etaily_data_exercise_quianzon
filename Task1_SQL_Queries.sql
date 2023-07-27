create table customer (
id int primary key auto_increment,
first_name varchar(50),
last_name varchar(50),
gender varchar(20),
date_of_birth varchar(50),
country varchar(50),
age int
);
insert into customer (first_name, last_name, gender, date_of_birth, country, age)
values ('Jason', 'Smith', 'male', '1982-05-28', 'USA', 20),
		('Max', 'Mustermann', 'male', '1980-07-18', 'Germany', 24),
		('Will', 'Myer', 'male', '1981-03-30', 'England', 56),
        ('Christin', 'Dawn', 'female', '1978-08-02', 'USA', 42),
        ('Angela', 'Gutierez', 'female', '1986-01-16', 'Spain', 22),
        ('Peter', 'Jackson', 'male', '1958-12-05', 'USA', 33
);

create table orders (
id int primary key auto_increment,
order_nr bigint,
sum decimal(5, 2),
fk_customer int,
constraint orders_ibfk_1
    foreign key (fk_customer) references customer (id)
);
insert into orders (order_nr, sum, fk_customer)
values (2783292423, 100.85, 2),
		(4784232411, 77.34, 3),
		(3783292423, 30.99, 5),
        (9368315313, 33.55, 2
);

create table order_item (
id int primary key auto_increment,
sku varchar(50),
fk_order int,
constraint order_item_ibfk_1
    foreign key (fk_order) references orders (id)
);
insert into order_item (sku, fk_order)
values ('ABCDEF', 1),
		('ABCDEF', 1),
		('OHSDLF', 1),
        ('1737234', 2),
        ('KLSHA', 3),
        ('OHSDLF', 3),
        ('GHJSK', 4
);

/*Basic queries*/
show tables;
select * from customer;
select * from orders;
select * from order_item;
drop table customer;
drop table orders;
drop table order_item;
/*Queries for testing foreign keys*/
alter table orders
drop foreign key orders_ibfk_1;
alter table order_item
drop foreign key order_item_ibfk_1;

/*Queries for given instruction*/
/* (1) Write a query which select all female customers*/
/*Queries for number (1)*/
select * from customer where gender = 'female';

/* (2) Write a query which prints out all customer names with the number of orders they did*/
/*DIFFERENT QUERIES THAT I'VE TRIED AND DID NOT WORK, RETAINED FOR DOCUMENTATION PURPOSES
select customer.id, first_name, last_name, fk_order from customer,orders, order_item where order_item.fk_order = orders.id and orders.fk_customer = customer.id;
select order_item.fk_order, count(order_item.fk_order) from order_item group by order_item.fk_order;
select customer.id, first_name, last_name, order_item.fk_order from customer
  inner join orders 
       inner join (select order_item.fk_order, count(order_item.fk_order)
					from order_item
						group by order_item.fk_order) 
							order_item  on order_item.fk_order = orders.fk_customer
	   on orders.fk_customer = customer.id;
*/
/*Queries for number (2)*/
select customer.id, customer.first_name, customer.last_name, COUNT(orders.id) as num_orders
	from customer
		left join orders on customer.id = orders.fk_customer
			group by customer.id, customer.first_name, customer.last_name;


/* (3) Write a query which prints out customers with the money they spend excluding customers without any orders*/
/*DIFFERENT QUERIES THAT I'VE TRIED AND DID NOT WORK, RETAINED FOR DOCUMENTATION PURPOSES
select customer.id, first_name, last_name, sum from customer, orders where customer.id = orders.fk_customer; 
select customer.id, customer.first_name, customer.last_name, sum from customer
		inner join orders on customer.id = orders.fk_customer;
*/
/*Queries for number (3)*/
select customer.id, customer.first_name, customer.last_name, SUM(orders.sum) as total_money_spent
	from customer
		inner join orders on customer.id = orders.fk_customer
			group by customer.id, customer.first_name, customer.last_name;

/* (4) Write a query which prints out the order nr of all orders with at least 2 items*/
/*DIFFERENT QUERIES THAT I'VE TRIED AND DID NOT WORK, RETAINED FOR DOCUMENTATION PURPOSES
select order_item.sku, count(order_item.sku) as num
  from order_item
	group by order_item.sku
	having num >= 2;
select order_nr
	from orders
		inner join (select order_item.sku, count(order_item.sku) as num
			from order_item
			group by order_item.sku
			having num >= 2) order_item on orders.id = order_item.fk_order where order_item.sku;
 */
 /*Queries for number (4)*/
select orders.order_nr
	from  orders
		join order_item on orders.id = order_item.fk_order
			group by orders.order_nr
			having COUNT(order_item.id) >= 2;
           

/* (5) Write a query that will pair the oldest male customer with the oldest female customer*/
/*DIFFERENT QUERIES THAT I'VE TRIED AND DID NOT WORK, RETAINED FOR DOCUMENTATION PURPOSES
select customer.id, first_name, last_name, age from customer where age = (SELECT max(age) FROM customer where gender = 'male') union
select customer.id, first_name, last_name, age from customer where age = (SELECT max(age) FROM customer where gender = 'female');
*/
 /*Queries for number (5)*/
SELECT 
  (SELECT id FROM customer WHERE gender = 'male' ORDER BY date_of_birth ASC LIMIT 1) AS id_male,
  (SELECT first_name FROM customer WHERE gender = 'male' ORDER BY date_of_birth ASC LIMIT 1) AS name_male,
	TIMESTAMPDIFF(YEAR, (SELECT date_of_birth FROM customer WHERE gender = 'male' ORDER BY date_of_birth ASC LIMIT 1), CURDATE()) AS age_male,
  (SELECT id FROM customer WHERE gender = 'female' ORDER BY date_of_birth ASC LIMIT 1) AS id_female,
  (SELECT first_name FROM customer WHERE gender = 'female' ORDER BY date_of_birth ASC LIMIT 1) AS name_female,
	TIMESTAMPDIFF(YEAR, (SELECT date_of_birth FROM customer WHERE gender = 'female' ORDER BY date_of_birth ASC LIMIT 1), CURDATE()) AS age_female;
    /* PETER WAS THE ONE RETRIEVED BECAUSE HIS DATE OF BIRTH IS EARLIER THAN WILL */





