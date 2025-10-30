-- Create Database
CREATE DATABASE Airline_Reservation;
USE Airline_Reservation;

-- Airlines Table
CREATE TABLE Airlines (
    Airline_id INT AUTO_INCREMENT PRIMARY KEY,
    Airline_Name VARCHAR(100) NOT NULL UNIQUE
);

-- Airports Table
CREATE TABLE Airports (
    Airport_code CHAR(3) PRIMARY KEY,   -- IATA code (e.g., JFK, LAX, DEL)
    Airport_Name VARCHAR(100) NOT NULL,
    City VARCHAR(100),
    Country VARCHAR(100)
);

-- Flights Table
CREATE TABLE Flights (
    Flight_id INT AUTO_INCREMENT PRIMARY KEY,
    Flight_number VARCHAR(10) NOT NULL UNIQUE,
    Airline_id INT NOT NULL,
    Origin_airport CHAR(3) NOT NULL,
    Destination_airport CHAR(3) NOT NULL,
    Departure_time DATETIME NOT NULL,
    Arrival_time DATETIME NOT NULL,
    Aircraft_type VARCHAR(50),
    Available_seats INT CHECK (available_seats >= 0),
    Fare DECIMAL(10,2) CHECK (fare >= 0),
    FOREIGN KEY (Airline_id) REFERENCES Airlines(Airline_id),
    FOREIGN KEY (Origin_airport) REFERENCES Airports(Airport_code),
    FOREIGN KEY (Destination_airport) REFERENCES Airports(Airport_code)
);

-- Passengers Table
CREATE TABLE Passengers (
    Passenger_id INT AUTO_INCREMENT PRIMARY KEY,
    First_name VARCHAR(100) NOT NULL,
    Last_name VARCHAR(100) NOT NULL,
    Email VARCHAR(150) UNIQUE,
    Phone VARCHAR(20),
    Address VARCHAR(255)
);

-- Bookings Table (bridge table: Many-to-Many between Flights & Passengers)
CREATE TABLE Bookings (
    Booking_id INT AUTO_INCREMENT PRIMARY KEY,
    Passenger_id INT NOT NULL,
    Flight_id INT NOT NULL,
    Booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Seat_number VARCHAR(5),
    Payment_status ENUM('PENDING', 'PAID', 'CANCELLED') DEFAULT 'PENDING',
    FOREIGN KEY (Passenger_id) REFERENCES Passengers(Passenger_id),
    FOREIGN KEY (Flight_id) REFERENCES Flights(Flight_id),
    UNIQUE(Flight_id, Seat_number)  -- Prevent double booking of same seat
);

-- Users Table (Admin & Agents)
CREATE TABLE Users (
    User_id INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Password_hash VARCHAR(255) NOT NULL,
    User_Role ENUM('ADMIN', 'AGENT') NOT NULL
);

-- Arrival_time must be after Departure_time
ALTER TABLE Flights
ADD CONSTRAINT chk_time CHECK (Arrival_time > Departure_time);

-- Cascade delete for Bookings when Flight is deleted
ALTER TABLE Bookings
DROP FOREIGN KEY Bookings_ibfk_2;   -- old FK (name may differ, check with SHOW CREATE TABLE Bookings;) ,ibfk → shorthand for InnoDB Foreign Key.Bookings_ibfk_2 = Auto-generated foreign key name for (Flight_id → Flights.Flight_id).

ALTER TABLE Bookings
ADD CONSTRAINT fk_booking_flight    -- user-defined name
FOREIGN KEY (Flight_id) REFERENCES Flights(Flight_id)
ON DELETE CASCADE;

-- Update Passengers email uniqueness (allow duplicates but unique with phone)
ALTER TABLE Passengers
DROP INDEX Email;   -- remove old unique constraint

ALTER TABLE Passengers
ADD CONSTRAINT unique_email_phone UNIQUE (Email, Phone);

-- Seat number format validation (like 12A, 20B)
ALTER TABLE Bookings
ADD CONSTRAINT chk_seat_format CHECK (Seat_number REGEXP '^[0-9]{1,2}[A-F]$');

-- Link Bookings with Users (Agents/Admins who added the booking)
ALTER TABLE Bookings
ADD COLUMN Added_by INT;

ALTER TABLE Bookings
ADD CONSTRAINT fk_booking_user
FOREIGN KEY (Added_by) REFERENCES Users(User_id);

-- Flights index on Flight_number
CREATE INDEX idx_flight_number ON Flights(Flight_number);

-- Passengers index on names
CREATE INDEX idx_passenger_name ON Passengers(Last_name, First_name);

-- Bookings index on booking date
CREATE INDEX idx_booking_date ON Bookings(Booking_date);

