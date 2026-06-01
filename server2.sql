--Services Table
CREATE TABLE Services
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    ServiceName NVARCHAR(100) NOT NULL
);

INSERT INTO Services (ServiceName)
VALUES 
('Electrician'),
('Plumber'),
('HVAC Service'),
('Carpentry'),
('Painting');

select * from Services
--select * from Bookings
--2. Bookings Table (Improved 🔥)
CREATE TABLE Bookings
(
    Id INT IDENTITY(1,1) PRIMARY KEY,

    UserId INT NOT NULL,
    ServiceId INT NOT NULL,

    Issue NVARCHAR(500),
    Urgency NVARCHAR(50),

    ServiceDate DATE,
    ServiceTime NVARCHAR(20),

    Address NVARCHAR(300),
    Phone NVARCHAR(20),
    Email NVARCHAR(150),

    Status NVARCHAR(50) DEFAULT 'Pending',
    CreatedAt DATETIME DEFAULT GETDATE(),

    -- 🔥 Foreign Keys (IMPORTANT)
    CONSTRAINT FK_UserBooking FOREIGN KEY (UserId) REFERENCES Users(Id),
    CONSTRAINT FK_ServiceBooking FOREIGN KEY (ServiceId) REFERENCES Services(Id)
);

--3. Create Booking SP
CREATE OR ALTER PROCEDURE sp_CreateBooking
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
    );

    -- 🔥 Return Booking Id
    SELECT SCOPE_IDENTITY() AS BookingId;
END

--4. Get My Bookings SP (Final Clean Version)
CREATE OR ALTER PROCEDURE sp_GetMyBookings
(
    @UserId INT
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        B.Id,
        S.ServiceName AS Service,
        B.Issue AS Description,
        B.ServiceDate AS Date,
        B.ServiceTime AS Time,
        B.Status,
        U.Name AS Customer   -- 🔥 MUST
    FROM Bookings B
    JOIN Users U ON B.UserId = U.Id
    JOIN Services S ON B.ServiceId = S.Id
    WHERE B.UserId = @UserId
END
--Alter booking table
ALTER TABLE Bookings
ADD ProviderId INT NULL;
ALTER TABLE Bookings
ADD CONSTRAINT FK_ProviderBooking 
FOREIGN KEY (ProviderId) REFERENCES Users(Id);

--Get Available Bookings (Pending only)
CREATE OR ALTER PROCEDURE sp_GetAvailableBookings
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        B.Id,
        S.ServiceName AS Service,
        U.Name AS Customer,
        B.Issue AS Description,
        B.ServiceDate AS Date,
        B.ServiceTime AS Time,
        B.Status
    FROM Bookings B
    JOIN Users U ON B.UserId = U.Id
    JOIN Services S ON B.ServiceId = S.Id
    WHERE B.Status = 'Pending'
END

--2. Accept Booking (IMPORTANT 🔥)
CREATE OR ALTER PROCEDURE sp_AcceptBooking
(
    @BookingId INT,
    @ProviderId INT
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Bookings
    SET 
        Status = 'Accepted',
        ProviderId = @ProviderId
    WHERE Id = @BookingId
END

CREATE OR ALTER PROCEDURE sp_InProgressBooking
(
    @BookingId INT
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Bookings
    SET 
        Status = 'In Progress'
        
    WHERE Id = @BookingId
END

CREATE PROCEDURE sp_GetInProgressBookings
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        B.Id,
        S.ServiceName AS Service,
        U.Name AS Customer,
        B.Issue AS Description,
        B.ServiceDate AS Date,
        B.ServiceTime AS Time,
        B.Status
    FROM Bookings B
    JOIN Users U ON B.UserId = U.Id
    JOIN Services S ON B.ServiceId = S.Id
    WHERE B.Status = 'In Progress'
END
--3. Get Provider Accepted Bookings
CREATE OR ALTER PROCEDURE sp_GetProviderBookings
(
    @ProviderId INT
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        B.Id,
        S.ServiceName AS Service,
        U.Name AS Customer,
        B.Issue AS Description,
        B.ServiceDate AS Date,
        B.ServiceTime AS Time,
        B.Status
    FROM Bookings B
    JOIN Users U ON B.UserId = U.Id
    JOIN Services S ON B.ServiceId = S.Id
    WHERE B.ProviderId = @ProviderId
    AND B.Status = 'Accepted'
END

--4. Complete Booking
CREATE OR ALTER PROCEDURE sp_CompleteBooking
(
    @BookingId INT
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Bookings
    SET Status = 'Completed'
    WHERE Id = @BookingId
END


exec sp_AcceptBooking @BookingId=6,@ProviderId=1;


INSERT INTO Bookings
(
    UserId, ServiceId, Issue, Urgency,
    ServiceDate, ServiceTime, Address, Phone, Email
)
VALUES
(1, 2, 'Pipe leakage', 'High', '2026-04-15', '10:00 AM', 'Tanjore', '9999999999', 'test@gmail.com');

--select * from Bookings


-- get all provider booking based on servicer id
CREATE PROCEDURE Sp_GetAllBooking
(
    @ProviderId INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        B.Id,
        S.ServiceName AS Service,
        U.Name AS Customer,
        B.Issue AS Description,
        B.ServiceDate AS Date,
        B.ServiceTime AS Time,
        B.Status,
        B.Address,
        B.Phone
    FROM Bookings B
    INNER JOIN Users U ON B.UserId = U.Id
    INNER JOIN Services S ON B.ServiceId = S.Id
    WHERE B.ProviderId = @ProviderId;
END
exec Sp_GetAllBooking @ProviderId=2