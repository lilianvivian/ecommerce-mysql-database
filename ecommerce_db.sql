-- Drop the database if it already exists to start fresh
DROP DATABASE IF EXISTS `ecommerce_store`;

-- Create the new database
CREATE DATABASE `ecommerce_store`;

-- Select the database to use
USE `ecommerce_store`;

--
-- Table structure for table `users`
-- A user can have multiple orders and multiple addresses.
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
-- A category can contain multiple products.
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
-- A product belongs to one primary category (for simplicity, though a many-to-many join table is also common).
-- It can be part of many different orders.
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
    ON DELETE SET NULL -- If a category is deleted, the product is not deleted, just uncategorized
);

--
-- Table structure for table `orders`
-- This represents a single order placed by a user.
-- This is a one-to-many relationship: One user can have many orders.
--
CREATE TABLE `orders` (
  `order_id` INT AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `order_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `status` ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') NOT NULL DEFAULT 'pending',
  `total_amount` DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`order_id`),
  FOREIGN KEY (`user_id`) 
    REFERENCES `users`(`user_id`)
    ON DELETE CASCADE -- If a user is deleted, their orders are also deleted
);

--
-- Table structure for table `order_items`
-- This is the "join table" that resolves the many-to-many relationship
-- between `orders` and `products`.
-- An order can have many products, and a product can be in many orders.
--
CREATE TABLE `order_items` (
  `order_item_id` INT AUTO_INCREMENT,
  `order_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `quantity` INT NOT NULL,
  `price_at_purchase` DECIMAL(10, 2) NOT NULL, -- Price when ordered, as product price might change
  PRIMARY KEY (`order_item_id`),
  FOREIGN KEY (`order_id`) 
    REFERENCES `orders`(`order_id`)
    ON DELETE CASCADE, -- If an order is deleted, its items are deleted
  FOREIGN KEY (`product_id`) 
    REFERENCES `products`(`product_id`)
    ON DELETE RESTRICT -- Prevent deleting a product if it's part of an order
);

--
-- Table structure for table `addresses`
-- This represents a shipping or billing address for a user.
-- This is a one-to-many relationship: One user can have multiple addresses.
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
    ON DELETE CASCADE -- If a user is deleted, their addresses are deleted
);
