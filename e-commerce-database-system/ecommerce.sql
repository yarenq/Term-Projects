
-- Create and Use Database
--CREATE DATABASE  ecommerce;
-- USER Table
CREATE TABLE USER_TABLE (
    UserID INT PRIMARY KEY,
    Fname VARCHAR(50) NOT NULL,
    Lname VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Gender CHAR(1),
    Registration_Date DATE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Phone_No VARCHAR(15),
    Last_Login DATE
);


-- CUSTOMER Table
CREATE TABLE CUSTOMER (
    CustomerID INT PRIMARY KEY,
    Waist DECIMAL(5,2),
    Shoulder_Width DECIMAL(5,2),
    Shoe_Size DECIMAL(5,2),
    Height DECIMAL(5,2),
    Hips DECIMAL(5,2),
    Weight DECIMAL(5,2),
    Legs DECIMAL(5,2),
    Premium BOOLEAN,
    UserID INT NOT NULL,
    Premium_Start_Date DATE,
    Premium_End_Date DATE,
    FOREIGN KEY (UserID) REFERENCES USER_TABLE(UserID)
);


-- ADDRESS Table
CREATE TABLE ADDRESS (
    AddressID INT PRIMARY KEY,
    Title VARCHAR(50) UNIQUE,
    Description TEXT,
    Postal_Code VARCHAR(15),
    Resident_Name VARCHAR(100),
    CustomerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
);


-- RETURN Table
CREATE TABLE RETURNS (
    Return_Code INT PRIMARY KEY,
    Status VARCHAR(50),
    Date DATE,
    Amount DECIMAL(10,2),
    Reason TEXT,
    CustomerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
);


-- SHOPPING_CART Table
CREATE TABLE SHOPPING_CART (
    CartID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
);


-- PAYMENT Table  CHECK CONSTRAINT 2
CREATE TABLE PAYMENT (
    PaymentID INT PRIMARY KEY,
    Amount DECIMAL(10,2) CHECK (Amount > 0)
);


-- ORDER_HISTORY Table
CREATE TABLE ORDER_HISTORY (
    Sequence_Number INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
);


-- ONE_CLICK Table (renamed from 1_CLICK)
CREATE TABLE ONE_CLICK (
    ClickID INT PRIMARY KEY,
    Allowed_device VARCHAR(100),
    Default_payment_method INT,
    Default_address INT,
    CustomerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
);


-- PRODUCT Table  CHECK CONSTRAINT 1
CREATE TABLE PRODUCT (
    ProductID INT PRIMARY KEY,
    Name VARCHAR(100),
    Rating DECIMAL(3,2),
    Stock INT CHECK (Stock >= 0),  
    Description TEXT,
    Image VARCHAR(255),
    Item_Condition VARCHAR(50) -- Renamed to avoid reserved keyword conflict
);


-- CATEGORY Table
CREATE TABLE CATEGORY (
    Category_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Product_Quantity INT
);

-- SELLER Table
CREATE TABLE SELLER (
    SellerID INT PRIMARY KEY,
    Rating DECIMAL(3,2),
    Address VARCHAR(255),
    Registration_Date DATE,
    Average_shipment_duration INT,
    Question_answering_duration INT,
    UserID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES USER_TABLE(UserID)
);

-- MESSAGE Table
CREATE TABLE MESSAGE (
    Message_ID INT PRIMARY KEY,
    Content TEXT,
    Header VARCHAR(255),
    Type VARCHAR(50),
    CustomerID INT NOT NULL,
    SellerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
    FOREIGN KEY (SellerID) REFERENCES SELLER(SellerID)
);


-- MESSAGE_BOX Table
CREATE TABLE MESSAGE_BOX (
    Message_Box_ID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
);


-- ADMIN Table
CREATE TABLE ADMIN (
    AdminID INT PRIMARY KEY,
    Username VARCHAR(50) NOT NULL,
    Password VARCHAR(255) NOT NULL
);


-- ORDER Table 
CREATE TABLE ORDER_TABLE (
    OrderID INT PRIMARY KEY,
    Status VARCHAR(50),
    Date DATE,
    Money_Gain DECIMAL(10,2),
    Sequence_Number INT NOT NULL,
    CartID INT NOT NULL,
    PaymentID INT NOT NULL,
    FOREIGN KEY (Sequence_Number) REFERENCES ORDER_HISTORY(Sequence_Number),
    FOREIGN KEY (CartID) REFERENCES SHOPPING_CART(CartID),
    FOREIGN KEY (PaymentID) REFERENCES PAYMENT(PaymentID)
);


