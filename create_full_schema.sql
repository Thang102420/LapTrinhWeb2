USE HouseRentalDb;
GO

-- 1. USERS
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;
CREATE TABLE dbo.Users (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    PhoneNumber NVARCHAR(20) NOT NULL UNIQUE,
    IdentityNumber NVARCHAR(20) NULL,
    Address NVARCHAR(200) NULL,
    AvatarUrl NVARCHAR(500) NULL,
    PasswordHash VARBINARY(MAX) NOT NULL,
    PasswordSalt VARBINARY(MAX) NOT NULL,
    Role NVARCHAR(20) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME2 NULL
);
GO

-- 2. CATEGORIES
IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL DROP TABLE dbo.Categories;
CREATE TABLE dbo.Categories (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(200) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE()
);
GO

-- 3. AMENITIES
IF OBJECT_ID('dbo.Amenities', 'U') IS NOT NULL DROP TABLE dbo.Amenities;
CREATE TABLE dbo.Amenities (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    IconUrl NVARCHAR(500) NULL,
    Description NVARCHAR(200) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE()
);
GO

-- 4. SERVICETYPES
IF OBJECT_ID('dbo.ServiceTypes', 'U') IS NOT NULL DROP TABLE dbo.ServiceTypes;
CREATE TABLE dbo.ServiceTypes (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Unit NVARCHAR(50) NOT NULL,
    DefaultPrice DECIMAL(18,2) NOT NULL DEFAULT 0,
    IsMetered BIT NOT NULL DEFAULT 0,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE()
);
GO

-- 5. PROPERTIES
IF OBJECT_ID('dbo.Properties', 'U') IS NOT NULL DROP TABLE dbo.Properties;
CREATE TABLE dbo.Properties (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    CategoryId INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    Address NVARCHAR(200) NOT NULL,
    Province NVARCHAR(100) NOT NULL,
    District NVARCHAR(100) NOT NULL,
    Ward NVARCHAR(100) NOT NULL,
    Latitude DECIMAL(9,6) NULL,
    Longitude DECIMAL(9,6) NULL,
    Area DECIMAL(10,2) NOT NULL,
    Price DECIMAL(18,2) NOT NULL,
    DepositAmount DECIMAL(18,2) NOT NULL DEFAULT 0,
    Bedrooms INT NOT NULL DEFAULT 1,
    Bathrooms INT NOT NULL DEFAULT 1,
    MaxOccupants INT NOT NULL DEFAULT 2,
    Status NVARCHAR(20) NOT NULL DEFAULT 'AVAILABLE',
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME2 NULL,

    CONSTRAINT FK_Properties_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id) ON DELETE NO ACTION,
    CONSTRAINT FK_Properties_Categories FOREIGN KEY (CategoryId) REFERENCES dbo.Categories(Id) ON DELETE NO ACTION
);
GO

-- 6. PROPERTYAMENITIES
IF OBJECT_ID('dbo.PropertyAmenities', 'U') IS NOT NULL DROP TABLE dbo.PropertyAmenities;
CREATE TABLE dbo.PropertyAmenities (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    PropertyId INT NOT NULL,
    AmenityId INT NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_PropertyAmenities_Properties FOREIGN KEY (PropertyId) REFERENCES dbo.Properties(Id) ON DELETE CASCADE,
    CONSTRAINT FK_PropertyAmenities_Amenities FOREIGN KEY (AmenityId) REFERENCES dbo.Amenities(Id) ON DELETE CASCADE
);
GO

-- 7. PROPERTYIMAGES
IF OBJECT_ID('dbo.PropertyImages', 'U') IS NOT NULL DROP TABLE dbo.PropertyImages;
CREATE TABLE dbo.PropertyImages (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    PropertyId INT NOT NULL,
    ImageUrl NVARCHAR(500) NOT NULL,
    IsCover BIT NOT NULL DEFAULT 0,
    DisplayOrder INT NOT NULL DEFAULT 0,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_PropertyImages_Properties FOREIGN KEY (PropertyId) REFERENCES dbo.Properties(Id) ON DELETE CASCADE
);
GO

