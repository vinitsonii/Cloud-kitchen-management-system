-- ===================================================================================
-- SOMEE.COM 1-CLICK CLEAN DATABASE RESET & RECREATION SCRIPT
-- Target Host: Somee.com MS SQL Console
-- Database: MyKitchen
-- Generated: 2026-08-31 23:35:30
-- Description: 100% Compatible with Somee.com MS SQL Web Query Console.
--              Drops all tables, recreates schema cleanly, and ingests all 146 data records.
-- ===================================================================================

SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

-- STEP 1: DROP ALL EXISTING FOREIGN KEYS & TABLES
IF OBJECT_ID(N'[dbo].[FK_OrderDetails_Orders]', N'F') IS NOT NULL ALTER TABLE [dbo].[Order_Details] DROP CONSTRAINT [FK_OrderDetails_Orders];
IF OBJECT_ID(N'[dbo].[FK_OrderDetails_MenuItem]', N'F') IS NOT NULL ALTER TABLE [dbo].[Order_Details] DROP CONSTRAINT [FK_OrderDetails_MenuItem];
IF OBJECT_ID(N'[dbo].[FK_Orders_Customers]', N'F') IS NOT NULL ALTER TABLE [dbo].[Orders] DROP CONSTRAINT [FK_Orders_Customers];
IF OBJECT_ID(N'[dbo].[FK_Orders_Drivers]', N'F') IS NOT NULL ALTER TABLE [dbo].[Orders] DROP CONSTRAINT [FK_Orders_Drivers];
IF OBJECT_ID(N'[dbo].[FK_Dish_Ingredients_menu_item]', N'F') IS NOT NULL ALTER TABLE [dbo].[Dish_Ingredients] DROP CONSTRAINT [FK_Dish_Ingredients_menu_item];
IF OBJECT_ID(N'[dbo].[FK_Dish_Ingredients_Ingredients]', N'F') IS NOT NULL ALTER TABLE [dbo].[Dish_Ingredients] DROP CONSTRAINT [FK_Dish_Ingredients_Ingredients];
IF OBJECT_ID(N'[dbo].[FK_menu_item_cuisine_type]', N'F') IS NOT NULL ALTER TABLE [dbo].[menu_item] DROP CONSTRAINT [FK_menu_item_cuisine_type];
IF OBJECT_ID(N'[dbo].[FK_menu_item_menu_category]', N'F') IS NOT NULL ALTER TABLE [dbo].[menu_item] DROP CONSTRAINT [FK_menu_item_menu_category];
IF OBJECT_ID(N'[dbo].[FK_contact_messages_Customers]', N'F') IS NOT NULL ALTER TABLE [dbo].[contact_messages] DROP CONSTRAINT [FK_contact_messages_Customers];
GO

IF OBJECT_ID(N'[dbo].[Order_Details]', N'U') IS NOT NULL DROP TABLE [dbo].[Order_Details];
IF OBJECT_ID(N'[dbo].[Orders]', N'U') IS NOT NULL DROP TABLE [dbo].[Orders];
IF OBJECT_ID(N'[dbo].[Dish_Ingredients]', N'U') IS NOT NULL DROP TABLE [dbo].[Dish_Ingredients];
IF OBJECT_ID(N'[dbo].[menu_item]', N'U') IS NOT NULL DROP TABLE [dbo].[menu_item];
IF OBJECT_ID(N'[dbo].[contact_messages]', N'U') IS NOT NULL DROP TABLE [dbo].[contact_messages];
IF OBJECT_ID(N'[dbo].[Ingredients]', N'U') IS NOT NULL DROP TABLE [dbo].[Ingredients];
IF OBJECT_ID(N'[dbo].[menu_category]', N'U') IS NOT NULL DROP TABLE [dbo].[menu_category];
IF OBJECT_ID(N'[dbo].[cuisine_type]', N'U') IS NOT NULL DROP TABLE [dbo].[cuisine_type];
IF OBJECT_ID(N'[dbo].[Drivers]', N'U') IS NOT NULL DROP TABLE [dbo].[Drivers];
IF OBJECT_ID(N'[dbo].[Customers]', N'U') IS NOT NULL DROP TABLE [dbo].[Customers];
IF OBJECT_ID(N'[dbo].[Area_Pincode]', N'U') IS NOT NULL DROP TABLE [dbo].[Area_Pincode];
GO
GO

