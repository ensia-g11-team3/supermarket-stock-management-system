# 🧾 Stock Management Application — Sprint 1

A desktop application for basic stock and user management.
This first sprint delivers the core foundations of the system: user management, product management, and simple transaction creation.

---

## ✅ Sprint 1 Delivered Features

### **1. User Management (CRUD)**

* Create new users
* View list of users
* Update user information
* Delete users

### **2. Product Management (CRUD)**

* Add new products
* View products list
* Edit product details
* Delete products

### **3. Create Transaction**

* Start a new sale transaction
* Add products to the transaction
* Calculate total price
* Save the transaction

*(Note: Sprint 1 only includes creating a transaction — no advanced sales management yet.)*

---

## 🧰 Tech Stack (Sprint 1)

* **Frontend:** Flutter (Desktop)
* **Backend:** Flask (Python)
* **Database:** SQLite / MySQL (depending on your setup)
* **API communication:** REST

---

## 📁 Project Structure (Sprint 1)

```
project/
 ├── backend/
 │    ├── app.py
 │    ├── routes/
 │    ├── models/
 │    ├── database/
 │    └── requirements.txt
 ├── frontend/
 │    ├── lib/
 │    ├── screens/
 │    ├── widgets/
 │    ├── services/
 │    └── pubspec.yaml
 ├── README.md
 └── docs/
```

---

## 🚀 How to Run the Project

### **Backend**

```
cd backend
pip install -r requirements.txt
python app.py
```

### **Frontend**

```
cd frontend
flutter pub get
flutter run
```

---

## 📝 Sprint 1 Notes

* Authentication is **not yet implemented**.
* Transaction creation is basic: no report, no stock update yet.
* Sprint 1 focuses on building the foundation and database structure.

---

## 📌 Next Steps (Sprint 2 Goals)

* Update stock when a transaction happens
* Improve transactions
* Add supplier management ... etc

