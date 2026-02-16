-- Add Referential Integrity
-- Patrick Gonzalez
-- SDC250L Project Part 3


--------------------------------------------------
-- Question 1: Foreign Keys
--------------------------------------------------

ALTER TABLE ORDERS DROP CONSTRAINT fk_orders_user;
ALTER TABLE REVIEWS DROP CONSTRAINT fk_reviews_user;
ALTER TABLE USERLIBRARY DROP CONSTRAINT fk_userlib_user;

ALTER TABLE REVIEWS DROP CONSTRAINT fk_reviews_product;
ALTER TABLE USERLIBRARY DROP CONSTRAINT fk_userlib_product;

ALTER TABLE ORDERS
ADD CONSTRAINT fk_orders_user
FOREIGN KEY (USERID)
REFERENCES USERBASE(USERID);

ALTER TABLE REVIEWS
ADD CONSTRAINT fk_reviews_user
FOREIGN KEY (USERID)
REFERENCES USERBASE(USERID);

ALTER TABLE REVIEWS
ADD CONSTRAINT fk_reviews_product
FOREIGN KEY (PRODUCTCODE)
REFERENCES PRODUCTLIST(PRODUCTCODE);

ALTER TABLE USERLIBRARY
ADD CONSTRAINT fk_userlib_user
FOREIGN KEY (USERID)
REFERENCES USERBASE(USERID);

ALTER TABLE USERLIBRARY
ADD CONSTRAINT fk_userlib_product
FOREIGN KEY (PRODUCTCODE)
REFERENCES PRODUCTLIST(PRODUCTCODE);


--------------------------------------------------
-- Question 2
--------------------------------------------------

SELECT FIRSTNAME || ' ' || LASTNAME AS FULLNAME,
       USERNAME
FROM USERBASE
WHERE FLOOR(MONTHS_BETWEEN(SYSDATE, BIRTHDAY) / 12) >= 18;


--------------------------------------------------
-- Question 3
--------------------------------------------------

SELECT MAX(LENGTH(USERNAME)) AS MAX_USERNAME_LENGTH,
       AVG(LENGTH(USERNAME)) AS AVG_USERNAME_LENGTH
FROM USERBASE;


--------------------------------------------------
-- Question 4
--------------------------------------------------

SELECT QUESTION
FROM SECURITYQUESTION
WHERE QUESTION LIKE 'What is%'
   OR QUESTION LIKE 'What was%';


--------------------------------------------------
-- Question 5
--------------------------------------------------

SELECT PRODUCTCODE,
       MIN(RATING) AS LOWEST_RATING,
       COUNT(*) AS REVIEW_COUNT
FROM REVIEWS
GROUP BY PRODUCTCODE
ORDER BY REVIEW_COUNT DESC;


--------------------------------------------------
-- Question 6
--------------------------------------------------

SELECT PRODUCTCODE,
       COUNT(*) AS USER_COUNT
FROM WISHLIST
WHERE POSITION = 1
GROUP BY PRODUCTCODE;


--------------------------------------------------
-- Question 7
--------------------------------------------------

SELECT USERID,
       SUM(PRICE) AS TOTAL_SPENT
FROM ORDERS
GROUP BY USERID;


--------------------------------------------------
-- Question 8
--------------------------------------------------

SELECT PURCHASEDATE,
       SUM(PRICE) AS GROSS_PROFIT
FROM ORDERS
GROUP BY PURCHASEDATE
ORDER BY GROSS_PROFIT DESC;


--------------------------------------------------
-- Question 9
--------------------------------------------------

SELECT PRODUCTCODE,
       SUM(HOURSPLAYED) AS TOTAL_HOURS
FROM USERLIBRARY
GROUP BY PRODUCTCODE
ORDER BY TOTAL_HOURS DESC
FETCH FIRST 5 ROWS ONLY;


--------------------------------------------------
-- Question 10
--------------------------------------------------

CREATE OR REPLACE VIEW USER_INFRACTIONS AS
SELECT USERID,
       COUNT(*) AS INFRACTION_COUNT
FROM INFRACTIONS
GROUP BY USERID
ORDER BY INFRACTION_COUNT DESC;


--------------------------------------------------
-- Question 11
--------------------------------------------------

CREATE OR REPLACE VIEW USER_RULE_VIOLATIONS AS
SELECT USERID,
       RULENUM,
       COUNT(*) AS VIOLATION_COUNT
FROM INFRACTIONS
GROUP BY USERID, RULENUM
ORDER BY USERID;


--------------------------------------------------
-- Question 12
--------------------------------------------------

SELECT RULENUM,
       PENALTY,
       COUNT(*) AS PENALTY_COUNT
FROM INFRACTIONS
GROUP BY RULENUM, PENALTY;


--------------------------------------------------
-- Question 13
--------------------------------------------------

SELECT AVG(DATEUPDATED - DATESUBMITTED) AS AVG_TIME,
       MAX(DATEUPDATED - DATESUBMITTED) AS MAX_TIME,
       MIN(DATEUPDATED - DATESUBMITTED) AS MIN_TIME
FROM USERSUPPORT
WHERE STATUS = 'CLOSED';


--------------------------------------------------
-- Question 14
--------------------------------------------------

SELECT EMAIL,
       ISSUE,
       COUNT(*) AS ISSUE_COUNT
FROM USERSUPPORT
WHERE STATUS = 'NEW'
GROUP BY EMAIL, ISSUE, DATESUBMITTED
ORDER BY ISSUE_COUNT DESC;


--------------------------------------------------
-- Question 15
--------------------------------------------------

SELECT USERID,
       FIRSTNAME,
       LASTNAME,
       PASSWORD
FROM USERBASE
WHERE LOWER(PASSWORD) LIKE '%' || LOWER(FIRSTNAME) || '%'
   OR LOWER(PASSWORD) LIKE '%' || LOWER(LASTNAME) || '%';


--------------------------------------------------
-- Question 16
--------------------------------------------------

SELECT PUBLISHER,
       AVG(PRICE) AS AVG_PRICE
FROM PRODUCTLIST
GROUP BY PUBLISHER
ORDER BY PUBLISHER;


--------------------------------------------------
-- Question 17
--------------------------------------------------

CREATE OR REPLACE VIEW DISCOUNTED_OLD_PRODUCTS AS
SELECT PRODUCTNAME,
       PRICE * 0.75 AS DISCOUNT_PRICE
FROM PRODUCTLIST
WHERE RELEASEDATE <= ADD_MONTHS(SYSDATE, -60);


--------------------------------------------------
-- Question 18
--------------------------------------------------

SELECT GENRE,
       MAX(PRICE) AS MAX_PRICE,
       MIN(PRICE) AS MIN_PRICE
FROM PRODUCTLIST
GROUP BY GENRE;


--------------------------------------------------
-- Question 19
--------------------------------------------------

CREATE OR REPLACE VIEW RECENT_CHATLOG AS
SELECT *
FROM CHATLOG
WHERE DATESENT BETWEEN SYSDATE - 7 AND SYSDATE;


--------------------------------------------------
-- Question 20
--------------------------------------------------

CREATE OR REPLACE VIEW RECENT_PENALTIES AS
SELECT USERID,
       DATEASSIGNED,
       PENALTY
FROM INFRACTIONS
WHERE PENALTY IS NOT NULL
  AND DATEASSIGNED >= ADD_MONTHS(SYSDATE, -1);
