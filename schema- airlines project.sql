-- Airline Management System: database schema and sample data
-- Run with:  mysql -u root -p < schema.sql

CREATE DATABASE IF NOT EXISTS airlines;
USE airlines;

-- ---------------------------------------------------------------
-- Tables
-- ---------------------------------------------------------------

CREATE TABLE IF NOT EXISTS airfare (
    company          VARCHAR(20),
    economy_class    VARCHAR(10),
    premium_economy  VARCHAR(10),
    business_class   VARCHAR(10),
    first_class      VARCHAR(10)      -- 'N/A' where the airline has no first class
);

CREATE TABLE IF NOT EXISTS flight (
    flight_id       VARCHAR(10) NOT NULL,
    company         VARCHAR(20),
    flight_date     DATE,
    take_off_point  VARCHAR(20),
    destination     VARCHAR(20),
    departure       TIME,
    arrival         TIME,
    PRIMARY KEY (flight_id)
);

CREATE TABLE IF NOT EXISTS passengers (
    passport_number  VARCHAR(10),
    passenger_id     VARCHAR(10),
    name             VARCHAR(10),
    age              VARCHAR(10),
    sex              VARCHAR(10),
    contacts         VARCHAR(11),
    booking_date     DATE,
    departure_date   DATE,
    flight_id        VARCHAR(10),
    class_type       VARCHAR(20),
    fare             INT,
    UNIQUE (passenger_id)
    -- Optional: uncomment to link passengers to flights. With ON DELETE
    -- CASCADE, cancelling a flight also removes its bookings.
    -- , FOREIGN KEY (flight_id) REFERENCES flight(flight_id) ON DELETE CASCADE
);

-- ---------------------------------------------------------------
-- Sample data (fictional)
-- ---------------------------------------------------------------

INSERT INTO airfare (company, economy_class, premium_economy, business_class, first_class) VALUES
('Air India',    '5500', '8500', '15000', '25000'),
('IndiGo',       '4000', '6500', '12000', 'N/A'),
('SpiceJet',     '3800', '6000', '11000', 'N/A'),
('Vistara',      '6000', '9500', '18000', '28000'),
('Go First',     '4200', '7000', '13000', 'N/A'),
('AirAsia India','3900', '6200', '11500', 'N/A');

INSERT INTO flight (flight_id, company, flight_date, take_off_point, destination, departure, arrival) VALUES
('6E111', 'IndiGo',        '2025-11-03', 'Kolkata',   'Bhubaneswar', '14:00:00', '15:10:00'),
('6E202', 'IndiGo',        '2025-10-29', 'Mumbai',    'Bengaluru',   '09:15:00', '11:00:00'),
('6E334', 'IndiGo',        '2025-10-31', 'Hyderabad', 'Chennai',     '07:20:00', '08:30:00'),
('6E555', 'IndiGo',        '2025-11-02', 'Pune',      'Kolkata',     '12:20:00', '15:05:00'),
('6E789', 'IndiGo',        '2025-10-30', 'Lucknow',   'Delhi',       '14:40:00', '15:50:00'),
('6E999', 'IndiGo',        '2025-11-01', 'Mumbai',    'Ahmedabad',   '08:15:00', '09:20:00'),
('AI101', 'Air India',     '2025-10-29', 'Delhi',     'Mumbai',      '06:30:00', '08:45:00'),
('AI112', 'Air India',     '2025-10-31', 'Mumbai',    'Goa',         '09:45:00', '11:10:00'),
('AI206', 'Air India',     '2025-10-30', 'Delhi',     'Chandigarh',  '11:10:00', '12:05:00'),
('AI215', 'Air India',     '2025-11-01', 'Delhi',     'Leh',         '05:40:00', '07:25:00'),
('AI310', 'Air India',     '2025-11-02', 'Delhi',     'Bengaluru',   '06:10:00', '08:45:00'),
('AI455', 'Air India',     '2025-11-03', 'Chennai',   'Bengaluru',   '07:25:00', '08:15:00'),
('G8310', 'Go First',      '2025-11-01', 'Mumbai',    'Delhi',       '21:15:00', '23:25:00'),
('G8421', 'Go First',      '2025-10-29', 'Delhi',     'Srinagar',    '13:15:00', '14:45:00'),
('G8444', 'Go First',      '2025-11-03', 'Delhi',     'Ahmedabad',   '20:30:00', '22:15:00'),
('I5712', 'AirAsia India', '2025-10-30', 'Bengaluru', 'Hyderabad',   '08:20:00', '09:30:00'),
('I5733', 'AirAsia India', '2025-10-31', 'Kochi',     'Delhi',       '10:00:00', '12:45:00'),
('I5844', 'AirAsia India', '2025-11-02', 'Delhi',     'Patna',       '09:40:00', '11:10:00'),
('SG303', 'SpiceJet',      '2025-10-29', 'Chennai',   'Delhi',       '07:00:00', '09:40:00'),
('SG415', 'SpiceJet',      '2025-10-31', 'Delhi',     'Kolkata',     '16:00:00', '18:10:00'),
('SG704', 'SpiceJet',      '2025-11-02', 'Guwahati',  'Delhi',       '08:00:00', '10:45:00'),
('SG808', 'SpiceJet',      '2025-11-01', 'Bengaluru', 'Pune',        '18:10:00', '19:25:00'),
('SG909', 'SpiceJet',      '2025-11-03', 'Delhi',     'Varanasi',    '11:20:00', '12:45:00'),
('SG982', 'SpiceJet',      '2025-10-30', 'Pune',      'Delhi',       '17:25:00', '19:45:00'),
('UK122', 'Vistara',       '2025-11-03', 'Mumbai',    'Hyderabad',   '18:40:00', '20:10:00'),
('UK220', 'Vistara',       '2025-10-31', 'Bengaluru', 'Mumbai',      '13:25:00', '15:10:00'),
('UK332', 'Vistara',       '2025-11-01', 'Delhi',     'Chennai',     '09:00:00', '11:45:00'),
('UK404', 'Vistara',       '2025-10-29', 'Kolkata',   'Delhi',       '10:30:00', '12:50:00'),
('UK550', 'Vistara',       '2025-10-30', 'Jaipur',    'Mumbai',      '06:00:00', '07:25:00'),
('UK675', 'Vistara',       '2025-11-02', 'Hyderabad', 'Mumbai',      '16:30:00', '18:05:00');