-- 8. PROPERTYSERVICES
IF OBJECT_ID('dbo.PropertyServices', 'U') IS NOT NULL DROP TABLE dbo.PropertyServices;
CREATE TABLE dbo.PropertyServices (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    PropertyId INT NOT NULL,
    ServiceTypeId INT NOT NULL,
    Price DECIMAL(18,2) NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_PropertyServices_Properties FOREIGN KEY (PropertyId) REFERENCES dbo.Properties(Id) ON DELETE CASCADE,
    CONSTRAINT FK_PropertyServices_ServiceTypes FOREIGN KEY (ServiceTypeId) REFERENCES dbo.ServiceTypes(Id) ON DELETE NO ACTION
);
GO

-- 9. APPOINTMENTS
IF OBJECT_ID('dbo.Appointments', 'U') IS NOT NULL DROP TABLE dbo.Appointments;
CREATE TABLE dbo.Appointments (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    PropertyId INT NOT NULL,
    UserId INT NOT NULL,
    AppointmentDate DATETIME2 NOT NULL,
    Note NVARCHAR(500) NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'PENDING',
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME2 NULL,

    CONSTRAINT FK_Appointments_Properties FOREIGN KEY (PropertyId) REFERENCES dbo.Properties(Id) ON DELETE NO ACTION,
    CONSTRAINT FK_Appointments_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id) ON DELETE NO ACTION
);
GO

-- 10. CONTRACTS
IF OBJECT_ID('dbo.Contracts', 'U') IS NOT NULL DROP TABLE dbo.Contracts;
CREATE TABLE dbo.Contracts (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    PropertyId INT NOT NULL,
    UserId INT NOT NULL,
    ContractCode NVARCHAR(50) NOT NULL UNIQUE,
    StartDate DATETIME2 NOT NULL,
    EndDate DATETIME2 NOT NULL,
    MonthlyRent DECIMAL(18,2) NOT NULL,
    DepositAmount DECIMAL(18,2) NOT NULL,
    PaymentCycleMonths INT NOT NULL DEFAULT 1,
    PaymentDueDay INT NOT NULL DEFAULT 5,
    Terms NVARCHAR(MAX) NULL,
    ContractFileUrl NVARCHAR(500) NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME2 NULL,

    CONSTRAINT FK_Contracts_Properties FOREIGN KEY (PropertyId) REFERENCES dbo.Properties(Id) ON DELETE NO ACTION,
    CONSTRAINT FK_Contracts_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id) ON DELETE NO ACTION
);
GO

-- 11. MAINTENANCEREQUESTS
IF OBJECT_ID('dbo.MaintenanceRequests', 'U') IS NOT NULL DROP TABLE dbo.MaintenanceRequests;
CREATE TABLE dbo.MaintenanceRequests (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    PropertyId INT NOT NULL,
    UserId INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(1000) NOT NULL,
    ImageUrl NVARCHAR(500) NULL,
    Priority NVARCHAR(20) NOT NULL DEFAULT 'MEDIUM',
    Status NVARCHAR(20) NOT NULL DEFAULT 'PENDING',
    ResolvedDate DATETIME2 NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME2 NULL,

    CONSTRAINT FK_MaintenanceRequests_Properties FOREIGN KEY (PropertyId) REFERENCES dbo.Properties(Id) ON DELETE NO ACTION,
    CONSTRAINT FK_MaintenanceRequests_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id) ON DELETE NO ACTION
);
GO

-- 12. REVIEWS
IF OBJECT_ID('dbo.Reviews', 'U') IS NOT NULL DROP TABLE dbo.Reviews;
CREATE TABLE dbo.Reviews (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    PropertyId INT NOT NULL,
    UserId INT NOT NULL,
    Rating INT NOT NULL CHECK (Rating >= 1 AND Rating <= 5),
    Comment NVARCHAR(1000) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Reviews_Properties FOREIGN KEY (PropertyId) REFERENCES dbo.Properties(Id) ON DELETE NO ACTION,
    CONSTRAINT FK_Reviews_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id) ON DELETE NO ACTION
);
GO

