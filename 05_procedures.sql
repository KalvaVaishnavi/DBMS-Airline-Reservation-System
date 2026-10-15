CREATE OR REPLACE PROCEDURE Book_Ticket(
    P_Passenger NUMBER,
    P_Schedule  NUMBER,
    P_Seat      NUMBER,
    P_Fare      NUMBER) AS
    V_Avail NUMBER;
    V_Taken NUMBER;
    V_Valid NUMBER;
    V_Next  NUMBER;
BEGIN
    -- lock the schedule row so concurrent bookings are serialised
    SELECT Available_Seats INTO V_Avail
    FROM Schedule WHERE Schedule_ID = P_Schedule FOR UPDATE;

    SELECT COUNT(*) INTO V_Valid
    FROM Seat St JOIN Flight F ON F.Aircraft_ID = St.Aircraft_ID
                 JOIN Schedule S ON S.Flight_ID = F.Flight_ID
    WHERE St.Seat_ID = P_Seat AND S.Schedule_ID = P_Schedule;

    SELECT COUNT(*) INTO V_Taken FROM Booking
    WHERE Schedule_ID = P_Schedule AND Seat_ID = P_Seat
      AND Status = 'Confirmed';

    IF V_Avail <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No seats available');
    ELSIF V_Valid = 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Seat does not belong to this flight');
    ELSIF V_Taken > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Seat already booked');
    END IF;

    SELECT NVL(MAX(Booking_ID), 700) + 1 INTO V_Next FROM Booking;
    INSERT INTO Booking
    VALUES (V_Next, P_Passenger, P_Schedule, P_Seat,
            SYSDATE, P_Fare, 'Confirmed');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Booking confirmed. Booking ID: ' || V_Next);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20003, 'Invalid schedule');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE Cancel_Booking(B_ID NUMBER) AS
    V_Status Booking.Status%TYPE;
BEGIN
    SELECT Status INTO V_Status
    FROM Booking WHERE Booking_ID = B_ID FOR UPDATE;

    IF V_Status = 'Cancelled' THEN
        RAISE_APPLICATION_ERROR(-20005, 'Booking already cancelled');
    END IF;

    UPDATE Booking SET Status = 'Cancelled'
    WHERE Booking_ID = B_ID;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Booking cancelled. Refund: Rs. '
                         || Calculate_Refund(B_ID));
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20006, 'Booking not found');
END;
/
