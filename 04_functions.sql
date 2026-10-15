CREATE OR REPLACE FUNCTION Get_Booking_Count(P_ID NUMBER)
RETURN NUMBER IS
    Total_Bookings NUMBER;
BEGIN
    SELECT COUNT(*) INTO Total_Bookings
    FROM Booking
    WHERE Passenger_ID = P_ID;
    RETURN Total_Bookings;
END;
/

CREATE OR REPLACE FUNCTION Calculate_Refund(B_ID NUMBER)
RETURN NUMBER IS
    V_Fare   Booking.Fare%TYPE;
    V_Status Booking.Status%TYPE;
BEGIN
    SELECT Fare, Status INTO V_Fare, V_Status
    FROM Booking
    WHERE Booking_ID = B_ID;

    IF V_Status = 'Cancelled' THEN
        RETURN ROUND(V_Fare * 0.80, 2);   -- 80% refund policy
    ELSE
        RETURN 0;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN -1;                        -- invalid booking id
END;
/
