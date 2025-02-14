-- Active: 1737058836822@@127.0.0.1@3306@ecommerce
-- 3 Triggers for 3 Different Tables

--Trigger 1: Log shipping updates when an order status changes to 'Shipped'
CREATE TRIGGER LogShipping
AFTER UPDATE ON ORDER_TABLE
FOR EACH ROW
BEGIN
    IF NEW.Status = 'Shipped' THEN
        INSERT INTO SHIPPING (TrackingID, Company, Delivery_Date, Preferred_Delivery_Time, PaymentID, CartID, OrderID, Return_Code)
        VALUES (3, 'Default Carrier', CURRENT_DATE, '12:00:00', NEW.PaymentID, NEW.CartID, NEW.OrderID, NULL);
    END IF;
END;

SELECT * FROM SHIPPING;
UPDATE ORDER_TABLE
SET Status = 'Shipped'
WHERE OrderID = 3;

SELECT * FROM SHIPPING
WHERE OrderID = 3;
SELECT * FROM ORDER_TABLE;


--Trigger 2: when a new campaign is added, its applied to the products in apply table
CREATE TRIGGER ApplyCampaignToAllInStockProducts
AFTER INSERT ON CAMPAIGN
FOR EACH ROW
BEGIN
    INSERT INTO APPLY (ProductID, Campaign_ID)
    SELECT P.ProductID, NEW.Campaign_ID
    FROM PRODUCT P
    WHERE P.Stock > 0;  
END;

SELECT * FROM APPLY;
INSERT INTO CAMPAIGN (Campaign_ID, Name, Start_Date, End_Date, Discount_Type, Coupon_Flag, Coupon_Code, Lower_Limit, SellerID, AdminID)
VALUES (3, 'Yılbaşı İndirimi', '2025-12-01', '2025-12-31', 'Yüzde', FALSE, NULL, 100.00, NULL, 1);
SELECT * FROM APPLY;



-- Trigger 3: when an order is placed, shopping cart's product quantity is set to zero
CREATE TRIGGER UpdateKeepQuantityOnOrder
AFTER INSERT ON ORDER_TABLE
FOR EACH ROW
BEGIN
    UPDATE KEEP
    SET Quantity = 0
    WHERE CartID = NEW.CartID;
END;

SELECT * FROM KEEP;
INSERT INTO ORDER_HISTORY (Sequence_Number, CustomerID)
VALUES
(4, 2);
INSERT INTO ORDER_TABLE (OrderID, Status, Date, Money_Gain, Sequence_Number, CartID, PaymentID)
VALUES (4, 'Pending', '2025-01-20', 1000.00, 4, 2, 2);

SELECT * FROM KEEP;

-- 4. Check Constraints (applied in the database creation)

-- Check 1: Ensure Product Stock is always non-negative
-- (Stock >= 0) should be validated in application logic.


-- Check 2: Ensure Payment Amount is greater than zero
-- (Amount > 0) should be validated before inserting into the PAYMENT table.


-- Check 3: Ensure Campaign Start Date is before End Date
-- (Start_date < End_date) should be validated during data entry.



-- 5a. Sample INSERT, DELETE, and UPDATE Statements
-- Sample INSERT
INSERT INTO USER_TABLE (UserID, Fname, Lname, Email, Gender, Registration_Date, Password, Phone_No, Last_Login)
VALUES (5, 'Eve', 'Green', 'eve.green@example.com', 'F', '2023-05-10', 'securepass', '1239874560', '2023-05-10');
SELECT * FROM USER_TABLE;
-- Sample DELETE
DELETE FROM REVIEW WHERE ReviewID = 1;
SELECT * FROM REVIEW;

-- Sample UPDATE
SELECT * FROM PRODUCT;
UPDATE PRODUCT
SET Rating = 4.9
WHERE ProductID = 3;
SELECT * FROM PRODUCT;



-- 5b. SELECT Statements

-- i. Using a Minimum of 2 Tables

-- List all products in a customer's shopping cart.
SELECT PRODUCT.Name AS Product_Name, KEEP.Quantity AS Quantity, KEEP.Date AS Added_Date
FROM SHOPPING_CART
JOIN KEEP ON SHOPPING_CART.CartID = KEEP.CartID
JOIN PRODUCT ON KEEP.ProductID = PRODUCT.ProductID
WHERE SHOPPING_CART.CustomerID = 2;

