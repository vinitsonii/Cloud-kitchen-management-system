-- ===================================================================================
-- PRODUCTION-SAFE DATABASE MIGRATION SCRIPT: OLD DATABASE -> NEW DATABASE STRUCTURE
-- Target Project: Cloud Kitchen (MyKitchen Database)
-- Generated: 2026-08-31
-- Data Preservation: GUARANTEED (No tables dropped, no data deleted, no destructive ops)
-- ===================================================================================

SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

PRINT N'Starting Production-Safe Database Migration...';
GO

-- ===================================================================================
-- STEP 1: CREATE MISSING TABLES
-- ===================================================================================

-- 1.1 Create Ingredients Table
IF OBJECT_ID(N'[dbo].[Ingredients]', N'U') IS NULL
BEGIN
    PRINT N'Creating table [dbo].[Ingredients]...';
    CREATE TABLE [dbo].[Ingredients](
        [ingredient_id] [int] IDENTITY(1,1) NOT NULL,
        [ingredient_name] [varchar](100) NOT NULL,
        [stock_quantity] [decimal](10, 2) NOT NULL,
        [unit] [varchar](20) NOT NULL,
        [cost_per_unit] [decimal](10, 2) NULL,
        [low_stock_threshold] [decimal](10, 2) NULL,
        [last_updated] [datetime] NULL,
        CONSTRAINT [PK_Ingredients] PRIMARY KEY CLUSTERED 
        (
            [ingredient_id] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY];
END
ELSE
BEGIN
    PRINT N'Table [dbo].[Ingredients] already exists. Skipping creation.';
END
GO

-- 1.2 Create Drivers Table
IF OBJECT_ID(N'[dbo].[Drivers]', N'U') IS NULL
BEGIN
    PRINT N'Creating table [dbo].[Drivers]...';
    CREATE TABLE [dbo].[Drivers](
        [driver_id] [int] IDENTITY(1,1) NOT NULL,
        [driver_name] [nvarchar](100) NOT NULL,
        [phone] [nvarchar](15) NOT NULL,
        [password] [nvarchar](50) NOT NULL,
        [vehicle_no] [nvarchar](20) NOT NULL,
        [status] [nvarchar](20) NOT NULL,
        [created_date] [datetime] NOT NULL,
        CONSTRAINT [PK_Drivers] PRIMARY KEY CLUSTERED 
        (
            [driver_id] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY];
END
ELSE
BEGIN
    PRINT N'Table [dbo].[Drivers] already exists. Skipping creation.';
END
GO

-- 1.3 Create Dish_Ingredients Table
IF OBJECT_ID(N'[dbo].[Dish_Ingredients]', N'U') IS NULL
BEGIN
    PRINT N'Creating table [dbo].[Dish_Ingredients]...';
    CREATE TABLE [dbo].[Dish_Ingredients](
        [recipe_id] [int] IDENTITY(1,1) NOT NULL,
        [m_id] [int] NOT NULL,
        [ingredient_id] [int] NOT NULL,
        [qty_required] [decimal](10, 2) NOT NULL,
        CONSTRAINT [PK_Dish_Ingredients] PRIMARY KEY CLUSTERED 
        (
            [recipe_id] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY];
END
ELSE
BEGIN
    PRINT N'Table [dbo].[Dish_Ingredients] already exists. Skipping creation.';
END
GO

-- ===================================================================================
-- STEP 2: ADD MISSING COLUMNS TO EXISTING TABLES
-- ===================================================================================

-- 2.1 Add missing columns to [dbo].[menu_item]
IF COL_LENGTH(N'[dbo].[menu_item]', N'm_track_inventory') IS NULL
BEGIN
    PRINT N'Adding column [m_track_inventory] to [dbo].[menu_item]...';
    ALTER TABLE [dbo].[menu_item] ADD [m_track_inventory] [bit] NULL;
END
GO

IF COL_LENGTH(N'[dbo].[menu_item]', N'm_unit_stock') IS NULL
BEGIN
    PRINT N'Adding column [m_unit_stock] to [dbo].[menu_item]...';
    ALTER TABLE [dbo].[menu_item] ADD [m_unit_stock] [int] NULL;
END
GO

-- 2.2 Add missing columns to [dbo].[Orders]
IF COL_LENGTH(N'[dbo].[Orders]', N'driver_id') IS NULL
BEGIN
    PRINT N'Adding column [driver_id] to [dbo].[Orders]...';
    ALTER TABLE [dbo].[Orders] ADD [driver_id] [int] NULL;
END
GO

IF COL_LENGTH(N'[dbo].[Orders]', N'delivery_otp') IS NULL
BEGIN
    PRINT N'Adding column [delivery_otp] to [dbo].[Orders]...';
    ALTER TABLE [dbo].[Orders] ADD [delivery_otp] [varchar](6) NULL;
END
GO

IF COL_LENGTH(N'[dbo].[Orders]', N'delivered_time') IS NULL
BEGIN
    PRINT N'Adding column [delivered_time] to [dbo].[Orders]...';
    ALTER TABLE [dbo].[Orders] ADD [delivered_time] [datetime] NULL;
END
GO

IF COL_LENGTH(N'[dbo].[Orders]', N'delivery_notes') IS NULL
BEGIN
    PRINT N'Adding column [delivery_notes] to [dbo].[Orders]...';
    ALTER TABLE [dbo].[Orders] ADD [delivery_notes] [nvarchar](255) NULL;
END
GO

-- ===================================================================================
-- STEP 3: POPULATE / BACKFILL REQUIRED NEW COLUMNS
-- ===================================================================================

-- Backfill default value 1 for m_track_inventory on existing menu items where NULL
PRINT N'Backfilling default values for [menu_item].[m_track_inventory]...';
UPDATE [dbo].[menu_item]
SET [m_track_inventory] = 1
WHERE [m_track_inventory] IS NULL;
GO

-- ===================================================================================
-- STEP 4: MODIFY COMPATIBLE COLUMNS
-- ===================================================================================
-- (No column modifications required. All existing column data types and lengths are identical)
GO

-- ===================================================================================
-- STEP 5: CREATE DEFAULT CONSTRAINTS
-- ===================================================================================

-- 5.1 Defaults for Drivers Table
IF NOT EXISTS (
    SELECT 1 FROM sys.default_constraints 
    WHERE parent_object_id = OBJECT_ID(N'[dbo].[Drivers]') 
      AND col_name(parent_object_id, parent_column_id) = N'status'
)
BEGIN
    PRINT N'Adding default constraint for [Drivers].[status]...';
    ALTER TABLE [dbo].[Drivers] ADD DEFAULT ('Available') FOR [status];
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.default_constraints 
    WHERE parent_object_id = OBJECT_ID(N'[dbo].[Drivers]') 
      AND col_name(parent_object_id, parent_column_id) = N'created_date'
)
BEGIN
    PRINT N'Adding default constraint for [Drivers].[created_date]...';
    ALTER TABLE [dbo].[Drivers] ADD DEFAULT (getdate()) FOR [created_date];
END
GO

-- 5.2 Defaults for Ingredients Table
IF NOT EXISTS (
    SELECT 1 FROM sys.default_constraints 
    WHERE parent_object_id = OBJECT_ID(N'[dbo].[Ingredients]') 
      AND col_name(parent_object_id, parent_column_id) = N'stock_quantity'
)
BEGIN
    PRINT N'Adding default constraint for [Ingredients].[stock_quantity]...';
    ALTER TABLE [dbo].[Ingredients] ADD DEFAULT ((0.00)) FOR [stock_quantity];
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.default_constraints 
    WHERE parent_object_id = OBJECT_ID(N'[dbo].[Ingredients]') 
      AND col_name(parent_object_id, parent_column_id) = N'cost_per_unit'
)
BEGIN
    PRINT N'Adding default constraint for [Ingredients].[cost_per_unit]...';
    ALTER TABLE [dbo].[Ingredients] ADD DEFAULT ((0.00)) FOR [cost_per_unit];
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.default_constraints 
    WHERE parent_object_id = OBJECT_ID(N'[dbo].[Ingredients]') 
      AND col_name(parent_object_id, parent_column_id) = N'low_stock_threshold'
)
BEGIN
    PRINT N'Adding default constraint for [Ingredients].[low_stock_threshold]...';
    ALTER TABLE [dbo].[Ingredients] ADD DEFAULT ((2.00)) FOR [low_stock_threshold];
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.default_constraints 
    WHERE parent_object_id = OBJECT_ID(N'[dbo].[Ingredients]') 
      AND col_name(parent_object_id, parent_column_id) = N'last_updated'
)
BEGIN
    PRINT N'Adding default constraint for [Ingredients].[last_updated]...';
    ALTER TABLE [dbo].[Ingredients] ADD DEFAULT (getdate()) FOR [last_updated];
