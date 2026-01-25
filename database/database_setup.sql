CREATE TABLE users (
    users_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'unique identifier for each user',
    full_name VARCHAR(200) NOT NULL COMMENT 'Full name of the user from sms',
    phone_number VARCHAR(20) UNIQUE COMMENT 'Unique phone number for user'
);

CREATE TABLE roles (
    roles_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Unique identifier for each role',
    role_name VARCHAR(100) NOT NULL UNIQUE COMMENT 'Name of the role such as sender, receiver or mobile money system',
    description VARCHAR(500) COMMENT 'Detailed description of the role'
);

CREATE TABLE user_roles (
    user_roles_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Unique identifier for the user-role mapping',
    roles_id INT NOT NULL COMMENT 'Reference to the role',
    users_id INT NOT NULL COMMENT 'Reference to the user',
    FOREIGN KEY (roles_id) REFERENCES roles(roles_id) COMMENT 'Foreign key reference to roles table',
    FOREIGN KEY (users_id) REFERENCES users(users_id) COMMENT 'Foreign key reference to users table',
    UNIQUE KEY unique_user_role (users_id, roles_id) COMMENT 'Ensure each user has only one instance of each role'
);

CREATE TABLE transaction_category (
    transaction_category_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Unique identifier for each transaction category',
    category_name VARCHAR(100) NOT NULL UNIQUE COMMENT 'Name of the transaction category such as transfer, payment or withdrawal'
);

CREATE TABLE transactions (
    transactions_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Unique identifier for each transaction',
    transferred_amount DECIMAL(15, 2) NOT NULL COMMENT 'Amount transferred in the transaction',
    reference_code VARCHAR(100) NOT NULL UNIQUE COMMENT 'Unique reference code for transaction tracking',
    currency VARCHAR(3) NOT NULL COMMENT 'currency that is used in transaction',
    transaction_fee DECIMAL(10, 2) DEFAULT 0 CHECK (transaction_fee >= 0) COMMENT 'Transaction fee charged (must not be negative)',
    transaction_date DATETIME NOT NULL COMMENT 'Date and time when the transaction occurred',
    new_balance DECIMAL(15, 2) COMMENT 'New balance of end user after transaction',
    sender_id INT NOT NULL COMMENT 'Reference to the user sending money',
    receiver_id INT NOT NULL COMMENT 'Reference to the user receiving money',
    transaction_category_id INT NOT NULL COMMENT 'Reference to the transaction category',
    CHECK (transferred_amount > 0) COMMENT 'Ensure transferred amount is positive',
    CHECK (sender_id != receiver_id) COMMENT 'Ensure sender and receiver are different users',
    FOREIGN KEY (sender_id) REFERENCES users(users_id) COMMENT 'Foreign key reference to sender user',
    FOREIGN KEY (receiver_id) REFERENCES users(users_id) COMMENT 'Foreign key reference to receiver user',
    FOREIGN KEY (transaction_category_id) REFERENCES transaction_category(transaction_category_id) COMMENT 'Foreign key reference to transaction category'
);

CREATE TABLE system_logs (
    system_logs_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Unique identifier for each log entry',
    log_level ENUM('DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL') NOT NULL COMMENT 'Severity level of the log entry',
    message VARCHAR(1000) NOT NULL COMMENT 'Log message describing the event',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp when the log was created',
    transactions_id INT COMMENT 'Optional reference to related transaction',
    FOREIGN KEY (transactions_id) REFERENCES transactions(transactions_id) COMMENT 'Foreign key reference to transaction (can be NULL)'
);

CREATE INDEX idx_users_phone ON users(phone_number) COMMENT 'Index for fast phone number lookups';
CREATE INDEX idx_transactions_sender ON transactions(sender_id) COMMENT 'Index for finding transactions by sender';
CREATE INDEX idx_transactions_receiver ON transactions(receiver_id) COMMENT 'Index for finding transactions by receiver';
CREATE INDEX idx_transactions_date ON transactions(transaction_date) COMMENT 'Index for filtering transactions by date range';
CREATE INDEX idx_system_logs_created ON system_logs(created_at) COMMENT 'Index for filtering logs by creation date';
CREATE INDEX idx_user_roles_role ON user_roles(roles_id) COMMENT 'Index for finding users by role';