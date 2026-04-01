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