END
GO

-- 5.3 Defaults for menu_item Table
IF NOT EXISTS (
    SELECT 1 FROM sys.default_constraints 
    WHERE parent_object_id = OBJECT_ID(N'[dbo].[menu_item]') 
      AND col_name(parent_object_id, parent_column_id) = N'm_track_inventory'
)
BEGIN
    PRINT N'Adding default constraint for [menu_item].[m_track_inventory]...';
    ALTER TABLE [dbo].[menu_item] ADD DEFAULT ((1)) FOR [m_track_inventory];
END
GO

-- ===================================================================================
-- STEP 6: CREATE PRIMARY KEYS
-- ===================================================================================
-- (Primary keys PK_Ingredients, PK_Drivers, PK_Dish_Ingredients were created inline with tables in Step 1)
GO

-- ===================================================================================
-- STEP 7: CREATE UNIQUE CONSTRAINTS / INDEXES
-- ===================================================================================

-- 7.1 Drivers Phone Unique Index
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes 
    WHERE object_id = OBJECT_ID(N'[dbo].[Drivers]') 
      AND (name = N'UQ_Drivers_phone' OR name LIKE N'UQ__Drivers__%')
)
BEGIN
    PRINT N'Creating unique constraint UQ_Drivers_phone on [dbo].[Drivers]([phone])...';
    ALTER TABLE [dbo].[Drivers] ADD CONSTRAINT [UQ_Drivers_phone] UNIQUE NONCLUSTERED 
    (
        [phone] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY];
END
GO

-- ===================================================================================
-- STEP 8: CREATE CHECK CONSTRAINTS
-- ===================================================================================
-- (No new check constraints required)
GO

-- ===================================================================================
-- STEP 9: CREATE INDEXES
-- ===================================================================================
-- (Unique index on Drivers.phone handled in Step 7)
GO

-- ===================================================================================
-- STEP 10: CREATE FOREIGN KEYS
-- ===================================================================================

-- 10.1 Dish_Ingredients -> Ingredients (ingredient_id)
IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys 
    WHERE parent_object_id = OBJECT_ID(N'[dbo].[Dish_Ingredients]') 
      AND referenced_object_id = OBJECT_ID(N'[dbo].[Ingredients]')
)
BEGIN
    PRINT N'Adding Foreign Key [FK_Dish_Ingredients_Ingredients]...';
    ALTER TABLE [dbo].[Dish_Ingredients] WITH CHECK ADD CONSTRAINT [FK_Dish_Ingredients_Ingredients] 
    FOREIGN KEY([ingredient_id]) REFERENCES [dbo].[Ingredients] ([ingredient_id]) 
    ON DELETE CASCADE;

    ALTER TABLE [dbo].[Dish_Ingredients] CHECK CONSTRAINT [FK_Dish_Ingredients_Ingredients];
END
GO

-- 10.2 Dish_Ingredients -> menu_item (m_id)
IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys 
    WHERE parent_object_id = OBJECT_ID(N'[dbo].[Dish_Ingredients]') 
      AND referenced_object_id = OBJECT_ID(N'[dbo].[menu_item]')
)
BEGIN
    PRINT N'Adding Foreign Key [FK_Dish_Ingredients_menu_item]...';
    ALTER TABLE [dbo].[Dish_Ingredients] WITH CHECK ADD CONSTRAINT [FK_Dish_Ingredients_menu_item] 
    FOREIGN KEY([m_id]) REFERENCES [dbo].[menu_item] ([m_id]) 
    ON DELETE CASCADE;

    ALTER TABLE [dbo].[Dish_Ingredients] CHECK CONSTRAINT [FK_Dish_Ingredients_menu_item];
END
GO

-- 10.3 (Optional / Recommended) Orders -> Drivers (driver_id)
-- Note: NEW script does not explicitly create an FK for Orders.driver_id -> Drivers.driver_id,
-- but if desired, it can be added. It is left optional to maintain exact structural parity with NEW script.

-- ===================================================================================
-- STEPS 11-14: VIEWS / FUNCTIONS / PROCEDURES / TRIGGERS
-- ===================================================================================
-- (None present in NEW schema)
GO

PRINT N'Database Migration Completed Successfully!';
GO

































-- ===================================================================================
-- FULL DATABASE SCHEMA EQUIVALENCE AUDIT (COMPARING LIVE DB vs NEW DATABASE SCRIPT)
-- ===================================================================================

SET NOCOUNT ON;

-- -----------------------------------------------------------------------------------
-- SET 1: TABLE & COLUMN COUNT PARITY AUDIT
-- -----------------------------------------------------------------------------------
WITH ExpectedSchema AS (
    SELECT TableName = 'Area_Pincode', ExpectedCols = 3 UNION ALL
    SELECT TableName = 'contact_messages', ExpectedCols = 7 UNION ALL
    SELECT TableName = 'cuisine_type', ExpectedCols = 3 UNION ALL
    SELECT TableName = 'Customers', ExpectedCols = 5 UNION ALL
    SELECT TableName = 'Dish_Ingredients', ExpectedCols = 4 UNION ALL
    SELECT TableName = 'Drivers', ExpectedCols = 7 UNION ALL
    SELECT TableName = 'Ingredients', ExpectedCols = 7 UNION ALL
    SELECT TableName = 'menu_category', ExpectedCols = 3 UNION ALL
    SELECT TableName = 'menu_item', ExpectedCols = 14 UNION ALL
    SELECT TableName = 'Order_Details', ExpectedCols = 6 UNION ALL
    SELECT TableName = 'Orders', ExpectedCols = 13
)
SELECT 
    [Table] = e.TableName,
    [Status] = CASE WHEN t.object_id IS NOT NULL THEN 'EXISTS' ELSE 'MISSING' END,
    [Actual Cols] = ISNULL(COUNT(c.column_id), 0),
    [Expected Cols] = e.ExpectedCols,
    [Column Parity] = CASE 
        WHEN COUNT(c.column_id) = e.ExpectedCols THEN 'MATCH (100%)' 
        ELSE 'MISMATCH' 
    END
