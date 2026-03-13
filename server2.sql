select * from Users
select * from Bookings
CREATE TABLE Bookings
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT,
    ServiceId INT,
    Issue NVARCHAR(500),
    Urgency NVARCHAR(50),
    ServiceDate DATE,
    ServiceTime NVARCHAR(20),
    Address NVARCHAR(300),
    Phone NVARCHAR(20),
    Email NVARCHAR(150),
    Status NVARCHAR(50) DEFAULT 'Pending',
    CreatedAt DATETIME DEFAULT GETDATE()
)

CREATE PROCEDURE sp_CreateBooking
(
    @UserId INT,
    @ServiceId INT,
    @Issue NVARCHAR(500),
    @Urgency NVARCHAR(50),
    @ServiceDate DATE,
    @ServiceTime NVARCHAR(20),
    @Address NVARCHAR(300),
    @Phone NVARCHAR(20),
    @Email NVARCHAR(150)
)
AS
BEGIN

SET NOCOUNT ON;

INSERT INTO Bookings
(
UserId,
ServiceId,
Issue,
Urgency,
ServiceDate,
ServiceTime,
Address,
Phone,
Email
)
VALUES
(
@UserId,
@ServiceId,
@Issue,
@Urgency,
@ServiceDate,
@ServiceTime,
@Address,
@Phone,
@Email
)

END

CREATE PROCEDURE sp_GetMyBookings
(
    @UserId INT
)
AS
BEGIN

SET NOCOUNT ON;

SELECT 
    Id,
    ServiceId,
    Issue AS Description,
    ServiceDate,
    ServiceTime,
    Status,
    Address,
    Phone,
    Email,
    CreatedAt
FROM Bookings
WHERE UserId = @UserId
ORDER BY CreatedAt DESC

END
DELETE FROM Bookings
WHERE  ServiceId=0;

ALTER PROCEDURE sp_CreateBooking
(
    @UserId INT,
    @ServiceId INT,
    @Issue NVARCHAR(500),
    @Urgency NVARCHAR(50),
    @ServiceDate DATE,
    @ServiceTime NVARCHAR(20),
    @Address NVARCHAR(300),
    @Phone NVARCHAR(20),
    @Email NVARCHAR(150)
)
AS
BEGIN

SET NOCOUNT ON;

INSERT INTO Bookings
(
UserId,
ServiceId,
Issue,
Urgency,
ServiceDate,
ServiceTime,
Address,
Phone,
Email
)
VALUES
(
@UserId,
@ServiceId,
@Issue,
@Urgency,
@ServiceDate,
@ServiceTime,
@Address,
@Phone,
@Email
)

SELECT SCOPE_IDENTITY() AS BookingId

END

ALTER PROCEDURE sp_GetMyBookings
(
@UserId INT
)
AS
BEGIN

SELECT 
B.Id,
S.ServiceName AS Service,
B.Issue AS Description,
B.ServiceDate AS Date,
B.ServiceTime AS Time,
B.Status,
U.Name AS Customer
FROM Bookings B
JOIN Users U ON B.UserId = U.Id
JOIN Services S ON B.ServiceId = S.Id
WHERE B.UserId = @UserId

END