-- Drop the database if it already exists to start fresh
DROP DATABASE IF EXISTS `ecommerce_store`;

-- Create the new database
CREATE DATABASE `ecommerce_store`;

-- Select the database to use
USE `ecommerce_store`;

--
-- Table structure for table `users`
--
CREATE TABLE `users` (
  `user_id` INT AUTO_INCREMENT,
  `first_name` VARCHAR(100) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email_unique` (`email`)
);

--
-- Table structure for table `categories`
--
CREATE TABLE `categories` (
  `category_id` INT AUTO_INCREMENT,
  `category_name` VARCHAR(100) NOT NULL,
  `description` TEXT,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `category_name_unique` (`category_name`)
);

--
-- Table structure for table `products`
--
CREATE TABLE `products` (
  `product_id` INT AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `description` TEXT,
  `price` DECIMAL(10, 2) NOT NULL,
  `stock_quantity` INT NOT NULL DEFAULT 0,
  `category_id` INT,
  PRIMARY KEY (`product_id`),
  FOREIGN KEY (`category_id`) 
    REFERENCES `categories`(`category_id`)
    ON DELETE SET NULL
);

--
-- Table structure for table `orders`
--
CREATE TABLE `orders` (
  `order_id` INT AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `order_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `status` ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') NOT NULL DEFAULT 'pending',
  
  PRIMARY KEY (`order_id`),
  FOREIGN KEY (`user_id`) 
    REFERENCES `users`(`user_id`)
    ON DELETE CASCADE
);

--
-- Table structure for table `order_items`
--
CREATE TABLE `order_items` (
  `order_item_id` INT AUTO_INCREMENT,
  `order_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `quantity` INT NOT NULL,
  `price_at_purchase` DECIMAL(10, 2) NOT NULL, 
  PRIMARY KEY (`order_item_id`),
  FOREIGN KEY (`order_id`) 
    REFERENCES `orders`(`order_id`)
    ON DELETE CASCADE,
  FOREIGN KEY (`product_id`) 
    REFERENCES `products`(`product_id`)
    ON DELETE RESTRICT
);

--
-- Table structure for table `addresses`
--
CREATE TABLE `addresses` (
  `address_id` INT AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `address_line1` VARCHAR(255) NOT NULL,
  `address_line2` VARCHAR(255),
  `city` VARCHAR(100) NOT NULL,
  `state_province` VARCHAR(100) NOT NULL,
  `postal_code` VARCHAR(20) NOT NULL,
  `country` VARCHAR(100) NOT NULL,
  `is_default` BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (`address_id`),
  FOREIGN KEY (`user_id`) 
    REFERENCES `users`(`user_id`)
    ON DELETE CASCADE
);

--
-- =================================================================
-- POPULATE DATABASE WITH SAMPLE DATA
-- =================================================================
--
-- Note: Data is inserted in order to satisfy foreign key constraints.

-- 1. Insert Users
-- (Passwords are just strings, in a real app they should be securely hashed)
INSERT INTO `users` (`first_name`, `last_name`, `email`, `password_hash`) 
VALUES
('Alice', 'Smith', 'alice@example.com', 'hash12345'),
('Bob', 'Johnson', 'bob@example.com', 'hash67890'),
('Charlie', 'Brown', 'charlie@example.com', 'hashabcde');

-- 2. Insert Categories
INSERT INTO `categories` (`category_name`, `description`) 
VALUES
('Electronics', 'Gadgets, computers, and accessories'),
('Books', 'Fiction, non-fiction, and educational books'),
('Clothing', 'Apparel for men, women, and children');

-- 3. Insert Products
-- (Note how `category_id` links to the categories above)
INSERT INTO `products` (`name`, `description`, `price`, `stock_quantity`, `category_id`) 
VALUES
('Laptop Pro', 'A high-performance laptop for professionals.', 1299.99, 50, 1),
('Smartphone X', 'The latest smartphone with advanced features.', 899.99, 150, 1),
('Wireless Headphones', 'Noise-cancelling over-ear headphones.', 199.99, 200, 1),
('The SQL Enigma', 'A mystery novel where the clue is in the database.', 24.99, 500, 2),
('Learn Python', 'A comprehensive guide to Python programming.', 39.99, 300, 2),
('Classic T-Shirt', 'A comfortable 100% cotton t-shirt.', 19.99, 1000, 3);

-- 4. Insert Addresses
-- (Note how `user_id` links to the users above)
INSERT INTO `addresses` (`user_id`, `address_line1`, `city`, `state_province`, `postal_code`, `country`, `is_default`) 
VALUES
(1, '123 Main St', 'New York', 'NY', '10001', 'USA', TRUE),
(1, '456 Second Ave', 'Brooklyn', 'NY', '11201', 'USA', FALSE),
(2, '789 Oak Ln', 'Chicago', 'IL', '60601', 'USA', TRUE);

-- 5. Insert Orders
-- (We will create two orders, one for Alice (user 1) and one for Bob (user 2))
-- (Total amount is pre-calculated for this sample data)
INSERT INTO `orders` (`user_id`, `status`) 
VALUES
(1, 'shipped'),  -- Alice's order (1x Laptop Pro + 1x Wireless Headphones)
(2, 'pending');    -- Bob's order (2x The SQL Enigma + 1x Learn Python)

-- 6. Insert Order Items
-- (Linking Orders and Products)
-- Order 1 (for Alice)
INSERT INTO `order_items` (`order_id`, `product_id`, `quantity`, `price_at_purchase`) 
VALUES
(1, 1, 1, 1299.99), -- Order 1, Product 1 (Laptop Pro)
(1, 3, 1, 199.99);  -- Order 1, Product 3 (Wireless Headphones)

-- Order 2 (for Bob)
INSERT INTO `order_items` (`order_id`, `product_id`, `quantity`, `price_at_purchase`) 
VALUES
(2, 4, 2, 24.99), -- Order 2, Product 4 (The SQL Enigma), Qty 2
(2, 5, 1, 39.99);  -- Order 2, Product 5 (Learn Python), Qty 1

SELECT
  o.order_id,
  o.user_id,
  o.status,
  o.order_date,
  -- Calculate the true total from order_items
  SUM(oi.quantity * oi.price_at_purchase) AS total_amount
FROM 
  `orders` o
JOIN 
  `order_items` oi ON o.order_id = oi.order_id
GROUP BY
  o.order_id;