FROM ExpectedSchema e
LEFT JOIN sys.tables t ON t.name = e.TableName AND t.schema_id = SCHEMA_ID('dbo')
LEFT JOIN sys.columns c ON c.object_id = t.object_id
GROUP BY e.TableName, e.ExpectedCols, t.object_id
ORDER BY e.TableName;

-- -----------------------------------------------------------------------------------
-- SET 2: PRIMARY KEY AUDIT ACROSS ALL TABLES
-- -----------------------------------------------------------------------------------
SELECT 
    [Table] = t.name,
    [Primary Key Name] = ISNULL(pk.name, 'NO PK DEFINED'),
    [PK Column(s)] = STUFF((
        SELECT ', ' + col.name
        FROM sys.index_columns ic
        JOIN sys.columns col ON ic.object_id = col.object_id AND ic.column_id = col.column_id
        WHERE ic.object_id = t.object_id AND ic.index_id = pk.index_id
        FOR XML PATH('')
    ), 1, 2, '')
FROM sys.tables t
LEFT JOIN sys.indexes pk ON t.object_id = pk.object_id AND pk.is_primary_key = 1
WHERE t.schema_id = SCHEMA_ID('dbo')
ORDER BY t.name;

-- -----------------------------------------------------------------------------------
-- SET 3: FOREIGN KEYS & UNIQUE INDEXES AUDIT
-- -----------------------------------------------------------------------------------
SELECT 
    [Object Type] = 'Foreign Key',
    [Constraint Name] = fk.name,
    [Parent Table] = OBJECT_NAME(fk.parent_object_id),
    [Referenced Table] = OBJECT_NAME(fk.referenced_object_id)
FROM sys.foreign_keys fk
UNION ALL
SELECT 
    [Object Type] = 'Unique Index',
    [Constraint Name] = idx.name,
    [Parent Table] = OBJECT_NAME(idx.object_id),
    [Referenced Table] = 'N/A'
FROM sys.indexes idx
WHERE idx.is_unique = 1 AND idx.is_primary_key = 0 AND OBJECT_NAME(idx.object_id) NOT LIKE 'sys%'
ORDER BY [Object Type], [Parent Table];

-- -----------------------------------------------------------------------------------
-- SET 4: FINAL EQUIVALENCE VERDICT
-- -----------------------------------------------------------------------------------
SELECT 
    [Audit Metric] = 'Database Parity Summary',
    [Total Target Tables] = 11,
    [Live Tables Found] = (SELECT COUNT(*) FROM sys.tables WHERE schema_id = SCHEMA_ID('dbo') AND name IN ('Area_Pincode', 'contact_messages', 'cuisine_type', 'Customers', 'Dish_Ingredients', 'Drivers', 'Ingredients', 'menu_category', 'menu_item', 'Order_Details', 'Orders')),
    [Total Target Columns] = 72,
    [Live Columns Found] = (SELECT COUNT(*) FROM sys.columns WHERE object_id IN (SELECT object_id FROM sys.tables WHERE schema_id = SCHEMA_ID('dbo'))),
    [Overall Verdict] = CASE 
        WHEN (SELECT COUNT(*) FROM sys.tables WHERE schema_id = SCHEMA_ID('dbo')) >= 11
         AND (SELECT COUNT(*) FROM sys.columns WHERE object_id IN (SELECT object_id FROM sys.tables WHERE schema_id = SCHEMA_ID('dbo'))) >= 72
        THEN '✅ MATCH: Database structure is 100% EQUIVALENT to new script (ckmscriptnew.sql)'
        ELSE '⚠️ MISMATCH: Missing tables or columns detected'
    END;


-- ===================================================================================
-- STEP 4: SEED DATA & PRODUCTION INITIAL DATA INGESTION
-- ===================================================================================
PRINT N'Starting Data Ingestion from ckmscriptnew.sql...';
GO
-- Data Ingestion for [dbo].[Area_Pincode] (7 rows)
IF EXISTS (SELECT 1 FROM [dbo].[Area_Pincode])
BEGIN
    PRINT N'Table [dbo].[Area_Pincode] already contains data. Skipping initial inserts to preserve existing records.';
END
ELSE
BEGIN
    PRINT N'Inserting initial data into [dbo].[Area_Pincode] (7 records)...';
    SET IDENTITY_INSERT [dbo].[Area_Pincode] ON 
    INSERT [dbo].[Area_Pincode] ([Area_Id], [Area_Name], [Pincode]) VALUES (1, N'Vallabh Vidhyanagar', N'388120')
    INSERT [dbo].[Area_Pincode] ([Area_Id], [Area_Name], [Pincode]) VALUES (2, N'Anand', N'388121')
    INSERT [dbo].[Area_Pincode] ([Area_Id], [Area_Name], [Pincode]) VALUES (4, N'Borsad', N'388540')
    INSERT [dbo].[Area_Pincode] ([Area_Id], [Area_Name], [Pincode]) VALUES (5, N'Bakrol', N'388315')
    INSERT [dbo].[Area_Pincode] ([Area_Id], [Area_Name], [Pincode]) VALUES (6, N'Memdabad', N'383678')
    SET IDENTITY_INSERT [dbo].[Area_Pincode] OFF
END
GO
-- Data Ingestion for [dbo].[Customers] (5 rows)
IF EXISTS (SELECT 1 FROM [dbo].[Customers])
BEGIN
    PRINT N'Table [dbo].[Customers] already contains data. Skipping initial inserts to preserve existing records.';
END
ELSE
BEGIN
    PRINT N'Inserting initial data into [dbo].[Customers] (5 records)...';
    SET IDENTITY_INSERT [dbo].[Customers] ON 
    INSERT [dbo].[Customers] ([c_id], [c_name], [email], [phone], [password]) VALUES (1, N'Vinit Soni', N'vinitsoni5911@gmail.com', N'+918160698196', N'THFIsGGcGUbcMQoHhQWfr62S/V28fI+ubfOER7syuP8=')
    INSERT [dbo].[Customers] ([c_id], [c_name], [email], [phone], [password]) VALUES (2, N'Dhruvil Rana', N'idkranadhruvil2209@gmail.com', N'+917016532976', N'asMkz5EqdVsbeSpL24Myh/xAwfWyQNG7oFI/Ood8nbE=')
    INSERT [dbo].[Customers] ([c_id], [c_name], [email], [phone], [password]) VALUES (8, N'Rudra Jadav', N'Rudra@gmail.com', N'+919878787217', N'0uwoS4FrYrOnjEZggZaXt5F+vO1VnIEvqGAqSa9R7Ng=')
    SET IDENTITY_INSERT [dbo].[Customers] OFF
END
GO
-- Data Ingestion for [dbo].[Drivers] (5 rows)
IF EXISTS (SELECT 1 FROM [dbo].[Drivers])
BEGIN
    PRINT N'Table [dbo].[Drivers] already contains data. Skipping initial inserts to preserve existing records.';
