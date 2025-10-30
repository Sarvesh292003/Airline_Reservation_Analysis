USE Airline_Reservation;
Select * From Airlines;

Select * From Airports;

Select * From Bookings;

Select * From Flights; 

Select * From Passengers;

Select * From Users;

-- All Passengers and their Bookings
SELECT p.First_name, p.Last_name, b.Booking_id, b.Seat_number, b.Payment_status
FROM Passengers p
JOIN Bookings b ON p.Passenger_id = b.Passenger_id;

-- List of all Flight with Airline Name
SELECT f.Flight_number, a.Airline_Name, f.Origin_airport, f.Destination_airport
FROM Flights f
JOIN Airlines a ON f.Airline_id = a.Airline_id;

-- Count the number of bookings for each flight
SELECT f.Flight_number, COUNT(b.Booking_id) AS Total_Bookings
FROM Flights f
LEFT JOIN Bookings b ON f.Flight_id = b.Flight_id
GROUP BY f.Flight_number;

-- Find passengers who have pending payments
SELECT p.First_name, p.Last_name, b.Seat_number, b.Payment_status
FROM Passengers p
JOIN Bookings b ON p.Passenger_id = b.Passenger_id
WHERE b.Payment_status = 'PENDING';

-- Show flights departing from India
SELECT f.Flight_number, f.Departure_time, ap.City, ap.Country
FROM Flights f
JOIN Airports ap 
ON f.Origin_airport = ap.Airport_code
WHERE ap.Country = 'India';

-- Find the total revenue collected (only PAID bookings)
SELECT SUM(f.Fare) AS Total_Revenue
FROM Bookings b
JOIN Flights f 
ON b.Flight_id = f.Flight_id
WHERE b.Payment_status = 'PAID';

-- Show which agent added each booking
SELECT b.Booking_id, p.First_name, p.Last_name, u.Username AS Added_By
FROM Bookings b
JOIN Passengers p 
ON b.Passenger_id = p.Passenger_id
JOIN Users u 
ON b.Added_by = u.User_id;

-- Find flights with available seats less than 170
SELECT Flight_number, Available_seats
FROM Flights
WHERE Available_seats < 170;

-- Show all cancelled bookings with passenger name
SELECT p.First_name, p.Last_name, f.Flight_number, b.Seat_number
FROM Bookings b
JOIN Passengers p ON b.Passenger_id = p.Passenger_id
JOIN Flights f ON b.Flight_id = f.Flight_id
WHERE b.Payment_status = 'CANCELLED';

-- Count number of passengers from each country
SELECT ap.Country, COUNT(DISTINCT p.Passenger_id) AS Total_Passengers
FROM Passengers p
JOIN Bookings b ON p.Passenger_id = b.Passenger_id
JOIN Flights f ON b.Flight_id = f.Flight_id
JOIN Airports ap ON f.Origin_airport = ap.Airport_code
GROUP BY ap.Country;

-- Find the Most Popular Routes
SELECT f.Origin_airport, f.Destination_airport, COUNT(b.Booking_id) AS Total_Bookings
FROM Bookings b
JOIN Flights f ON b.Flight_id = f.Flight_id
GROUP BY f.Origin_airport, f.Destination_airport
ORDER BY Total_Bookings DESC
LIMIT 5;

-- Revenue Per Airline
SELECT a.Airline_Name, SUM(f.Fare) AS Total_Revenue
FROM Flights f
JOIN Airlines a ON f.Airline_id = a.Airline_id
JOIN Bookings b ON f.Flight_id = b.Flight_id
WHERE b.Payment_status = 'PAID'
GROUP BY a.Airline_Name
ORDER BY Total_Revenue DESC;


-- Top Frequent Flyers
SELECT p.First_name, p.Last_name, COUNT(b.Booking_id) AS Total_Flights
FROM Passengers p
JOIN Bookings b ON p.Passenger_id = b.Passenger_id
WHERE b.Booking_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY p.Passenger_id
ORDER BY Total_Flights DESC
LIMIT 5;

-- Cancelled Booking Losses
SELECT a.Airline_Name, SUM(f.Fare) AS Lost_Revenue
FROM Bookings b
JOIN Flights f ON b.Flight_id = f.Flight_id
JOIN Airlines a ON f.Airline_id = a.Airline_id
WHERE b.Payment_status = 'CANCELLED'
GROUP BY a.Airline_Name
ORDER BY Lost_Revenue DESC;

-- Busiest Airports
SELECT ap.Airport_code, ap.Airport_Name, COUNT(*) AS Total_Flights
FROM Airports ap
JOIN (
    SELECT Origin_airport AS Airport_code FROM Flights
    UNION ALL
    SELECT Destination_airport AS Airport_code FROM Flights
) AS fd ON ap.Airport_code = fd.Airport_code
GROUP BY ap.Airport_code, ap.Airport_Name
ORDER BY Total_Flights DESC
LIMIT 5;



