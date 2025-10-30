# **E-Commerce Database Schema**

## **Project Objective**

This repository contains a complete SQL schema for a relational database (MySQL) designed for a general-purpose e-commerce store. The project fulfills an objective to design and implement a full-featured relational database from a real-world use case.

## **Schema Overview**

The schema is contained in the ecommerce_db.sql file. It defines a logical and normalized structure for managing users, products, orders, and related data.

### **Tables Created:**

users: Stores customer information (name, email, password).

categories: Stores product categories (e.g., "Electronics", "Books").

products: Stores product details, price, stock, and links to a category.

orders: Stores header information for a customer's order, linking to a user.order_items: A junction table that resolves the many-to-many relationship between orders and products.

addresses: Stores one or more shipping/billing addresses for a user.

### **Relationships:**

One-to-Many:users to orders (One user can have many orders)users to addresses (One user can have many addresses)categories to products (One category can have many products)

Many-to-Many:orders to products (An order can contain many products, and a product can be in many orders). This is implemented via the order_items table.

## **How to UseTo use this schema,**

 you can run the ecommerce_db.sql file directly in your MySQL instance. This will create the ecommerce_store database, all the tables, and set up all primary keys, foreign keys, and constraints.Using MySQL Command Line:mysql -u [your_username] -p < ecommerce_db.sql

Using a GUI Tool (like DBeaver, MySQL Workbench, or TablePlus):Open the ecommerce_db.sql file.Connect to your MySQL server.Execute the entire script.