-- 13. INVOICES
IF OBJECT_ID('dbo.Invoices', 'U') IS NOT NULL DROP TABLE dbo.Invoices;
CREATE TABLE dbo.Invoices (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ContractId INT NOT NULL,
    UserId INT NOT NULL,
    InvoiceCode NVARCHAR(50) NOT NULL UNIQUE,
    BillingMonth INT NOT NULL,
    BillingYear INT NOT NULL,
    DueDate DATETIME2 NOT NULL,
    TotalAmount DECIMAL(18,2) NOT NULL DEFAULT 0,
    PaidAmount DECIMAL(18,2) NOT NULL DEFAULT 0,
    Status NVARCHAR(20) NOT NULL DEFAULT 'UNPAID',
    Note NVARCHAR(200) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME2 NULL,

    CONSTRAINT FK_Invoices_Contracts FOREIGN KEY (ContractId) REFERENCES dbo.Contracts(Id) ON DELETE NO ACTION,
    CONSTRAINT FK_Invoices_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id) ON DELETE NO ACTION
);
GO

-- 14. INVOICEDETAILS
IF OBJECT_ID('dbo.InvoiceDetails', 'U') IS NOT NULL DROP TABLE dbo.InvoiceDetails;
CREATE TABLE dbo.InvoiceDetails (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    InvoiceId INT NOT NULL,
    ServiceTypeId INT NOT NULL,
    OldReading DECIMAL(10,2) NULL,
    NewReading DECIMAL(10,2) NULL,
    Quantity DECIMAL(10,2) NOT NULL DEFAULT 1,
    UnitPrice DECIMAL(18,2) NOT NULL,
    Amount DECIMAL(18,2) NOT NULL,
    Note NVARCHAR(200) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_InvoiceDetails_Invoices FOREIGN KEY (InvoiceId) REFERENCES dbo.Invoices(Id) ON DELETE CASCADE,
    CONSTRAINT FK_InvoiceDetails_ServiceTypes FOREIGN KEY (ServiceTypeId) REFERENCES dbo.ServiceTypes(Id) ON DELETE NO ACTION
);
GO

-- 15. PAYMENTS
IF OBJECT_ID('dbo.Payments', 'U') IS NOT NULL DROP TABLE dbo.Payments;
CREATE TABLE dbo.Payments (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    InvoiceId INT NOT NULL,
    UserId INT NOT NULL,
    PaymentCode NVARCHAR(50) NOT NULL UNIQUE,
    Amount DECIMAL(18,2) NOT NULL,
    PaymentMethod NVARCHAR(20) NOT NULL,
    TransactionCode NVARCHAR(100) NULL,
    PaymentDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    Status NVARCHAR(20) NOT NULL DEFAULT 'SUCCESS',
    Note NVARCHAR(200) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Payments_Invoices FOREIGN KEY (InvoiceId) REFERENCES dbo.Invoices(Id) ON DELETE NO ACTION,
    CONSTRAINT FK_Payments_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id) ON DELETE NO ACTION
);
GO

-- SEED DATA
INSERT INTO dbo.Users (FullName, Email, PhoneNumber, IdentityNumber, Address, PasswordHash, PasswordSalt, Role, IsActive)
VALUES 
(N'Quản Trị Viên', N'admin@rental.com', N'0901000001', N'001099000001', N'Hà Nội', 0x01, 0x02, N'ADMIN', 1),
(N'Nguyễn Văn Chủ Nhà', N'landlord@rental.com', N'0902000002', N'001099000002', N'Cầu Giấy, Hà Nội', 0x01, 0x02, N'LANDLORD', 1),
(N'Trần Thị Khách Thuê', N'tenant@rental.com', N'0903000003', N'001099000003', N'Đống Đa, Hà Nội', 0x01, 0x02, N'TENANT', 1);

INSERT INTO dbo.Categories (Name, Description)
VALUES 
(N'Chung cư mini', N'Căn hộ mini khép kín đầy đủ đồ'),
(N'Phòng trọ sinh viên', N'Phòng trọ giá rẻ diện tích từ 15-25m2'),
(N'Căn hộ dịch vụ', N'Căn hộ cao cấp có dọn phòng và quản lý'),
(N'Nhà nguyên căn', N'Nhà riêng từ 2-4 tầng phù hợp hộ gia đình');

