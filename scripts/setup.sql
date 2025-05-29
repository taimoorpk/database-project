- Customers table
CREATE TABLE IF NOT EXISTS customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders table
CREATE TABLE IF NOT EXISTS orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending'
);

-- Initial data (idempotent)
INSERT INTO customers (first_name, last_name, email)
SELECT 'John', 'Doe', 'john@example.com'
WHERE NOT EXISTS (SELECT 1 FROM customers WHERE email = 'john@example.com');

INSERT INTO orders (customer_id, amount, status)
SELECT 1, 99.99, 'completed'
WHERE NOT EXISTS (SELECT 1 FROM orders WHERE order_id = 1);