-- Ensure arrival is after departure
UPDATE Flights
SET Arrival_time = DATE_ADD(Departure_time, INTERVAL 2 HOUR)
WHERE Arrival_time <= Departure_time;

-- Fix seat numbers to match new format (e.g., change '12' to '12A')
UPDATE Bookings
SET Seat_number = CONCAT(Seat_number, 'A')
WHERE Seat_number REGEXP '^[0-9]+$';

-- Add actual arrival time column
ALTER TABLE Flights
ADD COLUMN Actual_Arrival_time DATETIME;

-- Example: simulate actual arrival with 15 min delay
UPDATE Flights
SET Actual_Arrival_time = DATE_ADD(Arrival_time, INTERVAL 15 MINUTE)
WHERE Flight_id IN (1, 3, 5);   -- update only selected flights

-- Example: on-time arrivals
UPDATE Flights
SET Actual_Arrival_time = Arrival_time
WHERE Actual_Arrival_time IS NULL;



-- Airlines Data
INSERT INTO Airlines (Airline_Name) VALUES
('Air India'),
('IndiGo'),
('Emirates'),
('Singapore Airlines'),
('Lufthansa'),
('British Airways'),
('Qatar Airways'),
('Etihad Airways'),
('Turkish Airlines'),
('Cathay Pacific'),
('Air France'),
('KLM'),
('American Airlines'),
('Delta Airlines'),
('United Airlines');

-- Airports Data
INSERT INTO Airports (Airport_code, Airport_Name, City, Country) VALUES
('DEL', 'Indira Gandhi International Airport', 'New Delhi', 'India'),
('BOM', 'Chhatrapati Shivaji Maharaj International Airport', 'Mumbai', 'India'),
('DXB', 'Dubai International Airport', 'Dubai', 'UAE'),
('SIN', 'Changi Airport', 'Singapore', 'Singapore'),
('FRA', 'Frankfurt Airport', 'Frankfurt', 'Germany'),
('LHR', 'Heathrow Airport', 'London', 'UK'),
('DOH', 'Hamad International Airport', 'Doha', 'Qatar'),
('AUH', 'Abu Dhabi International Airport', 'Abu Dhabi', 'UAE'),
('IST', 'Istanbul Airport', 'Istanbul', 'Turkey'),
('HKG', 'Hong Kong International Airport', 'Hong Kong', 'Hong Kong'),
('CDG', 'Charles de Gaulle Airport', 'Paris', 'France'),
('AMS', 'Amsterdam Airport Schiphol', 'Amsterdam', 'Netherlands'),
('JFK', 'John F. Kennedy International Airport', 'New York', 'USA'),
('ATL', 'Hartsfield–Jackson Atlanta International Airport', 'Atlanta', 'USA'),
('ORD', 'O\'Hare International Airport', 'Chicago', 'USA');


-- Flights Data
INSERT INTO Flights (Flight_number, Airline_id, Origin_airport, Destination_airport, Departure_time, Arrival_time, Aircraft_type, Available_seats, Fare) VALUES
('AI101', 1, 'DEL', 'BOM', '2025-09-10 08:00:00', '2025-09-10 10:00:00', 'Airbus A320', 150, 5500.00),
('6E202', 2, 'BOM', 'DEL', '2025-09-11 15:00:00', '2025-09-11 17:00:00', 'Airbus A321', 180, 4500.00),
('EK501', 3, 'BOM', 'DXB', '2025-09-12 09:30:00', '2025-09-12 11:30:00', 'Boeing 777', 220, 15000.00),
('SQ403', 4, 'DEL', 'SIN', '2025-09-13 23:00:00', '2025-09-14 07:00:00', 'Airbus A350', 200, 22000.00),
('LH760', 5, 'FRA', 'DEL', '2025-09-15 14:00:00', '2025-09-16 02:00:00', 'Boeing 747', 250, 30000.00),
('BA215', 6, 'LHR', 'DEL', '2025-09-16 10:00:00', '2025-09-16 22:00:00', 'Boeing 777', 200, 28000.00),
('QR101', 7, 'DOH', 'BOM', '2025-09-17 05:00:00', '2025-09-17 11:00:00', 'Airbus A350', 180, 16000.00),
('EY301', 8, 'AUH', 'DEL', '2025-09-18 08:00:00', '2025-09-18 16:00:00', 'Boeing 777', 200, 17000.00),
('TK100', 9, 'IST', 'DXB', '2025-09-19 07:00:00', '2025-09-19 11:00:00', 'Airbus A330', 190, 14000.00),
('CX500', 10, 'HKG', 'SIN', '2025-09-20 09:00:00', '2025-09-20 13:00:00', 'Boeing 777', 200, 18000.00),
('AF200', 11, 'CDG', 'DEL', '2025-09-21 12:00:00', '2025-09-22 02:00:00', 'Airbus A350', 220, 25000.00),
('KL300', 12, 'AMS', 'DEL', '2025-09-22 14:00:00', '2025-09-23 02:00:00', 'Boeing 777', 220, 26000.00),
('AA101', 13, 'JFK', 'LHR', '2025-09-23 18:00:00', '2025-09-24 06:00:00', 'Boeing 777', 250, 30000.00),
('DL202', 14, 'ATL', 'ORD', '2025-09-24 09:00:00', '2025-09-24 11:00:00', 'Airbus A320', 180, 5000.00),
('UA303', 15, 'ORD', 'JFK', '2025-09-25 07:00:00', '2025-09-25 10:00:00', 'Boeing 737', 170, 5500.00);

