"""Airline Management System (Python + MySQL)

Setup:
    1. Run schema.sql in MySQL to create the database and tables.
    2. pip install mysql-connector-python
    3. python airline_management.py
"""

import os
import getpass
import mysql.connector as mc

# ---------------------------------------------------------------
# Connecting to the MySQL database (no password stored in the code)
# ---------------------------------------------------------------
try:
    con = mc.connect(
        host=os.getenv("DB_HOST", "localhost"),
        user=os.getenv("DB_USER", "root"),
        passwd=os.getenv("DB_PASSWORD") or getpass.getpass("MySQL password: "),
        database=os.getenv("DB_NAME", "airlines"),
    )
except mc.Error as e:
    print("Could not connect to the database:", e)
    raise SystemExit(1)

cur = con.cursor()

# class name typed by user (lowercase) -> (name stored in DB, airfare column)
CLASSES = {
    "economy": ("Economy", "economy_class"),
    "premium economy": ("Premium Economy", "premium_economy"),
    "business": ("Business", "business_class"),
    "first class": ("First Class", "first_class"),
}


# ---------------------------------------------------------------
# Helper functions
# ---------------------------------------------------------------
def get_int(prompt):
    """Keep asking until the user enters a whole number."""
    while True:
        try:
            return int(input(prompt))
        except ValueError:
            print("Please enter a number.")


def get_company(flight_id):
    """Return the airline of a flight, or None if the flight doesn't exist."""
    cur.execute("SELECT company FROM flight WHERE flight_id = %s", (flight_id,))
    row = cur.fetchone()
    return row[0] if row else None


def get_fare(company, class_type):
    """Return (class name, fare) for an airline and class, or None if invalid."""
    entry = CLASSES.get(class_type.strip().lower())
    if entry is None:
        print("Invalid class type.")
        return None
    name, column = entry  # column comes from our own dict, never from user input

    cur.execute(f"SELECT {column} FROM airfare WHERE company = %s", (company,))
    row = cur.fetchone()
    if row is None:
        print("Error: No fare found for", company)
        return None
    if not str(row[0]).isdigit():  # e.g. 'N/A' when an airline has no first class
        print(f"{company} does not offer {name}.")
        return None
    return name, int(row[0])


# ---------------------------------------------------------------
# ADD FLIGHT
# ---------------------------------------------------------------
def add_flight():
    flight_id = input("Enter Flight ID: ")
    company = input("Enter Airline Company: ")
    flight_date = input("Enter Flight Date (YYYY-MM-DD): ")
    take_off_point = input("Enter Take-off Point: ")
    destination = input("Enter Destination: ")
    departure = input("Enter Departure Time (HH:MM:SS): ")
    arrival = input("Enter Arrival Time (HH:MM:SS): ")

    sql = '''INSERT INTO flight
             (flight_id, company, flight_date, take_off_point, destination, departure, arrival)
             VALUES (%s, %s, %s, %s, %s, %s, %s)'''
    try:
        cur.execute(sql, (flight_id, company, flight_date, take_off_point,
                          destination, departure, arrival))
        con.commit()
        print("Flight added")
    except mc.Error as e:
        con.rollback()
        print("Could not add flight:", e)


# ---------------------------------------------------------------
# BOOK PASSENGER
# ---------------------------------------------------------------
def bookPassenger():
    passport_number = input("Enter Passport Number: ")
    passenger_id = input("Enter Passenger ID: ")
    name = input("Enter Passenger Name: ")
    age = input("Enter Age: ")
    sex = input("Enter Gender: ")
    contact = input("Enter Contact Number: ")
    booking_date = input("Enter Booking Date (YYYY-MM-DD): ")
    departure_date = input("Enter Departure Date (YYYY-MM-DD): ")
    flight_id = input("Enter Flight ID: ")

    # The airline is taken from the flight, so it can't be typed wrongly
    company = get_company(flight_id)
    if company is None:
        print("No such flight. Add the flight first.")
        return

    class_type = input("Enter Class Type (Economy / Premium Economy / Business / First Class): ")
    result = get_fare(company, class_type)
    if result is None:
        return  # nothing has been saved yet, so no half-booked passenger
    class_type, fare = result

    sql = '''INSERT INTO passengers
             (passport_number, passenger_id, name, age, sex, contacts,
              booking_date, departure_date, flight_id, class_type, fare)
             VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)'''
    try:
        cur.execute(sql, (passport_number, passenger_id, name, age, sex, contact,
                          booking_date, departure_date, flight_id, class_type, fare))
        con.commit()
        print(f"Passenger booked successfully. Fare: {fare}")
    except mc.Error as e:
        con.rollback()
        print("Could not book passenger:", e)


