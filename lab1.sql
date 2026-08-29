/*  Create table users, status, inventory, transaction */
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    email TEXT NOT NULL,
    password TEXT NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP);

CREATE TABLE status (
    id SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE inventory (
    id SERIAL PRIMARY KEY,
    status_id INTEGER REFERENCES status(id),
    description TEXT NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    inventory_id INTEGER REFERENCES inventory(id),
    checkout_time TIMESTAMP NOT NULL,
    scheduled_checkin_time TIMESTAMP,
    actual_checkin_time TIMESTAMP,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

/* Insert 5 values into users table  */
INSERT INTO users (first_name, last_name, email, password, created_at, updated_at)
VALUES
    ('Tram', 'Ngo', 'tramngo@gmail.com', 'password123', '2026-08-01 9:00:00', '2026-08-01 10:00:00'),
    ('Anthony', 'Lam', 'alam@gmail.com', 'password234', '2026-08-02 9:00:00', '2026-08-02 10:00:00'),
    ('Trang', 'Ngo', 'trangnngo@gmail.com', 'password345', '2026-08-03 9:00:00', '2026-08-03 10:00:00'),
    ('An', 'Ngo', 'anngo@gmail.com', 'password567', '2026-08-04 9:00:00', '2020-07-04 10:00:00'),
    ('Lanh', 'Do', 'lanhdo@gmail.com', 'password657', '2026-08-05 9:00:00', '2026-08-04 10:00:00');

/* Insert 5 values into status table*/
INSERT INTO status (description, created_at, updated_at)
VALUES
    ('Available', '2026-08-01 9:00:00', '2026-08-01 10:00:00'),
    ('Checked out', '2026-08-01 11:00:00', '2026-08-01 12:00:00'),
    ('Overdue', '2026-08-01 8:00:00', '2026-08-01 9:00:00'),
    ('Unavailable', '2026-08-01 10:00:00', '2026-08-01 11:00:00'),
    ('Under Repair', '2026-08-01 5:00:00', '2026-08-01 6:00:00');

/* Insert 5 inventory into status table*/
INSERT INTO inventory (status_id, description, created_at, updated_at)
VALUES
    (1, 'Laptop1', '2026-08-04 5:00:00', '2026-08-05 5:00:00'),
    (1, 'Laptop2', '2026-08-07 5:00:00', '2026-08-08 5:00:00'),
    (1, 'Webcam1', '2026-08-08 7:00:00', '2026-08-08 8:00:00'),
    (1, 'TV1', '2026-08-01 7:00:00', '2026-08-01 9:00:00'),
    (1, 'Microphone1', '2026-08-01 10:00:00', '2026-08-01 11:00:00');
/* Insert 3 inventory into transaction table*/
INSERT INTO transactions (user_id, inventory_id, checkout_time, scheduled_checkin_time, actual_checkin_time, created_at, updated_at)
VALUES
(1, 1, '2020-07-20 5:00:00', '2020-08-02 7:00:00', NULL, '2020-07-20 5:00', '2020-07-20 10:00'),
(1, 2, '2020-07-21 5:00:00', '2020-08-21 7:00:00', NULL, '2020-07-21 5:00', '2020-07-21 11:00'),
(2, 3, '2020-07-25 5:00:00', '2020-07-30 7:00:00', NULL, '2020-07-25 5:00', '2020-07-25 12:00');

/* Update the 3 inventory items: since they checked-out, update the invenotry table to check out which is id=2 in status*/
UPDATE inventory
SET status_id = 2
WHERE id IN (1, 2, 3);
/* verify the update*/
SELECT * FROM inventory;

/* add Sign_agreement to users table*/
ALTER TABLE users
ADD COLUMN signed_agreement BOOLEAN DEFAULT FALSE;
/* check if it was added \d users */

/* List of checked-out equipment + scheduled return*/

SELECT
    inventory.description,
    transactions.scheduled_checkin_time
FROM inventory
JOIN transactions
    ON inventory.id = transactions.inventory_id
JOIN status
    ON inventory.status_id = status.id
WHERE status.description = 'Checked out'
ORDER BY transactions.scheduled_checkin_time DESC;

/*Write a query that returns a list of all equipment due after July 31, 2020.*/
SELECT
    inventory.description,
    transactions.scheduled_checkin_time
FROM inventory
JOIN transactions
    ON inventory.id = transactions.inventory_id
WHERE transactions.scheduled_checkin_time > '2020-07-31';

/*Write a query that returns a count of the number of items with a status of Checked out by user_id 1.*/
SELECT COUNT(*)
FROM transactions
JOIN inventory
    ON transactions.inventory_id = inventory.id
JOIN status
    ON inventory.status_id = status.id
WHERE transactions.user_id = 1
  AND status.description = 'Checked out';
