-- ===================================================================================
-- SOMEE.COM & LOCALDB DATABASE VERIFICATION QUERY
-- Copy and paste this query into Somee.com MS SQL Query Console to verify table counts
-- ===================================================================================

SELECT 'Area_Pincode' AS [Table Name], COUNT(*) AS [Total Records] FROM [dbo].[Area_Pincode]
UNION ALL
SELECT 'contact_messages', COUNT(*) FROM [dbo].[contact_messages]
UNION ALL
SELECT 'cuisine_type', COUNT(*) FROM [dbo].[cuisine_type]
UNION ALL
SELECT 'Customers', COUNT(*) FROM [dbo].[Customers]
UNION ALL
SELECT 'Dish_Ingredients', COUNT(*) FROM [dbo].[Dish_Ingredients]
UNION ALL
SELECT 'Drivers', COUNT(*) FROM [dbo].[Drivers]
UNION ALL
SELECT 'Ingredients', COUNT(*) FROM [dbo].[Ingredients]
UNION ALL
SELECT 'menu_category', COUNT(*) FROM [dbo].[menu_category]
UNION ALL
SELECT 'menu_item', COUNT(*) FROM [dbo].[menu_item]
UNION ALL
SELECT 'Order_Details', COUNT(*) FROM [dbo].[Order_Details]
UNION ALL
SELECT 'Orders', COUNT(*) FROM [dbo].[Orders];
