-- 1. Validation and default values
CREATE OR REPLACE TRIGGER Booking_Validate
BEFORE INSERT ON Booking
FOR EACH ROW
DECLARE
    V_Date DATE;
BEGIN
    IF :NEW.Status IS NULL THEN
        :NEW.Status := 'Confirmed';
    END IF;
    IF :NEW.Booking_Date IS NULL THEN
        :NEW.Booking_Date := SYSDATE;
    END IF;
    SELECT Flight_Date INTO V_Date
    FROM Schedule WHERE Schedule_ID = :NEW.Schedule_ID;
    IF TRUNC(:NEW.Booking_Date) > V_Date THEN
        RAISE_APPLICATION_ERROR(-20010,
            'Cannot book a flight that has already departed');
    END IF;
END;
/

-- 2. Automatic seat inventory update
CREATE OR REPLACE TRIGGER Seat_Inventory
AFTER INSERT OR UPDATE OF Status OR DELETE ON Booking
FOR EACH ROW
BEGIN
    IF INSERTING AND :NEW.Status = 'Confirmed' THEN
        UPDATE Schedule SET Available_Seats = Available_Seats - 1
        WHERE Schedule_ID = :NEW.Schedule_ID;
    ELSIF UPDATING AND :OLD.Status = 'Confirmed'
                   AND :NEW.Status = 'Cancelled' THEN
        UPDATE Schedule SET Available_Seats = Available_Seats + 1
        WHERE Schedule_ID = :NEW.Schedule_ID;
    ELSIF DELETING AND :OLD.Status = 'Confirmed' THEN
        UPDATE Schedule SET Available_Seats = Available_Seats + 1
        WHERE Schedule_ID = :OLD.Schedule_ID;
    END IF;
END;
/

-- 3. Audit / history logging
CREATE OR REPLACE TRIGGER Booking_Audit_Trg
AFTER INSERT OR UPDATE OR DELETE ON Booking
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO Booking_Audit (Booking_ID, Action_Type, Old_Status, New_Status)
        VALUES (:NEW.Booking_ID, 'INSERT', NULL, :NEW.Status);
    ELSIF UPDATING THEN
        INSERT INTO Booking_Audit (Booking_ID, Action_Type, Old_Status, New_Status)
        VALUES (:NEW.Booking_ID, 'UPDATE', :OLD.Status, :NEW.Status);
    ELSE
        INSERT INTO Booking_Audit (Booking_ID, Action_Type, Old_Status, New_Status)
        VALUES (:OLD.Booking_ID, 'DELETE', :OLD.Status, NULL);
    END IF;
END;
/
