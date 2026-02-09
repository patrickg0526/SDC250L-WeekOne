/* 
  SDC250 / SDC250L
  Project 2.2 - Manipulating the Database Structure
  Name: Patrick Gonzalez
  Student ID: patgon2554
*/

------------------------------------------------------------
-- Question 1
-- Alter PRODUCTLIST, update from STOREFRONT, drop STOREFRONT
------------------------------------------------------------

ALTER TABLE PRODUCTLIST
  ADD (PRICE NUMBER(8,2),
       DESCRIPTION VARCHAR2(250));

UPDATE PRODUCTLIST p
SET (p.PRICE, p.DESCRIPTION) =
    (SELECT s.PRICE, s.DESCRIPTION
     FROM STOREFRONT s
     WHERE s.PRODUCTCODE = p.PRODUCTCODE)
WHERE EXISTS
    (SELECT 1
     FROM STOREFRONT s
     WHERE s.PRODUCTCODE = p.PRODUCTCODE);

DROP TABLE STOREFRONT;


------------------------------------------------------------
-- Question 2
-- CHATLOG
------------------------------------------------------------

CREATE TABLE CHATLOG (
  CHATID     NUMBER(3) PRIMARY KEY,
  RECEIVERID NUMBER(3),
  SENDERID   NUMBER(3),
  DATESENT   DATE,
  CONTENT    VARCHAR2(250)
);

INSERT INTO CHATLOG
SELECT
  rn,
  receiverid,
  senderid,
  SYSDATE - rn,
  'Sample message #' || rn
FROM (
  SELECT
    ROW_NUMBER() OVER (ORDER BY u1.USERID, u2.USERID) rn,
    u1.USERID receiverid,
    u2.USERID senderid
  FROM USERBASE u1
  CROSS JOIN USERBASE u2
  WHERE u1.USERID <> u2.USERID
)
WHERE rn <= 10;

COMMIT;


------------------------------------------------------------
-- Question 3
-- FRIENDSLIST
------------------------------------------------------------

CREATE TABLE FRIENDSLIST (
  USERID   NUMBER(3),
  FRIENDID NUMBER(3),
  PRIMARY KEY (USERID, FRIENDID)
);

INSERT INTO FRIENDSLIST
SELECT
  a.USERID,
  b.USERID
FROM USERBASE a
CROSS JOIN USERBASE b
WHERE a.USERID <> b.USERID
FETCH FIRST 10 ROWS ONLY;

COMMIT;


------------------------------------------------------------
-- Question 4
-- WISHLIST
------------------------------------------------------------

CREATE TABLE WISHLIST (
  USERID      NUMBER(3),
  PRODUCTCODE VARCHAR2(5),
  POSITION    NUMBER(3),
  PRIMARY KEY (USERID, PRODUCTCODE)
);

INSERT INTO WISHLIST
SELECT
  u.USERID,
  p.PRODUCTCODE,
  1
FROM USERBASE u
CROSS JOIN PRODUCTLIST p
FETCH FIRST 10 ROWS ONLY;

COMMIT;


------------------------------------------------------------
-- Question 5
-- USERPROFILE
------------------------------------------------------------

CREATE TABLE USERPROFILE (
  USERID      NUMBER(3) PRIMARY KEY,
  IMAGEFILE   VARCHAR2(250),
  DESCRIPTION VARCHAR2(250)
);

INSERT INTO USERPROFILE
SELECT
  USERID,
  '/images/profile_' || USERID || '.png',
  'About me for user ' || USERID
FROM USERBASE
FETCH FIRST 10 ROWS ONLY;

COMMIT;


------------------------------------------------------------
-- Question 6
-- SECURITYQUESTION
------------------------------------------------------------

CREATE TABLE SECURITYQUESTION (
  QUESTIONID NUMBER PRIMARY KEY,
  USERID     NUMBER(3),
  QUESTION   VARCHAR2(250),
  ANSWER     VARCHAR2(250)
);

INSERT INTO SECURITYQUESTION
SELECT
  rn,
  USERID,
  'Security question #' || rn,
  'Answer #' || rn
FROM (
  SELECT USERID,
         ROW_NUMBER() OVER (ORDER BY USERID) rn
  FROM USERBASE
)
WHERE rn <= 10;

COMMIT;


------------------------------------------------------------
-- Question 7
-- COMMUNITYRULES
------------------------------------------------------------

CREATE TABLE COMMUNITYRULES (
  RULENUM NUMBER PRIMARY KEY,
  TITLE VARCHAR2(250),
  DESCRIPTION VARCHAR2(250),
  SEVERITYPOINT NUMBER(4)
);

INSERT INTO COMMUNITYRULES
SELECT
  LEVEL,
  'Rule Title ' || LEVEL,
  'Rule Description ' || LEVEL,
  LEVEL * 10
FROM DUAL
CONNECT BY LEVEL <= 10;

COMMIT;


------------------------------------------------------------
-- Question 8
-- INFRACTIONS
------------------------------------------------------------

CREATE TABLE INFRACTIONS (
  INFRACTIONID NUMBER PRIMARY KEY,
  USERID NUMBER(3),
  RULENUM NUMBER(3),
  DATEASSIGNED DATE,
  PENALTY VARCHAR2(250)
);

INSERT INTO INFRACTIONS
SELECT
  rn,
  u.USERID,
  r.RULENUM,
  SYSDATE - rn,
  'Penalty for infraction #' || rn
FROM (
  SELECT USERID,
         ROW_NUMBER() OVER (ORDER BY USERID) rn
  FROM USERBASE
) u
JOIN COMMUNITYRULES r
ON r.RULENUM = u.rn
WHERE u.rn <= 10;

COMMIT;


------------------------------------------------------------
-- Question 9
-- USERSUPPORT
------------------------------------------------------------

CREATE TABLE USERSUPPORT (
  TICKETID NUMBER PRIMARY KEY,
  EMAIL VARCHAR2(250),
  ISSUE VARCHAR2(250),
  DATESUBMITTED DATE,
  DATEUPDATED DATE,
  STATUS VARCHAR2(250)
);

INSERT INTO USERSUPPORT
SELECT
  LEVEL,
  'user' || LEVEL || '@example.com',
  'Support issue #' || LEVEL,
  SYSDATE - (LEVEL + 10),
  SYSDATE - LEVEL,
  CASE
    WHEN MOD(LEVEL,3)=1 THEN 'NEW'
    WHEN MOD(LEVEL,3)=2 THEN 'IN PROGRESS'
    ELSE 'CLOSED'
  END
FROM DUAL
CONNECT BY LEVEL <= 10;

COMMIT;


------------------------------------------------------------
-- Question 10
-- VIEWS
------------------------------------------------------------

CREATE OR REPLACE VIEW VW_UNIQUE_SECURITY_QUESTIONS AS
SELECT DISTINCT QUESTION
FROM SECURITYQUESTION;

CREATE OR REPLACE VIEW VW_OPEN_SUPPORT_TICKETS AS
SELECT
  TICKETID,
  EMAIL,
  ISSUE,
  DATEUPDATED
FROM USERSUPPORT
WHERE STATUS IN ('NEW','IN PROGRESS');
