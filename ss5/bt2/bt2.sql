create table account(
id int auto_increment primary key,
username varchar(100) not null unique,
password varchar(255) not null ,
address varchar(255) not null,
status bit(1) not null
);

insert into account (username ,password ,address ,status)
values ("Hùng","123456","Nghệ An",1),
("Cường","654321","Hà Nội",1),
("Bách","135790","Hà Nội",1);

create table bill (
id int auto_increment primary key,
bill_type bit not null ,
acc_id int not null ,
created datetime not null ,
auth_date datetime not null,
foreign key (acc_id) references account(id)
);

insert into bill (bill_type,acc_id,created,auth_date)
values (0,1,'2022-02-11','2022-03-12'),
(0,1,'2023-10-05','2023-10-10'),
(1,3,'2022-02-01','2022-02-10'),
(1,2,'2024-05-15','2024-05-20');

create table product(
id int auto_increment primary key ,
name varchar(255) not null ,
created datetime not null ,
price double not null check (price > 0),
stock int not null ,
status bit(1) not null
);

insert into product(name,created,price,stock,status)
values ("Quần dài",'2022-03-12',1200,5,1),
("Áo dài",'2023-03-15',1500,8,1),
("Mũ cối",'1999-03-08',1600,10,1);

create table bill_detail(
id int auto_increment primary key,
bill_id int not null ,
product_id int not null ,
quantity int not null check (quantity > 0),
price double not null check (price > 0),
foreign key (bill_id) references bill(id),
foreign key (product_id) references product(id)
);

insert into bill_detail (bill_id,product_id,quantity,price)
values (1,1,3,1200), (1,1,3,1200), (1,1,3,1200), (1,1,3,1200),
(1,2,4,1500),
(2,1,1,1200),
(3,2,4,1500),
(4,3,7,1600);

DELIMITER //
CREATE PROCEDURE GetAccountsWithAtLeastFiveBills()
BEGIN
    SELECT 
        account.*,
        COUNT(bill.id) AS total_bills
    FROM 
        account
    JOIN 
        bill ON account.id = bill.acc_id
    GROUP BY 
        account.id
    HAVING 
        total_bills >= 5;
END //
DELIMITER ;
select * from GetAccountsWithAtLeastFiveBills;
CALL GetAccountsWithAtLeastFiveBills();
drop PROCEDURE GetAccountsWithAtLeastFiveBills;

DELIMITER //
CREATE PROCEDURE GetUnsoldProducts()
BEGIN
    SELECT 
        product.*
    FROM 
        product
    LEFT JOIN 
        bill_detail ON product.id = bill_detail.product_id
    WHERE 
        bill_detail.product_id IS NULL;
END //
DELIMITER ;
CALL GetUnsoldProducts();

DELIMITER //
CREATE PROCEDURE GetTop2BestSellingProducts()
BEGIN
    SELECT 
        product.name, 
        SUM(bill_detail.quantity) AS total_quantity_sold
    FROM 
        product
    JOIN 
        bill_detail ON product.id = bill_detail.product_id
    GROUP BY 
        product.name
    ORDER BY 
        total_quantity_sold DESC
    LIMIT 2;
END //
DELIMITER ;
CALL GetTop2BestSellingProducts();

DELIMITER //
CREATE PROCEDURE AddNewAccount(
    IN p_username VARCHAR(100), 
    IN p_password VARCHAR(255), 
    IN p_address VARCHAR(255), 
    IN p_status BIT
)
BEGIN
    INSERT INTO account (username, password, address, status)
    VALUES (p_username, p_password, p_address, p_status);
END //
DELIMITER ;
CALL AddNewAccount('JohnDoe', 'mypassword', '123 Main St', 1);
select * from account;

DELIMITER //
CREATE PROCEDURE GetBillDetailsById(
    IN p_bill_id INT
)
BEGIN
    SELECT 
        bill_detail.id, 
        bill_detail.bill_id, 
        product.name AS product_name, 
        bill_detail.quantity, 
        bill_detail.price
    FROM 
        bill_detail
    JOIN 
        product ON bill_detail.product_id = product.id
    WHERE 
        bill_detail.bill_id = p_bill_id;
END //
DELIMITER ;
CALL GetBillDetailsById(1);

DELIMITER //
CREATE PROCEDURE AddNewBill(
    IN p_bill_type BIT, 
    IN p_acc_id INT, 
    IN p_created DATETIME, 
    IN p_auth_date DATETIME,
    OUT new_bill_id INT
)
BEGIN
    -- Thêm một bản ghi mới vào bảng bill
    INSERT INTO bill (bill_type, acc_id, created, auth_date)
    VALUES (p_bill_type, p_acc_id, p_created, p_auth_date);
    -- Lấy bill_id vừa mới được tạo
    SET new_bill_id = LAST_INSERT_ID();
END //
DELIMITER ;
CALL AddNewBill(1, 2, '2024-01-01 10:00:00', '2024-01-02 12:00:00', @new_bill_id);
-- Xem bill_id vừa được tạo
SELECT @new_bill_id;

DELIMITER //
CREATE PROCEDURE GetProductsSoldMoreThanFive()
BEGIN
    SELECT 
        product.name, 
        SUM(bill_detail.quantity) AS total_quantity_sold
    FROM 
        product
    JOIN 
        bill_detail ON product.id = bill_detail.product_id
    GROUP BY 
        product.id
    HAVING 
        total_quantity_sold > 5;
END //
DELIMITER ;
CALL GetProductsSoldMoreThanFive();