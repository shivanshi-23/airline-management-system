# Airline Management System

An airline management system built with **Python** and **MySQL**. It lets an admin manage flights and lets passengers be booked, updated, searched and cancelled, through a text menu.


## Features

- **Add flights** with route, date, departure and arrival times
- **Book passengers** with automatic fare lookup based on airline and class (Economy, Premium Economy, Business, First Class)
- **Update passenger details**: change contact number or travel class (the fare updates with it)
- **Cancel a flight** (admin) or **delete a passenger record** (user)
- **Search and view**: all flights, all airfares, all passengers, flights by destination, passengers by flight ID

## Tech Stack

- Python 3
- MySQL
- `mysql-connector-python`

## Project Files

| File | Purpose |
|------|---------|
| `airline_simple.py` | The main program |
| `schema.sql` | Creates the `airlines` database, its tables, and sample data |

## Setup

1. **Install Python** and run `pip install mysql-connector-python`.
2. Run `schema.sql` in MySQL to create the database and sample data
3. Run `python airline_simple.py` and enter your MySQL password

## Database Structure

- **`flight`**: flight ID (primary key), company, date, take-off point, destination, departure and arrival times
- **`passengers`**: passport number, passenger ID (unique), name, age, gender, contact, booking and departure dates, flight ID, class type, fare
- **`airfare`**: company and the fare for each class (`N/A` where an airline doesn't offer that class)

All names, passport numbers and phone numbers in the sample data are fictional.

## Known Limitations

- The admin/user choice is just typing `A` or `U`. There is no real login system.
- Fares and ages are stored as text/numbers in a basic form with limited validation.
- There is no foreign key between `passengers` and `flight` (an optional one is included, commented out, in `schema.sql`).
- It is a terminal program with no graphical interface.


Cleaned up with some help from an AI assistant (Claude).
