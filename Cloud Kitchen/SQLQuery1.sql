-- Creating the Customers table
CREATE TABLE Customers (
    c_id INT IDENTITY(1,1) PRIMARY KEY,
    c_name NVARCHAR(50) NOT NULL,
    email NVARCHAR(40) NOT NULL,
    phone NVARCHAR(13) NOT NULL,
    password NVARCHAR(256) NOT NULL
);

-- Creating the Menu_Category table
CREATE TABLE Menu_Category (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    category_status BIT NOT NULL
);

-- Creating the Cuisine_Type table
CREATE TABLE Cuisine_Type (
    cuisine_id INT IDENTITY(1,1) PRIMARY KEY,
    cuisine_name NVARCHAR(50) NOT NULL,
    cuisine_status BIT NOT NULL
);

-- Creating the Menu_Item table
CREATE TABLE Menu_Item (
    m_id INT IDENTITY(1,1) PRIMARY KEY,
    m_name NVARCHAR(100) NOT NULL,
    m_category_id INT NOT NULL,
    m_cuisine_id INT NOT NULL,
    m_description NVARCHAR(255) NULL,
    m_price NUMERIC(6,2) NOT NULL,
    m_discount NUMERIC(5,2) NULL,
    m_final_price NUMERIC(6,2) NULL,
    m_image_url NVARCHAR(255) NULL,
    m_availability BIT NOT NULL,
    m_featured BIT NOT NULL,
    m_status BIT NOT NULL,
    FOREIGN KEY (m_category_id) REFERENCES Menu_Category(category_id) ON DELETE CASCADE,
    FOREIGN KEY (m_cuisine_id) REFERENCES Cuisine_Type(cuisine_id) ON DELETE CASCADE
);

CREATE TABLE Orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    c_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    order_status NVARCHAR(50) NULL,
    order_date DATETIME DEFAULT GETDATE(),
    address NVARCHAR(255) NOT NULL,
    pincode NVARCHAR(10) NOT NULL,
    payment_type NVARCHAR(50) NOT NULL,
    transaction_number NVARCHAR(50) NULL,
    FOREIGN KEY (c_id) REFERENCES Customers(c_id) ON DELETE CASCADE
);

-- Creating the Order_Details table
CREATE TABLE Order_Details (
    order_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    m_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (m_id) REFERENCES Menu_Item(m_id) ON DELETE CASCADE
);


CREATE TABLE contact_messages (
    message_id INT IDENTITY(1,1) PRIMARY KEY,
    c_id INT NULL,  -- Allows NULL if the message is from a guest user
    name NVARCHAR(50) NOT NULL,
    email NVARCHAR(50) NOT NULL,
    message NVARCHAR(500) NOT NULL,
    submitted_at DATETIME DEFAULT GETDATE(),
    status BIT DEFAULT 0,  -- 0 for unread, 1 for read
    FOREIGN KEY (c_id) REFERENCES Customers(C_Id) ON DELETE CASCADE
);


CREATE TABLE Area_Pincode (
    Area_Id INT IDENTITY(1,1) PRIMARY KEY,
    Area_Name NVARCHAR(255) NOT NULL,
    Pincode NVARCHAR(10) NOT NULL UNIQUE,
);

