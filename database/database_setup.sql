-- Create Roles table
CREATE TABLE Roles (
    Roles_id INT PRIMARY KEY AUTO_INCREMENT,
    Role_name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Create Users table
CREATE TABLE Users (
    users_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    Role_id INT,
    FOREIGN KEY (Role_id) REFERENCES Roles(Roles_id)
);

-- Create User_roles junction table
CREATE TABLE User_roles (
    User_roles_id INT PRIMARY KEY AUTO_INCREMENT,
    Roles_id INT,
    users_id INT,
    FOREIGN KEY (Roles_id) REFERENCES Roles(Roles_id),
    FOREIGN KEY (users_id) REFERENCES Users(users_id)
);

-- Create transaction_category table
CREATE TABLE transaction_category (
    Category_id INT PRIMARY KEY AUTO_INCREMENT,
    transaction_id INT,
    category_name VARCHAR(100)
);

-- Create sender table
CREATE TABLE sender (
    sender_id INT PRIMARY KEY AUTO_INCREMENT,
    Phone VARCHAR(20),
    Full_name VARCHAR(255),
    User_type VARCHAR(50),
    now_balance DECIMAL(12, 2)
);

-- Create Transactions table
CREATE TABLE Transactions (
    Transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    Transferred_amount DECIMAL(12, 2),
    Reference_code VARCHAR(100),
    Currency VARCHAR(10),
    Status VARCHAR(50),
    Raw_message TEXT,
    transaction_fee DECIMAL(12, 2),
    Transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Transaction_type VARCHAR(50),
    New_balance DECIMAL(12, 2),
    Sender_id INT,
    Receiver_id INT,
    Category_id INT,
    FOREIGN KEY (Sender_id) REFERENCES Users(users_id),
    FOREIGN KEY (Receiver_id) REFERENCES Users(users_id),
    FOREIGN KEY (Category_id) REFERENCES transaction_category(Category_id)
);

-- Create System_logs table
CREATE TABLE System_logs (
    Log_id INT PRIMARY KEY AUTO_INCREMENT,
    Transaction_id INT,
    Log_level VARCHAR(50),
    message TEXT,
    Source VARCHAR(100),
    Created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Transaction_id) REFERENCES Transactions(Transaction_id)
);
