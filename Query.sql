CREATE DATABASE Library

USE Library

CREATE VIEW VIEW_BOOK_AND_AUTHORS AS
SELECT
  B.Id,
  B.Name,
  B.PageCount,
  (A.Name + ' ' + A.Surname) AS 'AuthorFullName'
FROM
  Books AS B
JOIN Authors AS A
ON B.AuthorId = A.Id

CREATE VIEW VIEW_AUTHOR_AND_BOOKS AS
SELECT
  A.Id,
  (A.Name + ' ' + A.Surname) AS 'FullName',
  (SELECT COUNT(Id) FROM Books Where AuthorId = A.Id) AS 'BooksCount',
  (SELECT MAX(PageCount) FROM Books Where AuthorId = A.Id) AS 'MaxPageCount'
FROM
  Authors AS A

CREATE PROCEDURE USP_SEARCH
	@searchKey NVARCHAR(100)
AS
SELECT * FROM VIEW_BOOK_AND_AUTHORS
WHERE
	(Name LIKE '%' + @searchKey + '%')
	OR
	(AuthorFullName LIKE '%' + @searchKey + '%')

CREATE PROCEDURE USP_INSERT_TO_AUTHORS
	@name NVARCHAR(30),
	@surname NVARCHAR(30)
AS
INSERT INTO Authors
VALUES
	(@name, @surname)

CREATE PROCEDURE USP_UPDATE_IN_AUTHORS
	@name NVARCHAR(30),
	@surname NVARCHAR(30),
	@searchKey NVARCHAR(30)
AS
UPDATE Authors
SET
	Name = @name,
	Surname = @surname
WHERE
	Name = @searchKey

CREATE PROCEDURE USP_DELETE_FROM_AUTHORS
	@name NVARCHAR(30)
AS
DELETE FROM Authors
WHERE
	Name = @name;

CREATE TABLE Authors
(
	Id INT IDENTITY PRIMARY KEY,
	Name NVARCHAR(30),
	Surname NVARCHAR(30)
)

INSERT INTO Authors
VALUES
	('George','Orwell'),
	('Jack','London'),
	('Ray','Bradbury')

EXEC USP_DELETE_FROM_AUTHORS 'Lev'
EXEC USP_INSERT_TO_AUTHORS 'Lev', 'Tolstoy'
EXEC USP_UPDATE_IN_AUTHORS 'Charles', 'Bukowski', 'Lev'

CREATE TABLE Books
(
	Id INT IDENTITY PRIMARY KEY,
	Name NVARCHAR(100) CHECK (LEN(Name) >= 2 AND LEN(Name) <= 100),
	PageCount INT CHECK (PageCount >= 10),
	AuthorId INT REFERENCES Authors(Id)
)

INSERT INTO Books
VALUES
	('Nineteen Eighty-Four (1984)', 277, 1),
	('Animal Farm', 101, 1),
	('Coming Up for Air', 289, 1),
	('The Iron Heel', 320, 2),
	('Martin Eden', 393, 2),
	('Fahrenheit 451', 256, 3)

SELECT * FROM Authors
SELECT * FROM Books
SELECT * FROM VIEW_BOOK_AND_AUTHORS
SELECT * FROM VIEW_AUTHOR_AND_BOOKS
EXEC USP_SEARCH 'Jack'