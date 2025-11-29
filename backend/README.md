# Supermarket Backend — Flask + MySQL

Backend API for the supermarket stock management system. Built with Flask and MySQL.

## Requirements
- Python 3.10+
- MySQL Server
- Git

## Project Structure
backend/
  app.py
  db.py
  config.py
  routes/
    save_transactions.py
  db/
    create_db.sql
    tables.sql
    db_er_diagram.png
  requirements.txt
  README.md

## 1. Clone the Repository
git clone https://github.com/<your-username>/<your-repo>.git
cd <your-repo>/backend

## 2. Create & Activate Virtual Environment
(make sure you are inside the backend folder)
python -m venv venv

Windows (PowerShell):
venv\Scripts\activate

macOS / Linux:
source venv/bin/activate

## 3. Install Dependencies
pip install -r requirements.txt

If missing:
pip install flask mysql-connector-python

## 4. Database Setup

### Create database
CREATE DATABASE stock_db;

### Configure db.py
Set your MySQL username, password, host, and database.


### Create tables
use tables.sql

## 5. Run the Backend
python app.py

API available at:
http://127.0.0.1:5000/

## 6. Test /save_transaction Endpoint
{
  "worker_id": 1,
  "total_amount": 2000,
  "payment_method": "cash",
  "items": [
    { "product_id": 1, "quantity": 3 },
    { "product_id": 2, "quantity": 2 },
    { "product_id": 3, "quantity": 1 }
  ]
}

## Remark
make sure you have in the db tables a worker, and products with the correspounding IDs

## References
https://www.makeareadme.com  
https://github.com/othneildrew/Best-README-Template  
https://www.freecodecamp.org/news/how-to-structure-your-readme-file/
