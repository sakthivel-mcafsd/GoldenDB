create database services
CREATE TABLE Users
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100),
    Email NVARCHAR(150),
    PasswordHash VARBINARY(256),
    PasswordSalt VARBINARY(256),
    Role NVARCHAR(50)
)

CREATE PROCEDURE sp_RegisterUser
(
    @Name NVARCHAR(100),
    @Email NVARCHAR(150),
    @PasswordHash VARBINARY(256),
    @PasswordSalt VARBINARY(256),
    @Role NVARCHAR(50)
)
AS
BEGIN

IF EXISTS (SELECT 1 FROM Users WHERE Email = @Email)
BEGIN
    RETURN 0
END

INSERT INTO Users
(
    Name,
    Email,
    PasswordHash,
    PasswordSalt,
    Role
)
VALUES
(
    @Name,
    @Email,
    @PasswordHash,
    @PasswordSalt,
    @Role
)

END
select * from Users



CREATE PROCEDURE dbo.sp_LoginUser
(
    @Email NVARCHAR(150)
)
AS
BEGIN

SET NOCOUNT ON;

SELECT 
    Id,
    Email,
    Role,
    PasswordHash,
    PasswordSalt
FROM dbo.Users
WHERE Email = @Email

END
ALTER PROCEDURE dbo.sp_LoginUser
(
    @Email NVARCHAR(150)
)
AS
BEGIN

SET NOCOUNT ON;

SELECT 
    Id,
    Name,       -- inga Name add pannalam
    Email,
    Role,
    PasswordHash,
    PasswordSalt
FROM dbo.Users
WHERE Email = @Email

END