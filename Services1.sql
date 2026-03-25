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



ALTER TABLE Users 
ADD IsEmailVerified BIT DEFAULT 0,
    VerificationToken NVARCHAR(200)


ALTER PROCEDURE sp_RegisterUser
(
    @Name NVARCHAR(100),
    @Email NVARCHAR(150),
    @PasswordHash VARBINARY(256),
    @PasswordSalt VARBINARY(256),
    @Role NVARCHAR(50),
    @Token NVARCHAR(200)
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
    Role,
    IsEmailVerified,
    VerificationToken
)
VALUES
(
    @Name,
    @Email,
    @PasswordHash,
    @PasswordSalt,
    @Role,
    0,
    @Token
)

END


ALTER PROCEDURE sp_RegisterUser
(
    @Name NVARCHAR(100),
    @Email NVARCHAR(150),
    @PasswordHash VARBINARY(256),
    @PasswordSalt VARBINARY(256),
    @Role NVARCHAR(50),
    @Token NVARCHAR(200)
)
AS
BEGIN

SET NOCOUNT ON;

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
    Role,
    IsEmailVerified,
    VerificationToken
)
VALUES
(
    @Name,
    @Email,
    @PasswordHash,
    @PasswordSalt,
    @Role,
    0,
    @Token
)

RETURN 1

END
select * from Users
DELETE FROM Users

ALTER TABLE Users
ADD CONSTRAINT DF_CreatedDate DEFAULT GETDATE() FOR CreatedDate