-- Passenger Data
INSERT INTO Passengers (First_name, Last_name, Email, Phone, Address) VALUES
('Rahul', 'Sharma', 'rahul.sharma@email.com', '9876543210', 'Delhi, India'),
('Priya', 'Mehta', 'priya.mehta@email.com', '9876500000', 'Mumbai, India'),
('John', 'Smith', 'john.smith@email.com', '+971500000000', 'Dubai, UAE'),
('Alice', 'Tan', 'alice.tan@email.com', '+6598765432', 'Singapore'),
('Hans', 'Müller', 'hans.muller@email.com', '+491701234567', 'Frankfurt, Germany'),
('Emma', 'Brown', 'emma.brown@email.com', '+441234567890', 'London, UK'),
('Ahmed', 'Khan', 'ahmed.khan@email.com', '+97450001234', 'Doha, Qatar'),
('Fatima', 'Al Farsi', 'fatima.farsi@email.com', '+971500112233', 'Abu Dhabi, UAE'),
('Mehmet', 'Yilmaz', 'mehmet.yilmaz@email.com', '+905001234567', 'Istanbul, Turkey'),
('Li', 'Wei', 'li.wei@email.com', '+85212345678', 'Hong Kong'),
('Pierre', 'Dubois', 'pierre.dubois@email.com', '+33123456789', 'Paris, France'),
('Jan', 'de Vries', 'jan.devries@email.com', '+31123456789', 'Amsterdam, Netherlands'),
('Michael', 'Johnson', 'michael.johnson@email.com', '+12123456789', 'New York, USA'),
('Sophia', 'Williams', 'sophia.williams@email.com', '+14041234567', 'Atlanta, USA'),
('Robert', 'Davis', 'robert.davis@email.com', '+13125551234', 'Chicago, USA');

-- Booking Data
INSERT INTO Bookings (Passenger_id, Flight_id, Seat_number, Payment_status, Added_by) VALUES
(1, 1, '12A', 'PAID', 2),
(2, 2, '14B', 'PENDING', 2),
(3, 3, '20C', 'PAID', 2),
(4, 4, '15D', 'PAID', 2),
(5, 5, '22A', 'CANCELLED', 2),
(6, 6, '18B', 'PAID', 2),
(7, 7, '19C', 'PAID', 2),
(8, 8, '21D', 'PENDING', 2),
(9, 9, '23A', 'PAID', 2),
(10, 10, '24B', 'PAID', 2),
(11, 11, '25C', 'PAID', 2),
(12, 12, '26D', 'CANCELLED', 2),
(13, 13, '27A', 'PAID', 2),
(14, 14, '28B', 'PAID', 2),
(15, 15, '29C', 'PAID', 2);

-- User Data
INSERT INTO Users (Username, Password_hash, User_Role) VALUES
('admin1', 'hashed_pass_1', 'ADMIN'),
('admin2', 'hashed_pass_2', 'ADMIN'),
('agent_rahul', 'hashed_pass_3', 'AGENT'),
('agent_priya', 'hashed_pass_4', 'AGENT'),
('agent_john', 'hashed_pass_5', 'AGENT'),
('agent_alice', 'hashed_pass_6', 'AGENT'),
('agent_hans', 'hashed_pass_7', 'AGENT'),
('agent_emma', 'hashed_pass_8', 'AGENT'),
('agent_ahmed', 'hashed_pass_9', 'AGENT'),
('agent_fatima', 'hashed_pass_10', 'AGENT'),
('agent_mehmet', 'hashed_pass_11', 'AGENT'),
('agent_li', 'hashed_pass_12', 'AGENT'),
('agent_pierre', 'hashed_pass_13', 'AGENT'),
('agent_jan', 'hashed_pass_14', 'AGENT'),
('agent_michael', 'hashed_pass_15', 'AGENT');



