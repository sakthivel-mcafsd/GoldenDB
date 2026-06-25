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

select * from Users
ALTER TABLE Users ADD  PhoneNo VARCHAR(15) Null, DateOfBirth varchar(50), Genter var, Address VARCHAR(500);
ALTER TABLE Users ALTER COLUMN Genter VARCHAR(50);
ALTER TABLE Users ALTER COLUMN DateOfBirth Date;
update Users set Gete
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
update Users set IsEmailVerified=1 where Id=3

CREATE PROCEDURE sp_GetUserProfileById
(
    @Id INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        Id,
        Name,
        Email,
        Role,
        PhoneNo,
        DateOfBirth AS DataOfBirth,
        Genter AS Gender,
        Address
    FROM Users
    WHERE Id = @Id;
END
GO

exec sp_GetUserProfileById  @Id=1 
exec sp_UpdateUserProfile  @Id=2,@PhoneNo='79042725252',@DateOfBirth='04-11-2002',@Genter = 'Male',@Address='ppt,pudukkotai,TN'
CREATE PROCEDURE sp_UpdateUserProfile
(
    @Id INT,
    @PhoneNo VARCHAR(15),
    @DateOfBirth VARCHAR(50),
    @Genter VARCHAR(50),
    @Address VARCHAR(500)
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Users
    SET
        PhoneNo = @PhoneNo,
        DateOfBirth = @DateOfBirth,
        Genter = @Genter,
        Address = @Address
    WHERE Id = @Id;

    SELECT @@ROWCOUNT AS RowsAffected;
END
GO
exec sp_UpdateUserProfile @Id=1,@PhoneNo="7979797979",@Name="SakthivelSubramaniyan",@DateOfBirth="2002-11-04",@Genter="Male",@Address="ppt,tanju,tamilnadu"
Alter PROCEDURE sp_UpdateUserProfile
(
    @Id INT,
    @PhoneNo VARCHAR(15),
	@Name varchar(100),
    @DateOfBirth VARCHAR(50),
    @Genter VARCHAR(50),
    @Address VARCHAR(500)
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Users
    SET
	    Name=@Name,
        PhoneNo = @PhoneNo,
        DateOfBirth = @DateOfBirth,
        Genter = @Genter,
        Address = @Address
    WHERE Id = @Id;

    SELECT @@ROWCOUNT AS RowsAffected;
END

ALTER PROCEDURE sp_UpdateUserProfile
(
    @Id INT,
    @PhoneNo VARCHAR(15),
    @DateOfBirth VARCHAR(50),
    @Genter VARCHAR(50),
    @Address VARCHAR(500)
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Users
    SET
        PhoneNo = @PhoneNo,
        DateOfBirth = @DateOfBirth,
        Genter = @Genter,
        Address = @Address
    WHERE Id = @Id;
END
update Users set PhoneNo='79042725252' where Id=2
update Users set DateOfBirth='2002-11-04' where Id=1


CREATE PROCEDURE sp_RegisterUser1
(
    @Name NVARCHAR(100),
    @Email NVARCHAR(150),
    @PasswordHash VARBINARY(256),
    @PasswordSalt VARBINARY(256),
    @Role NVARCHAR(50),
    @Gender VARCHAR(50),
    @DateOfBirth DATE,
    @PhoneNo VARCHAR(15),
    @Address VARCHAR(500),
    @Token NVARCHAR(200)
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Users
    (
        Name,
        Email,
        PasswordHash,
        PasswordSalt,
        Role,
        Genter,
        DateOfBirth,
        PhoneNo,
        Address,
        VerificationToken
    )
    VALUES(@Name,@Email,@PasswordHash,@PasswordSalt,@Role,@Gender,@DateOfBirth,@PhoneNo,@Address,@Token);
END
GO