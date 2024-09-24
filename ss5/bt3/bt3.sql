create table class(
Id int primary key auto_increment,
className varchar(100) not null unique,
startDate datetime not null,
status bit(1) not null
);

create table student(
id int primary key auto_increment,
studentName varchar(100) not null,
address varchar(255) not null,
phone varchar(11) not null,
classId int not null,
foreign key (classId) references class(Id),
status bit(1) not null
);

create table subject(
id int primary key auto_increment,
subjectName varchar (100),
credit int not null,
status bit(1) not null
);

create table mark (
markId int auto_increment primary key ,
studentId int not null ,
subjectId int not null ,
mark double not null,
examTime datetime not null  
);

insert into class (className,startDate,status)
values ("bodoi",'2022-01-30',1),
("congan",'2024-02-21',1),
("canhsat",'2021-06-19',1);
insert into student (studentName,address,phone,classId,status)
values ("duong mom","ha noi","0123456789",1,1),
("sep minh","ha nam","0987123456",1,1),
("tho huynh","ha tinh","0987654321",2,1);
insert into subject (subjectName,credit,status)
values ("Toán",3,1),
("Văn",3,1),
("Anh",2,1);
insert into mark (studentId,subjectId,mark,examTime)
values (1,1,7,'2020-05-19'),
(1,1,7,'2022-03-30'),
(2,2,8,'2024-05-23'),
(2,3,9,'2020-03-24'),
(3,3,10,'2021-02-21');

DELIMITER //
CREATE PROCEDURE GetClassesWithMoreThanFiveStudents()
BEGIN
    SELECT 
        class.className, 
        COUNT(student.id) AS student_count
    FROM 
        class
    JOIN 
        student ON class.Id = student.classId
    GROUP BY 
        class.Id
    HAVING 
        student_count > 5;
END //
DELIMITER ;
CALL GetClassesWithMoreThanFiveStudents();

DELIMITER //
CREATE PROCEDURE GetSubjectsWithMaxMark()
BEGIN
    SELECT 
        subject.subjectName, 
        mark.mark, 
        mark.examTime
    FROM 
        subject
    JOIN 
        mark ON subject.id = mark.subjectId
    WHERE 
        mark.mark = 10;
END //
DELIMITER ;
CALL GetSubjectsWithMaxMark();

DELIMITER //
CREATE PROCEDURE GetClassesWithStudentsHavingMaxMark()
BEGIN
    SELECT 
        class.className, 
        student.studentName, 
        subject.subjectName, 
        mark.mark, 
        mark.examTime
    FROM 
        class
    JOIN 
        student ON class.Id = student.classId
    JOIN 
        mark ON student.id = mark.studentId
    JOIN 
        subject ON mark.subjectId = subject.id
    WHERE 
        mark.mark = 10;
END //
DELIMITER ;
CALL GetClassesWithStudentsHavingMaxMark();

DELIMITER //
CREATE PROCEDURE AddNewStudent(
    IN p_studentName VARCHAR(100),
    IN p_address VARCHAR(255),
    IN p_phone VARCHAR(11),
    IN p_classId INT,
    IN p_status BIT,
    OUT new_student_id INT
)
BEGIN
    -- Thêm một sinh viên mới vào bảng student
    INSERT INTO student (studentName, address, phone, classId, status)
    VALUES (p_studentName, p_address, p_phone, p_classId, p_status);
    -- Lấy id vừa được tạo và trả về
    SET new_student_id = LAST_INSERT_ID();
END //
DELIMITER ;
CALL AddNewStudent('Nguyen Van A', 'Ha Noi', '0123456789', 1, 1, @new_student_id);
-- Xem id của sinh viên vừa được thêm
SELECT @new_student_id;

DELIMITER //
CREATE PROCEDURE GetSubjectsWithNoExams()
BEGIN
    SELECT 
        subject.id, 
        subject.subjectName
    FROM 
        subject
    LEFT JOIN 
        mark ON subject.id = mark.subjectId
    WHERE 
        mark.subjectId IS NULL;
END //
DELIMITER ;
CALL GetSubjectsWithNoExams();