-- SHIPPING Table
CREATE TABLE SHIPPING (
    TrackingID INT PRIMARY KEY,
    Company VARCHAR(100),
    Delivery_Date DATE,
    Preferred_Delivery_Time TIME,
    PaymentID INT NOT NULL,
    CartID INT NOT NULL,
    OrderID INT NOT NULL,
    Return_Code INT,
    FOREIGN KEY (PaymentID) REFERENCES PAYMENT(PaymentID),
    FOREIGN KEY (CartID) REFERENCES SHOPPING_CART(CartID),
    FOREIGN KEY (OrderID) REFERENCES ORDER_TABLE(OrderID),
    FOREIGN KEY (Return_Code) REFERENCES RETURNS (Return_Code)
);


-- KEEP Table
CREATE TABLE KEEP (
    CartID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT,
    Date DATE,
    PRIMARY KEY (CartID, ProductID),
    FOREIGN KEY (CartID) REFERENCES SHOPPING_CART(CartID),
    FOREIGN KEY (ProductID) REFERENCES PRODUCT(ProductID)
);


-- INCLUDED_IN Table
CREATE TABLE INCLUDED_IN (
    ProductID INT NOT NULL,
    CategoryID INT NOT NULL,
    PRIMARY KEY (ProductID, CategoryID),
    FOREIGN KEY (ProductID) REFERENCES PRODUCT(ProductID),
    FOREIGN KEY (CategoryID) REFERENCES CATEGORY(Category_ID)
);


-- HOLDS Table
CREATE TABLE HOLDS (
    Message_Box_ID INT NOT NULL,
    Message_ID INT NOT NULL,
    PRIMARY KEY (Message_Box_ID, Message_ID),
    FOREIGN KEY (Message_Box_ID) REFERENCES MESSAGE_BOX(Message_Box_ID),
    FOREIGN KEY (Message_ID) REFERENCES MESSAGE(Message_ID)
);


-- SUGGEST_SIMILAR Table
CREATE TABLE SUGGEST_SIMILAR (
    Main_ProductID INT NOT NULL,
    Sgst_ProductID INT NOT NULL,
    PRIMARY KEY (Main_ProductID, Sgst_ProductID),
    FOREIGN KEY (Main_ProductID) REFERENCES PRODUCT(ProductID),
    FOREIGN KEY (Sgst_ProductID) REFERENCES PRODUCT(ProductID)
);


-- INVOLVE Table
CREATE TABLE INVOLVE (
    Main_CategoryID INT NOT NULL,
    Sub_CategoryID INT NOT NULL,
    PRIMARY KEY (Main_CategoryID, Sub_CategoryID),
    FOREIGN KEY (Main_CategoryID) REFERENCES CATEGORY(Category_ID),
    FOREIGN KEY (Sub_CategoryID) REFERENCES CATEGORY(Category_ID)
);


-- FAST_PROCESS Table
CREATE TABLE FAST_PROCESS (
    ProductID INT NOT NULL,
    ClickID INT NOT NULL,
    OrderID INT NOT NULL,
    PRIMARY KEY (ProductID, ClickID, OrderID),
    FOREIGN KEY (ProductID) REFERENCES PRODUCT(ProductID),
    FOREIGN KEY (ClickID) REFERENCES ONE_CLICK(ClickID),
    FOREIGN KEY (OrderID) REFERENCES ORDER_TABLE(OrderID)
);





-- PAYMENT_METHOD Table
CREATE TABLE PAYMENT_METHOD (
    Payment_Method_ID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
);


-- WALLET Table
CREATE TABLE WALLET (
    Wallet_ID INT PRIMARY KEY,
    Gain DECIMAL(10,2),
    Balance DECIMAL(10,2),
    Payment_Method_ID INT NOT NULL,
    FOREIGN KEY (Payment_Method_ID) REFERENCES PAYMENT_METHOD(Payment_Method_ID)
);


-- CREDIT_CARD Table
CREATE TABLE CREDIT_CARD (
    Card_Name VARCHAR(100),
    Expire_Date DATE,
    CVV INT,
    Card_Number VARCHAR(20),
    Card_Holder VARCHAR(100),
    Payment_Method_ID INT PRIMARY KEY,
    FOREIGN KEY (Payment_Method_ID) REFERENCES PAYMENT_METHOD(Payment_Method_ID)
);


