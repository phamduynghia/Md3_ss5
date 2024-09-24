create table products(
pId int auto_increment primary key ,
pName varchar(255) not null ,
pPrice double not null 
);

insert into products (pId,pName,pPrice)
values (1,"bat" , 900),
(2,"chao" , 500),
(3,"xoong" , 300),
(4,"dia",900),
(5,"thot",500),
(6,"dao",500);

create table customers (
cId int auto_increment primary key ,
cName varchar(255) not null ,
cAge int not null
);

insert into customers(cName,cAge)
values ("Minh",10),
("Nga",20),
("yen",50);

insert into customers(cName,cAge)
values ("ngia",30);

create table orders (
oId int auto_increment primary key ,
cId int not null,
oDate datetime not null,
oTotalPrice double not null ,
foreign key (cId) references customers(cId)
);

insert into orders (oId,cId,oDate,oTotalPrice)
values (1,1,'2016-3-11',350000),
(2,2,'2016-2-23',250000),
(3,1,'2016-6-26',430000);

insert into orders (oId,cId,oDate,oTotalPrice)
values (4,4,'2020-2-21',0);

create table orderDetail (
oId  int not null,
pId int not null,
odQuantity int not null,
foreign key (oId)  references  orders(oId),
foreign key (pId) references products(pId)
);

insert into orderDetail(oId,pId,odQuantity)
values (1,1,3),
(1,3,7),
(1,4,2),
(2,1,1),
(3,1,8),
(2,5,4),
(2,3,3);

insert into orderDetail(oId,pId,odQuantity)
values (4,1,0);

CREATE VIEW view_all_customers AS
SELECT * 
FROM customers;
SELECT * FROM view_all_customers;

CREATE VIEW view_high_value_orders AS
SELECT * 
FROM orders
WHERE oTotalPrice > 150000;
SELECT * FROM view_high_value_orders;

CREATE INDEX idx_customer_name
ON customers(cName);
SHOW INDEX FROM customers;

CREATE INDEX idx_product_name
ON products(pName);
SHOW INDEX FROM products;

DELIMITER //
CREATE PROCEDURE GetSmallestOrder()
BEGIN
    SELECT *
    FROM orders
    WHERE oTotalPrice = (
        SELECT MIN(oTotalPrice) 
        FROM orders
    );
END //
DELIMITER ;
CALL GetSmallestOrder();

DELIMITER //
CREATE PROCEDURE GetCustomerWithLeastMayGiat()
BEGIN
    SELECT 
        customers.cName, 
        SUM(orderDetail.odQuantity) AS totalQuantity
    FROM 
        customers
    JOIN 
        orders ON customers.cId = orders.cId
    JOIN 
        orderDetail ON orders.oId = orderDetail.oId
    JOIN 
        products ON orderDetail.pId = products.pId
    WHERE 
        products.pName = 'May Giat'
    GROUP BY 
        customers.cName
    ORDER BY 
        totalQuantity ASC
    LIMIT 1;
END //
DELIMITER ;
CALL GetCustomerWithLeastMayGiat();