# ---------------------------------------------------------------
# DELETION
# ---------------------------------------------------------------
# 1. To cancel a flight (admin)
def del_f():
    flight_id = input("Enter Flight id: ")
    try:
        # Remove its bookings first so no orphaned passengers remain
        cur.execute("DELETE FROM passengers WHERE flight_id = %s", (flight_id,))
        removed = cur.rowcount
        cur.execute("DELETE FROM flight WHERE flight_id = %s", (flight_id,))
        if cur.rowcount == 0:
            con.rollback()
            print("No such flight.")
            return
        con.commit()
        print(f"Flight cancelled ({removed} booking(s) removed)")
    except mc.Error as e:
        con.rollback()
        print("Could not cancel flight:", e)


# 2. To delete passenger details (user)
def del_p():
    passenger_id = input("Enter passenger id: ")
    try:
        cur.execute("DELETE FROM passengers WHERE passenger_id = %s", (passenger_id,))
        con.commit()
        print("Record deleted" if cur.rowcount else "No such passenger.")
    except mc.Error as e:
        con.rollback()
        print("Could not delete record:", e)


# ---------------------------------------------------------------
# UPDATE RECORD
# ---------------------------------------------------------------
def update():
    passenger_id = input("Enter passenger id: ")

    cur.execute("SELECT flight_id FROM passengers WHERE passenger_id = %s", (passenger_id,))
    row = cur.fetchone()
    if row is None:
        print("No such passenger.")
        return
    flight_id = row[0]

    print("What do you want to update?")
    print("1. Contact")
    print("2. Class type")
    op = get_int("Enter option: ")

    try:
        if op == 1:
            contact = input("Enter contact: ")
            cur.execute("UPDATE passengers SET contacts = %s WHERE passenger_id = %s",
                        (contact, passenger_id))
            con.commit()
            print("Contact updated")

        elif op == 2:
            company = get_company(flight_id)
            class_type = input("Enter class type (Economy / Premium Economy / Business / First Class): ")
            result = get_fare(company, class_type)
            if result is None:
                return  # nothing changed, so class and fare never go out of sync
            class_type, fare = result
            # class and fare are updated together in one statement
            cur.execute("UPDATE passengers SET class_type = %s, fare = %s WHERE passenger_id = %s",
                        (class_type, fare, passenger_id))
            con.commit()
            print(f"Class updated. New fare: {fare}")

        else:
            print("Invalid option.")
    except mc.Error as e:
        con.rollback()
        print("Could not update record:", e)


# ---------------------------------------------------------------
# SEARCH RECORD
# ---------------------------------------------------------------
def print_rows(rows, empty_message):
    if rows:
        for x in rows:
            print(x)
    else:
        print(empty_message)


def search():
    print("What do you want to view?")
    print("1. All Flights")
    print("2. All Airfares")
    print("3. All Passengers")
    print("4. Search Flights by Destination")
    print("5. Search Passenger by Flight ID")
    ch = get_int("Enter your choice: ")

    if ch == 1:
        cur.execute("SELECT * FROM flight")
        print_rows(cur.fetchall(), "No flights found.")

    elif ch == 2:
        cur.execute("SELECT * FROM airfare")
        print_rows(cur.fetchall(), "No airfares found.")

    elif ch == 3:
        cur.execute("SELECT * FROM passengers")
        print_rows(cur.fetchall(), "No passengers found.")

    elif ch == 4:
        destination = input("Enter destination city: ")
        cur.execute("SELECT * FROM flight WHERE destination = %s", (destination,))
        print_rows(cur.fetchall(), "No flights found for that destination.")

    elif ch == 5:
        flight_id = input("Enter Flight ID: ")
        cur.execute("SELECT name, class_type, fare FROM passengers WHERE flight_id = %s",
                    (flight_id,))
        print_rows(cur.fetchall(), "No passengers found for that flight.")

    else:
        print("Invalid choice!")


# ---------------------------------------------------------------
# MAIN MENU
# ---------------------------------------------------------------
def Menu():
    while True:
        print("\n1. Add Flight")
        print("2. Book Passenger Ticket")
        print("3. Cancel Flight")
        print("4. Update passenger detail")
        print("5. Searching flight details")
        print("6. Exit")
        ch = get_int("Enter your choice: ")

        if ch == 1:
            add_flight()
        elif ch == 2:
            bookPassenger()
        elif ch == 3:
            # Simplified role check (a real system would use logins)
            n = input("Are you admin or user? (A/U): ").strip().upper()
            if n == 'A':
                del_f()
            elif n == 'U':
                del_p()
            else:
                print("Please enter A or U.")
        elif ch == 4:
            update()
        elif ch == 5:
            search()
        elif ch == 6:
            print("Exiting system...")
            break
        else:
            print("Invalid choice! Try again.")


if __name__ == "__main__":
    try:
        Menu()
    finally:
        cur.close()
        con.close()
