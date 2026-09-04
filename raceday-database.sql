-- ====================================================================================
-- RaceDay Event Management System

--=====================================================================================


IF OBJECT_ID('dbo.Results', 'U') IS NOT NULL DROP TABLE dbo.Results;
IF OBJECT_ID('dbo.Enrolments', 'U') IS NOT NULL DROP TABLE dbo.Enrolments;
IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL DROP TABLE dbo.Categories;
IF OBJECT_ID('dbo.Events', 'U') IS NOT NULL DROP TABLE dbo.Events;
IF OBJECT_ID('dbo.EmergencyContacts', 'U') IS NOT NULL DROP TABLE dbo.EmergencyContacts;
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;

CREATE TABLE dbo.Users (
    UserID INT IDENTITY(1,1) NOT NULL,
    Email NVARCHAR (256) NOT NULL,
    PasswordHash NVARCHAR(512) NOT NULL,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Role NVARCHAR(50) NOT NULL,
    ContactNumber NVARCHAR(20) NOT NULL,
    ProfilePictureUrl NVARCHAR(1000) NOT NULL,
    DateRegistered DATETIME2 NOT NULL,

          CONSTRAINT DF_Users_DateRegistered DEFAULT GETDATE(),
          CONSTRAINT PK_Users PRIMARY KEY CLUSTERED (UserID),
          CONSTRAINT UQ_Users_Email UNIQUE NONCLUSTERED (Email),
          CONSTRAINT CHK_User_Role_Check (Role IN ('Organiser', 'Participant')
  );
  
    CREATE TABLE dbo.EmergencyContacts (
    EmergencyContactId INT IDENTITY(1,1) NOT NULL,
    ParticipantUserId INT NOT NULL,
    ContactName NVARCHAR(200) NOT NULL,
    ContactNumber NVARCHAR(20) NOT NULL,
    Relationship NVARCHAR(100) NOT NULL,
    MedicalAidName NVARCHAR(100) NULL,
    MedicalAidNumber NVARCHAR(50) NULL,

    CONSTRAINT PK_EmergencyContacts PRIMARY KEY CLUSTERED (EmergencyContactId),
    CONSTRAINT UQ_EmergencyContacts_User UNIQUE NONCLUSTERED (ParticipantUserId),
    CONSTRAINT FK_EmergencyContacts_Users FOREIGN KEY (ParticipantUserId)
        REFERENCES dbo.Users (UserId) ON DELETE CASCADE
);