-- GIFT_CARD Table
CREATE TABLE GIFT_CARD (
    Code VARCHAR(50) PRIMARY KEY,
    Balance DECIMAL(10,2),
    Expiration_Date DATE,
    Payment_Method_ID INT NOT NULL,
    FOREIGN KEY (Payment_Method_ID) REFERENCES PAYMENT_METHOD(Payment_Method_ID)
);


-- LOAN Table
CREATE TABLE LOAN (
    LoanID INT PRIMARY KEY,
    Amount DECIMAL(10,2),
    Installment INT,
    Payment_Method_ID INT NOT NULL,
    FOREIGN KEY (Payment_Method_ID) REFERENCES PAYMENT_METHOD(Payment_Method_ID)
);


-- LIST Table
CREATE TABLE LIST (
    List_ID INT PRIMARY KEY,
    View_Count INT,
    Followers_Count INT,
    Private BOOLEAN,
    CustomerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
);


-- FAVORITES Table
CREATE TABLE FAVORITES (
    Favorites_ID INT PRIMARY KEY,
    List_ID INT NOT NULL,
    FOREIGN KEY (List_ID) REFERENCES LIST(List_ID)
);


-- MY_LIST Table
CREATE TABLE MY_LIST (
    My_List_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Type VARCHAR(50),
    List_ID INT NOT NULL,
    FOREIGN KEY (List_ID) REFERENCES LIST(List_ID)
);


-- CAMPAIGN Table   CHECK 3
CREATE TABLE CAMPAIGN (
    Campaign_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    End_Date DATE,
    Start_Date DATE,
    Discount_Type VARCHAR(50),
    Coupon_Flag BOOLEAN,
    Coupon_Code VARCHAR(50),
    Lower_Limit DECIMAL(10,2),
    SellerID INT,
    AdminID INT,
    FOREIGN KEY (SellerID) REFERENCES SELLER(SellerID),
    FOREIGN KEY (AdminID) REFERENCES ADMIN(AdminID),
    CHECK (Start_Date < End_Date)
);


-- CAMPAIGN_CONDITIONS Table
CREATE TABLE CAMPAIGN_CONDITIONS (
    Campaign_ID INT PRIMARY KEY,
    Campaign_Conditions TEXT,
    FOREIGN KEY (Campaign_ID) REFERENCES CAMPAIGN(Campaign_ID)
);


-- BENEFIT Table
CREATE TABLE BENEFIT (
    BenefitID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    Name VARCHAR(100),
    Description TEXT,
    Term_Gain DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
);


-- MADE_LIST Table
CREATE TABLE MADE_LIST (
    My_List_ID INT NOT NULL,
    CustomerID INT NOT NULL,
    BenefitID INT NOT NULL,
    PRIMARY KEY (My_List_ID, CustomerID, BenefitID),
    FOREIGN KEY (My_List_ID) REFERENCES MY_LIST(My_List_ID),
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID),
    FOREIGN KEY (BenefitID) REFERENCES BENEFIT(BenefitID)
);


-- REVIEW Table
CREATE TABLE REVIEW (
    ReviewID INT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Date DATE,
    Rating DECIMAL(3,2),
    SellerID INT,
    AdminID INT,
    CFlag BOOLEAN,
    Description TEXT,
    Media VARCHAR(255),
    FOREIGN KEY (OrderID) REFERENCES ORDER_TABLE(OrderID),
    FOREIGN KEY (ProductID) REFERENCES PRODUCT(ProductID),
    FOREIGN KEY (SellerID) REFERENCES SELLER(SellerID),
    FOREIGN KEY (AdminID) REFERENCES ADMIN(AdminID)
);


-- LINK_INCOME Table
CREATE TABLE LINK_INCOME (
    CustomerID INT NOT NULL,
    BenefitID INT NOT NULL,
    Gain DECIMAL(10,2),
    PRIMARY KEY (CustomerID, BenefitID),
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID),
    FOREIGN KEY (BenefitID) REFERENCES BENEFIT(BenefitID)
);


-- NOTIFICATION Table
CREATE TABLE NOTIFICATION (
    NotificationID INT PRIMARY KEY,
    Date DATE,
    Content TEXT,
    Type VARCHAR(50),
    Header VARCHAR(255),
    Message_ID INT,
    AdminID INT,
    FOREIGN KEY (Message_ID) REFERENCES MESSAGE(Message_ID),
    FOREIGN KEY (AdminID) REFERENCES ADMIN(AdminID)
);


