This project involves designing and implementing a database system for an e-commerce platform that supports customers, shops, products, orders, and logistics. The system enables customers to track their orders, maintain a favorite shopping list, and compare product prices across multiple sellers. It also provides inventory management and order tracking functionalities to ensure smooth operations for both customers and sellers. The project emphasizes database design, including conceptual, logical, and physical models.

Analysis
To ensure the database meets real-world e-commerce requirements, three major e-commerce websites—Amazon Türkiye, Hepsiburada, and Trendyol—were analyzed. The data requirements extracted from these platforms informed the design of the system, ensuring it accommodates multiple sellers for the same product, customer preferences, and logistics tracking.

Design
Conceptual Design
Three Enhanced Entity-Relationship (EER) diagrams were created separately for each website, reflecting their unique structures and data relationships.
The EER diagrams were then merged into a comprehensive EER model, combining features such as multi-seller product listings, order tracking, and customer wish lists.
Logical Model
The final EER diagram was converted into a relational model using proper database normalization techniques.
Implementation
Physical Model
Database Creation (DDL)

The database schema was implemented using SQL, defining tables for customers, products, orders, shops, and logistics.
Data Population (DML)

Sample data was inserted to simulate real-world use cases.
Triggers

Three meaningful triggers were implemented for order status updates, stock management, and automated wishlist notifications.
Constraints

Three meaningful CHECK constraints were applied to ensure data integrity.
SQL Queries

INSERT, DELETE, UPDATE statements were written for managing data.
5 SELECT queries were implemented, including multi-table joins and aggregations.
5 critical SELECT queries were developed for business insights, such as top-selling products, customer purchase behavior, and seller performance.
