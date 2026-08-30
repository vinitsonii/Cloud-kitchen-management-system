# ☁️🍽️ Cloud Kitchen — Full System Documentation

> **An end-to-end online food ordering platform** built with ASP.NET WebForms (VB.NET) and SQL Server.
> Customers browse a live menu, build a cart, and pay online or via COD — while admins manage everything from a protected dashboard.

---

## 📋 Table of Contents

| # | Section |
|---|---|
| 1 | [Project Overview](#1-project-overview) |
| 2 | [Tech Stack](#2-tech-stack) |
| 3 | [Project Structure](#3-project-structure) |
| 4 | [Database Schema](#4-database-schema) |
| 5 | [Roles & Authentication](#5-roles--authentication) |
| 6 | [Customer Side — Complete Workflows](#6-customer-side) |
| 7 | [Admin Side — Complete Workflows](#7-admin-side) |
| 8 | [Email Notification System](#8-email-notification-system) |
| 9 | [Security Implementation](#9-security-implementation) |
| 10 | [Page-by-Page Reference](#10-page-by-page-reference) |
| 11 | [End-to-End System Flow](#11-end-to-end-system-flow) |

---

## 1. Project Overview

**Cloud Kitchen** is a full-stack web application that digitizes the operations of a cloud/home kitchen business. It consists of two distinct portals:

- 🧑‍🍳 **Customer Portal** — Browse menu, search/filter dishes, manage cart, pay online (Razorpay) or via Cash on Delivery, track orders, download invoices, reorder
- 🔐 **Admin Panel** — Protected dashboard to manage the entire business: menu, categories, cuisines, delivery areas, orders (complete/cancel with email notification), customer messages, and detailed analytics reports

> **Business Context:** Operates in the Anand–Vidhyanagar region of Gujarat, India. Delivery areas are managed via pincode-based mapping.

---

## 2. Tech Stack

| Layer | Technology | Details |
|---|---|---|
| **Backend Framework** | ASP.NET WebForms | .NET Framework 4.x |
| **Language** | VB.NET | All code-behind files |
| **Database** | Microsoft SQL Server | Local `.mdf` file (App_Data) |
| **ORM/Data Access** | ADO.NET | SqlConnection, SqlCommand, SqlDataAdapter |
| **Frontend** | HTML5 + CSS3 | Vanilla CSS with CSS Variables |
| **UI Components** | Bootstrap 5.3 | Grid, modals, badges, tables |
| **Icons** | Bootstrap Icons | Used throughout both portals |
| **Fonts** | Google Fonts | Poppins (UI), Cormorant Garamond (branding) |
| **Charts** | Google Charts | Sales trend + Order status charts on dashboard |
| **Payment Gateway** | Razorpay | Online card/UPI payment processing |
| **Email** | System.Net.Mail | SMTP via Gmail for transactional emails |
| **Password Security** | SHA-256 Hashing | System.Security.Cryptography |
| **Session Management** | ASP.NET Session | Server-side, cleared on logout |
| **Caching Prevention** | HTTP Cache Headers | No-cache, no-store on admin pages |

---

## 3. Project Structure

```
Cloud Kitchen/
├── Admin/                          ← Admin portal (protected)
│   ├── Admin.Master                ← Admin layout (navbar, session guard, message badges)
│   ├── Admin.Master.vb             ← No-cache headers + session check + badge counters
│   ├── Dashboard.aspx              ← KPIs, charts, popular items, recent orders
│   ├── AddFoodItems.aspx           ← Menu item CRUD with image upload
│   ├── ManageCC1.aspx              ← Categories & Cuisines CRUD (with cascade protection)
│   ├── ManageOrders.aspx           ← Order management with filters, pagination, email
│   ├── ManageArea.aspx             ← Delivery area/pincode management
│   ├── Contact_Msg.aspx            ← Customer support message inbox
│   └── Reports.aspx                ← Advanced analytics & reports
│
├── Customers/                      ← Customer portal (mostly public)
│   ├── Customer.Master             ← Customer layout (navbar, footer)
│   ├── Customer.Master.vb          ← No-cache headers only
│   ├── Home.aspx                   ← Landing page
│   ├── Menu.aspx                   ← Browse & filter menu
│   ├── Cart.aspx                   ← Cart + checkout + payment
│   ├── MyOrders.aspx               ← Order history + invoice + reorder
│   ├── OrderConfirmation.aspx      ← Post-checkout confirmation
│   ├── Login.aspx                  ← Shared login (admin + customer)
│   ├── Register.aspx               ← New customer registration
│   └── Logout.aspx                 ← Session clear + redirect
│
├── Images/
│   └── Menu/                       ← Uploaded food item images (.jpg/.jpeg)
│
├── App_Data/
│   └── MYKITCHENN.MDF              ← SQL Server database file
│
└── Web.config                      ← DB connection string, SMTP settings
```

---

## 4. Database Schema

### 4.1 Tables Overview

| Table | Purpose |
|---|---|
| `Customers` | Registered customer accounts |
| `menu_category` | Food categories (e.g. Snacks, Main Course) |
| `cuisine_type` | Cuisine types (e.g. Indian, Chinese) |
| `menu_item` | Full food catalog |
| `Orders` | Order master record |
| `Order_Details` | Line items per order |
| `Area_Pincode` | Delivery service areas + pincodes |
| `contact_messages` | Customer support messages |

---

### 4.2 Table Field Details

#### `Customers`
| Column | Type | Notes |
|---|---|---|
| `c_id` | INT (PK) | Auto-increment |
| `c_name` | VARCHAR | Customer full name |
| `email` | VARCHAR | Unique, used for login |
| `phone` | VARCHAR | Country code + 10 digits, must be unique |
| `password` | VARCHAR | SHA-256 hashed |

#### `menu_category`
| Column | Type | Notes |
|---|---|---|
| `category_id` | INT (PK) | Auto-increment |
| `category_name` | VARCHAR | e.g. "Snacks", "Main Course" |
| `category_status` | BIT | 1 = Active, 0 = Inactive |

#### `cuisine_type`
| Column | Type | Notes |
|---|---|---|
| `cuisine_id` | INT (PK) | Auto-increment |
| `cuisine_name` | VARCHAR | e.g. "Indian", "Chinese" |
| `cuisine_status` | BIT | 1 = Active, 0 = Inactive |

#### `menu_item`
| Column | Type | Notes |
|---|---|---|
| `m_id` | INT (PK) | Auto-increment |
| `m_name` | VARCHAR | Dish name |
| `m_category_id` | INT (FK) | → `menu_category.category_id` |
| `m_cuisine_id` | INT (FK) | → `cuisine_type.cuisine_id` |
| `m_description` | TEXT | Description shown on menu card |
| `m_price` | DECIMAL | Original price |
| `m_discount` | DECIMAL | Discount % |
| `m_final_price` | DECIMAL | Price after discount |
| `m_image_url` | VARCHAR | Relative path to `/Images/Menu/` |
| `m_availability` | VARCHAR | "Yes" / "No" |
| `m_featured` | VARCHAR | "1" = shown on Home page |
| `m_status` | VARCHAR | Active / Inactive |

#### `Orders`
| Column | Type | Notes |
|---|---|---|
| `order_id` | INT (PK) | Auto-increment |
| `c_id` | INT (FK) | → `Customers.c_id` |
| `total_amount` | DECIMAL | Cart total at time of order |
| `order_status` | VARCHAR | "Pending" / "Completed" / "Cancelled" |
| `order_date` | DATETIME | Set via `GETDATE()` |
| `address` | VARCHAR | Customer delivery address |
| `pincode` | VARCHAR | Selected from `Area_Pincode` |
| `payment_type` | VARCHAR | "Cash on Delivery", "UPI", "Card Payment" etc. |
| `transaction_number` | VARCHAR | Razorpay payment ID or generated TXN code |

#### `Order_Details`
| Column | Type | Notes |
|---|---|---|
| `od_id` | INT (PK) | Auto-increment |
| `order_id` | INT (FK) | → `Orders.order_id` |
| `m_id` | INT (FK) | → `menu_item.m_id` |
| `quantity` | INT | Number of units |
| `price` | DECIMAL | Unit price at time of order |
| `total_price` | DECIMAL | `price × quantity` |

#### `Area_Pincode`
| Column | Type | Notes |
|---|---|---|
| `Area_Id` | INT (PK) | Auto-increment |
| `Area_Name` | VARCHAR | e.g. "Vidhyanagar", "Anand" |
| `Pincode` | VARCHAR | Must be unique across all areas |

#### `contact_messages`
| Column | Type | Notes |
|---|---|---|
| `message_id` | INT (PK) | Auto-increment |
| `c_id` | INT (FK, nullable) | → `Customers.c_id` |
| `email` | VARCHAR | Sender email |
| `message` | TEXT | Message body |
| `status` | BIT | 0 = Unread, 1 = Read |
| `submitted_at` | DATETIME | When message was submitted |

---

### 4.3 Table Relationships

```
Customers ──────────────< Orders >──────────────< Order_Details
                                                        │
                  Area_Pincode                    menu_item
                  (pincode FK)                    m_category_id ──> menu_category
                                                  m_cuisine_id  ──> cuisine_type

contact_messages >── Customers (c_id, nullable)
```

### 4.4 Order Status Flow

```
Customer Places Order
        │
        ▼
   [ Pending ]  ◄── Default status on creation
        │
   ┌────┴────┐
   ▼         ▼
[Completed] [Cancelled]
 Admin ✅    Admin ❌
 + Email     + Email
```

---

## 5. Roles & Authentication

### 🔴 Admin Role

| Property | Value |
|---|---|
| **Login Credentials** | `Admin@gmail.com` / `1234` (hardcoded) |
| **Session Key** | `Session("UserEmail")` |
| **Session Check** | Every request (both initial load and PostBacks) |
| **No-Cache** | `SetCacheability(NoCache)` + `SetExpires(-1)` + `SetNoStore()` |
| **Redirect on Fail** | `../Customers/Login.aspx` |
| **Logout** | Session cleared → redirect to Login |

> The session check runs **outside** `If Not IsPostBack` so even form submissions from a logged-out admin get caught.

---

### 🟢 Customer Role

| Property | Value |
|---|---|
| **Login** | Email + SHA-256 hashed password |
| **Session Keys** | `Session("c_id")`, `Session("c_name")`, `Session("UserEmail")` |
| **Remember Me** | Email + password stored in `HttpOnly` cookies (30 days expiry) |
| **Cart Storage** | `Session("Cart")` → `List(Of Dictionary(Of String, Object))` |
| **Guest Access** | Home, Menu (browse only) |
| **Auth Required** | Cart, My Orders, Order Confirmation, Logout |

---

## 6. Customer Side

### 6.1 🏠 Home Page (`Home.aspx`)

The landing page. Fully public.

| Section | Description |
|---|---|
| **Hero** | Full-screen background image, animated headline, search bar |
| **Search Bar** | Glassmorphism floating search input → submits to `Menu.aspx?search=...` |
| **Featured Dishes** | Pulls top items with `m_featured = 1` from DB, shown as image cards |
| **About Section** | Slideshow of food images + brand story + feature highlight cards |
| **Testimonials** | Auto-rotating customer review cards (pure JS carousel) |
| **Contact Form** | Name, Email, Message → `INSERT INTO contact_messages` |
| **Footer** | Links, social icons, dynamic copyright year (`<%=DateTime.Now.Year%>`) |

---

### 6.2 🍽️ Menu Page (`Menu.aspx`)

| Feature | Detail |
|---|---|
| **Load on Start** | Calls `LoadCategories()`, `LoadCuisines()`, `LoadMenuItems()` |
| **URL Search** | `?search=` query string pre-fills the search textbox |
| **Text Search** | LIKE query on `m_name` in DB |
| **Category Filter** | Dropdown AutoPostBack → filters by `m_category_id` |
| **Cuisine Filter** | Dropdown AutoPostBack → filters by `m_cuisine_id` |
| **Empty State** | Centered panel shown when no results match filters |
| **Item Cards** | Image, name, description, category + cuisine tags, original price, final price |
| **Unavailable Items** | Shows ❌ red "Not Available" label — Order button hidden |
| **Add to Cart** | Checks login → adds item to `Session("Cart")` → redirects to `Cart.aspx` |

---

### 6.3 🛒 Cart & Checkout (`Cart.aspx`)

#### Cart State
- If `Session("Cart")` is null → shows **empty cart panel**
- If cart has items → shows **cart items panel** with full item list

#### Cart Operations
| Action | What Happens |
|---|---|
| **Update Quantity** | TextBox in Repeater → updates item quantity and total_price in Session |
| **Remove Item** | `RemoveAll` from cart list by `m_id` |
| **Real-time Total** | `cart.Sum(Function(x) x("total_price"))` displayed live |

#### Checkout Form Fields
| Field | Source |
|---|---|
| Delivery Address | Free-text TextBox |
| Pincode | Dropdown bound from `Area_Pincode` table |
| Payment Type | Dropdown — COD, UPI, Card Payment, Debit Card, Wallet |

#### Payment Flow

```
Select Payment Type
        │
  ┌─────┴──────────────────────┐
  │                            │
 COD / Non-online          Online (Index 2)
  │                            │
  ▼                            ▼
"Place Order" button      Razorpay JS Popup opens
  │                            │
  ▼                            ▼
Checkout_Click()          Customer pays
  │                            │
  │                       Payment success callback
  │                            │
  │                       Animated popup modal shows payment ID
  │                            │
  │                       Customer clicks "Continue"
  │                            │
  │                       __doPostBack("PaymentSuccess", paymentId)
  │                            │
  │                       SaveOrderAfterPayment()
  │                            │
  └─────────────────┬──────────┘
                    │
          SQL Transaction begins
                    │
          INSERT INTO Orders
          + INSERT INTO Order_Details (loop per item)
                    │
          Transaction.Commit()
          (or Rollback on error)
                    │
          Session("Cart") cleared
                    │
          Order confirmation email sent
                    │
          Redirect → OrderConfirmation.aspx?OrderId=X
```

#### Card Payment Validation (before Razorpay opens)
- Card number: 4 blocks × 4 digits each
- Expiry Month: 2 digits, Expiry Year: 2 digits, must be > 25
- CCV: 3 digits
- Cardholder Name: required

---

### 6.4 📦 My Orders (`MyOrders.aspx`)

> **Auth required** — redirects to Login if not logged in.

#### Filters Available to Customer
| Filter | Options |
|---|---|
| **Status** | All / Pending / Completed / Cancelled |
| **Date Range** | Start Date + End Date picker |

#### Order Card Shows
- Order # and Date
- Status badge (color-coded: 🟡 Pending, ✅ Completed, ❌ Cancelled)
- Total Amount and Payment Type
- Delivery Address and Pincode
- Expandable item list (name, qty, price per item)

#### Actions Per Order

| Button | What it Does |
|---|---|
| **🖨 Print Invoice** | Generates a full styled HTML invoice → opens in new response → triggers `window.print()` automatically |
| **🔄 Reorder** | Fetches all items from that past order → adds to `Session("Cart")` (merges qty if item already in cart) → redirects to `Cart.aspx` |

#### Invoice Contents
- Cloud Kitchen branding header (green gradient)
- Customer Name, Phone, Address, Pincode
- Date & Time of print, Status: Paid
- Item table: Name | Qty | Unit Price | Total
- Grand Total
- Bootstrap-styled, print-optimized layout (hides browser UI ads, A4 page size)

---

### 6.5 ✅ Order Confirmation (`OrderConfirmation.aspx`)

Shown after a successful order placement.

- Displays Order ID
- Transaction Number
- Order Status
- Total Amount
- Link back to My Orders

---

### 6.6 🔐 Login (`Login.aspx`)

```
User submits email + password
        │
Is email = Admin@gmail.com AND password = 1234?
        │
    YES ─────────────────────────────────►  Set Session("UserEmail")
        │                                    Apply Remember Me cookie
        │                                    Redirect → Admin/Dashboard.aspx
        │
    NO ──► AuthenticateUser(email, password)
                    │
            Query Customers table by email
                    │
            Hash entered password (SHA-256)
            Compare with stored hash
                    │
            MATCH ──► Set Session("c_id"), Session("c_name"), Session("UserEmail")
                       Apply Remember Me cookie if checked
                       Redirect → Home.aspx
                    │
            NO MATCH ──► Show "Invalid email or password."
```

**Remember Me Behaviour:**
- Checked → Sets `HttpOnly` cookies for email + password (30 days)
- Unchecked → Removes existing cookies
- On page load → Pre-fills email/password from cookies if they exist

---

### 6.7 📝 Register (`Register.aspx`)

**Fields:** Full Name, Country Code (dropdown) + Phone (10 digits), Email, Password

**Real-time Validation (on TextChanged):**
- Email → checks DB for duplicate immediately
- Phone → checks 10-digit length AND DB for duplicate

**On Submit:**
1. Validates all fields not empty
2. Re-checks duplicate email → shows inline error label
3. Re-checks duplicate phone → shows inline error label
4. Hashes password with SHA-256
5. `INSERT INTO Customers (c_name, email, phone, password)`
6. Shows **success popup modal** with customer name — does NOT auto-redirect

---

## 7. Admin Side

### 7.1 🔒 Admin Master (`Admin.Master.vb`)

Runs on **every** page load (initial + postbacks) before anything else:

```vb
' 1. Prevent browser caching (must be first)
Response.Cache.SetCacheability(HttpCacheability.NoCache)
Response.Cache.SetExpires(DateTime.UtcNow.AddMinutes(-1))
Response.Cache.SetNoStore()

' 2. Authenticate on every request
If Session("UserEmail") Is Nothing Then
    Response.Redirect("../Customers/Login.aspx")
End If

' 3. Load badge counters (only after auth confirmed)
cntm()   → Count unread contact messages → lblcnt badge
cnto()   → Count pending orders → lblorder badge
```

The navbar always shows live badge counts for:
- 📩 Unread contact messages
- 🛒 Pending orders

---

### 7.2 📊 Dashboard (`Dashboard.aspx`)

Loads all data on first visit only (`If Not IsPostBack`).

#### KPI Cards

| KPI | SQL Query |
|---|---|
| **Total Orders** | `SELECT COUNT(*) FROM orders` |
| **Total Revenue** | `SELECT SUM(total_amount) FROM orders WHERE order_status='Completed'` |
| **Active Customers** | `SELECT COUNT(DISTINCT c_id) FROM orders` |
| **Top Dish** | `SELECT TOP 1 m_name ... GROUP BY m_name ORDER BY COUNT(order_details.m_id) DESC` |

#### Charts

| Chart | Type | Data |
|---|---|---|
| **Sales Trend** | Google Charts Area Chart | Monthly revenue grouped by `DATENAME(MONTH, order_date) + YEAR` |
| **Order Status** | Google Charts Donut Chart | Count per status (`Pending`, `Completed`, `Cancelled`) |

> Chart data is serialized with `JavaScriptSerializer` into hidden fields, then read by Google Charts JS on client.

#### Other Widgets

| Widget | Query |
|---|---|
| **Popular Items** | TOP 3 most-ordered dishes (from `Order_Details` JOIN `menu_item`) with image |
| **Recent Orders** | TOP 5 latest orders (order_id, customer, dish, amount, status, date) |

---

### 7.3 🍕 Manage Food Items (`AddFoodItems.aspx`)

#### Add New Item
1. Fill: Name, Category (dropdown), Cuisine (dropdown)
2. Description (textarea)
3. Price → auto-calculates Final Price on blur: `Price - (Price × Discount / 100)`
4. Upload image:
   - Only `.jpg` / `.jpeg` allowed on add
   - Max size: **2MB**
   - Saved to: `/Images/Menu/<filename>`
5. Set: Availability (Yes/No), Featured (Yes/No), Status (Active/Inactive)
6. `INSERT INTO menu_item` with all fields

#### Edit Item
- Click Edit in list → form pre-fills all fields
- Existing image stored in hidden field (`fn.Value`)
- Can upload new image → replaces, or leave blank → keeps existing
- On save: `UPDATE menu_item WHERE m_id = @MenuItemId`
- Accepts `.jpg`, `.jpeg`, **and `.png`** on update (wider than add)

#### Delete Item
- Instantly deletes: `DELETE FROM menu_item WHERE m_id = @MenuItemId`
- List refreshes immediately

#### Search & Filter
- **Search by name**: LIKE query (auto-submits on text change)
- **Filter by category**: Dropdown (auto-submits on change)

---

### 7.4 📂 Manage Categories & Cuisines (`ManageCC1.aspx`) ✅ Active

> This is the **safe version** — linked in the admin navbar.

#### Categories CRUD

| Action | Detail |
|---|---|
| **Add** | Name + Status (Active/Inactive) → `INSERT INTO menu_category` |
| **Edit** | Pre-fills form → `UPDATE menu_category WHERE category_id` |
| **Delete (Safe)** | First checks: `SELECT COUNT(*) FROM menu_item WHERE m_category_id = @id` — **blocks delete** if any items exist under this category |

> If items exist → Error: *"Cannot delete category. Menu items exist under this category."*

#### Cuisines CRUD

| Action | Detail |
|---|---|
| **Add** | Name + Status → `INSERT INTO cuisine_type` |
| **Edit** | Pre-fills form → `UPDATE cuisine_type WHERE cuisine_id` |
| **Delete (Safe)** | First checks: `SELECT COUNT(*) FROM menu_item WHERE m_cuisine_id = @id` — **blocks delete** if items exist |

> ℹ️ Only **Active** categories & cuisines appear in:
> - Customer menu filter dropdowns
> - Admin food item add/edit form dropdowns

---

### 7.5 🚚 Manage Orders (`ManageOrders.aspx`)

#### Summary Cards (top of page)
| Card | Query |
|---|---|
| Pending | `COUNT(*) WHERE order_status = 'Pending'` |
| Completed | `COUNT(*) WHERE order_status = 'Completed'` |
| Cancelled | `COUNT(*) WHERE order_status = 'Cancelled'` |
| Total | `COUNT(*)` |

#### Filters
| Filter | Options |
|---|---|
| **Status** | All / Pending / Completed / Cancelled |
| **Search** | Order ID, Customer Name, Phone (LIKE query on all 3) |
| **Date Range** | Start Date + End Date (default: last 30 days) |

#### Pagination
- **10 orders per page**
- Uses SQL `ROW_NUMBER()` window function for server-side paging
- Navigation: First | ◀ Previous | [numbered pages] | Next ▶ | Last

#### Order Row Shows
- Order # | Date | Customer Name | Phone | Address | Pincode
- Payment Type with icon (UPI / COD / Card / Wallet / Debit)
- Total Amount | Status badge
- Expandable section → Items in that order (name, qty, price)

#### Admin Actions Per Order

| Button | Visible When | What Happens |
|---|---|---|
| ✅ **Complete** | Status = Pending | `UPDATE Orders SET order_status = 'Completed'` → sends "Out for Delivery 🚚" email |
| ❌ **Cancel** | Status = Pending | `UPDATE Orders SET order_status = 'Cancelled'` → sends "Order Cancelled ❌" email |

> Both buttons disappear once an order is Completed or Cancelled.

---

### 7.6 📍 Manage Areas (`ManageArea.aspx`)

Manages which pincodes the kitchen delivers to. These pincodes drive the checkout pincode dropdown.

#### Statistics
- **Total Areas**: `COUNT(*) FROM Area_Pincode`
- **Recently Added**: Count of last 3 entries by `Area_Id DESC`

#### CRUD Operations

| Action | Detail |
|---|---|
| **Add** | Area Name + Pincode → Duplicate pincode check → `INSERT INTO Area_Pincode` |
| **Edit** | Pre-fills modal → Checks pincode not used by another area → `UPDATE` |
| **Delete** | `DELETE FROM Area_Pincode WHERE Area_Id` |
| **Search** | By Area Name OR Pincode (LIKE on both) |

> Edit/Add panel slides in as an animated overlay panel.

---

### 7.7 💬 Contact Messages (`Contact_Msg.aspx`)

Inbox for customer support messages submitted via the Home page contact form.

#### Stats Bar
- **Total Messages**: `COUNT(*) FROM contact_messages`
- **Unread**: `COUNT(*) WHERE status = 0`

#### Filters & Sorting
| Filter | Options |
|---|---|
| **Status Filter** | All / Unread / Read |
| **Sort Order** | Newest First / Oldest First |
| **Search** | Customer name OR email (LIKE) |

#### Pagination
- **6 messages per page**
- Previous / Next / numbered page buttons

#### Actions
| Action | What Happens |
|---|---|
| **Mark as Read** | `UPDATE contact_messages SET status = 1 WHERE message_id` → badge count updates |
| **Delete** | `DELETE FROM contact_messages WHERE message_id` |

---

### 7.8 📈 Reports (`Reports.aspx`)

Advanced analytics with date-range filtering.

| Report Type | Description |
|---|---|
| **Sales by Date** | Total revenue in selected period |
| **Order Summary** | Full list: order ID, customer, amount, status, date |
| **Item-wise Sales** | Which menu items sold most in period |
| **Customer Activity** | Per-customer: order count, total spend |
| **Order Status Breakdown** | Count of each status (Pending / Completed / Cancelled) |
| **Top Customers** | Top 10 by order count and total spend |
| **Frequent Buyers** | Customer segmentation (Active vs Inactive) |
| **Top 20 High-Value Orders** | Largest orders by total amount |

---

## 8. Email Notification System

All emails sent via **SMTP (Gmail)** configured in `Web.config` AppSettings:

```xml
<add key="SMTPServer" value="smtp.gmail.com" />
<add key="SMTPPort" value="587" />
<add key="EmailUsername" value="info.cloudkitchenn@gmail.com" />
<add key="EmailPassword" value="..." />
```

### Email Triggers

| Trigger | When | Recipient | Subject |
|---|---|---|---|
| **Order Placed** | Customer completes checkout | Customer | `🍽 Your Cloud Kitchen Order is Confirmed! #X` |
| **Order Completed** | Admin clicks Complete | Customer | `Your Order #X is Out for Delivery! 🚚` |
| **Order Cancelled** | Admin clicks Cancel | Customer | `Your Order #X has been Cancelled ❌` |

### Order Confirmation Email Content
- ✅ Confirmation heading (green bordered box)
- Order ID # and Transaction ID
- Delivery Address and Pincode
- Payment Method
- Estimated Delivery: 30–40 Minutes
- Order summary table (item name, price, qty, row total)
- Grand total (highlighted in brand color)
- CTA button: "View My Orders" → links to `cloudkitchen.somee.com/Customers/MyOrders.aspx`
- Branded footer: Cloud Kitchen logo gradient header (#4F7E76 → #3a5f59)

### Order Status Update Email Content
- "Out for Delivery" → 🚚 happy message with order item table
- "Cancelled" → regret message with item table + contact support note

---

## 9. Security Implementation

| Feature | How It's Done |
|---|---|
| **Password Hashing** | SHA-256 via `System.Security.Cryptography.SHA256` → `Convert.ToBase64String` |
| **Password Verification** | Re-hash entered password → compare with stored hash (no plain-text ever stored) |
| **Admin Session Guard** | `Session("UserEmail") Is Nothing` check runs on EVERY request (not just first load) |
| **No-Cache on Admin** | `SetCacheability(NoCache)` + `SetExpires(-1)` + `SetNoStore()` in `Admin.Master.vb` |
| **No-Cache on Customer** | Same 3 headers set in `Customer.Master.vb` |
| **Back-Button Block** | No-cache forces fresh server request → session check fires → redirects if not logged in |
| **SQL Injection Prevention** | ALL database queries use `SqlCommand.Parameters.AddWithValue()` — no string concatenation |
| **File Upload Validation** | Extension whitelist (`.jpg`/`.jpeg`), max size 2MB — enforced server-side |
| **Cookie Security** | `HttpOnly = True` on Remember Me cookies — not accessible via JavaScript |
| **Razorpay Test Key** | `rzp_test_Sq7x7OL1DUIl17` (test mode — should change to live key for production) |

---

## 10. Page-by-Page Reference

### Customer Pages

| Page | File | Auth | Purpose |
|---|---|---|---|
| Home | `Home.aspx` | ❌ Public | Landing, featured dishes, contact form |
| Menu | `Menu.aspx` | ❌ Public | Browse, search, filter, order |
| Login | `Login.aspx` | ❌ Public | Admin + Customer login |
| Register | `Register.aspx` | ❌ Public | New customer sign-up |
| Cart | `Cart.aspx` | ✅ Customer | Cart management + checkout + payment |
| My Orders | `MyOrders.aspx` | ✅ Customer | Order history, invoice, reorder |
| Order Confirmation | `OrderConfirmation.aspx` | ✅ Customer | Post-order success screen |
| Logout | `Logout.aspx` | ✅ Customer | Clears session, redirects to login |

### Admin Pages

| Page | File | Purpose |
|---|---|---|
| Dashboard | `Dashboard.aspx` | KPIs, charts, popular items, recent orders |
| Manage Food Items | `AddFoodItems.aspx` | Full menu item CRUD with image upload |
| Manage Cat. & Cuisines | `ManageCC1.aspx` ✅ | Safe CRUD with cascade-delete protection |
| Manage Orders | `ManageOrders.aspx` | View, filter, complete/cancel orders + email |
| Manage Areas | `ManageArea.aspx` | Delivery area + pincode CRUD |
| Contact Messages | `Contact_Msg.aspx` | Support inbox, mark read, delete |
| Reports | `Reports.aspx` | Advanced analytics, all report types |

---

## 11. End-to-End System Flow

```
╔══════════════════════════════════════════════════════════════════╗
║  ADMIN SETUP                                                     ║
║  1. Add Categories (e.g. Snacks, Main Course)                    ║
║  2. Add Cuisine Types (e.g. Indian, Chinese)                     ║
║  3. Add Menu Items (with price, discount, image, featured flag)  ║
║  4. Add Delivery Areas + Pincodes                                ║
╚══════════════════════════════════════════════════════════════════╝
                         ↓
╔══════════════════════════════════════════════════════════════════╗
║  CUSTOMER — DISCOVERY                                            ║
║  1. Lands on Home.aspx → sees featured dishes                    ║
║  2. Searches from hero bar OR navigates to Menu.aspx             ║
║  3. Filters by category/cuisine, searches by name                ║
╚══════════════════════════════════════════════════════════════════╝
                         ↓
╔══════════════════════════════════════════════════════════════════╗
║  CUSTOMER — ORDER PLACEMENT                                      ║
║  1. Clicks "Order Now" → checks login → adds to Session Cart     ║
║  2. Goes to Cart.aspx → reviews + updates items                  ║
║  3. Fills address + selects pincode + payment type               ║
║  4a. COD → clicks "Place Order" → saves to DB → email sent       ║
║  4b. Online → Razorpay popup → payment → popup → postback        ║
║     → saves to DB (SQL transaction) → email sent                 ║
║  5. Redirected to OrderConfirmation.aspx                         ║
╚══════════════════════════════════════════════════════════════════╝
                         ↓
╔══════════════════════════════════════════════════════════════════╗
║  ADMIN — ORDER MANAGEMENT                                        ║
║  1. Sees new Pending count badge in navbar                       ║
║  2. Opens ManageOrders.aspx → finds the order                    ║
║  3. Clicks Complete → status updated → email sent to customer    ║
║     OR Clicks Cancel → status updated → email sent to customer   ║
╚══════════════════════════════════════════════════════════════════╝
                         ↓
╔══════════════════════════════════════════════════════════════════╗
║  CUSTOMER — POST ORDER                                           ║
║  1. Sees updated status in MyOrders.aspx                         ║
║  2. Can print invoice or reorder                                 ║
╚══════════════════════════════════════════════════════════════════╝
                         ↓
╔══════════════════════════════════════════════════════════════════╗
║  ADMIN — ANALYTICS                                               ║
║  Dashboard → Revenue, active customers, top dish, charts         ║
║  Reports.aspx → Detailed breakdowns, date filters, customer data ║
╚══════════════════════════════════════════════════════════════════╝
```

---


