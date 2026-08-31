# 🍽️ Cloud Kitchen Management System

A comprehensive, database-driven **Cloud Kitchen Management System** developed using **ASP.NET (VB.NET)** and **MSSQL Server** to streamline online food ordering, kitchen operations, inventory management, and order dispatches.

---

## 🚀 Key Features

### 🛒 Customer Storefront
- **Registration & Authentication**: User sign-up and login with secure password hashing and session management.
- **Menu Exploration**: Browse food dishes with category (*Vegetarian*, *Non-Vegetarian*, *Snacks*, *Beverages*, *Sweets*) and cuisine filters (*North Indian*, *South Indian*, *Mughlai*, *Street Food*, *Desserts*).
- **Delivery Coverage Validation**: Real-time delivery pincode verification against active service areas before checkout.
- **Cart & Order Placement**: Item quantity management, inclusive tax pricing, and multiple payment options (Cash on Delivery & Online Payment).
- **Order Confirmation & Email**: Thermal invoice generation and automated email notifications with a confidential 4-digit Delivery OTP.
- **Live Order Tracking**: Real-time tracking of order preparation and delivery stages.

### 👑 Admin Control Panel
- **Real-Time Dashboard**: Monitor revenue, order statistics, active customer metrics, top-selling dishes, and low-stock alerts.
- **Menu & Recipe Management**: Add/Edit dishes, set prices, manage item availability, and define recipe bill of materials (BOM).
- **Inventory Control**: Monitor raw ingredient stock levels, set low-stock thresholds, and automatically deduct stock upon order preparation.
- **Kitchen Order Operations**: View active order queues, accept and start cooking, assign delivery partners, and print thermal receipts.
- **Service Area Management**: Manage active delivery zones and 6-digit postal pincodes.
- **Delivery Partner Management**: Register delivery drivers, assign vehicles, and track live duty status.
- **Customer Messages**: Review customer feedback, ratings, and inquiries.
- **Business Intelligence Reports**: Generate 19 multi-dimensional sales, inventory, and performance reports with 1-click Excel export and printing.

### 🛵 Delivery Driver Portal
- **Driver Authentication**: Dedicated login portal for delivery partners.
- **Order Pool & Claiming**: View available kitchen orders ready for pickup and claim assignments.
- **Customer Handoff**: Access customer address, phone contact links, and order details.
- **Secure OTP Verification**: Verify delivery by entering the customer's 4-digit OTP to complete orders.

---

## 🛠️ Technologies Used

| Layer | Technologies / Tools |
| :--- | :--- |
| **Backend** | ASP.NET WebForms, VB.NET |
| **Database** | MSSQL Server |
| **Frontend** | HTML5, CSS3, JavaScript, Bootstrap 5, FontAwesome |
| **UI Components** | Chart.js, SweetAlert, Thermal Print Generators |
| **Email Service** | SMTP Client (`System.Net.Mail`) |
| **Development IDE** | Visual Studio 2022 |

---

## 🔄 System Workflows

### Master Order Lifecycle

```mermaid
sequenceDiagram
    autonumber
    actor Customer as 🛒 Customer
    participant Storefront as Storefront / Cart
    participant DB as MSSQL Database
    participant Email as SMTP Email
    actor Admin as 👑 Kitchen Admin
    actor Driver as 🛵 Delivery Driver

    Customer->>Storefront: 1. Add dishes to cart & enter pincode
    Storefront->>DB: 2. Validate delivery pincode
    DB-->>Storefront: Pincode verified
    Storefront->>DB: 3. Place order (Status: Pending) & generate 4-digit OTP
    Storefront->>Email: 4. Send invoice receipt with 4-digit OTP
    Email-->>Customer: Receive order confirmation email
    
    Admin->>DB: 5. Accept order & start cooking (Status: Preparing)
    
    Driver->>DB: 6. Claim order from pool (Status: Out for Delivery)
    DB->>Email: 7. Send dispatch email with driver details
    Email-->>Customer: Receive dispatch notification email
    
    Driver->>Customer: 8. Arrive at address & request 4-digit OTP
    Customer->>Driver: 9. Provide 4-digit OTP
    Driver->>DB: 10. Verify OTP & mark completed (Status: Completed)
    DB->>DB: 11. Deduct raw ingredient stock automatically
```

### Order Status Lifecycle

```mermaid
stateDiagram-v2
    [*] --> Pending : Order Placed (Cart)
    Pending --> Preparing : Kitchen Accepts Order
    state "Out for Delivery" as OutForDelivery
    Preparing --> OutForDelivery : Driver Claims Order / Admin Dispatches
    OutForDelivery --> Completed : Driver Verifies 4-Digit OTP
    Pending --> Cancelled : Customer / Admin Cancels Order
    Preparing --> Cancelled : Kitchen Rejects Order
    Completed --> [*]
    Cancelled --> [*]
```