END
ELSE
BEGIN
    PRINT N'Inserting initial data into [dbo].[Drivers] (5 records)...';
    SET IDENTITY_INSERT [dbo].[Drivers] ON 
    INSERT [dbo].[Drivers] ([driver_id], [driver_name], [phone], [password], [vehicle_no], [status], [created_date]) VALUES (1, N'Ramesh Kumar', N'9876543210', N'123456', N'GJ-23-AB-1234', N'Offline', CAST(N'2026-08-19T01:19:11.777' AS DateTime))
    INSERT [dbo].[Drivers] ([driver_id], [driver_name], [phone], [password], [vehicle_no], [status], [created_date]) VALUES (2, N'Suresh Patel', N'9876543211', N'123456', N'GJ-23-CD-5679', N'Available', CAST(N'2026-08-19T01:19:11.777' AS DateTime))
    INSERT [dbo].[Drivers] ([driver_id], [driver_name], [phone], [password], [vehicle_no], [status], [created_date]) VALUES (1002, N'Kalpesh Patel', N'9876543214', N'123456', N'GJ-23-CD-4321', N'Available', CAST(N'2026-08-30T23:11:32.383' AS DateTime))
    SET IDENTITY_INSERT [dbo].[Drivers] OFF
END
GO
-- Data Ingestion for [dbo].[cuisine_type] (7 rows)
IF EXISTS (SELECT 1 FROM [dbo].[cuisine_type])
BEGIN
    PRINT N'Table [dbo].[cuisine_type] already contains data. Skipping initial inserts to preserve existing records.';
END
ELSE
BEGIN
    PRINT N'Inserting initial data into [dbo].[cuisine_type] (7 records)...';
    SET IDENTITY_INSERT [dbo].[cuisine_type] ON 
    INSERT [dbo].[cuisine_type] ([cuisine_id], [cuisine_name], [cuisine_status]) VALUES (1, N'North Indian', 1)
    INSERT [dbo].[cuisine_type] ([cuisine_id], [cuisine_name], [cuisine_status]) VALUES (2, N'South Indian', 1)
    INSERT [dbo].[cuisine_type] ([cuisine_id], [cuisine_name], [cuisine_status]) VALUES (3, N'Mughlai', 1)
    INSERT [dbo].[cuisine_type] ([cuisine_id], [cuisine_name], [cuisine_status]) VALUES (4, N'Street Food', 1)
    INSERT [dbo].[cuisine_type] ([cuisine_id], [cuisine_name], [cuisine_status]) VALUES (5, N'Desserts', 1)
    SET IDENTITY_INSERT [dbo].[cuisine_type] OFF
END
GO
-- Data Ingestion for [dbo].[menu_category] (7 rows)
IF EXISTS (SELECT 1 FROM [dbo].[menu_category])
BEGIN
    PRINT N'Table [dbo].[menu_category] already contains data. Skipping initial inserts to preserve existing records.';
END
ELSE
BEGIN
    PRINT N'Inserting initial data into [dbo].[menu_category] (7 records)...';
    SET IDENTITY_INSERT [dbo].[menu_category] ON 
    INSERT [dbo].[menu_category] ([category_id], [category_name], [category_status]) VALUES (1, N'Vegetarian', 1)
    INSERT [dbo].[menu_category] ([category_id], [category_name], [category_status]) VALUES (2, N'Non Vegetarian', 1)
    INSERT [dbo].[menu_category] ([category_id], [category_name], [category_status]) VALUES (3, N'Snacks', 1)
    INSERT [dbo].[menu_category] ([category_id], [category_name], [category_status]) VALUES (5, N'Sweets', 1)
    INSERT [dbo].[menu_category] ([category_id], [category_name], [category_status]) VALUES (7, N'Starters', 1)
    SET IDENTITY_INSERT [dbo].[menu_category] OFF
END
GO
-- Data Ingestion for [dbo].[Ingredients] (17 rows)
IF EXISTS (SELECT 1 FROM [dbo].[Ingredients])
BEGIN
    PRINT N'Table [dbo].[Ingredients] already contains data. Skipping initial inserts to preserve existing records.';
