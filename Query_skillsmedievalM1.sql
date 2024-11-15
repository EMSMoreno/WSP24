use DB_skillsmedieval_EduardoMoreno_M1
go

/*
-- 2. Clients Table
CREATE TABLE clients (
    client_id INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    taxpayer_number VARCHAR(20) UNIQUE NOT NULL,  -- Unique Tax Payer Number
    address VARCHAR(255),
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20),
    state VARCHAR(20) CHECK (state IN ('Active', 'Inactive')) DEFAULT 'Inactive', -- Client Status
    registration_date DATETIME DEFAULT GETDATE() -- Client Registration Date
);

-- Organizers Table
CREATE TABLE organizers (
    organizer_id INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment
    name VARCHAR(255) NOT NULL,
    locality VARCHAR(100),
    taxpayer_number VARCHAR(20) NOT NULL -- Unique Tax Payer Number
);

-- Events Table
CREATE TABLE events (
    event_id INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment
    title VARCHAR(255) NOT NULL,
    description TEXT,
    start_date DATETIME,
    end_date DATETIME,
    location VARCHAR(255),
    organizer_id INT,
    facebook_link VARCHAR(255),
    instagram_link VARCHAR(255),
    tiktok_link VARCHAR(255),
    FOREIGN KEY (organizer_id) REFERENCES organizers(organizer_id) -- Relationship with Organizers
);

-- User Table (Knights/Protectors)
CREATE TABLE users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    address VARCHAR(255),
    phone_number VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    role VARCHAR(20) CHECK (role IN ('Admin', 'Moderator', 'Knight', 'Other')) DEFAULT 'Other', -- User Function
    registration_date DATETIME DEFAULT GETDATE() -- Registration Date User
);

-- User Access Log Table
CREATE TABLE user_access_log (
    log_id INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment
    user_id INT,
    login_time DATETIME DEFAULT GETDATE(),
    logout_time DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(user_id) -- Relationship with Users
);

-- Warehouses Table
CREATE TABLE warehouses (
    warehouse_id INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255)
);

-- Costumes Table
CREATE TABLE costumes (
    costume_id INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment
    reference_code VARCHAR(50) UNIQUE NOT NULL,  -- Rental availability (1 = available, 0 = not available)
    name VARCHAR(255) NOT NULL,
    available_for_rent BIT DEFAULT 1,  -- Rental availability (1 = available, 0 = not available)
    rental_price DECIMAL(10, 2) NOT NULL, -- Rental Price
    warehouse_id INT,
    image_path VARCHAR(255), -- Image Path
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id) -- Relationship with Warehouses
);

-- Rentals Table
CREATE TABLE rentals (
    rental_id INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment
    client_id INT,
    user_id INT,
    rental_date DATETIME DEFAULT GETDATE(),
    return_date DATETIME,
    status VARCHAR(20) CHECK (status IN ('In Progress', 'Completed')) DEFAULT 'In Progress', -- Rental Status
    FOREIGN KEY (client_id) REFERENCES clients(client_id), -- Relationship with Users
    FOREIGN KEY (user_id) REFERENCES users(user_id) -- Relationship with Users
);

-- Rental Items Table (Rental Costumes)
CREATE TABLE rental_items (
    rental_item_id INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment
    rental_id INT,
    costume_id INT,
    quantity INT DEFAULT 1,  -- Number of Outfits rented
    FOREIGN KEY (rental_id) REFERENCES rentals(rental_id), -- Relationship with Rentals
    FOREIGN KEY (costume_id) REFERENCES costumes(costume_id) -- Relationship with Costumes
);

-- Rent Returns Table
CREATE TABLE rental_returns (
    return_id INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment
    rental_id INT,
    return_date DATETIME DEFAULT GETDATE(),
    status VARCHAR(20) CHECK (status IN ('Returned', 'Not Returned')) DEFAULT 'Not Returned', -- Return Status
    FOREIGN KEY (rental_id) REFERENCES rentals(rental_id) -- Relationship with Rentals
);

-- Event Outfit Table (Connects Outfits to Events)
CREATE TABLE event_costumes (
    event_costume_id INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment
    event_id INT,
    costume_id INT,
    FOREIGN KEY (event_id) REFERENCES events(event_id), -- Relationshp with Events
    FOREIGN KEY (costume_id) REFERENCES costumes(costume_id) -- Relationship with Costumes
);
*/

