-- Active: 1737058836822@@127.0.0.1@3306@ecommerce




-- Populate USER_TABLE
INSERT INTO USER_TABLE (UserID, Fname, Lname, Email, Gender, Registration_Date, Password, Phone_No, Last_Login) 
VALUES 
(1, 'John', 'Doe', 'john.doe@example.com', 'M', '2023-01-01', 'password123', '1234567890', '2023-01-10'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', 'F', '2023-01-02', 'password456', '0987654321', '2023-01-11'),
(3, 'Emily', 'Taylor', 'emily.taylor@example.com', 'F', '2023-01-03', 'password789', '1122334455', '2023-01-12'),
(4, 'Bob', 'Brown', 'bob.brown@example.com', 'M', '2023-01-04', 'password321', '5566778899', '2023-01-13');


-- Populate CUSTOMER
INSERT INTO CUSTOMER (CustomerID, Waist, Shoulder_Width, Shoe_Size, Height, Hips, Weight, Legs, Premium, UserID, Premium_Start_Date, Premium_End_Date) 
VALUES 
(1, 32.5, 18.2, 10.0, 180.0, 36.0, 75.0, 40.0, TRUE, 1, '2023-01-01', '2024-01-01'),
(2, 28.0, 16.5, 8.0, 165.0, 34.0, 60.0, 38.0, FALSE, 2, NULL, NULL);

-- Populate ADDRESS
INSERT INTO ADDRESS (AddressID, Title, Description, Postal_Code, Resident_Name, CustomerID) 
VALUES 
(1, 'Home', '123 Main Street', '12345', 'John Doe', 1),
(2, 'Office', '456 Business Road', '67890', 'Jane Smith', 2);

-- Populate RETURNS
INSERT INTO RETURNS (Return_Code, Status, Date, Amount, Reason, CustomerID) 
VALUES 
(1, 'Processed', '2023-01-15', 50.00, 'Defective item', 1),
(2, 'Pending', '2023-01-16', 75.00, 'Wrong size', 2);

-- Populate SHOPPING_CART
INSERT INTO SHOPPING_CART (CartID, CustomerID) 
VALUES 
(1, 1),
(2, 2);

-- Populate PAYMENT
INSERT INTO PAYMENT (PaymentID, Amount) 
VALUES 
(1, 100.00),
(2, 200.00);

-- Populate ORDER_HISTORY
INSERT INTO ORDER_HISTORY (Sequence_Number, CustomerID) 
VALUES 
(1, 1),
(2, 2),
(3, 1);

-- Populate ONE_CLICK
INSERT INTO ONE_CLICK (ClickID, Allowed_device, Default_payment_method, Default_address, CustomerID) 
VALUES 
(1, 'Mobile', 1, 1, 1),
(2, 'Desktop', 2, 2, 2);

-- Populate PRODUCT
INSERT INTO PRODUCT (ProductID, Name, Rating, Stock, Description, Image, Item_Condition) 
VALUES 
(1, 'Laptop', 4.5, 10, 'High performance laptop', 'laptop.jpg', 'New'),
(2, 'Phone', 4.2, 20, 'Latest smartphone', 'phone.jpg', 'New'),
(3, 'Camera', 3.2, 10,'New technology', 'camera.jpg', 'New');


-- Populate CATEGORY
INSERT INTO CATEGORY (Category_ID, Name, Product_Quantity) 
VALUES 
(1, 'Electronics', 2),
(2, 'Gadgets', 2);

-- Populate MESSAGE
INSERT INTO MESSAGE (Message_ID, Content, Header, Type, CustomerID) 
VALUES 
(1, 'Your order_request has been shipped.', 'Order_Update', 'Info', 1),
(2, 'Your return_request has been processed.', 'Return_Update', 'Info', 2);

-- Populate MESSAGE_BOX
INSERT INTO MESSAGE_BOX (Message_Box_ID, CustomerID) 
VALUES 
(1, 1),
(2, 2);

-- Populate ADMIN
INSERT INTO ADMIN (AdminID, Username, Password) 
VALUES 
(1, 'admin1', 'adminpass1'),
(2, 'admin2', 'adminpass2');

-- Populate ORDER_TABLE
INSERT INTO ORDER_TABLE (OrderID, Status, Date, Money_Gain, Sequence_Number, CartID, PaymentID) 
VALUES 
(1, 'Shipped', '2023-01-20', 150.00, 1, 1, 1),
(2, 'Shipped', '2023-01-21', 250.00, 2, 2, 2),
(3, 'Pending', '2023-05-21', 100.00, 3, 1, 1);

-- Populate SHIPPING
INSERT INTO SHIPPING (TrackingID, Company, Delivery_Date, Preferred_Delivery_Time, PaymentID, CartID, OrderID, Return_Code) 
VALUES 
(1, 'DHL', '2023-01-25', '14:00:00', 1, 1, 1, 1),
(2, 'FedEx', '2023-01-26', '16:00:00', 2, 2, 2, 2);

-- Populate KEEP
INSERT INTO KEEP (CartID, ProductID, Quantity, Date) 
VALUES 
(2, 2, 1, '2023-01-19');



-- Populate INCLUDED_IN
INSERT INTO INCLUDED_IN (ProductID, CategoryID) 
VALUES 
(1, 1),
(2, 2);

-- Populate HOLDS
INSERT INTO HOLDS (Message_Box_ID, Message_ID) 
VALUES 
(1, 1),
(2, 2);

-- Populate SUGGEST_SIMILAR
INSERT INTO SUGGEST_SIMILAR (Main_ProductID, Sgst_ProductID) 
VALUES 
(1, 2),
(2, 1);

-- Populate INVOLVE
INSERT INTO INVOLVE (Main_CategoryID, Sub_CategoryID) 
VALUES 
(1, 2),
(2, 1);

-- Populate FAST_PROCESS
INSERT INTO FAST_PROCESS (ProductID, ClickID, OrderID) 
VALUES 
(1, 1, 1),
(2, 2, 2);

-- Populate SELLER
INSERT INTO SELLER (SellerID, Rating, Address, Registration_Date, Average_shipment_duration, Question_answering_duration, UserID) 
VALUES 
(1, 4.7, '789 Market Street', '2023-01-05', 3, 2, 3),
(2, 4.8, '123 Trade Avenue', '2023-01-06', 2, 1, 4);

-- Populate PAYMENT_METHOD
INSERT INTO PAYMENT_METHOD (Payment_Method_ID, CustomerID) 
VALUES 
(1, 1),
(2, 2),
(3, 1),
(4, 2),
(5, 1);

-- Populate WALLET
INSERT INTO WALLET (Wallet_ID, Gain, Balance, Payment_Method_ID) 
VALUES 
(1, 50.00, 100.00, 1);

-- Populate CREDIT_CARD
INSERT INTO CREDIT_CARD (Card_Name, Expire_Date, CVV, Card_Number, Card_Holder, Payment_Method_ID) 
VALUES
('MasterCard', '2024-11-30', 456, '5500000000000004', 'Jane Smith', 2),
('Visa', '2027-11-27', 123, '1234567891011121', 'John Doe', 5);

-- Populate GIFT_CARD
INSERT INTO GIFT_CARD (Code, Balance, Expiration_Date, Payment_Method_ID) 
VALUES 
('GC123', 25.00, '2024-12-31', 3);

-- Populate LOAN
INSERT INTO LOAN (LoanID, Amount, Installment, Payment_Method_ID) 
VALUES 
(1, 500.00, 10, 4);

-- Populate LIST
INSERT INTO LIST (List_ID, View_Count, Followers_Count, Private, CustomerID) 
VALUES 
(1, 100, 10, FALSE, 1),
(2, 200, 20, TRUE, 2),
(3, 200, 20, TRUE, 2),
(4, 200, 20, TRUE, 2);

-- Populate FAVORITES
INSERT INTO FAVORITES (Favorites_ID, List_ID) 
VALUES 
(1, 1),
(2, 2);

-- Populate MY_LIST
INSERT INTO MY_LIST (My_List_ID, Name, Type, List_ID) 
VALUES 
(1, 'Gifts', 'Personal', 3),
(2, 'Clothes', 'Shared', 4);

-- Populate CAMPAIGN
INSERT INTO CAMPAIGN (Campaign_ID, Name, End_Date, Start_Date, Discount_Type, Coupon_Flag, Coupon_Code, Lower_Limit, SellerID, AdminID) 
VALUES 
(1, 'Winter Sale', '2024-01-31', '2024-01-01', 'Percentage', TRUE, 'WINTER10', 100.00, 1, NULL),
(2, 'Summer Sale', '2024-07-31', '2024-07-01', 'Flat', FALSE, NULL, 50.00, NULL, 2);

-- Populate CAMPAIGN_CONDITIONS
INSERT INTO CAMPAIGN_CONDITIONS (Campaign_ID, Campaign_Conditions) 
VALUES 
(1, 'Minimum purchase $100 for 10% off'),
(2, 'Flat $10 discount on orders above $50');

-- Populate BENEFIT
INSERT INTO BENEFIT (BenefitID, CustomerID, Name, Description, Term_Gain) 
VALUES 
(1, 1, 'Loyalty Bonus', '10% cashback on every purchase', 10.00),
(2, 2, 'Seasonal Reward', 'Special discount during the holidays', 0);

-- Populate MADE_LIST
INSERT INTO MADE_LIST (My_List_ID, CustomerID, BenefitID) 
VALUES 
(1, 1, 1),
(2, 2, 2);

-- Populate REVIEW
INSERT INTO REVIEW (ReviewID, OrderID, ProductID, Date, Rating, SellerID, AdminID, CFlag, Description, Media) 
VALUES 
(1, 1, 1, '2023-01-25', 4.5, 1, 1, TRUE, 'Excellent product!', 'review1.jpg'),
(2, 2, 2, '2023-01-26', 4.0, 2, 2, TRUE, 'Good quality but late delivery.', 'review2.jpg');

-- Populate LINK_INCOME
INSERT INTO LINK_INCOME (CustomerID, BenefitID, Gain) 
VALUES 
(1, 1, 15.00),
(2, 2, 20.00);

-- Populate NOTIFICATION
INSERT INTO NOTIFICATION (NotificationID, Date, Content, Type, Header, Message_ID, AdminID) 
VALUES 
(1, '2023-01-27', 'Your return has been processed successfully.', 'Info', 'Return Status', 1, 1),
(2, '2023-01-28', 'New campaign available: Winter Sale!', 'Alert', 'Campaign Alert', 2, 2);

-- Populate HOME_DELIVERY
INSERT INTO HOME_DELIVERY (Delivery_ID, TrackingID, AddressID) 
VALUES 
(1, 1, 1),
(2, 2, 2);

-- Populate PICK_UP
INSERT INTO PICK_UP (Pick_UpID, Work_Hours, Address, Name, TrackingID) 
VALUES 
(1, '9 AM - 5 PM', '789 Pickup Point', 'Main Pickup', 1),
(2, '10 AM - 6 PM', '123 Pickup Center', 'Secondary Pickup', 2);

-- Populate ORDERED_PRODUCT
INSERT INTO ORDERED_PRODUCT (OrderID, ProductID) 
VALUES 
(1, 1),
(2, 2);

-- Populate SLOW_PROCESS
INSERT INTO SLOW_PROCESS (PaymentID, CartID, OrderID) 
VALUES 
(1, 1, 1),
(2, 2, 2);

INSERT INTO CHECKS (UserID, AdminID) 
VALUES 
(3, 1), (2, 1);

INSERT INTO FOLLOWS (UserID, CustomerID) 
VALUES 
(3, 1), (1, 2);

INSERT INTO RECIEVES (CustomerID, NotificationID) 
VALUES 
(1, 1), (2, 2);

INSERT INTO APPLY (ProductID, Campaign_ID) 
VALUES 
(3, 1), (1, 2) ;

INSERT INTO SELLS (SellerID, ProductID, Price) 
VALUES 
(2, 1, 99.99), (2, 2, 149.99);

INSERT INTO USES (Payment_method_ID, PaymentID) 
VALUES 
(2, 1), (5, 2);

INSERT INTO CONTAINS (List_ID, ProductID, Date) 
VALUES 
(1, 1, '2024-01-01'), (2, 3, '2024-01-02');


