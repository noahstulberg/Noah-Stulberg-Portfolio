/*
Email Campaign Analysis Portfolio Project:

Problem Statement: Analyze the effectiveness of various email campaigns conducted by a company.

Database Creation:

Set up a database that records:

- Customer details (id, age, gender, location, etc.)
- Email campaigns (id, start date, end date, campaign theme)
- Customer actions on each email (customer_id, campaign_id, email_opened, link_clicked, purchase_made, etc.)
*/

-- Creating the Customers table

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,  -- Primary key for each customer
    first_name VARCHAR(50),       -- Customer's first name
    last_name VARCHAR(50),        -- Customer's last name
    gender VARCHAR(10),           -- Customer's gender
    age INT,                      -- Customer's age
    location VARCHAR(100)         -- Customer's location
);

-- Populating the Customers table
INSERT INTO Customers (customer_id, first_name, last_name, gender, age, location)
VALUES 
    (1, 'John', 'Doe', 'Male', 35, 'New York'),
    (2, 'Jane', 'Smith', 'Female', 28, 'Los Angeles'),
    (3, 'Bob', 'Johnson', 'Male', 42, 'Chicago'),
    (4, 'Alice', 'Williams', 'Female', 30, 'San Francisco'),
    (5, 'Charlie', 'Brown', 'Male', 29, 'Austin'),
    (6, 'Tom', 'Jackson', 'Male', 36, 'Houston'),
    (7, 'Sandra', 'Brown', 'Female', 45, 'Philadelphia'),
    (8, 'Betty', 'Taylor', 'Female', 31, 'Phoenix'),
    (9, 'Robert', 'Anderson', 'Male', 52, 'San Antonio'),
    (10, 'Kim', 'White', 'Female', 38, 'San Diego');

-- Creating the EmailCampaigns table
CREATE TABLE EmailCampaigns (
    campaign_id INT PRIMARY KEY,  -- Primary key for each campaign
    start_date DATE,              -- Start date of the campaign
    end_date DATE,                -- End date of the campaign
    campaign_theme VARCHAR(100)   -- Theme of the campaign
);

-- Populating the EmailCampaigns table
INSERT INTO EmailCampaigns (campaign_id, start_date, end_date, campaign_theme)
VALUES 
    (1, '2023-01-01', '2023-01-31', 'New Year Sale'),
    (2, '2023-02-01', '2023-02-28', 'Valentines Special'),
    (3, '2023-03-01', '2023-03-31', 'Spring Collection'),
    (4, '2023-04-01', '2023-04-30', 'Easter Extravaganza'),
    (5, '2023-05-01', '2023-05-31', 'Summer Kickoff'),
    (6, '2023-06-01', '2023-06-30', 'Father’s Day Flash Sale'),
    (7, '2023-07-01', '2023-07-31', 'Summer Clearance'),
    (8, '2023-08-01', '2023-08-31', 'Back to School'),
    (9, '2023-09-01', '2023-09-30', 'Fall Fashion'),
    (10, '2023-10-01', '2023-10-31', 'Halloween Special');

-- Creating the EmailActions table
CREATE TABLE EmailActions (
    action_id INT PRIMARY KEY,                     -- Primary key for each action
    customer_id INT,                               -- Foreign key linking to the Customers table
    campaign_id INT,                               -- Foreign key linking to the EmailCampaigns table
    email_opened BOOLEAN,                          -- Indicator if the email was opened
    link_clicked BOOLEAN,                          -- Indicator if a link was clicked in the email
    purchase_made BOOLEAN,                         -- Indicator if a purchase was made after the email
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),      -- Setting up the foreign key
    FOREIGN KEY (campaign_id) REFERENCES EmailCampaigns(campaign_id)  -- Setting up the foreign key


