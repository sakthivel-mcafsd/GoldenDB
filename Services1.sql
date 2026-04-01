CREATE DATABASE Services;
GO

USE Services;
GO
--1. User table created
CREATE TABLE Users
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(150) NOT NULL UNIQUE,  -- 🔥 UNIQUE
    PasswordHash VARBINARY(256) NOT NULL,
    PasswordSalt VARBINARY(256) NOT NULL,
    Role NVARCHAR(50),
    IsEmailVerified BIT DEFAULT 0,
    VerificationToken NVARCHAR(200),
    CreatedDate DATETIME DEFAULT GETDATE()
);

--2. Register Stored Procedure
CREATE OR ALTER PROCEDURE sp_RegisterUser
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
        RETURN 0;
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
    );

    RETURN 1;
END

-- 3.Login Stored Procedure
CREATE OR ALTER PROCEDURE sp_LoginUser
(
    @Email NVARCHAR(150)
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        Id,
        Name,
        Email,
        Role,
        PasswordHash,
        PasswordSalt,
        IsEmailVerified
    FROM Users
    WHERE Email = @Email;
END

-- 4.Verify Stored Procedure
CREATE OR ALTER PROCEDURE sp_VerifyUser
(
    @Token NVARCHAR(200)
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Users
    SET 
        IsEmailVerified = 1,
        VerificationToken = NULL
    WHERE VerificationToken = @Token;
END