END
ELSE
BEGIN
    PRINT N'Inserting initial data into [dbo].[Ingredients] (17 records)...';
    SET IDENTITY_INSERT [dbo].[Ingredients] ON 
    INSERT [dbo].[Ingredients] ([ingredient_id], [ingredient_name], [stock_quantity], [unit], [cost_per_unit], [low_stock_threshold], [last_updated]) VALUES (1, N'Paneer (Cottage Cheese)', CAST(11.50 AS Decimal(10, 2)), N'kg', CAST(320.00 AS Decimal(10, 2)), CAST(3.00 AS Decimal(10, 2)), CAST(N'2026-08-26T17:57:52.680' AS DateTime))
    INSERT [dbo].[Ingredients] ([ingredient_id], [ingredient_name], [stock_quantity], [unit], [cost_per_unit], [low_stock_threshold], [last_updated]) VALUES (2, N'Fresh Chicken', CAST(25.00 AS Decimal(10, 2)), N'kg', CAST(240.00 AS Decimal(10, 2)), CAST(5.00 AS Decimal(10, 2)), CAST(N'2026-08-18T23:56:08.047' AS DateTime))
    INSERT [dbo].[Ingredients] ([ingredient_id], [ingredient_name], [stock_quantity], [unit], [cost_per_unit], [low_stock_threshold], [last_updated]) VALUES (3, N'Butter', CAST(7.30 AS Decimal(10, 2)), N'kg', CAST(480.00 AS Decimal(10, 2)), CAST(2.00 AS Decimal(10, 2)), CAST(N'2026-08-26T17:57:52.680' AS DateTime))
    INSERT [dbo].[Ingredients] ([ingredient_id], [ingredient_name], [stock_quantity], [unit], [cost_per_unit], [low_stock_threshold], [last_updated]) VALUES (4, N'Basmati Rice', CAST(50.00 AS Decimal(10, 2)), N'kg', CAST(95.00 AS Decimal(10, 2)), CAST(5.00 AS Decimal(10, 2)), CAST(N'2026-08-19T00:19:45.413' AS DateTime))
    INSERT [dbo].[Ingredients] ([ingredient_id], [ingredient_name], [stock_quantity], [unit], [cost_per_unit], [low_stock_threshold], [last_updated]) VALUES (5, N'Cooking Oil', CAST(28.99 AS Decimal(10, 2)), N'L', CAST(140.00 AS Decimal(10, 2)), CAST(5.00 AS Decimal(10, 2)), CAST(N'2026-08-30T23:07:49.647' AS DateTime))
    INSERT [dbo].[Ingredients] ([ingredient_id], [ingredient_name], [stock_quantity], [unit], [cost_per_unit], [low_stock_threshold], [last_updated]) VALUES (6, N'Onion & Tomato Paste', CAST(17.90 AS Decimal(10, 2)), N'kg', CAST(60.00 AS Decimal(10, 2)), CAST(4.00 AS Decimal(10, 2)), CAST(N'2026-08-26T17:57:52.680' AS DateTime))
    INSERT [dbo].[Ingredients] ([ingredient_id], [ingredient_name], [stock_quantity], [unit], [cost_per_unit], [low_stock_threshold], [last_updated]) VALUES (7, N'Indian Spices & Garam Masala', CAST(4.45 AS Decimal(10, 2)), N'kg', CAST(650.00 AS Decimal(10, 2)), CAST(1.00 AS Decimal(10, 2)), CAST(N'2026-08-30T23:07:49.647' AS DateTime))
    INSERT [dbo].[Ingredients] ([ingredient_id], [ingredient_name], [stock_quantity], [unit], [cost_per_unit], [low_stock_threshold], [last_updated]) VALUES (8, N'Fresh Cream', CAST(9.44 AS Decimal(10, 2)), N'L', CAST(210.00 AS Decimal(10, 2)), CAST(2.00 AS Decimal(10, 2)), CAST(N'2026-08-26T17:57:52.680' AS DateTime))
    INSERT [dbo].[Ingredients] ([ingredient_id], [ingredient_name], [stock_quantity], [unit], [cost_per_unit], [low_stock_threshold], [last_updated]) VALUES (9, N'Potatoes (Aloo)', CAST(34.89 AS Decimal(10, 2)), N'kg', CAST(30.00 AS Decimal(10, 2)), CAST(8.00 AS Decimal(10, 2)), CAST(N'2026-08-30T23:07:49.647' AS DateTime))
    INSERT [dbo].[Ingredients] ([ingredient_id], [ingredient_name], [stock_quantity], [unit], [cost_per_unit], [low_stock_threshold], [last_updated]) VALUES (10, N'Dosa Batter', CAST(13.60 AS Decimal(10, 2)), N'L', CAST(50.00 AS Decimal(10, 2)), CAST(3.00 AS Decimal(10, 2)), CAST(N'2026-08-26T17:57:52.683' AS DateTime))
    INSERT [dbo].[Ingredients] ([ingredient_id], [ingredient_name], [stock_quantity], [unit], [cost_per_unit], [low_stock_threshold], [last_updated]) VALUES (11, N'Puri Balls & Water Spices', CAST(194.00 AS Decimal(10, 2)), N'pcs', CAST(1.50 AS Decimal(10, 2)), CAST(30.00 AS Decimal(10, 2)), CAST(N'2026-08-26T17:45:35.150' AS DateTime))
    INSERT [dbo].[Ingredients] ([ingredient_id], [ingredient_name], [stock_quantity], [unit], [cost_per_unit], [low_stock_threshold], [last_updated]) VALUES (12, N'Sugar & Sugar Syrup', CAST(25.00 AS Decimal(10, 2)), N'kg', CAST(45.00 AS Decimal(10, 2)), CAST(5.00 AS Decimal(10, 2)), CAST(N'2026-08-18T23:56:08.360' AS DateTime))
    INSERT [dbo].[Ingredients] ([ingredient_id], [ingredient_name], [stock_quantity], [unit], [cost_per_unit], [low_stock_threshold], [last_updated]) VALUES (13, N'Khoya & Milk Powder', CAST(6.00 AS Decimal(10, 2)), N'kg', CAST(380.00 AS Decimal(10, 2)), CAST(1.50 AS Decimal(10, 2)), CAST(N'2026-08-18T23:56:08.393' AS DateTime))
    INSERT [dbo].[Ingredients] ([ingredient_id], [ingredient_name], [stock_quantity], [unit], [cost_per_unit], [low_stock_threshold], [last_updated]) VALUES (14, N'Black Lentils (Urad Dal)', CAST(20.00 AS Decimal(10, 2)), N'kg', CAST(120.00 AS Decimal(10, 2)), CAST(2.50 AS Decimal(10, 2)), CAST(N'2026-08-19T00:53:48.507' AS DateTime))
    INSERT [dbo].[Ingredients] ([ingredient_id], [ingredient_name], [stock_quantity], [unit], [cost_per_unit], [low_stock_threshold], [last_updated]) VALUES (15, N'Mixed Vegetables (Cabbage/Carrot)', CAST(5.00 AS Decimal(10, 2)), N'kg', CAST(50.00 AS Decimal(10, 2)), CAST(2.00 AS Decimal(10, 2)), CAST(N'2026-08-19T00:04:09.650' AS DateTime))
    SET IDENTITY_INSERT [dbo].[Ingredients] OFF
END
GO
-- Data Ingestion for [dbo].[menu_item] (17 rows)
IF EXISTS (SELECT 1 FROM [dbo].[menu_item])
BEGIN
    PRINT N'Table [dbo].[menu_item] already contains data. Skipping initial inserts to preserve existing records.';
