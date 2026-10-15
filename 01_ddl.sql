CREATE TABLE Airport (
    Airport_ID   INT PRIMARY KEY,
    Airport_Name VARCHAR2(100) NOT NULL,
    City         VARCHAR2(50) NOT NULL
);

CREATE TABLE Aircraft (
    Aircraft_ID INT PRIMARY KEY,
    Model       VARCHAR2(50) NOT NULL,
    Capacity    INT CHECK (Capacity > 0)
);

CREATE TABLE Flight (
    Flight_ID      INT PRIMARY KEY,
    Flight_Number  VARCHAR2(10) NOT NULL UNIQUE,
    Aircraft_ID    INT,
    Source_Airport INT,
    Dest_Airport   INT,
    Dep_Time       VARCHAR2(10),
    Arr_Time       VARCHAR2(10),
    Base_Fare      NUMBER(10,2) CHECK (Base_Fare > 0),
    FOREIGN KEY (Aircraft_ID)    REFERENCES Aircraft(Aircraft_ID),
    FOREIGN KEY (Source_Airport) REFERENCES Airport(Airport_ID),
    FOREIGN KEY (Dest_Airport)   REFERENCES Airport(Airport_ID),
    CHECK (Source_Airport <> Dest_Airport)
);

CREATE TABLE Schedule (
    Schedule_ID     INT PRIMARY KEY,
    Flight_ID       INT,
    Flight_Date     DATE NOT NULL,
    Available_Seats INT CHECK (Available_Seats >= 0),
    FOREIGN KEY (Flight_ID) REFERENCES Flight(Flight_ID)
);

CREATE TABLE Seat (
    Seat_ID     INT PRIMARY KEY,
    Aircraft_ID INT,
    Seat_Number VARCHAR2(5) NOT NULL,
    Seat_Class  VARCHAR2(20)
                CHECK (Seat_Class IN ('Economy','Business','First')),
    FOREIGN KEY (Aircraft_ID) REFERENCES Aircraft(Aircraft_ID),
    UNIQUE (Aircraft_ID, Seat_Number)
);

CREATE TABLE Passenger (
    Passenger_ID   INT PRIMARY KEY,
    Passenger_Name VARCHAR2(100) NOT NULL,
    Email          VARCHAR2(100) UNIQUE,
    Phone          VARCHAR2(15) UNIQUE
);

CREATE TABLE Booking (
    Booking_ID   INT PRIMARY KEY,
    Passenger_ID INT,
    Schedule_ID  INT,
    Seat_ID      INT,
    Booking_Date DATE,
    Fare         NUMBER(10,2) CHECK (Fare > 0),
    Status       VARCHAR2(20)
                 CHECK (Status IN ('Confirmed','Cancelled')),
    FOREIGN KEY (Passenger_ID) REFERENCES Passenger(Passenger_ID),
    FOREIGN KEY (Schedule_ID)  REFERENCES Schedule(Schedule_ID),
    FOREIGN KEY (Seat_ID)      REFERENCES Seat(Seat_ID)
);

-- A seat can be held by only ONE confirmed booking per schedule
CREATE UNIQUE INDEX Uq_Active_Seat ON Booking (
    CASE WHEN Status = 'Confirmed' THEN Schedule_ID END,
    CASE WHEN Status = 'Confirmed' THEN Seat_ID END
);

-- Supporting table used by the audit trigger
CREATE TABLE Booking_Audit (
    Audit_ID    INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Booking_ID  INT,
    Action_Type VARCHAR2(10),
    Old_Status  VARCHAR2(20),
    New_Status  VARCHAR2(20),
    Changed_By  VARCHAR2(30) DEFAULT USER,
    Changed_On  DATE DEFAULT SYSDATE
);
