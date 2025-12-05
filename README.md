# **GNB Database Project — README**

This project contains a MySQL database and two Python files used to create and manage data for the Gold ’n Blues database.

## **Files Included**

### **1. `GnBDatabase.sql`**

* Creates the full database (tables, keys, etc.).
* Run this first on any MySQL server.

### **2. `DataExport.sql`**

* Contains sample data to insert into the database after the schema is created.

### **3. `gnb_db.py`**

* Python script that connects to the MySQL database.
* Handles database creation, connection, and helper functions.

### **4. `gnb_menu.py`**

* The main Python menu program.
* Lets the user add members, list data, and interact with the database through a simple text menu.

---

## **How to Use (On Any Computer)**

### **1. Install Requirements**

* Install **Python 3**
* Install **MySQL Server 8+**
* Install Python packages:

```
pip install mysql-connector-python
```

---

### **2. Set Up the Database**

**Step 1:** Open a MySQL terminal and run:

```
mysql -u root -p < GnBDatabase.sql
```

**Step 2:** Then load the sample data:

```
mysql -u root -p < DataExport.sql
```

This creates the full database and inserts data.

---

### **3. Run the Python Program**

Make sure MySQL is running, then in a terminal:

```
python gnb_menu.py
```

This opens the menu system where you can:

* Add members
* View database information
* Run basic operations

---

### **4. Editing Database Login Info**

If needed, change the MySQL username/password inside:

```
gnb_db.py
```

Look for:

```python
config = {
    "user": "root",
    "password": "YOUR_PASSWORD",
    "host": "127.0.0.1"
}
```

Update it to match your computer.
