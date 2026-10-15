INSERT INTO Airport VALUES (101, 'Rajiv Gandhi International', 'Hyderabad');
INSERT INTO Airport VALUES (102, 'Indira Gandhi International', 'Delhi');
INSERT INTO Airport VALUES (103, 'Chhatrapati Shivaji International', 'Mumbai');
INSERT INTO Airport VALUES (104, 'Kempegowda International', 'Bengaluru');

INSERT INTO Aircraft VALUES (11, 'Airbus A320', 180);
INSERT INTO Aircraft VALUES (12, 'Boeing 737', 160);

INSERT INTO Flight VALUES (201, 'AI101', 11, 101, 102, '06:00', '08:10', 5500);
INSERT INTO Flight VALUES (202, '6E202', 12, 101, 103, '09:30', '11:00', 4200);
INSERT INTO Flight VALUES (203, 'UK303', 11, 102, 104, '14:00', '16:45', 6100);

INSERT INTO Schedule VALUES (301, 201, TO_DATE('2026-11-15','YYYY-MM-DD'), 150);
INSERT INTO Schedule VALUES (302, 202, TO_DATE('2026-11-16','YYYY-MM-DD'), 120);
INSERT INTO Schedule VALUES (303, 203, TO_DATE('2026-11-17','YYYY-MM-DD'), 100);

INSERT INTO Seat VALUES (501, 11, '1A',  'Business');
INSERT INTO Seat VALUES (502, 11, '12C', 'Economy');
INSERT INTO Seat VALUES (503, 11, '12D', 'Economy');
INSERT INTO Seat VALUES (504, 12, '5A',  'Economy');
INSERT INTO Seat VALUES (505, 12, '5B',  'Economy');

INSERT INTO Passenger VALUES (601, 'Ananya', 'ananya@gmail.com', '9876500001');
INSERT INTO Passenger VALUES (602, 'Rohit',  'rohit@gmail.com',  '9876500002');
INSERT INTO Passenger VALUES (603, 'Meera',  'meera@gmail.com',  '9876500003');

INSERT INTO Booking VALUES (701, 601, 301, 501, TO_DATE('2026-10-20','YYYY-MM-DD'), 9500, 'Confirmed');
INSERT INTO Booking VALUES (702, 602, 301, 502, TO_DATE('2026-10-21','YYYY-MM-DD'), 5500, 'Confirmed');
INSERT INTO Booking VALUES (703, 603, 302, 504, TO_DATE('2026-10-22','YYYY-MM-DD'), 4200, 'Confirmed');
COMMIT;

-- UPDATE
UPDATE Booking   SET Status = 'Cancelled' WHERE Booking_ID = 703;
UPDATE Passenger SET Phone = '9876500039' WHERE Passenger_ID = 603;
COMMIT;

-- DELETE (record not referenced by any booking)
INSERT INTO Passenger VALUES (604, 'Kiran', 'kiran@gmail.com', '9876500004');
DELETE FROM Passenger WHERE Passenger_ID = 604;
COMMIT;
