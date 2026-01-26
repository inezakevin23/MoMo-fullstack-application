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
    FOREIGN KEY (roles_id) REFERENCES roles(roles_id),
    FOREIGN KEY (users_id) REFERENCES users(users_id),
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
    transaction_fee DECIMAL(10, 2) DEFAULT 0 COMMENT 'Transaction fee charged (must not be negative)',
    transaction_date DATETIME NOT NULL COMMENT 'Date and time when the transaction occurred',
    new_balance DECIMAL(15, 2) COMMENT 'New balance of end user after transaction',
    sender_id INT NOT NULL COMMENT 'Reference to the user sending money',
    receiver_id INT NOT NULL COMMENT 'Reference to the user receiving money',
    transaction_category_id INT NOT NULL COMMENT 'Reference to the transaction category',
    CHECK (transaction_fee >= 0),
    CHECK (transferred_amount > 0),
    CHECK (sender_id != receiver_id),
    FOREIGN KEY (sender_id) REFERENCES users(users_id),
    FOREIGN KEY (receiver_id) REFERENCES users(users_id),
    FOREIGN KEY (transaction_category_id) REFERENCES transaction_category(transaction_category_id)
);

CREATE TABLE system_logs (
    system_logs_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Unique identifier for each log entry',
    log_level ENUM('DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL') NOT NULL COMMENT 'Severity level of the log entry',
    message VARCHAR(1000) NOT NULL COMMENT 'Log message describing the event',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp when the log was created',
    transactions_id INT COMMENT 'Optional reference to related transaction',
    FOREIGN KEY (transactions_id) REFERENCES transactions(transactions_id)
);

CREATE INDEX idx_users_phone ON users(phone_number) COMMENT 'Index for fast phone number lookups';
CREATE INDEX idx_transactions_sender ON transactions(sender_id) COMMENT 'Index for finding transactions by sender';
CREATE INDEX idx_transactions_receiver ON transactions(receiver_id) COMMENT 'Index for finding transactions by receiver';
CREATE INDEX idx_transactions_date ON transactions(transaction_date) COMMENT 'Index for filtering transactions by date range';
CREATE INDEX idx_system_logs_created ON system_logs(created_at) COMMENT 'Index for filtering logs by creation date';
CREATE INDEX idx_user_roles_role ON user_roles(roles_id) COMMENT 'Index for finding users by role';

INSERT INTO roles (role_name, description) VALUES
('sender', 'User who initiates a transaction or sends money'),
('receiver', 'User who receives money in a transaction');

INSERT INTO users (full_name, phone_number) VALUES
('Keza Irene', '250788999990'),
('Kabera Dorcas', '250791666666'),
('Mwiza Zawadi', '250791666662'),
('Mugisha Fabrice', '250788999997'),
('MTN Agent', NULL),
('Bank system', NULL);

INSERT INTO user_roles (users_id, roles_id) VALUES
(1, 1), -- Keza Irene is a sender (Keza Irene sent money to kabera Dorcas)
(2, 2), -- Kabera Dorcas is a receiver (Kabera Dorcas received money from Keza Irene)
(4, 2), -- Mugisha Fabrice is a receiver (Mugisha Fabrice has received payment from Keza Irene)
(1, 2), -- Keza Irene is also a receiver (Keza Irene received money from Mwiza Zawadi)
(3, 1), -- Mwiza Zawadi is a sender (Mwiza Zawadi sent money to Keza Irene)
(5, 2), -- MTN Agent is a receiver (Keza Irene bought MTN airtime)
(6, 1); -- Bank system is a sender (Bank deposits money to mobile money of Keza Irene)

INSERT INTO transaction_category (category_name) VALUES
('transfer'),
('payment'),
('deposit'),
('withdrawal'),
('airtime');

INSERT INTO transactions (transferred_amount, reference_code, currency, transaction_fee, transaction_date, new_balance, sender_id, receiver_id, transaction_category_id) VALUES
-- Transaction 1: Keza Irene sent money to kabera Dorcas
(2000, '76662021700', 'RWF', 100, '2024-05-10 16:30:51', 2000, 1, 2, 1),
-- Transaction 2: Keza Irene has paid money to Mugisha Fabrice
(1000, '73214484437', 'RWF', 100, '2024-05-10 18:31:39', 900, 4, 1, 2),
-- Transaction 3: Keza Irene received money from Mwiza Zawadi
(6000, '51732411227', 'RWF', 0, '2024-05-11 21:32:32', 6900, 3, 1, 1),
-- Transaction 4:  Bank deposits money to mobile money of Keza Irene
(40000, '40000_bank_deposit_05_11', 'RWF', 0, '2024-05-12 18:43:49', 46900, 6, 1, 3),
-- Transaction 5: Keza Irene bought MTN airtime (airtime payment)
(3000, '17818959211', 'RWF', 0, '2024-05-11 18:48:42', 43900, 1, 5, 5);

INSERT INTO system_logs (log_level, message, transactions_id) VALUES
('INFO', 'Transaction sms processed successfully', 1),
('INFO', 'payment sms processed successfully', 2),
('INFO', 'Transaction processed successfully', 3),
('INFO', 'Bank deposit sms processed successfully', 4),
('INFO', 'Airtime purchase sms processed successfully', 5),
('ERROR', 'system rejected transaction because no amount found', NULL);
