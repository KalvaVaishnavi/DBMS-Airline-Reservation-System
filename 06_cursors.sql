-- Explicit cursor: revenue report for every flight
SET SERVEROUTPUT ON
DECLARE
    CURSOR Flight_Cursor IS
        SELECT F.Flight_Number,
               NVL(SUM(CASE WHEN B.Status = 'Confirmed'
                            THEN B.Fare END), 0) AS Revenue
        FROM Flight F
        LEFT JOIN Schedule S ON S.Flight_ID = F.Flight_ID
        LEFT JOIN Booking  B ON B.Schedule_ID = S.Schedule_ID
        GROUP BY F.Flight_Number
        ORDER BY F.Flight_Number;
BEGIN
    FOR R IN Flight_Cursor LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD(R.Flight_Number, 10) ||
                             'Rs. ' || R.Revenue);
    END LOOP;
END;
/

-- Implicit cursor: batch cancellation when a flight is called off
CREATE OR REPLACE PROCEDURE Cancel_Schedule(P_Schedule NUMBER) AS
BEGIN
    UPDATE Booking SET Status = 'Cancelled'
    WHERE Schedule_ID = P_Schedule AND Status = 'Confirmed';
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' booking(s) cancelled.');
    COMMIT;
END;
/
