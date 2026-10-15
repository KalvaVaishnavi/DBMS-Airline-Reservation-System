-- Block 1: SAVEPOINT and ROLLBACK
INSERT INTO Booking VALUES (704, 601, 302, 505,
       TO_DATE('2026-10-25','YYYY-MM-DD'), 4200, 'Confirmed');
SAVEPOINT booking_save;
UPDATE Booking SET Status = 'Cancelled' WHERE Booking_ID = 704;
ROLLBACK TO booking_save;
SELECT Booking_ID, Status FROM Booking WHERE Booking_ID = 704;  -- Confirmed
ROLLBACK;
SELECT COUNT(*) FROM Booking WHERE Booking_ID = 704;            -- 0

-- Block 2: COMMIT makes a change permanent
UPDATE Passenger SET Email = 'ananya.s@gmail.com' WHERE Passenger_ID = 601;
COMMIT;
ROLLBACK;                                  -- has no effect after COMMIT
SELECT Email FROM Passenger WHERE Passenger_ID = 601;