INSERT INTO EmailActions (action_id, customer_id, campaign_id, email_opened, link_clicked, purchase_made)
VALUES 
    (1, 1, 1, TRUE, FALSE, FALSE),
    (2, 2, 1, TRUE, TRUE, TRUE),
    (3, 3, 1, FALSE, FALSE, FALSE),
    (4, 4, 1, TRUE, TRUE, FALSE),
    (5, 5, 1, TRUE, FALSE, FALSE),
    (6, 1, 2, TRUE, TRUE, TRUE),
    (7, 2, 2, TRUE, TRUE, TRUE),
    (8, 3, 2, FALSE, FALSE, FALSE),
    (9, 4, 2, TRUE, TRUE, TRUE),
    (10, 5, 2, TRUE, FALSE, FALSE),
    (11, 1, 3, TRUE, TRUE, FALSE),
    (12, 2, 3, FALSE, FALSE, FALSE),
    (13, 3, 3, FALSE, FALSE, FALSE),
    (14, 4, 3, TRUE, TRUE, TRUE),
    (15, 5, 3, TRUE, TRUE, TRUE),
    (16, 6, 1, TRUE, TRUE, FALSE),
    (17, 7, 1, TRUE, TRUE, TRUE),
    (18, 8, 1, TRUE, FALSE, FALSE),
    (19, 9, 1, FALSE, FALSE, FALSE),
    (20, 10, 1, TRUE, TRUE, TRUE),
    (21, 6, 2, TRUE, TRUE, FALSE),
    (22, 7, 2, FALSE, FALSE, FALSE),
    (23, 8, 2, TRUE, TRUE, TRUE),
    (24, 9, 2, TRUE, FALSE, FALSE),
    (25, 10, 2, TRUE, TRUE, TRUE),
    (26, 6, 3, FALSE, FALSE, FALSE),
    (27, 7, 3, TRUE, TRUE, TRUE),
    (28, 8, 3, TRUE, TRUE, FALSE),
    (29, 9, 3, TRUE, TRUE, TRUE),
    (30, 10, 3, TRUE, FALSE, FALSE)
;

-- Email Campaign Analysis 

-- What is the total number of unique customers reached across all campaigns 
SELECT COUNT(DISTINCT customer_id) AS total_customers_reached
FROM EmailActions
;

-- What is the total number of unique customers reached with each campaign?
SELECT COUNT(DISTINCT customer_id) AS customers_reached
FROM EmailActions
GROUP BY campaign_id
ORDER BY COUNT(DISTINCT customer_id);


-- What is the total volume of opens, clicks, and purchases across all campaigns?
SELECT 
    SUM(CASE WHEN email_opened = 'TRUE' THEN 1 ELSE 0 END) AS total_opens,
    SUM(CASE WHEN link_clicked = 'TRUE' THEN 1 ELSE 0 END) AS total_clicks,
    SUM(CASE WHEN purchase_made = 'TRUE' THEN 1 ELSE 0 END) AS total_purchases
FROM EmailActions;

-- What is the total volume of opens, clicks, and purchases for each campaign?
SELECT 
    ec.campaign_id, 
    ec.campaign_theme, 
    SUM(CASE WHEN e.email_opened = 'TRUE' THEN 1 ELSE 0 END) AS total_opens,
    SUM(CASE WHEN e.link_clicked = 'TRUE' THEN 1 ELSE 0 END) AS total_clicks,
    SUM(CASE WHEN e.purchase_made = 'TRUE' THEN 1 ELSE 0 END) AS total_purchases
FROM EmailCampaigns ec
JOIN EmailActions e ON ec.campaign_id = e.campaign_id
GROUP BY ec.campaign_id, ec.campaign_theme
ORDER BY total_purchases DESC, total_clicks DESC, total_opens DESC;


-- What is the open_rate, click through rate, and purchase rate across all campaigns?
SELECT 
    ROUND((SUM(CASE WHEN email_opened = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS open_rate,
    ROUND((SUM(CASE WHEN link_clicked = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS click_through_rate,
    ROUND((SUM(CASE WHEN purchase_made = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS purchase_rate
FROM EmailActions;

-- What is the open rate, click through rate, and purchase rate for each campaign?
SELECT 
    campaign_id, 
    ROUND((SUM(CASE WHEN email_opened = TRUE THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS open_rate,
    ROUND((SUM(CASE WHEN link_clicked = TRUE THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS click_rate,
    ROUND((SUM(CASE WHEN purchase_made = TRUE THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS purchase_rate
FROM EmailActions
GROUP BY campaign_id;

-- What is the average purchase rate of our email campaigns by gender and location?
SELECT c.gender, c.location, ROUND(AVG(CASE WHEN e.purchase_made = TRUE THEN 1 ELSE 0 END), 2) AS avg_purchase_rate
FROM Customers c
JOIN EmailActions e ON c.customer_id = e.customer_id
GROUP BY c.gender, c.location
ORDER BY avg_purchase_rate DESC;

-- How many customers opened an email but did not click any links or make any purchases?
SELECT COUNT(customer_id) 
FROM EmailActions 
WHERE email_opened = TRUE AND link_clicked = FALSE AND purchase_made = FALSE
;

-- What is the gender breakdown for each campaign?
SELECT 
    ec.campaign_id, 
    c.gender, 
    COUNT(DISTINCT e.customer_id) AS customer_count
FROM EmailCampaigns ec
JOIN EmailActions e ON ec.campaign_id = e.campaign_id
JOIN Customers c ON e.customer_id = c.customer_id
GROUP BY ec.campaign_id, c.gender;



