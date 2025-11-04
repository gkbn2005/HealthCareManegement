# 🏥 Health Care Management System

A **Spring Boot–based hospital and clinic management system** with role-based access for **Admin, Doctor, and Receptionist**.  
Includes patient management, appointment scheduling, and invoicing modules.

---

## 🚀 Features

- Patient registration **CRUD** (Create, Read, Update, Delete)  
- **Signup** with role selection (Admin / Doctor / Receptionist)  
- **Login & Logout** with session-based authentication  
- **Role-based UI visibility** (reports, users, etc. shown/hidden per role)  
- **Appointments** management (for Doctors)  
- **Invoices** management (for Receptionists)  
- Simple and clean **MVC architecture**  
- REST endpoint for `/api/auth/login`  

---

## 🧰 Tech Stack

| Layer | Technology |
|-------|-------------|
| Backend | Spring Boot (Java 17) |
| Frontend | Thymeleaf / HTML / Bootstrap |
| Database | H2 / MySQL (configurable) |
| Build Tool | Maven |
| Security | Session-based Authentication |

---

## ⚙️ How to Run

### 1️⃣ Requirements
- **Java 17+**
- **Maven 3.8+**

### 2️⃣ Build & Run
```bash
mvn spring-boot:run
