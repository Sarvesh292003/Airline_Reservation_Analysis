# Airline Reservation Analysis

A complete end-to-end **database & analytics project** built around an airline reservation system. This project demonstrates **database design**, **SQL query development**, and **business intelligence dashboards** using **Power BI**, **Tableau**, and **PowerPoint**.

Perfect for showcasing **data engineering**, **data analysis**, and **BI skills** in a portfolio.

---

## 🚀 Project Overview

This project simulates a complete airline reservation ecosystem with:

* A fully designed **relational database schema**
* **Sample data** for flights, passengers, bookings, airlines & airports
* **Operational & analytical SQL queries**
* **Power BI & Tableau dashboards**
* **Presentation decks** explaining findings and insights

The project is structured so that anyone can recreate the database, run the analysis, and view key insights.

---

## 📁 Repository Contents

| File                                | Description                                         |
| ----------------------------------- | --------------------------------------------------- |
| `Airline_Reservation_Analysis.sql`  | Database creation, schema, constraints, sample data |
| `Airline_Reservation_Querry.sql`    | Collection of analytical queries (ready to run)     |
| `Airline Reservation Analysis.pptx` | Slide deck with objectives, schema, and insights    |
| `Airline_Reservation_PowerBI.pptx`  | Export of Power BI dashboards                       |
| `Airline_Reservation.pbix`          | Power BI dashboard file                             |
| `Airline_Reservastion_Anlysis.twb`  | Tableau dashboard workbook                          |
| `Airline_Reservation_Analysis.xlsx` | Raw/cleaned dataset used for visuals                |

---

## 🧱 Database Schema Overview

The system follows a normalized relational design.

### **Main Tables:**

* **Airlines** – airline master data
* **Airports** – IATA codes, names, cities & countries
* **Flights** – flight numbers, timings, fare, seat capacity, airline mapping
* **Passengers** – traveler information
* **Bookings** – passenger–flight mapping, payment status, booking date, seat number
* **Users** – system users (ADMIN/AGENT)

### **Key Features**

* Referential integrity via foreign keys
* Validation using constraints (seat format, dates, unique seat bookings)
* Indexing on frequently used columns (flight number, passenger name)

---

## 🔍 Sample Analytical Queries

### **1️⃣ Passenger & Booking Details**

```sql
SELECT p.First_name, p.Last_name, b.Booking_id, b.Seat_number, b.Payment_status
FROM Passengers p
JOIN Bookings b ON p.Passenger_id = b.Passenger_id;
```

### **2️⃣ Top 5 Most Popular Routes**

```sql
SELECT f.Origin_airport, f.Destination_airport, COUNT(b.Booking_id) AS Total_Bookings
FROM Bookings b
JOIN Flights f ON b.Flight_id = f.Flight_id
GROUP BY f.Origin_airport, f.Destination_airport
ORDER BY Total_Bookings DESC
LIMIT 5;
```

### **3️⃣ Revenue by Airline**

```sql
SELECT a.Airline_Name, SUM(f.Fare) AS Total_Revenue
FROM Flights f
JOIN Airlines a ON f.Airline_id = a.Airline_id
JOIN Bookings b ON f.Flight_id = b.Flight_id
WHERE b.Payment_status = 'PAID'
GROUP BY a.Airline_Name
ORDER BY Total_Revenue DESC;
```

See the full list in **`Airline_Reservation_Querry.sql`**.

---

## 📊 Dashboards & Insights

This project includes dashboards built using **Power BI** and **Tableau**.

### **Covered Insights:**

* Most profitable airlines & routes
* Booking trends and seasonal patterns
* Country-wise passenger distribution
* Payment status & revenue loss due to cancellations
* Airline-wise revenue contribution
* Flight occupancy & demand patterns

Dashboards highlight business decisions such as:

* Scaling high-demand routes
* Improving pricing strategies
* Identifying frequent flyers
* Reducing cancellations

---

## 🛠️ How to Run the Project

### **1. Set Up the Database**

```bash
mysql -u <username> -p < Airline_Reservation_Analysis.sql
```

This creates all tables and inserts the sample dataset.

### **2. Execute Analytical Queries**

Run queries from:

```
Airline_Reservation_Querry.sql
```

### **3. View Dashboards**

* Open `.pbix` in **Power BI Desktop**
* Open `.twb` in **Tableau Desktop**
* Or view summary slides in the `.pptx` files

---

## 🎯 Key Learnings Demonstrated

* Data modelling & schema design
* Writing optimized SQL queries
* Data cleaning & transformation
* Creating insights-driven dashboards
* BI storytelling via PowerPoint

---

## 📌 Future Enhancements

* Add dynamic pricing engine simulation
* Build Python/Flask API for bookings
* Integrate machine learning demand forecasting
* Add user authentication with hashed passwords
* ETL pipeline with scheduled refresh

---

## 👨‍💻 Author

**Sarvesh Pandit**
If you use or modify this project, feel free to ⭐ the repository.

---

## 📄 License

This project is open-source under the **MIT License**. Add a `LICENSE` file for GitHub.
