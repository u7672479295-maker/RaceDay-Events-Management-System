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

CREATE TABLE dbo.Events (
    EventId INT IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    Date DATETIME2 NOT NULL,
    Location NVARCHAR(200) NOT NULL,
    Distance NVARCHAR(50) NOT NULL,
    EventType NVARCHAR(50) NOT NULL,
    CreatedByUserId INT NOT NULL,
    BannerImageUrl NVARCHAR(1000) NULL,
    DateCreated DATETIME2 NOT NULL
        CONSTRAINT DF_Events_DateCreated DEFAULT GETDATE(),

    CREATE TABLE dbo.Categories (
    CategoryId INT IDENTITY(1,1) NOT NULL,
    EventId INT NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500) NULL,
    RegistrationFee DECIMAL(10,2) NOT NULL
        CONSTRAINT DF_Categories_Fee DEFAULT 0.00,

    CONSTRAINT PK_Categories PRIMARY KEY CLUSTERED (CategoryId),
    CONSTRAINT FK_Categories_Events FOREIGN KEY (EventId)
        REFERENCES dbo.Events (EventId) ON DELETE CASCADE
);

CREATE TABLE dbo.Enrolments (
    EnrolmentId INT IDENTITY(1,1) NOT NULL,
    ParticipantUserId INT NOT NULL,
    EventId INT NOT NULL,
    CategoryId INT NOT NULL,
    EnrolmentDate DATETIME2 NOT NULL
        CONSTRAINT DF_Enrolments_Date DEFAULT GETDATE(),
    EnrolmentStatus NVARCHAR(50) NOT NULL
        CONSTRAINT DF_Enrolments_Status DEFAULT 'Pending',

    CONSTRAINT PK_Enrolments PRIMARY KEY CLUSTERED (EnrolmentId),
    CONSTRAINT UQ_Participant_Event UNIQUE NONCLUSTERED
        (ParticipantUserId, EventId),
    CONSTRAINT CHK_Enrolment_Status CHECK
        (EnrolmentStatus IN ('Pending', 'Confirmed', 'Cancelled')),
    CONSTRAINT FK_Enrolments_Users FOREIGN KEY (ParticipantUserId)
        REFERENCES dbo.Users (UserId),
    CONSTRAINT FK_Enrolments_Events FOREIGN KEY (EventId)
        REFERENCES dbo.Events (EventId),
    CONSTRAINT FK_Enrolments_Categories FOREIGN KEY (CategoryId)
        REFERENCES dbo.Categories (CategoryId)
);

CREATE TABLE dbo.Results (
    ResultId INT IDENTITY(1,1) NOT NULL,
    EnrolmentId INT NOT NULL,
    FinishTime NVARCHAR(50) NOT NULL,
    FinishingPosition INT NOT NULL,
    IsDisqualified BIT NOT NULL
        CONSTRAINT DF_Results_IsDisqualified DEFAULT 0,
    Notes NVARCHAR(500) NULL,

    CONSTRAINT PK_Results PRIMARY KEY CLUSTERED (ResultId),
    CONSTRAINT UQ_Results_Enrolment UNIQUE NONCLUSTERED (EnrolmentId),
    CONSTRAINT FK_Results_Enrolments FOREIGN KEY (EnrolmentId)
        REFERENCES dbo.Enrolments (EnrolmentId) ON DELETE CASCADE,
    CONSTRAINT CHK_Finishing_Position CHECK (FinishingPosition > 0)
);


    CONSTRAINT PK_Events PRIMARY KEY CLUSTERED (EventId),
    CONSTRAINT CHK_Event_Type CHECK (EventType IN ('Run', 'Walk', 'Cycle')),
    CONSTRAINT FK_Events_Users FOREIGN KEY (CreatedByUserId)
        REFERENCES dbo.Users (UserId)
);
