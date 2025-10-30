# **E-Commerce Database Schema**

## **Project Objective**

This repository contains a complete SQL schema for a relational database (MySQL) designed for a general-purpose e-commerce store. The project fulfills an objective to design and implement a full-featured relational database from a real-world use case.

## **Schema Diagram (ERD)**
```
+--------------+       +-------------+       +--------------+
|   users      |       |  addresses  |       |    orders    |
+--------------+       +-------------+       +--------------+
| *user_id (PK)|<--+---(FK) user_id   |       | *order_id (PK)|
|  first_name  |   |   | *address_id |       | (FK) user_id |
|  last_name   |   |   |  address_line1 |       |  order_date  |
|  email       |   |   |  city        |       |  status      |
|  password_hash|   |   |  postal_code |       +-------^------+
+--------------+   |   |  is_default  |               |
                   |   +-------------+               | 1-to-Many
   1-to-Many       |                                 |
                   +---------------------------------+
                                                     |
+--------------+       +-------------+       +-------+------+
|  categories  |       |  products   |       | order_items  |
+--------------+       +-------------+       +--------------+
| *category_id |       | *product_id |       | *o_item_id(PK)|
|  category_name|      |  name       |       | (FK) order_id|
|  description |<-----(FK) category_id|      | (FK) product_id|
+--------------+       |  price      |       |  quantity    |
                       |  stock      |       |  price_at_purchase|
                       +------^------+       +-------+------+
                              |                       |
                              +------(Many-to-Many)---+

```

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

Run the ecommerce_db.sql file directly in your MySQL instance. This will create the ecommerce_store database, all the tables, and set up all primary keys, foreign keys, and constraints.
 
 Using MySQL Command Line:
   ```mysql -u [your_username] -p < ecommerce_db.sql```

Using a GUI Tool (like DBeaver, MySQL Workbench, or TablePlus):
1. Open the ecommerce_db.sql file.
2. Connect to your MySQL server.
3. Execute the entire script.