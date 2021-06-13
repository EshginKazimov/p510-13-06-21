CREATE DATABASE P510Db

USE P510Db;

CREATE TABLE Students(
	Id int primary key identity,
	Name nvarchar(30) not null,
	Surname nvarchar(30),
	Age int CHECK (Age > 15)
)

insert into Students 
values ('Seymur', 'Suleymanli', 18), 
('Tural', 'Suleymanli', 18),
('Suraj', 'Ismayilov', 21),
('Zulfugar', 'Ibrahimov', 18),
('Elnur', 'Abbaszade', 33),
('Murad', 'Kerimov', 20),
('Elmar', 'Atakishiyev', 17)

--SUB QUERY
SELECT * FROM Students
WHERE Age < (select avg(Age) from Students)

--SQL FUNCTIONS
SELECT LEN(Name) FROM Students

SELECT * FROM Students
WHERE LEN(Name) > 6

--DISTINCT
SELECT Distinct Surname FROM Students

--GROUP BY
SELECT Surname, COUNT(Surname) 'COUNT' FROM Students
Group by Surname

SELECT Surname, COUNT(Surname) 'COUNT' FROM Students
Group by Surname
HAVING COUNT(Surname)>1

--JOINS
CREATE TABLE Groups(
	Id int primary key identity,
	Name nvarchar(10)
)

insert into Groups
values ('P510'),
('P310'), ('P219')

ALTER TABLE Students
ADD GroupId int references Groups(Id)

update Students set GroupId=1

--Inner join
SELECT st.Id, st.Name, Surname, Age, gr.Name 'Group'  FROM Students st
INNER JOIN Groups gr
ON st.GroupId=gr.Id

SELECT * FROM Students st
JOIN Groups gr
ON st.GroupId=gr.Id

--LEFT JOIN
SELECT * FROM Students st
LEFT JOIN Groups gr
ON st.GroupId=gr.Id

--RIGHT JOIN
SELECT * FROM Students st
RIGHT JOIN Groups gr
ON st.GroupId=gr.Id

--FULL JOIN
SELECT * FROM Students st
FULL JOIN Groups gr
ON st.GroupId=gr.Id

--SELF JOIN
CREATE TABLE Positions(
	Id int primary key identity,
	Name nvarchar(30),
	DependencyId int references Positions(Id)
)

SELECT p1.Name 'Child', p2.Name 'Parent' FROM Positions p1
JOIN Positions p2
ON p1.DependencyId=p2.Id

--CROSS JOIN
CREATE TABLE Products(
	Id int primary key identity,
	Name nvarchar(50),
	Price decimal(8,2)
)

CREATE TABLE Sizes(
	Id int primary key identity,
	Name nvarchar(10)
)

SELECT pr.Name, Price, s.Name 'Size' FROM Products pr
CROSS JOIN Sizes s

--NON EQUAL JOIN
CREATE TABLE Marks(
	Id int primary key identity,
	Letter nchar,
	MinMark int,
	MaxMark int
)

ALTER TABLE Students
ADD Grade int

SELECT Name, Surname, Age, Grade, Letter FROM Students s
JOIN Marks m
ON s.Grade BETWEEN m.MinMark AND m.MaxMark
ORDER BY Grade


SELECT st.Name, Surname, Age, gr.Name 'Group', Letter, Grade FROM Students st

JOIN Groups gr
ON st.GroupId=gr.Id

JOIN Marks m
ON st.Grade BETWEEN m.MinMark AND m.MaxMark

--UNION, UNION ALL
CREATE TABLE Employees(
	Id int primary key identity,
	Name nvarchar(30) not null,
	Surname nvarchar(30)
)

SELECT Name, Surname FROM Students
UNION 
SELECT Name, Surname FROM Employees

SELECT Name, Surname FROM Students
UNION ALL
SELECT Name, Surname FROM Employees

--EXCEPT
SELECT Name, Surname FROM Students
EXCEPT
SELECT Name, Surname FROM Employees

SELECT Name, Surname FROM Employees
EXCEPT
SELECT Name, Surname FROM Students

--INTERSECT
SELECT Name, Surname FROM Students
INTERSECT
SELECT Name, Surname FROM Employees


--VIEW
CREATE VIEW usv_GetStudentInfo
AS
SELECT st.Name, Surname, Age, gr.Name 'Group', Letter, Grade FROM Students st

JOIN Groups gr
ON st.GroupId=gr.Id

JOIN Marks m
ON st.Grade BETWEEN m.MinMark AND m.MaxMark

SELECT * FROM usv_GetStudentInfo
ORDER BY Name


--PROCEDURE
CREATE PROCEDURE usp_GetStudentsByAge @age int
AS
SELECT * FROM Students
Where Age>@age

EXEC usp_GetStudentsByAge 20
EXECUTE usp_GetStudentsByAge 21
usp_GetStudentsByAge 18

CREATE PROCEDURE usp_GetStudentsByAgeAndName (@age int, @startWith nvarchar(30))
AS
SELECT * FROM Students
Where Age>@age OR Name LIKE @startWith + '%'

EXEC usp_GetStudentsByAgeAndName 20, 'Tu'

--FUNCTIONS

CREATE FUNCTION usf_GetStudentsCountByName (@startWith nvarchar(30))
returns int
AS
BEGIN
	declare @count int
	SELECT @count=COUNT(*) FROM Students
	WHERE Name LIKE @startWith + '%'

	return @count
END

SELECT dbo.usf_GetStudentsCountByName('T')

--TRIGGER
INSERT INTO Sizes
Values ('XXXXXL')

SELECT * From Sizes

CREATE TRIGGER ShowDataAfterInsertInSizes
ON Sizes
AFTER INSERT
AS
BEGIN 
	SELECT * From Sizes
END

CREATE TRIGGER ShowDataAfterInsertUpdateDeleteInStudents
ON Students
AFTER INSERT,UPDATE,DELETE
AS
BEGIN
	SELECT * From Students
END

DELETE FROM Students
Where Id=8

INSERT INTO Students
values ('Elmar', 'Atakishiyev', 17, 1, 73)