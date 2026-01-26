![Uploading modern home for.png…]()
# 📦 Stockify - Stock Management Application

Stockify is a desktop stock management application designed for stores and supermarkets. It helps store owners and staff organize and manage their inventories efficiently through product management, category organization, and sales transaction tracking. The application supports four types of users, low-stock alerts, and offers localization in both English and French.

---

## 🛠 Technologies Used

- **Frontend:** Flutter  
- **Backend:** Flask  
- **Database:** MySQL  

---

## 📁 Project Structure

```

Stockify/
├── backend/      # Flask backend
├── frontend/     # Flutter frontend
├── .gitignore    # Git ignore file
├── README.md     # Project documentation

````

---

## ⚡ Installation & Setup

Follow these steps to set up Stockify locally:

### 📝 Prerequisites

1. Install **MySQL Server** on your computer.  
2. Install **Flutter** for the frontend.  
3. Install **Python** and **Flask** for the backend.  

---

### 📥 Clone the Repository

```bash
git clone https://github.com/ensia-g11-team3/supermarket-stock-management-system
cd Stockify
````

---

### 🖥 Backend Setup

1. Navigate to the backend folder:

```bash
cd backend
```

2. (Optional but recommended) Create a virtual environment:

```bash
python -m venv venv
source venv/bin/activate  # Linux/macOS
venv\Scripts\activate     # Windows
```

3. Install the required Python packages:

```bash
pip install -r requirements.txt
```

4. Create the database:

```sql
CREATE DATABASE stock_db;
```

5. Create the tables by running the queries in:

```
backend/db/tables.sql
```

6. Configure your database connection in `backend/db.py`. Make sure the **user**, **password**, and **host** match your MySQL setup.

7. **⚠️ Important:** Create the first admin user before running the app.

```bash
python create_first_user.py
```

> Note: The system only allows new user creation by an admin. This first user (admin) must be created before starting the application. 📝 Remember the username and password for the created user.

8. Run the backend:

```bash
python app.py
```

---

### 📱 Frontend Setup

1. Navigate to the frontend folder:

```bash
cd frontend
```

2. Get Flutter dependencies:

```bash
flutter pub get
```

3. Run the Flutter application:

```bash
flutter run
```

> Make sure your backend is running before starting the frontend to ensure proper communication with the API.

---

## ✨ Features

* **📦 Product Management:** Add, edit, delete, and view products and product batches.
* **📂 Category Management:** Organize products into categories for easier tracking.
* **💳 Sales Transactions:** Record sales, update inventory automatically, and track sales history.
* **👥 User Roles:** Supports four types of users.
* **⚠️ Low Stock Alerts:** Notify users when products reach low stock levels.
* **🌐 Localization:** Supports both English and French interfaces.

---

## 📝 Special Notes

* Make sure to create the **first admin user** before running the application.
* Backend requires correct **database credentials** in `db.py`.
* Using a virtual environment is recommended to avoid package conflicts.
* The system is designed to be desktop-based; Flutter frontend can be run on Windows, macOS, or Linux.
* Low-stock alerts are triggered based on thresholds set in the database by the users.

---

## 👨‍💻 Team

<div align="center">

| Role | Name | GitHub |
|:----:|------|:------:|
| 👨‍💼 **Team Lead** | NOUR MALEK YAHIAOUI | [![GitHub](https://img.shields.io/badge/GitHub-100000?style=flat&logo=github&logoColor=white)](https://github.com/nour-malek-yahiaoui |
| 👩‍💻 **Developer** | BENMAKHLOUF LERYEME | [![GitHub](https://img.shields.io/badge/GitHub-100000?style=flat&logo=github&logoColor=white)](https://github.com/leryeme17) |
| 👨‍💻 **Developer** | BOULEFA MUSTAPHA | [![GitHub](https://img.shields.io/badge/GitHub-100000?style=flat&logo=github&logoColor=white)](https://github.com/Mustapha-bf) |
| 👨‍💻 **Developer** | MOHAMED ANIS CHEHILI | [![GitHub](https://img.shields.io/badge/GitHub-100000?style=flat&logo=github&logoColor=white)](https://github.com/mohamed-anis-chehili) |
| 👩‍💻 **Developer** | WAIL OUARET | [![GitHub](https://img.shields.io/badge/GitHub-100000?style=flat&logo=github&logoColor=white)](https://github.com/WailOuaret) |

</div>


---

## 🎬 Demo Video

[![Watch Demo](https://img.youtube.com/vi/9_Fb54MZqCE/hqdefault.jpg)](https://youtu.be/9_Fb54MZqCE)


--- 

## 📄 License

This project is licensed under the [MIT License](LICENSE).

