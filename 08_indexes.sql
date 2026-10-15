-- Index-organized table (indexed file organization)
CREATE TABLE Booking_IOT (
    Booking_ID  INT PRIMARY KEY,
    Schedule_ID INT,
    Fare        NUMBER(10,2)
) ORGANIZATION INDEX;

-- B+ tree (B-tree) secondary indexes
CREATE INDEX Idx_Booking_Passenger ON Booking(Passenger_ID);
CREATE INDEX Idx_Schedule_Flight   ON Schedule(Flight_ID);
CREATE INDEX Idx_Flight_Route      ON Flight(Source_Airport, Dest_Airport);

EXPLAIN PLAN FOR
SELECT * FROM Booking WHERE Passenger_ID = 602;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
