-- Question 1
-- Display USER_ID, USERNAME, CREATED, and PASSWORD_CHANGE_DATE
SELECT USER_ID, USERNAME, CREATED, PASSWORD_CHANGE_DATE
FROM USER_USERS;

-- Question 2
-- Display all tables in the database
SELECT *
FROM USER_TABLES;

-- Question 3a
-- Describe the ORDERS table
DESC ORDERS;

-- Question 3b
-- Describe the PRODUCTLIST table
DESC PRODUCTLIST;

-- Question 3c
-- Describe the REVIEWS table
DESC REVIEWS;

-- Question 3d
-- Describe the STOREFRONT table
DESC STOREFRONT;

-- Question 3e
-- Describe the USERBASE table
DESC USERBASE;

-- Question 3f
-- Describe the USERLIBRARY table
DESC USERLIBRARY;

-- Question 4a
-- Display all data in the ORDERS table
SELECT *
FROM ORDERS;

-- Question 4b
-- Display all data in the PRODUCTLIST table
SELECT *
FROM PRODUCTLIST;

-- Question 4c
-- Display all data in the REVIEWS table
SELECT *
FROM REVIEWS;

-- Question 4d
-- Display all data in the STOREFRONT table
SELECT *
FROM STOREFRONT;

-- Question 4e
-- Display all data in the USERBASE table
SELECT *
FROM USERBASE;

-- Question 4f
-- Display all data in the USERLIBRARY table
SELECT *
FROM USERLIBRARY;

-- Question 5
-- Display database constraints
SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE, STATUS
FROM USER_CONSTRAINTS;

-- Question 6
-- Display database views
SELECT VIEW_NAME, TEXT
FROM USER_VIEWS;

-- Question 7
-- Display every USERNAME in alphabetical order
SELECT USERNAME
FROM USERBASE
ORDER BY USERNAME ASC;

-- Question 8
-- Display users with Yahoo email addresses
SELECT FIRSTNAME, LASTNAME, USERNAME, PASSWORD, EMAIL
FROM USERBASE
WHERE LOWER(EMAIL) LIKE '%yahoo%';

-- Question 9
-- Display users with less than $25 in wallet funds
SELECT USERNAME, BIRTHDAY, WALLETFUNDS
FROM USERBASE
WHERE WALLETFUNDS < 25;

-- Question 10
-- Display users with more than 100 hours played
SELECT USERID, PRODUCTCODE
FROM USERLIBRARY
WHERE HOURSPLAYED > 100;

-- Question 11
-- Display games with less than 10 hours played
SELECT PRODUCTCODE
FROM USERLIBRARY
WHERE HOURSPLAYED < 10;

-- Question 12
-- Display every unique publisher
SELECT DISTINCT PUBLISHER
FROM PRODUCTLIST;

-- Question 13
-- Display products sorted by genre
SELECT PRODUCTNAME, RELEASEDATE, PUBLISHER, GENRE
FROM PRODUCTLIST
ORDER BY GENRE ASC;

-- Question 14
-- Display strategy genre products
SELECT PRODUCTCODE, PUBLISHER
FROM PRODUCTLIST
WHERE GENRE = 'Strategy';

-- Question 15
-- Display products costing more than $25, sorted by descending price
SELECT PRODUCTCODE, DESCRIPTION, PRICE
FROM STOREFRONT
WHERE PRICE > 25
ORDER BY PRICE DESC;

-- Question 16
-- Display inventory sorted by ascending price
SELECT INVENTORYID, PRICE
FROM STOREFRONT
ORDER BY PRICE ASC;

-- Question 17
-- Display reviews with rating of 1
SELECT PRODUCTCODE, REVIEW
FROM REVIEWS
WHERE RATING = 1;

-- Question 18
-- Display reviews with rating of 4 or higher
SELECT PRODUCTCODE, REVIEW
FROM REVIEWS
WHERE RATING >= 4;

-- Question 19
-- Display unique users who placed an order
SELECT DISTINCT USERID
FROM ORDERS;

-- Question 20
-- Display all orders sorted by earliest purchase date
SELECT *
FROM ORDERS
ORDER BY PURCHASEDATE ASC;