/*
-- 3. Trigger to change the costume's state to "not available" when it is rented

CREATE TRIGGER trg_update_costume_availability
ON rental_items
AFTER INSERT
AS
BEGIN
    -- Updates costume status to "not available" after rental
    UPDATE costumes
    SET available_for_rent = 0  -- Costume will be marked as unavailable
    FROM costumes c
    INNER JOIN inserted i ON c.costume_id = i.costume_id
    WHERE i.costume_id = c.costume_id;
END;
*/

/*
-- 4. Creates a stored procedure so that after creating a costume it becomes unavailable for use.

-- Creating the Stored Procedure
CREATE PROCEDURE MarkCostumeAsUnavailable
    @costume_id INT -- ID of the costume to be marked as unavailable
AS
BEGIN
    -- Update the costume's availability to "unavailable" after creation
    UPDATE costumes
    SET available_for_rent = 0  -- Mark the costume as unavailable for rental
    WHERE costume_id = @costume_id;

    -- Message to confirm the update
    PRINT 'Costume marked as unavailable for rental.';
END;

*/

/* -- 5. Insert data (with at least 5 records) into the tables.


INSERT INTO clients (first_name, last_name, taxpayer_number, address, email, phone_number, state)
VALUES 
    ('John', 'Doe', '123456789', '123 Medieval St, Camelot', 'john.doe@example.com', '123-456-7890', 'Active'),
    ('Alice', 'Smith', '987654321', '456 Kings Rd, Camelot', 'alice.smith@example.com', '234-567-8901', 'Active'),
    ('Bob', 'Johnson', '112233445', '789 Queens Blvd, Camelot', 'bob.johnson@example.com', '345-678-9012', 'Inactive'),
    ('Emily', 'Davis', '667788990', '101 Knight Way, Camelot', 'emily.davis@example.com', '456-789-0123', 'Active'),
    ('Michael', 'Brown', '223344556', '202 Royal Ave, Camelot', 'michael.brown@example.com', '567-890-1234', 'Inactive');

	-- Inserting data into the organizers table
INSERT INTO organizers (name, locality, taxpayer_number)
VALUES 
    ('King Arthur''s Tournament', 'Camelot', '555123456'),
    ('Medieval Knights Fair', 'Excalibur', '555654321'),
    ('Dragon Festival', 'Kingdom of Avalon', '555789012'),
    ('Camelot Renaissance', 'Camelot', '555345678'),
    ('Legends of the Round Table', 'Camelot', '555987654');

	-- Inserting data into the events table
INSERT INTO events (title, description, start_date, end_date, location, organizer_id, facebook_link, instagram_link, tiktok_link)
VALUES 
    ('Jousting Tournament', 'A thrilling jousting competition.', '2024-12-01 10:00:00', '2024-12-01 17:00:00', 'Camelot Arena', 1, 'https://facebook.com/jousting', 'https://instagram.com/jousting', 'https://tiktok.com/@jousting'),
    ('Medieval Feast', 'Join us for a grand medieval feast with music and dance.', '2024-12-05 18:00:00', '2024-12-05 22:00:00', 'Camelot Great Hall', 2, 'https://facebook.com/medievalfeast', 'https://instagram.com/medievalfeast', 'https://tiktok.com/@medievalfeast'),
    ('Dragon Fire Festival', 'A spectacular display of fire-breathing dragons.', '2024-12-10 19:00:00', '2024-12-10 23:00:00', 'Avalon Arena', 3, 'https://facebook.com/dragonfirefestival', 'https://instagram.com/dragonfirefestival', 'https://tiktok.com/@dragonfirefestival'),
    ('Royal Ball', 'An elegant ball with nobles from all kingdoms.', '2024-12-12 20:00:00', '2024-12-12 23:59:00', 'Camelot Ballroom', 4, 'https://facebook.com/royalball', 'https://instagram.com/royalball', 'https://tiktok.com/@royalball'),
    ('Knight''s Oath Ceremony', 'A ceremonial oath of allegiance by the knights.', '2024-12-15 14:00:00', '2024-12-15 16:00:00', 'Camelot Castle', 5, 'https://facebook.com/knightsoath', 'https://instagram.com/knightsoath', 'https://tiktok.com/@knightsoath');

	-- Inserting data into the users table
INSERT INTO users (first_name, last_name, address, phone_number, email, password, role)
VALUES 
    ('Arthur', 'Pendragon', 'Camelot Castle', '678-123-4567', 'arthur@camelot.com', 'password123', 'Admin'),
    ('Lancelot', 'du Lac', 'Knights Hall, Camelot', '789-234-5678', 'lancelot@camelot.com', 'password123', 'Knight'),
    ('Gawain', 'of Orkney', 'Camelot Castle', '890-345-6789', 'gawain@camelot.com', 'password123', 'Moderator'),
    ('Guinevere', 'Pendragon', 'Camelot Castle', '123-456-7890', 'guinevere@camelot.com', 'password123', 'Admin'),
    ('Merlin', 'the Wizard', 'Merlin''s Tower, Camelot', '234-567-8901', 'merlin@camelot.com', 'password123', 'Other');

	-- Inserting data into the user_access_log table
INSERT INTO user_access_log (user_id, login_time, logout_time)
VALUES 
    (1, '2024-11-01 08:00:00', '2024-11-01 16:00:00'),
    (2, '2024-11-02 09:00:00', '2024-11-02 17:00:00'),
    (3, '2024-11-03 10:00:00', '2024-11-03 18:00:00'),
    (4, '2024-11-04 11:00:00', '2024-11-04 19:00:00'),
    (5, '2024-11-05 12:00:00', '2024-11-05 20:00:00');

	-- Inserting data into the warehouses table
INSERT INTO warehouses (name, location)
VALUES 
    ('Camelot Warehouse', 'Camelot Castle'),
    ('Excalibur Warehouse', 'Excalibur City'),
    ('Avalon Warehouse', 'Avalon Kingdom'),
    ('Royal Warehouse', 'Camelot Castle'),
    ('Dragonstone Warehouse', 'Dragonstone Castle');

	-- Inserting data into the costumes table
INSERT INTO costumes (reference_code, name, available_for_rent, rental_price, warehouse_id, image_path)
VALUES 
    ('R001', 'Knight Armor', 1, 150.00, 1, 'images/knight_armor.jpg'),
    ('R002', 'Jester Costume', 1, 75.00, 2, 'images/jester_costume.jpg'),
    ('R003', 'Princess Gown', 1, 120.00, 3, 'images/princess_gown.jpg'),
    ('R004', 'Dragon Slayer Armor', 1, 200.00, 4, 'images/dragon_slayer_armor.jpg'),
    ('R005', 'Royal Robes', 1, 180.00, 5, 'images/royal_robes.jpg');

	-- Inserting data into the rentals table
INSERT INTO rentals (client_id, user_id, rental_date, return_date, status)
VALUES 
    (1, 2, '2024-11-01 10:00:00', '2024-11-02 12:00:00', 'In Progress'),
    (2, 3, '2024-11-02 09:00:00', '2024-11-03 12:00:00', 'In Progress'),
    (3, 4, '2024-11-03 14:00:00', '2024-11-04 16:00:00', 'Completed'),
    (4, 5, '2024-11-04 08:00:00', '2024-11-05 10:00:00', 'Completed'),
    (5, 1, '2024-11-05 11:00:00', '2024-11-06 13:00:00', 'In Progress');

	-- Inserting data into the rental_items table
INSERT INTO rental_items (rental_id, costume_id, quantity)
VALUES 
    (1, 1, 1),
    (2, 2, 2),
    (3, 3, 1),
    (4, 4, 1),
    (5, 5, 1);

	-- Inserting data into the rental_returns table
INSERT INTO rental_returns (rental_id, return_date, status)
VALUES 
    (1, '2024-11-02 12:00:00', 'Returned'),
    (2, '2024-11-03 12:00:00', 'Returned'),
    (3, '2024-11-04 16:00:00', 'Returned'),
    (4, '2024-11-05 10:00:00', 'Returned'),
    (5, '2024-11-06 13:00:00', 'Not Returned');

	
-- Inserting data into the event_costumes table
INSERT INTO event_costumes (event_id, costume_id)
VALUES 
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);

-- See Data in the Tables

SELECT * FROM dbo.clients;
SELECT * FROM dbo.costumes;
SELECT * FROM dbo.event_costumes;
SELECT * FROM dbo.events;
SELECT * FROM dbo.organizers; 
SELECT * FROM dbo.rental_items;
SELECT * FROM dbo.rental_returns;
SELECT * FROM dbo.user_access_log;
SELECT * FROM dbo.users;
SELECT * FROM dbo.warehouses;

*/


/* -- Module 3 - Validations Password

ALTER TABLE users
ADD 
    is_locked BIT DEFAULT 0,  -- Se a conta está bloqueada (0 = não bloqueada, 1 = bloqueada)
    failed_login_attempts INT DEFAULT 0,  -- Contador de tentativas de login falhadas
    pin_code VARCHAR(4),  -- PIN para desbloqueio de conta
    password_changed BIT DEFAULT 0;  -- Se a senha foi alterada após o primeiro login

*/