---

## 🗄️ Database Architecture (11 Core Tables)

```mermaid
erDiagram
    Customers ||--o{ Orders : "places"
    Drivers ||--o{ Orders : "delivers"
    Area_Pincode ||--o{ Orders : "validates coverage"
    Orders ||--|{ Order_Details : "contains"
    menu_item ||--o{ Order_Details : "ordered in"
    menu_category ||--o{ menu_item : "categorizes"
    cuisine_type ||--o{ menu_item : "classifies"
    menu_item ||--o{ Dish_Ingredients : "requires recipe"
    Ingredients ||--o{ Dish_Ingredients : "used in recipe"
    Customers ||--o{ contact_messages : "submits feedback"
```

| Table Name | Description | Key Attributes |
| :--- | :--- | :--- |
| **`Customers`** | Customer account details and credentials | `c_id`, `c_name`, `email`, `phone`, `password` |
| **`Orders`** | Master transaction records | `order_id`, `c_id`, `total_amount`, `order_status`, `pincode`, `delivery_otp`, `driver_id` |
| **`Order_Details`** | Ordered line items and breakdown | `order_detail_id`, `order_id`, `m_id`, `quantity`, `price`, `total_price` |
| **`menu_item`** | Food dishes, pricing, and availability | `m_id`, `m_name`, `m_category_id`, `m_cuisine_id`, `m_price`, `m_final_price`, `m_availability` |
| **`menu_category`** | Food category groupings | `category_id`, `category_name` |
| **`cuisine_type`** | Regional culinary classifications | `cuisine_id`, `cuisine_name` |
| **`Ingredients`** | Raw inventory stock tracking | `ingredient_id`, `ingredient_name`, `stock_quantity`, `unit`, `low_stock_threshold` |
| **`Dish_Ingredients`** | Recipe Bill of Materials (BOM) mapping | `recipe_id`, `m_id`, `ingredient_id`, `qty_required` |
| **`Area_Pincode`** | Active delivery coverage pincodes | `Area_Id`, `Area_Name`, `Pincode` |
| **`Drivers`** | Delivery partner details and status | `driver_id`, `driver_name`, `phone`, `vehicle_no`, `status` |
| **`contact_messages`** | Customer feedback and support messages | `message_id`, `c_id`, `name`, `email`, `message`, `status` |

---

## 📸 Project Screenshots

### 🏠 Customer Storefront

#### Home
![Home](screenshots/Home.webp)

#### Login
![Login](screenshots/Login.webp)

#### Register
![Register](screenshots/Register.webp)

#### Menu
![Menu](screenshots/Menu.webp)

#### Cart
![Cart](screenshots/Cart.webp)

#### Order Confirmation
![OrderConfirmation](screenshots/OrderConfirmation.webp)

#### Order Confirmation E-Mail
![OrderConfirmation_Email](screenshots/Mail.png)

#### My Orders
![MyOrders](screenshots/MyOrders.webp)

#### Bill
![Bill](screenshots/MyOrders-in.webp)

---

### 👑 Admin Control Panel

#### Dashboard
![Dashboard](screenshots/Dashboard.webp)

#### Manage Menu
![ManageMenu](screenshots/AddFoodItems.webp)

#### Manage Cuisine
![ManageCuisine](screenshots/ManageCC.webp)

#### Manage Order
![ManageOrders](screenshots/ManageOrders.webp)

#### Manage Area
![ManageArea](screenshots/ManageArea.webp)

#### Contact Message
![Contact](screenshots/Contact-Msg.webp)

#### Reports
![Reports](screenshots/Reports.webp)

---

## ▶️ How To Run

1. **Clone the repository**
   ```bash
   git clone https://github.com/vinitsonii/Cloud_Kitchen.git
   ```

2. **Open the project in Visual Studio**
   - Open Visual Studio 2022 and launch `Cloud Kitchen.sln`.

3. **Configure MSSQL Database**
   - Verify connection string `constr` in `Web.config` pointing to your database or SQL Server instance.

4. **Configure Mail Credentials**
   - Update `EmailUsername` and `EmailPassword` settings in `Web.config`.

5. **Admin Login**
   - Email: `admincloudkitchen2026@gmail.com`
   - Password: `password`

6. **Run Application**
   - Run the project using IIS Express (press `F5`).

---

## 👨‍💻 Developer

### **Vinit Soni**
*Software Developer passionate about building web, mobile, and database-driven applications.*

- **GitHub**: [github.com/vinitsonii](https://github.com/vinitsonii)
- **LinkedIn**: [linkedin.com/in/vinitsonii](https://linkedin.com/in/vinitsonii)

---
