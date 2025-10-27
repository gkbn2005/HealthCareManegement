# 🏥 Health Care Management System

A simple Spring Boot-based hospital/clinic management system with role-based access (Admin, Doctor, Receptionist).

## Features
- Patient registration CRUD (Create, Read, Update, Delete)
- Simple login authentication (no JWT yet)
- Role-based UI behavior (Admin/Doctor/Receptionist)
- MVC-based pages (Thymeleaf/Freemarker style pages)
- REST endpoint for login `/api/auth/login`

## How to Run
### 1. Requirements
- Java 17+
- Maven

### 2. Build & Run
```bash
mvn spring-boot:run
```
The app will start on: `http://localhost:8080`

### 3. Access Pages
| Page | URL |
|------|------|
| Login Page | `/login` |
| Home Page | `/` |
| View Patients | `/patient-list` |
| Add Patient | `/add-patient` |

## Login (API Endpoint)
```
POST /api/auth/login
{
  "username": "admin",
  "password": "admin123"
}
```
Response example:
```
{
  "id": 1,
  "username": "admin",
  "role": "ADMIN"
}
```

## 👤 Roles & Permissions
| Role | Can View Patients | Can Add/Edit Patients | Can Manage Users |
|------|-------------------|------------------------|------------------|
| Admin | ✅ | ✅ | ✅ |
| Doctor | ✅ | ✅ | ❌ |
| Receptionist | ✅ | ✅ | ❌ |

## Project Structure
```
src/main/java/com/hms
 ├── controller
 ├── model
 ├── repository
 └── service (optional later)
```

---

## Next Steps (Upcoming)
- Add logout functionality
- Protect backend using session
- Hide UI buttons based on role
- Add user management page for Admin