-- HOME_DELIVERY Table
CREATE TABLE HOME_DELIVERY (
    Delivery_ID INT PRIMARY KEY,
    TrackingID INT NOT NULL,
    AddressID INT NOT NULL,
    FOREIGN KEY (TrackingID) REFERENCES SHIPPING(TrackingID),
    FOREIGN KEY (AddressID) REFERENCES ADDRESS(AddressID)
);


-- PICK_UP Table
CREATE TABLE PICK_UP (
    Pick_UpID INT PRIMARY KEY,
    Work_Hours VARCHAR(100),
    Address VARCHAR(255),
    Name VARCHAR(100),
    TrackingID INT NOT NULL,
    FOREIGN KEY (TrackingID) REFERENCES SHIPPING(TrackingID)
);


-- ORDERED_PRODUCT Table
CREATE TABLE ORDERED_PRODUCT (
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES ORDER_TABLE(OrderID),
    FOREIGN KEY (ProductID) REFERENCES PRODUCT(ProductID)
);


-- SLOW_PROCESS Table
CREATE TABLE SLOW_PROCESS (
    PaymentID INT NOT NULL,
    CartID INT NOT NULL,
    OrderID INT NOT NULL,
    PRIMARY KEY (PaymentID, CartID, OrderID),
    FOREIGN KEY (PaymentID) REFERENCES PAYMENT(PaymentID),
    FOREIGN KEY (CartID) REFERENCES SHOPPING_CART(CartID),
    FOREIGN KEY (OrderID) REFERENCES ORDER_TABLE(OrderID)
);


-- CHECKS Tablosu
CREATE TABLE CHECKS (
    UserID INT NOT NULL,
    AdminID INT NOT NULL,
    PRIMARY KEY (UserID, AdminID),
    FOREIGN KEY (UserID) REFERENCES USER_TABLE(UserID),
    FOREIGN KEY (AdminID) REFERENCES ADMIN(AdminID)
);


-- FOLLOWS Tablosu
CREATE TABLE FOLLOWS (
    UserID INT NOT NULL,
    CustomerID INT NOT NULL,
    PRIMARY KEY (UserID, CustomerID),
    FOREIGN KEY (UserID) REFERENCES USER_TABLE(UserID),
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
);


-- RECIEVES Tablosu
CREATE TABLE RECIEVES (
    CustomerID INT NOT NULL,
    NotificationID INT NOT NULL,
    PRIMARY KEY(CustomerID, NotificationID),
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID),
    FOREIGN KEY (NotificationID) REFERENCES NOTIFICATION(NotificationID)
);


-- APPLY Tablosu
CREATE TABLE APPLY (
    ProductID INT NOT NULL,
    Campaign_ID INT NOT NULL,
    PRIMARY KEY (ProductID, Campaign_ID),
    FOREIGN KEY (ProductID) REFERENCES PRODUCT(ProductID),
    FOREIGN KEY (Campaign_ID) REFERENCES CAMPAIGN(Campaign_ID)
);


-- SELLS Tablosu
CREATE TABLE SELLS (
    SellerID INT NOT NULL,
    ProductID INT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (SellerID, ProductID),
    FOREIGN KEY (SellerID) REFERENCES SELLER(SellerID),
    FOREIGN KEY (ProductID) REFERENCES PRODUCT(ProductID)
);


-- USES Tablosu
CREATE TABLE USES (
    Payment_method_ID INT NOT NULL,
    PaymentID INT NOT NULL,
    PRIMARY KEY(Payment_method_ID, PaymentID),
    FOREIGN KEY (Payment_method_ID) REFERENCES PAYMENT_METHOD(Payment_method_ID),
    FOREIGN KEY (PaymentID) REFERENCES PAYMENT(PaymentID)
);


-- CONTAINS Tablosu
CREATE TABLE CONTAINS (
    List_ID INT NOT NULL,
    ProductID INT NOT NULL,
    Date DATE NOT NULL,
    PRIMARY KEY (List_ID, ProductID),
    FOREIGN KEY (List_ID) REFERENCES LIST(List_ID),
    FOREIGN KEY (ProductID) REFERENCES PRODUCT(ProductID)
);