INSERT INTO passengers (passport_number, passenger_id, name, age, sex, contacts, booking_date, departure_date, flight_id, class_type, fare) VALUES
('P12345', 'PS001', 'Aarav',   '28', 'Male',   '9876543210', '2025-10-20', '2025-10-29', 'AI101', 'Economy',         5500),
('P12346', 'PS002', 'Ishita',  '25', 'Female', '9876543211', '2025-10-22', '2025-10-29', '6E202', 'Economy',         4000),
('P12347', 'PS003', 'Vihaan',  '32', 'Male',   '9876543212', '2025-10-23', '2025-10-29', 'SG303', 'Business',        11000),
('P12348', 'PS004', 'Ananya',  '27', 'Female', '9876543213', '2025-10-21', '2025-10-29', 'UK404', 'Premium Economy', 9500),
('P12349', 'PS005', 'Rohan',   '30', 'Male',   '9876543214', '2025-10-24', '2025-10-29', 'G8421', 'Economy',         4200),
('P12350', 'PS006', 'Diya',    '24', 'Female', '9876543215', '2025-10-25', '2025-10-30', 'I5712', 'Economy',         3900),
('P12351', 'PS007', 'Karan',   '35', 'Male',   '9876543216', '2025-10-25', '2025-10-30', 'AI206', 'Business',        15000),
('P12352', 'PS008', 'Meera',   '29', 'Female', '9876543217', '2025-10-26', '2025-10-30', '6E789', 'Economy',         4000),
('P12353', 'PS009', 'Aditya',  '31', 'Male',   '9876543218', '2025-10-26', '2025-10-30', 'SG982', 'Premium Economy', 6000),
('P12354', 'PS010', 'Riya',    '22', 'Female', '9876543219', '2025-10-27', '2025-10-30', 'UK550', 'Economy',         6000),
('P12355', 'PS011', 'Arjun',   '26', 'Male',   '9876543220', '2025-10-27', '2025-10-31', 'AI112', 'Economy',         5500),
('P12356', 'PS012', 'Nisha',   '33', 'Female', '9876543221', '2025-10-27', '2025-10-31', '6E334', 'Premium Economy', 6500),
('P12357', 'PS013', 'Rahul',   '29', 'Male',   '9876543222', '2025-10-28', '2025-10-31', 'SG415', 'Business',        11000),
('P12358', 'PS014', 'Sneha',   '23', 'Female', '9876543223', '2025-10-28', '2025-10-31', 'UK220', 'Economy',         6000),
('P12359', 'PS015', 'Aryan',   '34', 'Male',   '9876543224', '2025-10-28', '2025-10-31', 'I5733', 'Economy',         3900),
('P12360', 'PS016', 'Priya',   '27', 'Female', '9876543225', '2025-10-28', '2025-11-01', 'AI215', 'Business',        15000),
('P12361', 'PS017', 'Lakshay', '28', 'Male',   '9876543226', '2025-10-29', '2025-11-01', '6E999', 'Economy',         4000),
('P12362', 'PS018', 'Saanvi',  '24', 'Female', '9876543227', '2025-10-29', '2025-11-01', 'SG808', 'Premium Economy', 6000),
('P12363', 'PS019', 'Yash',    '36', 'Male',   '9876543228', '2025-10-30', '2025-11-01', 'UK332', 'Business',        18000),
('P12364', 'PS020', 'Avni',    '29', 'Female', '9876543229', '2025-10-30', '2025-11-01', 'G8310', 'Economy',         4200),
('P12365', 'PS021', 'Dev',     '33', 'Male',   '9876543230', '2025-10-31', '2025-11-02', 'AI310', 'Economy',         5500),
('P12366', 'PS022', 'Tara',    '26', 'Female', '9876543231', '2025-10-31', '2025-11-02', '6E555', 'Premium Economy', 6500),
('P12367', 'PS023', 'Ritik',   '35', 'Male',   '9876543232', '2025-10-31', '2025-11-02', 'SG704', 'Business',        11000),
('P12368', 'PS024', 'Mira',    '28', 'Female', '9876543233', '2025-10-31', '2025-11-02', 'UK675', 'Economy',         6000),
('P12369', 'PS025', 'Kavya',   '27', 'Female', '9876543234', '2025-10-31', '2025-11-02', 'I5844', 'Economy',         3900),
('P12370', 'PS026', 'Rajat',   '31', 'Male',   '9876543235', '2025-11-01', '2025-11-03', 'AI455', 'Business',        15000),
('P12371', 'PS027', 'Ira',     '22', 'Female', '9876543236', '2025-11-01', '2025-11-03', '6E111', 'Economy',         4000),
('P12372', 'PS028', 'Naman',   '30', 'Male',   '9876543237', '2025-11-01', '2025-11-03', 'SG909', 'Premium Economy', 6000),
('P12373', 'PS029', 'Simran',  '25', 'Female', '9876543238', '2025-11-01', '2025-11-03', 'UK122', 'Business',        18000),
('P12374', 'PS030', 'Arnav',   '29', 'Male',   '9876543239', '2025-11-01', '2025-11-03', 'G8444', 'Economy',         4200);