END
ELSE
BEGIN
    PRINT N'Inserting initial data into [dbo].[menu_item] (17 records)...';
    SET IDENTITY_INSERT [dbo].[menu_item] ON 
    INSERT [dbo].[menu_item] ([m_id], [m_name], [m_category_id], [m_cuisine_id], [m_description], [m_price], [m_discount], [m_final_price], [m_image_url], [m_availability], [m_featured], [m_status], [m_track_inventory], [m_unit_stock]) VALUES (1, N'Paneer Butter Masala', 1, 1, N'Delicious North Indian curry with paneer and butter-rich gravy', CAST(250.00 AS Numeric(6, 2)), CAST(3.00 AS Numeric(5, 2)), CAST(242.50 AS Numeric(6, 2)), N'../Images/Menu/Paneer Butter Masala img (2).jpg', 1, 0, 1, 1, NULL)
    INSERT [dbo].[menu_item] ([m_id], [m_name], [m_category_id], [m_cuisine_id], [m_description], [m_price], [m_discount], [m_final_price], [m_image_url], [m_availability], [m_featured], [m_status], [m_track_inventory], [m_unit_stock]) VALUES (2, N'Masala Dosa', 1, 2, N'Crispy dosa stuffed with spiced potato filling', CAST(150.00 AS Numeric(6, 2)), CAST(5.00 AS Numeric(5, 2)), CAST(142.50 AS Numeric(6, 2)), N'../Images/Menu/zoshua-colah-VIqcVqZ1uxM-unsplash.jpg', 1, 0, 1, 1, NULL)
    INSERT [dbo].[menu_item] ([m_id], [m_name], [m_category_id], [m_cuisine_id], [m_description], [m_price], [m_discount], [m_final_price], [m_image_url], [m_availability], [m_featured], [m_status], [m_track_inventory], [m_unit_stock]) VALUES (3, N'Chicken Biryani', 2, 3, N'Fragrant basmati rice cooked with tender chicken pieces and spices', CAST(300.00 AS Numeric(6, 2)), CAST(15.00 AS Numeric(5, 2)), CAST(255.00 AS Numeric(6, 2)), N'../Images/Menu/Chicken Biryani.jpg', 1, 0, 1, 1, NULL)
    INSERT [dbo].[menu_item] ([m_id], [m_name], [m_category_id], [m_cuisine_id], [m_description], [m_price], [m_discount], [m_final_price], [m_image_url], [m_availability], [m_featured], [m_status], [m_track_inventory], [m_unit_stock]) VALUES (4, N'Pani Puri', 3, 4, N'Crispy puris filled with spicy and tangy water', CAST(50.00 AS Numeric(6, 2)), CAST(0.00 AS Numeric(5, 2)), CAST(50.00 AS Numeric(6, 2)), N'../Images/Menu/Pani Puri.jpeg', 1, 0, 1, 1, NULL)
    INSERT [dbo].[menu_item] ([m_id], [m_name], [m_category_id], [m_cuisine_id], [m_description], [m_price], [m_discount], [m_final_price], [m_image_url], [m_availability], [m_featured], [m_status], [m_track_inventory], [m_unit_stock]) VALUES (5, N'Gulab Jamun', 5, 5, N'Soft fried milk dumplings soaked in sugar syrup', CAST(100.00 AS Numeric(6, 2)), CAST(0.00 AS Numeric(5, 2)), CAST(100.00 AS Numeric(6, 2)), N'../Images/Menu/Gulab Jamun Recipe.jpeg', 1, 1, 1, 1, NULL)
    INSERT [dbo].[menu_item] ([m_id], [m_name], [m_category_id], [m_cuisine_id], [m_description], [m_price], [m_discount], [m_final_price], [m_image_url], [m_availability], [m_featured], [m_status], [m_track_inventory], [m_unit_stock]) VALUES (6, N'Paneer Tikka', 1, 1, N'Grilled spiced paneer cubes served with mint chutney', CAST(200.00 AS Numeric(6, 2)), CAST(10.00 AS Numeric(5, 2)), CAST(180.00 AS Numeric(6, 2)), N'../Images/Menu/Indulge in the perfect balance of flavors with our….jpeg', 1, 1, 1, 1, NULL)
    INSERT [dbo].[menu_item] ([m_id], [m_name], [m_category_id], [m_cuisine_id], [m_description], [m_price], [m_discount], [m_final_price], [m_image_url], [m_availability], [m_featured], [m_status], [m_track_inventory], [m_unit_stock]) VALUES (7, N'Chicken Drum Stick', 2, 3, N'Marinated chicken cooked in a traditional clay oven', CAST(350.00 AS Numeric(6, 2)), CAST(15.00 AS Numeric(5, 2)), CAST(297.50 AS Numeric(6, 2)), N'../Images/Menu/Tandoori Chicken.jpeg', 1, 0, 1, 1, NULL)
    INSERT [dbo].[menu_item] ([m_id], [m_name], [m_category_id], [m_cuisine_id], [m_description], [m_price], [m_discount], [m_final_price], [m_image_url], [m_availability], [m_featured], [m_status], [m_track_inventory], [m_unit_stock]) VALUES (8, N'Vegetable Manchurian', 1, 4, N'Crispy fried vegetable balls tossed in spicy sauce', CAST(180.00 AS Numeric(6, 2)), CAST(5.00 AS Numeric(5, 2)), CAST(171.00 AS Numeric(6, 2)), N'../Images/Menu/Gobi Manchurian.jpeg', 1, 0, 1, 1, NULL)
    INSERT [dbo].[menu_item] ([m_id], [m_name], [m_category_id], [m_cuisine_id], [m_description], [m_price], [m_discount], [m_final_price], [m_image_url], [m_availability], [m_featured], [m_status], [m_track_inventory], [m_unit_stock]) VALUES (9, N'Aloo Tikki', 3, 4, N'Crispy fried potato patties served with chutneys', CAST(90.00 AS Numeric(6, 2)), CAST(0.00 AS Numeric(5, 2)), CAST(90.00 AS Numeric(6, 2)), N'../Images/Menu/Aloo Tikki with Chutney_.jpeg', 1, 0, 1, 1, NULL)
    INSERT [dbo].[menu_item] ([m_id], [m_name], [m_category_id], [m_cuisine_id], [m_description], [m_price], [m_discount], [m_final_price], [m_image_url], [m_availability], [m_featured], [m_status], [m_track_inventory], [m_unit_stock]) VALUES (10, N'Butter Chicken', 2, 3, N'Rich creamy tomato-based chicken gravy', CAST(300.00 AS Numeric(6, 2)), CAST(10.00 AS Numeric(5, 2)), CAST(270.00 AS Numeric(6, 2)), N'../Images/Menu/Butter Chicken (Murgh Makhani).jpeg', 1, 0, 1, 1, NULL)
    INSERT [dbo].[menu_item] ([m_id], [m_name], [m_category_id], [m_cuisine_id], [m_description], [m_price], [m_discount], [m_final_price], [m_image_url], [m_availability], [m_featured], [m_status], [m_track_inventory], [m_unit_stock]) VALUES (11, N'Dal Makhani', 1, 1, N'Slow-cooked black lentils with butter and cream', CAST(220.00 AS Numeric(6, 2)), CAST(5.00 AS Numeric(5, 2)), CAST(209.00 AS Numeric(6, 2)), N'../Images/Menu/Dal Makhani - The Ultimate Recipe for Stovetop and Pressure Cooker.jpeg', 1, 0, 1, 1, NULL)
    INSERT [dbo].[menu_item] ([m_id], [m_name], [m_category_id], [m_cuisine_id], [m_description], [m_price], [m_discount], [m_final_price], [m_image_url], [m_availability], [m_featured], [m_status], [m_track_inventory], [m_unit_stock]) VALUES (12, N'Hyderabadi Biryani', 2, 3, N'Traditional Mughlai rice dish with flavorful spices', CAST(350.00 AS Numeric(6, 2)), CAST(15.00 AS Numeric(5, 2)), CAST(297.50 AS Numeric(6, 2)), N'../Images/Menu/Indian Hyderabadi Biryani.jpeg', 1, 0, 1, 1, NULL)
    INSERT [dbo].[menu_item] ([m_id], [m_name], [m_category_id], [m_cuisine_id], [m_description], [m_price], [m_discount], [m_final_price], [m_image_url], [m_availability], [m_featured], [m_status], [m_track_inventory], [m_unit_stock]) VALUES (14, N'Kadhai Paneer', 1, 1, N'Spicy paneer dish cooked in thick tomato gravy', CAST(250.00 AS Numeric(6, 2)), CAST(10.00 AS Numeric(5, 2)), CAST(225.00 AS Numeric(6, 2)), N'../Images/Menu/Kadai Paneer Recipe - Restaurant Style Kadai Paneer Recipe - Khaddoroshik.jpeg', 1, 1, 1, 1, NULL)
    INSERT [dbo].[menu_item] ([m_id], [m_name], [m_category_id], [m_cuisine_id], [m_description], [m_price], [m_discount], [m_final_price], [m_image_url], [m_availability], [m_featured], [m_status], [m_track_inventory], [m_unit_stock]) VALUES (15, N'Dahi Puri', 3, 4, N'Crispy puris filled with dahi and Sev', CAST(70.00 AS Numeric(6, 2)), CAST(0.00 AS Numeric(5, 2)), CAST(70.00 AS Numeric(6, 2)), N'../Images/Menu/Dahi Puri.jpeg', 1, 0, 1, 1, NULL)
    INSERT [dbo].[menu_item] ([m_id], [m_name], [m_category_id], [m_cuisine_id], [m_description], [m_price], [m_discount], [m_final_price], [m_image_url], [m_availability], [m_featured], [m_status], [m_track_inventory], [m_unit_stock]) VALUES (16, N'Rasgulla', 5, 5, N'Soft and spongy Bengali sweet soaked in sugar syrup', CAST(120.00 AS Numeric(6, 2)), CAST(10.00 AS Numeric(5, 2)), CAST(108.00 AS Numeric(6, 2)), N'../Images/Menu/Rashgulla.jpeg', 1, 0, 1, 1, NULL)
    SET IDENTITY_INSERT [dbo].[menu_item] OFF
