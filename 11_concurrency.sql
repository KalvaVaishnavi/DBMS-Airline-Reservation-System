-- Open two SQL*Plus windows. Run the steps in the order T1 ... T6.

-- ===== T1 : SESSION A =====
SELECT Schedule_ID, Available_Seats FROM Schedule
WHERE Schedule_ID = 301 FOR UPDATE;

-- ===== T2 : SESSION B  (this statement WAITS) =====
SELECT Schedule_ID, Available_Seats FROM Schedule
WHERE Schedule_ID = 301 FOR UPDATE;

-- ===== T3 : SESSION A =====
SELECT COUNT(*) FROM Booking
WHERE Schedule_ID = 301 AND Seat_ID = 503 AND Status = 'Confirmed';   -- 0
INSERT INTO Booking VALUES (704, 601, 301, 503, SYSDATE, 5500, 'Confirmed');

-- ===== T4 : SESSION A =====
COMMIT;                       -- releases the lock, Session B continues

-- ===== T5 : SESSION B =====
SELECT COUNT(*) FROM Booking
WHERE Schedule_ID = 301 AND Seat_ID = 503 AND Status = 'Confirmed';   -- 1

-- ===== T6 : SESSION B  (seat taken, so reject the request) =====
ROLLBACK;

-- Safety net: an insert that skips the lock is stopped by Uq_Active_Seat
INSERT INTO Booking VALUES (705, 602, 301, 503, SYSDATE, 5500, 'Confirmed');
-- ORA-00001: unique constraint (UQ_ACTIVE_SEAT) violated

-- Clean up the test data
DELETE FROM Booking WHERE Booking_ID = 704;
COMMIT;