IF OBJECT_ID(N'[dbo].[FK_OrderDetails_Orders]', N'F') IS NOT NULL ALTER TABLE [dbo].[Order_Details] DROP CONSTRAINT [FK_OrderDetails_Orders];
IF OBJECT_ID(N'[dbo].[FK_OrderDetails_MenuItem]', N'F') IS NOT NULL ALTER TABLE [dbo].[Order_Details] DROP CONSTRAINT [FK_OrderDetails_MenuItem];
IF OBJECT_ID(N'[dbo].[FK_Orders_Customers]', N'F') IS NOT NULL ALTER TABLE [dbo].[Orders] DROP CONSTRAINT [FK_Orders_Customers];
IF OBJECT_ID(N'[dbo].[FK_Orders_Drivers]', N'F') IS NOT NULL ALTER TABLE [dbo].[Orders] DROP CONSTRAINT [FK_Orders_Drivers];
IF OBJECT_ID(N'[dbo].[FK_Dish_Ingredients_menu_item]', N'F') IS NOT NULL ALTER TABLE [dbo].[Dish_Ingredients] DROP CONSTRAINT [FK_Dish_Ingredients_menu_item];
IF OBJECT_ID(N'[dbo].[FK_Dish_Ingredients_Ingredients]', N'F') IS NOT NULL ALTER TABLE [dbo].[Dish_Ingredients] DROP CONSTRAINT [FK_Dish_Ingredients_Ingredients];
IF OBJECT_ID(N'[dbo].[FK_menu_item_cuisine_type]', N'F') IS NOT NULL ALTER TABLE [dbo].[menu_item] DROP CONSTRAINT [FK_menu_item_cuisine_type];
IF OBJECT_ID(N'[dbo].[FK_menu_item_menu_category]', N'F') IS NOT NULL ALTER TABLE [dbo].[menu_item] DROP CONSTRAINT [FK_menu_item_menu_category];
IF OBJECT_ID(N'[dbo].[FK_contact_messages_Customers]', N'F') IS NOT NULL ALTER TABLE [dbo].[contact_messages] DROP CONSTRAINT [FK_contact_messages_Customers];
GO

IF OBJECT_ID(N'[dbo].[Order_Details]', N'U') IS NOT NULL DROP TABLE [dbo].[Order_Details];
IF OBJECT_ID(N'[dbo].[Orders]', N'U') IS NOT NULL DROP TABLE [dbo].[Orders];
IF OBJECT_ID(N'[dbo].[Dish_Ingredients]', N'U') IS NOT NULL DROP TABLE [dbo].[Dish_Ingredients];
IF OBJECT_ID(N'[dbo].[menu_item]', N'U') IS NOT NULL DROP TABLE [dbo].[menu_item];
IF OBJECT_ID(N'[dbo].[contact_messages]', N'U') IS NOT NULL DROP TABLE [dbo].[contact_messages];
IF OBJECT_ID(N'[dbo].[Ingredients]', N'U') IS NOT NULL DROP TABLE [dbo].[Ingredients];
IF OBJECT_ID(N'[dbo].[menu_category]', N'U') IS NOT NULL DROP TABLE [dbo].[menu_category];
IF OBJECT_ID(N'[dbo].[cuisine_type]', N'U') IS NOT NULL DROP TABLE [dbo].[cuisine_type];
IF OBJECT_ID(N'[dbo].[Drivers]', N'U') IS NOT NULL DROP TABLE [dbo].[Drivers];
IF OBJECT_ID(N'[dbo].[Customers]', N'U') IS NOT NULL DROP TABLE [dbo].[Customers];
IF OBJECT_ID(N'[dbo].[Area_Pincode]', N'U') IS NOT NULL DROP TABLE [dbo].[Area_Pincode];
GO

