# ⚙️ CommunityConnect - Backend Architecture & Engineering Report

**Project**: CommunityConnect REST API Backend Server  
**Target Audience**: Backend Engineers, Systems Architects & Technical Reviewers  
**Tech Stack**: Java 21 | Spring Boot 3.2.3 | Spring Security 6.2 | Spring Data JPA | PostgreSQL 16 | Flyway 10  
**Root Directory**: `/home/saikiran/Documents/communityconnect/backend`

---

## 1. Overview & System Purpose

The **CommunityConnect Backend** is a multi-tenant enterprise REST API server designed for gated residential communities. It handles data persistence, authentication, role-based access control (RBAC), multi-tenancy isolation, and business logic execution.

### Key Business Domains Handled:
1. **Multi-Tenant Isolation**: Ensures resident and financial records of Community A are strictly isolated from Community B.
2. **Occupancy Verification & Conflict Resolution**: Enforces the single active household rule per flat. Triggers security alerts and admin workflow when conflict occurs.
3. **Group Service Demand Aggregation**: Groups resident service requests (e.g. AC servicing) to secure bulk vendor discounts while managing 1-on-1 daily staff retainers (Home Cooks & Maids).
4. **Digital Gate Pass & Security Verification**: Manages timed security pass creation, scanning, and gate logs.

---

## 2. Technology Stack & Frameworks

| Layer | Technology | Version | Purpose |
|---|---|---|---|
| **Runtime & Language** | Java JDK | 21 (LTS) | High-performance enterprise Java runtime |
| **Framework** | Spring Boot | 3.2.3 | Application container, dependency injection & REST API framework |
| **Security** | Spring Security | 6.2 | Security configuration, RBAC filters, and authentication |
| **Authentication** | JJWT (Java JWT) | 0.12.5 | HMAC-SHA256 token generation and signature verification |
| **Persistence / ORM** | Spring Data JPA / Hibernate | 6.4 | Object-Relational Mapping to PostgreSQL |
| **Database** | PostgreSQL | 16 | Relational database engine |
| **DB Migrations** | Flyway | 10.7 | Automated database versioning & schema migrations |
| **Build Tool** | Apache Maven | 3.9+ | Dependency management and build lifecycle execution |

---

## 3. Package Architecture (`src/main/java/com/communityconnect`)

```
backend/src/main/java/com/communityconnect/
├── CommunityConnectApplication.java   # Spring Boot Main Entry Class
├── config/                            # Global CORS, Web & Database Config
├── security/                          # Security & Authentication Engine
│   ├── SecurityConfig.java            # Spring Security 6 FilterChain & RBAC rules
│   ├── JwtTokenProvider.java          # Token generation, claims validation & parsing
│   └── JwtAuthenticationFilter.java   # Per-request JWT Bearer token validation filter
├── model/                             # JPA Database Entities
│   ├── User.java                      # User account model & role assignment
│   ├── Community.java                 # Gated society tenant configuration
│   ├── Household.java                 # Occupancy tracking model (1 active per flat)
│   ├── OccupancyConflict.java         # Conflict dispute entity
│   └── GroupDemandPool.java           # Bulk service aggregation pool model
├── repository/                        # Spring Data JPA Repositories
│   ├── UserRepository.java
│   ├── CommunityRepository.java
│   ├── HouseholdRepository.java
│   ├── OccupancyConflictRepository.java
│   └── GroupDemandPoolRepository.java
├── service/                           # Business Logic & Isolation Layer
│   ├── AuthService.java               # Password hashing & login logic
│   ├── CommunityService.java           # Community tenant management
│   ├── OccupancyService.java           # Flat conflict detection & admin resolution
│   └── ServicePoolService.java         # Group buying & vendor retainer management
├── controller/                        # REST API Endpoints
│   ├── AuthController.java            # /api/auth endpoints
│   ├── CommunityController.java       # /api/communities endpoints
│   ├── OccupancyController.java       # /api/occupancy endpoints
│   └── ServicePoolController.java     # /api/services endpoints
└── exception/                         # Global Exception Interceptor
    ├── GlobalExceptionHandler.java    # Intercepts runtime errors -> returns standardized JSON
    └── OccupancyConflictException.java # Custom domain exception
```

---

## 4. Security & Business Logic Rules

### A. Role-Based Access Control (RBAC)
Supported System Roles:
- `PLATFORM_ADMIN`: Full access across all communities and system metrics.
- `COMMUNITY_ADMIN`: Admin access restricted strictly to their assigned community.
- `RESIDENT`: Access to personal household details, gate pass generator, and service pools.
- `SECURITY`: Access to gate pass scanner and visitor log operations.
- `SERVICE_PROVIDER`: Access to servicing contracts and vendor pools.

### B. Single Active Household Enforcement Rule
- Only **1 active household** can be linked to a single flat unit at any time.
- If a new tenant attempts to register an already occupied flat, the system creates an `OccupancyConflict` record, locks the registration state, and alerts the Community Admin for physical verification.

### C. Multi-Tenancy Data Isolation
- Every entity query and service execution checks the user's `community_id`. Cross-tenant queries are blocked with HTTP `403 Forbidden`.

---

## 5. Commands Cheatsheet

### Run Spring Boot Server
```bash
cd /home/saikiran/Documents/communityconnect/backend
mvn spring-boot:run
```
*(Starts REST server on `http://localhost:8080`)*

### Run Automated Unit & Integration Tests
```bash
cd /home/saikiran/Documents/communityconnect/backend
mvn test
```

### Build Executable JAR File
```bash
cd /home/saikiran/Documents/communityconnect/backend
mvn clean package -DskipTests
```

### Quick REST API Verification (`curl`)
```bash
# 1. User Login
curl -i -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"rahul.sharma@gmail.com","password":"password123"}'

# 2. Public Community Directory
curl -s http://localhost:8080/api/communities/public

# 3. Service Catalog
curl -s http://localhost:8080/api/services/catalog
```
