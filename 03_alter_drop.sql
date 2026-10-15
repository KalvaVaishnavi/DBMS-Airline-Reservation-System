ALTER TABLE Passenger ADD Date_Of_Birth DATE;
ALTER TABLE Aircraft  MODIFY Model VARCHAR2(80);
ALTER TABLE Flight    ADD CONSTRAINT Chk_Flight_Times
      CHECK (Dep_Time <> Arr_Time);

CREATE TABLE Flight_Archive AS SELECT * FROM Flight;
DROP TABLE Flight_Archive;
