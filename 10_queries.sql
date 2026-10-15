-- 8.1 Basic SELECT
SELECT Flight_ID, Flight_Number, Dep_Time, Arr_Time, Base_Fare FROM Flight;
SELECT Airport_ID, City FROM Airport ORDER BY City;

-- 8.2 Joins
SELECT F.Flight_Number, S.Flight_Date, A1.City AS Source, A2.City AS Destination
FROM Flight F JOIN Schedule S ON F.Flight_ID = S.Flight_ID
JOIN Airport A1 ON F.Source_Airport = A1.Airport_ID
JOIN Airport A2 ON F.Dest_Airport   = A2.Airport_ID;

SELECT P.Passenger_Name, B.Booking_ID, B.Status
FROM Passenger P JOIN Booking B ON P.Passenger_ID = B.Passenger_ID;

SELECT F.Flight_Number, COUNT(B.Booking_ID) AS Bookings
FROM Flight F LEFT JOIN Schedule S ON F.Flight_ID = S.Flight_ID
LEFT JOIN Booking B ON S.Schedule_ID = B.Schedule_ID
GROUP BY F.Flight_Number ORDER BY F.Flight_Number;

-- 8.3 Aggregate functions
SELECT COUNT(*) AS Total_Bookings FROM Booking;
SELECT SUM(Fare) AS Confirmed_Revenue FROM Booking WHERE Status = 'Confirmed';
SELECT ROUND(AVG(Base_Fare),2) AS Avg_Fare, MAX(Base_Fare) AS Highest,
       MIN(Base_Fare) AS Lowest FROM Flight;

-- 8.4 GROUP BY and HAVING
SELECT Status, COUNT(*) AS Total FROM Booking GROUP BY Status ORDER BY Status;
SELECT Status, COUNT(*) AS Total FROM Booking
GROUP BY Status HAVING COUNT(*) > 1;
SELECT Schedule_ID, SUM(Fare) AS Revenue FROM Booking
WHERE Status = 'Confirmed' GROUP BY Schedule_ID HAVING SUM(Fare) > 10000;

-- 8.5 Subqueries
SELECT Flight_Number, Base_Fare FROM Flight
WHERE Base_Fare > (SELECT AVG(Base_Fare) FROM Flight);

SELECT Passenger_Name FROM Passenger WHERE Passenger_ID IN
 (SELECT Passenger_ID FROM Booking WHERE Status = 'Confirmed' AND Schedule_ID IN
   (SELECT Schedule_ID FROM Schedule WHERE Flight_ID IN
     (SELECT Flight_ID FROM Flight WHERE Source_Airport =
       (SELECT Airport_ID FROM Airport WHERE City = 'Hyderabad'))));

SELECT Passenger_Name FROM Passenger P WHERE EXISTS
 (SELECT 1 FROM Booking B WHERE B.Passenger_ID = P.Passenger_ID
    AND B.Status = 'Cancelled');

-- 8.6 View
CREATE VIEW Booking_Details AS
SELECT B.Booking_ID, P.Passenger_Name, F.Flight_Number, S.Flight_Date,
       St.Seat_Number, B.Fare, B.Status
FROM Booking B JOIN Passenger P ON B.Passenger_ID = P.Passenger_ID
JOIN Schedule S ON B.Schedule_ID = S.Schedule_ID
JOIN Flight F   ON S.Flight_ID   = F.Flight_ID
JOIN Seat St    ON B.Seat_ID     = St.Seat_ID;
SELECT * FROM Booking_Details;

-- 13 Reports
SELECT Booking_ID, Passenger_Name, Flight_Number, Seat_Number, Fare, Status
FROM Booking_Details ORDER BY Booking_ID;

SELECT B.Booking_ID, P.Passenger_Name, B.Booking_Date, B.Fare,
       Calculate_Refund(B.Booking_ID) AS Refund
FROM Booking B JOIN Passenger P ON B.Passenger_ID = P.Passenger_ID
WHERE B.Status = 'Cancelled';

SELECT F.Flight_Number, S.Flight_Date,
       COUNT(CASE WHEN B.Status = 'Confirmed' THEN 1 END) AS Tickets,
       NVL(SUM(CASE WHEN B.Status = 'Confirmed' THEN B.Fare END), 0) AS Revenue
FROM Flight F JOIN Schedule S ON S.Flight_ID = F.Flight_ID
LEFT JOIN Booking B ON B.Schedule_ID = S.Schedule_ID
GROUP BY F.Flight_Number, S.Flight_Date
ORDER BY S.Flight_Date;
