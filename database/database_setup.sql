CREATE TABLE roles (
    roles_id INT PRIMARY KEY,
    role_name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE users (
    users_id INT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20)
);

CREATE TABLE User_roles (
    User_roles_id INT PRIMARY KEY,
    Roles_id INT,
    users_id INT,
    FOREIGN KEY (Roles_id) REFERENCES Roles(Roles_id),
    FOREIGN KEY (users_id) REFERENCES Users(users_id)
);

CREATE TABLE transaction_category (
    Category_id INT PRIMARY KEY,
    transaction_id INT,
    category_name VARCHAR(100)
);

CREATE TABLE Transactions (
    Transaction_id INT PRIMARY KEY,
    Transferred_amount DECIMAL(12, 2),
    Reference_code VARCHAR(100),
    Currency VARCHAR(10),
    Raw_message TEXT,
    transaction_fee DECIMAL(12, 2),
    Transaction_date TIMESTAMP,
    Transaction_type VARCHAR(50),
    New_balance DECIMAL(12, 2),
    Sender_id INT,
    Receiver_id INT,
    Category_id INT,
    FOREIGN KEY (Sender_id) REFERENCES Users(users_id),
    FOREIGN KEY (Receiver_id) REFERENCES Users(users_id),
    FOREIGN KEY (Category_id) REFERENCES transaction_category(Category_id)
);

CREATE TABLE System_logs (
    Log_id INT PRIMARY KEY,
    Transaction_id INT,
    Log_level VARCHAR(50),
    message TEXT,
    Source VARCHAR(100),
    Created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Transaction_id) REFERENCES Transactions(Transaction_id)
);