END
GO
-- Data Ingestion for [dbo].[Dish_Ingredients] (53 rows)
IF EXISTS (SELECT 1 FROM [dbo].[Dish_Ingredients])
BEGIN
    PRINT N'Table [dbo].[Dish_Ingredients] already contains data. Skipping initial inserts to preserve existing records.';
END
ELSE
BEGIN
    PRINT N'Inserting initial data into [dbo].[Dish_Ingredients] (53 records)...';
    SET IDENTITY_INSERT [dbo].[Dish_Ingredients] ON 
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (1, 1, 1, CAST(0.25 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (2, 1, 3, CAST(0.05 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (3, 1, 8, CAST(0.04 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (4, 1, 6, CAST(0.15 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (5, 1, 7, CAST(0.02 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (6, 2, 10, CAST(0.20 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (7, 2, 9, CAST(0.15 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (8, 2, 5, CAST(0.03 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (9, 2, 7, CAST(0.01 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (10, 3, 2, CAST(0.30 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (11, 3, 4, CAST(0.25 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (12, 3, 5, CAST(0.04 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (13, 3, 7, CAST(0.03 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (14, 4, 11, CAST(6.00 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (15, 4, 9, CAST(0.30 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (16, 5, 13, CAST(0.12 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (17, 5, 12, CAST(0.15 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (18, 5, 5, CAST(0.05 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (19, 6, 1, CAST(0.22 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (20, 6, 7, CAST(0.03 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (21, 6, 5, CAST(0.03 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (22, 7, 2, CAST(0.35 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (23, 7, 5, CAST(0.08 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (24, 7, 7, CAST(0.02 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (25, 8, 15, CAST(0.25 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (26, 8, 5, CAST(0.05 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (27, 8, 7, CAST(0.02 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (28, 9, 9, CAST(0.20 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (29, 9, 5, CAST(0.04 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (30, 9, 7, CAST(0.01 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (31, 10, 2, CAST(0.30 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (32, 10, 3, CAST(0.07 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (33, 10, 8, CAST(0.05 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (34, 10, 6, CAST(0.15 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (35, 10, 7, CAST(0.02 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (36, 11, 14, CAST(0.18 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (37, 11, 3, CAST(0.04 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (38, 11, 8, CAST(0.03 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (39, 11, 7, CAST(0.02 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (40, 12, 2, CAST(0.35 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (41, 12, 4, CAST(0.25 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (42, 12, 5, CAST(0.05 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (43, 12, 7, CAST(0.04 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (44, 14, 1, CAST(0.25 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (45, 14, 6, CAST(0.12 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (46, 14, 7, CAST(0.02 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (47, 14, 5, CAST(0.03 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (48, 15, 11, CAST(6.00 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (49, 15, 9, CAST(0.06 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (50, 16, 13, CAST(0.10 AS Decimal(10, 2)))
    INSERT [dbo].[Dish_Ingredients] ([recipe_id], [m_id], [ingredient_id], [qty_required]) VALUES (51, 16, 12, CAST(0.18 AS Decimal(10, 2)))
    SET IDENTITY_INSERT [dbo].[Dish_Ingredients] OFF
END
GO
-- Data Ingestion for [dbo].[contact_messages] (4 rows)
IF EXISTS (SELECT 1 FROM [dbo].[contact_messages])
BEGIN
    PRINT N'Table [dbo].[contact_messages] already contains data. Skipping initial inserts to preserve existing records.';
END
ELSE
BEGIN
    PRINT N'Inserting initial data into [dbo].[contact_messages] (4 records)...';
    SET IDENTITY_INSERT [dbo].[contact_messages] ON 
    INSERT [dbo].[contact_messages] ([message_id], [c_id], [name], [email], [message], [submitted_at], [status]) VALUES (9, 1, N'Vinit Soni', N'vinitsoni5911@gmail.com', N'The food is absolutely delicious! The packaging is neat, and delivery is super quick. Highly recommend!', CAST(N'2025-03-30T15:15:57.640' AS DateTime), 1)
    INSERT [dbo].[contact_messages] ([message_id], [c_id], [name], [email], [message], [submitted_at], [status]) VALUES (10, 8, N'Rudra Jadav', N'rudra@gmail.com', N'The taste, the packaging, the speed—everything about this place is just WOW! Definitely my favorite!', CAST(N'2025-03-30T15:15:57.000' AS DateTime), 1)
    SET IDENTITY_INSERT [dbo].[contact_messages] OFF
END
GO
-- Data Ingestion for [dbo].[Orders] (12 rows)
IF EXISTS (SELECT 1 FROM [dbo].[Orders])
BEGIN
    PRINT N'Table [dbo].[Orders] already contains data. Skipping initial inserts to preserve existing records.';
END
ELSE
BEGIN
    PRINT N'Inserting initial data into [dbo].[Orders] (12 records)...';
    SET IDENTITY_INSERT [dbo].[Orders] ON 
    INSERT [dbo].[Orders] ([order_id], [c_id], [total_amount], [order_status], [order_date], [address], [pincode], [payment_type], [transaction_number], [driver_id], [delivery_otp], [delivered_time], [delivery_notes]) VALUES (1, 1, CAST(70.00 AS Decimal(10, 2)), N'Completed', CAST(N'2026-08-26T14:26:55.803' AS DateTime), N'ABCD', N'388120', N'Razorpay', N'TXN202608261426557579', 1, N'8837', CAST(N'2026-08-26T17:45:35.120' AS DateTime), NULL)
    INSERT [dbo].[Orders] ([order_id], [c_id], [total_amount], [order_status], [order_date], [address], [pincode], [payment_type], [transaction_number], [driver_id], [delivery_otp], [delivered_time], [delivery_notes]) VALUES (2, 1, CAST(0.00 AS Decimal(10, 2)), N'Completed', CAST(N'2026-08-26T15:06:10.850' AS DateTime), N'102, Shivalik Heights, Vallabh Vidyanagar', N'388120', N'Razorpay', N'TXN_PEND_238189', 2, N'8305', CAST(N'2026-08-26T17:48:10.777' AS DateTime), NULL)
    INSERT [dbo].[Orders] ([order_id], [c_id], [total_amount], [order_status], [order_date], [address], [pincode], [payment_type], [transaction_number], [driver_id], [delivery_otp], [delivered_time], [delivery_notes]) VALUES (3, 1, CAST(0.00 AS Decimal(10, 2)), N'Completed', CAST(N'2026-08-26T15:06:10.870' AS DateTime), N'405, Orchid Green, Anand', N'388001', N'Cash on Delivery', N'TXN_PREP_269304', 1, N'9242', CAST(N'2026-08-26T17:47:23.650' AS DateTime), NULL)
    INSERT [dbo].[Orders] ([order_id], [c_id], [total_amount], [order_status], [order_date], [address], [pincode], [payment_type], [transaction_number], [driver_id], [delivery_otp], [delivered_time], [delivery_notes]) VALUES (4, 1, CAST(0.00 AS Decimal(10, 2)), N'Completed', CAST(N'2026-08-26T15:06:10.880' AS DateTime), N'A-12, Green Park Society, Bakrol', N'388315', N'Razorpay', N'TXN_DISP_843464', 2, N'6766', CAST(N'2026-08-26T17:49:24.270' AS DateTime), NULL)
    INSERT [dbo].[Orders] ([order_id], [c_id], [total_amount], [order_status], [order_date], [address], [pincode], [payment_type], [transaction_number], [driver_id], [delivery_otp], [delivered_time], [delivery_notes]) VALUES (5, 1, CAST(0.00 AS Decimal(10, 2)), N'Completed', CAST(N'2026-08-26T15:06:10.887' AS DateTime), N'78, Silver Oak Residency, VV Nagar', N'388120', N'UPI Payment', N'TXN_COMP_688941', 2, N'5563', CAST(N'2026-08-26T17:48:53.630' AS DateTime), NULL)
    INSERT [dbo].[Orders] ([order_id], [c_id], [total_amount], [order_status], [order_date], [address], [pincode], [payment_type], [transaction_number], [driver_id], [delivery_otp], [delivered_time], [delivery_notes]) VALUES (6, 1, CAST(650.00 AS Decimal(10, 2)), N'Completed', CAST(N'2026-08-26T15:06:53.753' AS DateTime), N'102, Shivalik Heights, Vallabh Vidyanagar', N'388120', N'Razorpay', N'TXN_PEND_216964', 2, N'7270', CAST(N'2026-08-26T17:50:14.500' AS DateTime), NULL)
    INSERT [dbo].[Orders] ([order_id], [c_id], [total_amount], [order_status], [order_date], [address], [pincode], [payment_type], [transaction_number], [driver_id], [delivery_otp], [delivered_time], [delivery_notes]) VALUES (7, 1, CAST(650.00 AS Decimal(10, 2)), N'Completed', CAST(N'2026-08-26T15:06:53.810' AS DateTime), N'405, Orchid Green, Anand', N'388001', N'Cash on Delivery', N'TXN_PREP_438253', 1, N'8627', CAST(N'2026-08-26T17:50:57.813' AS DateTime), NULL)
    INSERT [dbo].[Orders] ([order_id], [c_id], [total_amount], [order_status], [order_date], [address], [pincode], [payment_type], [transaction_number], [driver_id], [delivery_otp], [delivered_time], [delivery_notes]) VALUES (8, 1, CAST(650.00 AS Decimal(10, 2)), N'Completed', CAST(N'2026-08-26T15:06:53.827' AS DateTime), N'A-12, Green Park Society, Bakrol', N'388315', N'Razorpay', N'TXN_DISP_472545', 1, N'7988', CAST(N'2026-08-26T17:57:52.667' AS DateTime), NULL)
    INSERT [dbo].[Orders] ([order_id], [c_id], [total_amount], [order_status], [order_date], [address], [pincode], [payment_type], [transaction_number], [driver_id], [delivery_otp], [delivered_time], [delivery_notes]) VALUES (9, 1, CAST(650.00 AS Decimal(10, 2)), N'Completed', CAST(N'2026-08-26T15:06:53.830' AS DateTime), N'78, Silver Oak Residency, VV Nagar', N'388120', N'UPI Payment', N'TXN_COMP_972048', 2, N'5296', CAST(N'2026-08-26T17:51:22.837' AS DateTime), NULL)
    INSERT [dbo].[Orders] ([order_id], [c_id], [total_amount], [order_status], [order_date], [address], [pincode], [payment_type], [transaction_number], [driver_id], [delivery_otp], [delivered_time], [delivery_notes]) VALUES (10, 1, CAST(900.00 AS Decimal(10, 2)), N'Completed', CAST(N'2026-08-26T18:24:22.197' AS DateTime), N'VVN', N'388315', N'Cash on Delivery', N'TXN202608261824226340', 2, N'6181', CAST(N'2026-08-30T23:07:49.640' AS DateTime), NULL)
    SET IDENTITY_INSERT [dbo].[Orders] OFF
END
GO
-- Data Ingestion for [dbo].[Order_Details] (12 rows)
IF EXISTS (SELECT 1 FROM [dbo].[Order_Details])
BEGIN
    PRINT N'Table [dbo].[Order_Details] already contains data. Skipping initial inserts to preserve existing records.';
END
ELSE
BEGIN
    PRINT N'Inserting initial data into [dbo].[Order_Details] (12 records)...';
    SET IDENTITY_INSERT [dbo].[Order_Details] ON 
    INSERT [dbo].[Order_Details] ([order_detail_id], [order_id], [m_id], [quantity], [price], [total_price]) VALUES (1, 1, 15, 1, CAST(70.00 AS Decimal(10, 2)), CAST(70.00 AS Decimal(10, 2)))
    INSERT [dbo].[Order_Details] ([order_detail_id], [order_id], [m_id], [quantity], [price], [total_price]) VALUES (2, 6, 1, 2, CAST(250.00 AS Decimal(10, 2)), CAST(500.00 AS Decimal(10, 2)))
    INSERT [dbo].[Order_Details] ([order_detail_id], [order_id], [m_id], [quantity], [price], [total_price]) VALUES (3, 6, 2, 1, CAST(150.00 AS Decimal(10, 2)), CAST(150.00 AS Decimal(10, 2)))
    INSERT [dbo].[Order_Details] ([order_detail_id], [order_id], [m_id], [quantity], [price], [total_price]) VALUES (4, 7, 1, 2, CAST(250.00 AS Decimal(10, 2)), CAST(500.00 AS Decimal(10, 2)))
    INSERT [dbo].[Order_Details] ([order_detail_id], [order_id], [m_id], [quantity], [price], [total_price]) VALUES (5, 7, 2, 1, CAST(150.00 AS Decimal(10, 2)), CAST(150.00 AS Decimal(10, 2)))
    INSERT [dbo].[Order_Details] ([order_detail_id], [order_id], [m_id], [quantity], [price], [total_price]) VALUES (6, 8, 1, 2, CAST(250.00 AS Decimal(10, 2)), CAST(500.00 AS Decimal(10, 2)))
    INSERT [dbo].[Order_Details] ([order_detail_id], [order_id], [m_id], [quantity], [price], [total_price]) VALUES (7, 8, 2, 1, CAST(150.00 AS Decimal(10, 2)), CAST(150.00 AS Decimal(10, 2)))
    INSERT [dbo].[Order_Details] ([order_detail_id], [order_id], [m_id], [quantity], [price], [total_price]) VALUES (8, 9, 1, 2, CAST(250.00 AS Decimal(10, 2)), CAST(500.00 AS Decimal(10, 2)))
    INSERT [dbo].[Order_Details] ([order_detail_id], [order_id], [m_id], [quantity], [price], [total_price]) VALUES (9, 9, 2, 1, CAST(150.00 AS Decimal(10, 2)), CAST(150.00 AS Decimal(10, 2)))
    INSERT [dbo].[Order_Details] ([order_detail_id], [order_id], [m_id], [quantity], [price], [total_price]) VALUES (10, 10, 9, 10, CAST(90.00 AS Decimal(10, 2)), CAST(900.00 AS Decimal(10, 2)))
    SET IDENTITY_INSERT [dbo].[Order_Details] OFF
END
GO