-- Show the premium start and end dates of customers who have made at least one return.
SELECT CUSTOMER.CustomerID, CUSTOMER.Premium_Start_Date, CUSTOMER.Premium_End_Date
FROM RETURNS
JOIN CUSTOMER ON RETURNS.CustomerID = CUSTOMER.CustomerID
GROUP BY CUSTOMER.CustomerID;

-- ii. Using a Minimum of 3 Tables

-- Get all orders placed by premium customers, including the money gain and the date.
SELECT ORDER_TABLE.OrderID, ORDER_TABLE.Date AS Order_Date, ORDER_TABLE.Money_Gain, CUSTOMER.Premium
FROM ORDER_TABLE
JOIN ORDER_HISTORY ON ORDER_TABLE.Sequence_Number = ORDER_HISTORY.Sequence_Number
JOIN CUSTOMER ON ORDER_HISTORY.CustomerID = CUSTOMER.CustomerID
WHERE CUSTOMER.Premium = TRUE;


-- Retrieve the list of products sold by a seller, along with their categories.
SELECT SELLS.SellerID, PRODUCT.Name AS Product_Name, CATEGORY.Name AS Category_Name
FROM SELLS
JOIN PRODUCT ON SELLS.ProductID = PRODUCT.ProductID
JOIN INCLUDED_IN ON PRODUCT.ProductID = INCLUDED_IN.ProductID
JOIN CATEGORY ON INCLUDED_IN.CategoryID = CATEGORY.Category_ID
WHERE SELLS.SellerID = 2;


-- Show all wallets associated with premium customers and their balances.
SELECT CUSTOMER.CustomerID, WALLET.Wallet_ID, WALLET.Balance
FROM WALLET
JOIN PAYMENT_METHOD ON WALLET.Payment_Method_ID = PAYMENT_METHOD.Payment_Method_ID
JOIN CUSTOMER ON PAYMENT_METHOD.CustomerID = CUSTOMER.CustomerID
WHERE CUSTOMER.Premium = TRUE;


-- 5c. Original SELECT Statements

--Displays CustomerID and Premium from CUSTOMER and Term_Gain from BENEFIT 
SELECT CUSTOMER.CustomerID,  CUSTOMER.Premium, BENEFIT.Term_Gain
FROM CUSTOMER, BENEFIT
WHERE CUSTOMER.CustomerID = BENEFIT.CustomerID;


--Display the product with the LOWEST rating and it's associated seller information
SELECT Name AS Product_Name, 
       Rating, 
       (SELECT SellerID 
        FROM SELLS 
        WHERE SELLS.ProductID = PRODUCT.ProductID) AS SellerID, 
       (SELECT Address 
        FROM SELLER 
        WHERE SELLER.SellerID = 
              (SELECT SellerID 
               FROM SELLS 
               WHERE SELLS.ProductID = PRODUCT.ProductID)) AS Seller_Address
FROM PRODUCT
ORDER BY Rating ASC
LIMIT 1;


-- List all campaigns created by an admin, including the number of products associated with each campaign.
SELECT Name AS Campaign_Name, 
       (SELECT Username 
        FROM ADMIN 
        WHERE AdminID = CAMPAIGN.AdminID) AS Admin_Name, 
       (SELECT COUNT(ProductID) 
        FROM APPLY 
        WHERE APPLY.Campaign_ID = CAMPAIGN.Campaign_ID) AS Product_Count
FROM CAMPAIGN
WHERE AdminID IS NOT NULL;


--displays reviews and comments of a product
SELECT ORDERED_PRODUCT.ProductID, PRODUCT.Name, REVIEW.Rating, REVIEW.Description, REVIEW.CFlag
FROM ORDERED_PRODUCT, REVIEW, PRODUCT
WHERE ORDERED_PRODUCT.ProductID = REVIEW.ProductID AND ORDERED_PRODUCT.ProductID = PRODUCT.ProductID


--Check if a product is included in any list and show the list details.
SELECT PRODUCT.ProductID, LIST.List_ID, LIST.Followers_Count, LIST.View_Count
FROM PRODUCT, LIST, CONTAINS
WHERE PRODUCT.ProductID = CONTAINS.ProductID
AND CONTAINS.List_ID = LIST.List_ID;