PRINT N'Step 1 Completed: All existing tables and constraints dropped.';
GO
-- STEP 2: CREATE TABLES, DATA INGESTION, AND FOREIGN KEYS
-- ===================================================================================
GO

GO
GO

GO
GO
GO
GO
GO
GO
GO
GO
GO
GO
GO
GO
GO
GO
GO
GO
GO
GO
GO
GO
GO
GO
GO
GO
GO
GO
GO
GO
GO
GO
GO
GO
GO
/****** Object:  Table [dbo].[Area_Pincode]    Script Date: 31-08-2026 14:39:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Area_Pincode](
	[Area_Id] [int] IDENTITY(1,1) NOT NULL,
	[Area_Name] [nvarchar](255) NOT NULL,
	[Pincode] [nvarchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Area_Id] ASC
)
)
GO
/****** Object:  Table [dbo].[contact_messages]    Script Date: 31-08-2026 14:39:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[contact_messages](
	[message_id] [int] IDENTITY(1,1) NOT NULL,
	[c_id] [int] NULL,
	[name] [nvarchar](50) NOT NULL,
	[email] [nvarchar](50) NOT NULL,
	[message] [nvarchar](500) NOT NULL,
	[submitted_at] [datetime] NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[message_id] ASC
)
)
GO
/****** Object:  Table [dbo].[cuisine_type]    Script Date: 31-08-2026 14:39:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cuisine_type](
	[cuisine_id] [int] IDENTITY(1,1) NOT NULL,
	[cuisine_name] [nvarchar](50) NOT NULL,
	[cuisine_status] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[cuisine_id] ASC
)
)
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 31-08-2026 14:39:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[c_id] [int] IDENTITY(1,1) NOT NULL,
	[c_name] [nvarchar](50) NOT NULL,
	[email] [nvarchar](40) NOT NULL,
	[phone] [nvarchar](13) NOT NULL,
	[password] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
(
	[c_id] ASC
)
)
GO
/****** Object:  Table [dbo].[Dish_Ingredients]    Script Date: 31-08-2026 14:39:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dish_Ingredients](
	[recipe_id] [int] IDENTITY(1,1) NOT NULL,
	[m_id] [int] NOT NULL,
	[ingredient_id] [int] NOT NULL,
	[qty_required] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[recipe_id] ASC
)
)
GO
/****** Object:  Table [dbo].[Drivers]    Script Date: 31-08-2026 14:39:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Drivers](
	[driver_id] [int] IDENTITY(1,1) NOT NULL,
	[driver_name] [nvarchar](100) NOT NULL,
	[phone] [nvarchar](15) NOT NULL,
	[password] [nvarchar](50) NOT NULL,
	[vehicle_no] [nvarchar](20) NOT NULL,
	[status] [nvarchar](20) NOT NULL,
	[created_date] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[driver_id] ASC
)
)
GO
/****** Object:  Table [dbo].[Ingredients]    Script Date: 31-08-2026 14:39:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ingredients](
	[ingredient_id] [int] IDENTITY(1,1) NOT NULL,
	[ingredient_name] [varchar](100) NOT NULL,
	[stock_quantity] [decimal](10, 2) NOT NULL,
	[unit] [varchar](20) NOT NULL,
	[cost_per_unit] [decimal](10, 2) NULL,
	[low_stock_threshold] [decimal](10, 2) NULL,
	[last_updated] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ingredient_id] ASC
)
)
GO
/****** Object:  Table [dbo].[menu_category]    Script Date: 31-08-2026 14:39:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[menu_category](
	[category_id] [int] IDENTITY(1,1) NOT NULL,
	[category_name] [varchar](50) NOT NULL,
	[category_status] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[category_id] ASC
)
)
GO
/****** Object:  Table [dbo].[menu_item]    Script Date: 31-08-2026 14:39:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[menu_item](
	[m_id] [int] IDENTITY(1,1) NOT NULL,
	[m_name] [nvarchar](100) NOT NULL,
	[m_category_id] [int] NOT NULL,
	[m_cuisine_id] [int] NOT NULL,
	[m_description] [nvarchar](255) NULL,
	[m_price] [numeric](6, 2) NOT NULL,
	[m_discount] [numeric](5, 2) NULL,
	[m_final_price] [numeric](6, 2) NULL,
	[m_image_url] [nvarchar](255) NULL,
	[m_availability] [bit] NOT NULL,
	[m_featured] [bit] NOT NULL,
	[m_status] [bit] NOT NULL,
	[m_track_inventory] [bit] NULL,
	[m_unit_stock] [int] NULL,
 CONSTRAINT [PK_menu_item] PRIMARY KEY CLUSTERED 
(
	[m_id] ASC
)
)
GO
/****** Object:  Table [dbo].[Order_Details]    Script Date: 31-08-2026 14:39:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order_Details](
	[order_detail_id] [int] IDENTITY(1,1) NOT NULL,
	[order_id] [int] NOT NULL,
	[m_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[price] [decimal](10, 2) NOT NULL,
	[total_price] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[order_detail_id] ASC
)
)
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 31-08-2026 14:39:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[order_id] [int] IDENTITY(1,1) NOT NULL,
	[c_id] [int] NOT NULL,
	[total_amount] [decimal](10, 2) NOT NULL,
	[order_status] [nvarchar](50) NULL,
	[order_date] [datetime] NULL,
	[address] [nvarchar](255) NOT NULL,
	[pincode] [nvarchar](10) NOT NULL,
	[payment_type] [nvarchar](50) NOT NULL,
	[transaction_number] [nvarchar](50) NULL,
	[driver_id] [int] NULL,
	[delivery_otp] [varchar](6) NULL,
	[delivered_time] [datetime] NULL,
	[delivery_notes] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[order_id] ASC
)
)
GO
SET IDENTITY_INSERT [dbo].[Area_Pincode] ON 

INSERT [dbo].[Area_Pincode] ([Area_Id], [Area_Name], [Pincode]) VALUES (1, N'Vallabh Vidhyanagar', N'388120')
INSERT [dbo].[Area_Pincode] ([Area_Id], [Area_Name], [Pincode]) VALUES (2, N'Anand', N'388121')
INSERT [dbo].[Area_Pincode] ([Area_Id], [Area_Name], [Pincode]) VALUES (4, N'Borsad', N'388540')
INSERT [dbo].[Area_Pincode] ([Area_Id], [Area_Name], [Pincode]) VALUES (5, N'Bakrol', N'388315')
INSERT [dbo].[Area_Pincode] ([Area_Id], [Area_Name], [Pincode]) VALUES (6, N'Memdabad', N'383678')
SET IDENTITY_INSERT [dbo].[Area_Pincode] OFF
GO
SET IDENTITY_INSERT [dbo].[contact_messages] ON 

INSERT [dbo].[contact_messages] ([message_id], [c_id], [name], [email], [message], [submitted_at], [status]) VALUES (9, 1, N'Vinit Soni', N'vinitsoni5911@gmail.com', N'The food is absolutely delicious! The packaging is neat, and delivery is super quick. Highly recommend!', CAST(N'2025-03-30T15:15:57.640' AS DateTime), 1)
INSERT [dbo].[contact_messages] ([message_id], [c_id], [name], [email], [message], [submitted_at], [status]) VALUES (10, 8, N'Rudra Jadav', N'rudra@gmail.com', N'The taste, the packaging, the speed—everything about this place is just WOW! Definitely my favorite!', CAST(N'2025-03-30T15:15:57.000' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[contact_messages] OFF
GO
SET IDENTITY_INSERT [dbo].[cuisine_type] ON 

INSERT [dbo].[cuisine_type] ([cuisine_id], [cuisine_name], [cuisine_status]) VALUES (1, N'North Indian', 1)
INSERT [dbo].[cuisine_type] ([cuisine_id], [cuisine_name], [cuisine_status]) VALUES (2, N'South Indian', 1)
INSERT [dbo].[cuisine_type] ([cuisine_id], [cuisine_name], [cuisine_status]) VALUES (3, N'Mughlai', 1)
INSERT [dbo].[cuisine_type] ([cuisine_id], [cuisine_name], [cuisine_status]) VALUES (4, N'Street Food', 1)
INSERT [dbo].[cuisine_type] ([cuisine_id], [cuisine_name], [cuisine_status]) VALUES (5, N'Desserts', 1)
SET IDENTITY_INSERT [dbo].[cuisine_type] OFF
GO
SET IDENTITY_INSERT [dbo].[Customers] ON 

INSERT [dbo].[Customers] ([c_id], [c_name], [email], [phone], [password]) VALUES (1, N'Vinit Soni', N'vinitsoni5911@gmail.com', N'+918160698196', N'THFIsGGcGUbcMQoHhQWfr62S/V28fI+ubfOER7syuP8=')
INSERT [dbo].[Customers] ([c_id], [c_name], [email], [phone], [password]) VALUES (2, N'Dhruvil Rana', N'idkranadhruvil2209@gmail.com', N'+917016532976', N'asMkz5EqdVsbeSpL24Myh/xAwfWyQNG7oFI/Ood8nbE=')
INSERT [dbo].[Customers] ([c_id], [c_name], [email], [phone], [password]) VALUES (8, N'Rudra Jadav', N'Rudra@gmail.com', N'+919878787217', N'0uwoS4FrYrOnjEZggZaXt5F+vO1VnIEvqGAqSa9R7Ng=')
SET IDENTITY_INSERT [dbo].[Customers] OFF
GO
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
GO
SET IDENTITY_INSERT [dbo].[Drivers] ON 

INSERT [dbo].[Drivers] ([driver_id], [driver_name], [phone], [password], [vehicle_no], [status], [created_date]) VALUES (1, N'Ramesh Kumar', N'9876543210', N'123456', N'GJ-23-AB-1234', N'Offline', CAST(N'2026-08-19T01:19:11.777' AS DateTime))
INSERT [dbo].[Drivers] ([driver_id], [driver_name], [phone], [password], [vehicle_no], [status], [created_date]) VALUES (2, N'Suresh Patel', N'9876543211', N'123456', N'GJ-23-CD-5679', N'Available', CAST(N'2026-08-19T01:19:11.777' AS DateTime))
INSERT [dbo].[Drivers] ([driver_id], [driver_name], [phone], [password], [vehicle_no], [status], [created_date]) VALUES (1002, N'Kalpesh Patel', N'9876543214', N'123456', N'GJ-23-CD-4321', N'Available', CAST(N'2026-08-30T23:11:32.383' AS DateTime))
SET IDENTITY_INSERT [dbo].[Drivers] OFF
GO
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
GO
SET IDENTITY_INSERT [dbo].[menu_category] ON 

INSERT [dbo].[menu_category] ([category_id], [category_name], [category_status]) VALUES (1, N'Vegetarian', 1)
INSERT [dbo].[menu_category] ([category_id], [category_name], [category_status]) VALUES (2, N'Non Vegetarian', 1)
INSERT [dbo].[menu_category] ([category_id], [category_name], [category_status]) VALUES (3, N'Snacks', 1)
INSERT [dbo].[menu_category] ([category_id], [category_name], [category_status]) VALUES (5, N'Sweets', 1)
INSERT [dbo].[menu_category] ([category_id], [category_name], [category_status]) VALUES (7, N'Starters', 1)
SET IDENTITY_INSERT [dbo].[menu_category] OFF
GO
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
GO
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
GO
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
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Area_Pin__54608449628FA481]    Script Date: 31-08-2026 14:39:09 ******/
ALTER TABLE [dbo].[Area_Pincode] ADD UNIQUE NONCLUSTERED 
(
	[Pincode] ASC
)
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Drivers__B43B145F11D3AE38]    Script Date: 31-08-2026 14:39:09 ******/
ALTER TABLE [dbo].[Drivers] ADD UNIQUE NONCLUSTERED 
(
	[phone] ASC
)
GO
ALTER TABLE [dbo].[contact_messages] ADD  DEFAULT (getdate()) FOR [submitted_at]
GO
ALTER TABLE [dbo].[contact_messages] ADD  CONSTRAINT [DF_contact_messages_status]  DEFAULT ((0)) FOR [status]
GO
ALTER TABLE [dbo].[cuisine_type] ADD  DEFAULT ((1)) FOR [cuisine_status]
GO
ALTER TABLE [dbo].[Drivers] ADD  DEFAULT ('Available') FOR [status]
GO
ALTER TABLE [dbo].[Drivers] ADD  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [dbo].[Ingredients] ADD  DEFAULT ((0.00)) FOR [stock_quantity]
GO
ALTER TABLE [dbo].[Ingredients] ADD  DEFAULT ((0.00)) FOR [cost_per_unit]
GO
ALTER TABLE [dbo].[Ingredients] ADD  DEFAULT ((2.00)) FOR [low_stock_threshold]
GO
ALTER TABLE [dbo].[Ingredients] ADD  DEFAULT (getdate()) FOR [last_updated]
GO
ALTER TABLE [dbo].[menu_category] ADD  DEFAULT ((1)) FOR [category_status]
GO
ALTER TABLE [dbo].[menu_item] ADD  CONSTRAINT [DF__menu_item__m_dis__182C9B23]  DEFAULT ((0.00)) FOR [m_discount]
GO
ALTER TABLE [dbo].[menu_item] ADD  CONSTRAINT [DF__menu_item__m_ava__1920BF5C]  DEFAULT ((1)) FOR [m_availability]
GO
ALTER TABLE [dbo].[menu_item] ADD  CONSTRAINT [DF__menu_item__m_fea__1A14E395]  DEFAULT ((0)) FOR [m_featured]
GO
ALTER TABLE [dbo].[menu_item] ADD  CONSTRAINT [DF__menu_item__m_sta__1CF15040]  DEFAULT ((1)) FOR [m_status]
GO
ALTER TABLE [dbo].[menu_item] ADD  DEFAULT ((1)) FOR [m_track_inventory]
GO
ALTER TABLE [dbo].[Orders] ADD  DEFAULT ('Pending') FOR [order_status]
GO
ALTER TABLE [dbo].[Orders] ADD  DEFAULT (getdate()) FOR [order_date]
GO
ALTER TABLE [dbo].[cuisine_type]  WITH CHECK ADD  CONSTRAINT [FK_cuisine_type_cuisine_type] FOREIGN KEY([cuisine_id])
REFERENCES [dbo].[cuisine_type] ([cuisine_id])
GO
ALTER TABLE [dbo].[cuisine_type] CHECK CONSTRAINT [FK_cuisine_type_cuisine_type]
GO
ALTER TABLE [dbo].[Dish_Ingredients]  WITH CHECK ADD FOREIGN KEY([ingredient_id])
REFERENCES [dbo].[Ingredients] ([ingredient_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Dish_Ingredients]  WITH CHECK ADD FOREIGN KEY([m_id])
REFERENCES [dbo].[menu_item] ([m_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[menu_item]  WITH CHECK ADD  CONSTRAINT [category_id_fk] FOREIGN KEY([m_category_id])
REFERENCES [dbo].[menu_category] ([category_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[menu_item] CHECK CONSTRAINT [category_id_fk]
GO
ALTER TABLE [dbo].[menu_item]  WITH CHECK ADD  CONSTRAINT [cuisine_id_fk] FOREIGN KEY([m_cuisine_id])
REFERENCES [dbo].[cuisine_type] ([cuisine_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[menu_item] CHECK CONSTRAINT [cuisine_id_fk]
GO
ALTER TABLE [dbo].[Order_Details]  WITH CHECK ADD  CONSTRAINT [FK__Order_Deta__m_id__5629CD9C] FOREIGN KEY([m_id])
REFERENCES [dbo].[menu_item] ([m_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Order_Details] CHECK CONSTRAINT [FK__Order_Deta__m_id__5629CD9C]
GO
ALTER TABLE [dbo].[Order_Details]  WITH CHECK ADD CHECK  (([quantity]>(0)))
GO
GO
GO