INSERT INTO dbo.Amenities (Name, Description)
VALUES 
(N'Điều hòa Inverter', N'Tiết kiệm điện'),
(N'Bình nóng lạnh', N'Nóng lạnh 20L'),
(N'Máy giặt riêng', N'Máy giặt cửa trước'),
(N'Tủ lạnh 2 cánh', N'Dung tích 200L'),
(N'Khóa cửa vân tay', N'An ninh 24/7'),
(N'Thang máy', N'Thang máy tốc độ cao');

INSERT INTO dbo.ServiceTypes (Name, Unit, DefaultPrice, IsMetered)
VALUES 
(N'Tiền điện', N'kWh', 3800.00, 1),
(N'Tiền nước sinh hoạt', N'm3', 28000.00, 1),
(N'Internet Wifi', N'Phòng', 100000.00, 0),
(N'Dịch vụ vệ sinh & Thang máy', N'Người', 50000.00, 0),
(N'Gửi xe máy', N'Xe', 100000.00, 0);

INSERT INTO dbo.Properties (UserId, CategoryId, Title, Description, Address, Province, District, Ward, Area, Price, DepositAmount, Bedrooms, Bathrooms, MaxOccupants, Status)
VALUES 
(2, 1, N'Căn hộ mini Full đồ mới 100% ngõ 68 Cầu Giấy', N'Phòng rộng thoáng mát, có ban công phơi đồ, giờ giấc tự do không chung chủ', N'Số 12 ngõ 68 Cầu Giấy', N'Hà Nội', N'Quận Cầu Giấy', N'Phường Quan Hoa', 32.5, 4500000.00, 4500000.00, 1, 1, 2, N'AVAILABLE'),
(2, 2, N'Phòng trọ khép kín gần ĐH Quốc Gia', N'Có điều hòa, nóng lạnh, gác xép để đồ rộng rãi', N'Số 5 ngõ 336 Xuân Thủy', N'Hà Nội', N'Quận Cầu Giấy', N'Phường Dịch Vọng Hậu', 20.0, 2800000.00, 2800000.00, 1, 1, 2, N'AVAILABLE');

INSERT INTO dbo.PropertyAmenities (PropertyId, AmenityId)
VALUES (1, 1), (1, 2), (1, 3), (1, 4), (1, 5);

INSERT INTO dbo.PropertyServices (PropertyId, ServiceTypeId, Price)
VALUES 
(1, 1, 3800.00),
(1, 2, 28000.00),
(1, 3, 100000.00),
(1, 4, 50000.00);

INSERT INTO dbo.Contracts (PropertyId, UserId, ContractCode, StartDate, EndDate, MonthlyRent, DepositAmount, PaymentCycleMonths, PaymentDueDay, Terms, Status)
VALUES 
(1, 3, N'HD-202610-0001', '2026-10-01', '2027-10-01', 4500000.00, 4500000.00, 1, 5, N'Hợp đồng thuê 1 năm, thanh toán hàng tháng vào ngày 5.', N'ACTIVE');

INSERT INTO dbo.Invoices (ContractId, UserId, InvoiceCode, BillingMonth, BillingYear, DueDate, TotalAmount, PaidAmount, Status, Note)
VALUES 
(1, 3, N'INV-202610-0001', 10, 2026, '2026-10-05', 5250000.00, 5250000.00, N'PAID', N'Tiền nhà tháng 10 + Điện nước dịch vụ');

INSERT INTO dbo.InvoiceDetails (InvoiceId, ServiceTypeId, OldReading, NewReading, Quantity, UnitPrice, Amount, Note)
VALUES 
(1, 1, 1200.00, 1350.00, 150.00, 3800.00, 570000.00, N'Chỉ số điện: 1200 -> 1350'),
(1, 2, 80.00, 85.00, 5.00, 28000.00, 140000.00, N'Chỉ số nước: 80 -> 85'),
(1, 3, NULL, NULL, 1.00, 100000.00, 100000.00, N'Internet cáp quang tháng 10');

INSERT INTO dbo.Payments (InvoiceId, UserId, PaymentCode, Amount, PaymentMethod, TransactionCode, PaymentDate, Status, Note)
VALUES 
(1, 3, N'PAY-202610-001', 5250000.00, N'BANK_TRANSFER', N'VNPAY20261005123456', GETDATE(), N'SUCCESS', N'Chuyển khoản thanh toán tiền phòng tháng 10');
GO
