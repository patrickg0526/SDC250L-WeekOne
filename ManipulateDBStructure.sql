/*
  SDC250L
  Project 2.2 - Manipulating the Database Structure
  Name: Patrick Gonzalez
*/

------------------------------------------------------------
-- Question 1: Alter PRODUCTLIST, update from STOREFRONT, drop STOREFRONT
------------------------------------------------------------

-- Add PRICE and DESCRIPTION columns to PRODUCTLIST
ALTER TABLE productlist
ADD (
  price NUMBER(8,2),
  description VARCHAR2(250)
);

-- Move PRICE and DESCRIPTION data from STOREFRONT into PRODUCTLIST
UPDATE productlist p
SET (p.price, p.description) =
(
  SELECT s.price, s.description
  FROM storefront s
  WHERE s.productcode = p.productcode
)
WHERE EXISTS
(
  SELECT 1
  FROM storefront s
  WHERE s.productcode = p.productcode
);

-- Drop STOREFRONT table
DROP TABLE storefront;


------------------------------------------------------------
-- Question 2: Create CHATLOG table and insert sample data
------------------------------------------------------------

CREATE TABLE chatlog (
  chatid     NUMBER(3),
  receiverid NUMBER(3),
  senderid   NUMBER(3),
  datesent   DATE,
  content    VARCHAR2(250),
  CONSTRAINT chatlog_pk PRIMARY KEY (chatid),
  CONSTRAINT chatlog_receiver_fk FOREIGN KEY (receiverid)
    REFERENCES userbase(userid),
  CONSTRAINT chatlog_sender_fk FOREIGN KEY (senderid)
    REFERENCES userbase(userid)
);

INSERT INTO chatlog (chatid, receiverid, senderid, datesent, content)
SELECT rn,
       receiverid,
       senderid,
       SYSDATE - rn,
       'Sample message #' || rn
FROM (
  SELECT ROW_NUMBER() OVER (ORDER BY u1.userid, u2.userid) rn,
         u1.userid receiverid,
         u2.userid senderid
  FROM userbase u1
  CROSS JOIN userbase u2
  WHERE u1.userid <> u2.userid
)
WHERE rn <= 10;


------------------------------------------------------------
-- Question 3: Create FRIENDSLIST table and insert sample data
------------------------------------------------------------

CREATE TABLE friendslist (
  userid   NUMBER(3),
  friendid NUMBER(3),
  CONSTRAINT friendslist_pk PRIMARY KEY (userid, friendid),
  CONSTRAINT friendslist_user_fk FOREIGN KEY (userid)
    REFERENCES userbase(userid),
  CONSTRAINT friendslist_friend_fk FOREIGN KEY (friendid)
    REFERENCES userbase(userid)
);

INSERT INTO friendslist (userid, friendid)
SELECT a.userid,
       b.userid
FROM userbase a
JOIN userbase b
  ON a.userid <> b.userid
FETCH FIRST 10 ROWS ONLY;


------------------------------------------------------------
-- Question 4: Create WISHLIST table and insert sample data
------------------------------------------------------------

CREATE TABLE wishlist (
  userid      NUMBER(3),
  productcode VARCHAR2(5),
  position    NUMBER(3),
  CONSTRAINT wishlist_pk PRIMARY KEY (userid, productcode),
  CONSTRAINT wishlist_user_fk FOREIGN KEY (userid)
    REFERENCES userbase(userid),
  CONSTRAINT wishlist_product_fk FOREIGN KEY (productcode)
    REFERENCES productlist(productcode)
);

INSERT INTO wishlist (userid, productcode, position)
SELECT u.userid,
       p.productcode,
       ROW_NUMBER() OVER (PARTITION BY u.userid ORDER BY p.productcode)
FROM userbase u
JOIN productlist p
  ON 1 = 1
FETCH FIRST 10 ROWS ONLY;


------------------------------------------------------------
-- Question 5: Create USERPROFILE table and insert sample data
------------------------------------------------------------

CREATE TABLE userprofile (
  userid      NUMBER(3),
  imagefile   VARCHAR2(250),
  description VARCHAR2(250),
  CONSTRAINT userprofile_pk PRIMARY KEY (userid),
  CONSTRAINT userprofile_user_fk FOREIGN KEY (userid)
    REFERENCES userbase(userid)
);

INSERT INTO userprofile (userid, imagefile, description)
SELECT userid,
       '/images/profile_' || userid || '.png',
       'About me for user ' || userid
FROM userbase
FETCH FIRST 10 ROWS ONLY;


------------------------------------------------------------
-- Question 6: Create SECURITYQUESTION table and insert sample data
------------------------------------------------------------

CREATE TABLE securityquestion (
  questionid NUMBER,
  userid     NUMBER(3),
  question   VARCHAR2(250),
  answer     VARCHAR2(250),
  CONSTRAINT securityquestion_pk PRIMARY KEY (questionid),
  CONSTRAINT securityquestion_user_fk FOREIGN KEY (userid)
    REFERENCES userbase(userid)
);

INSERT INTO securityquestion (questionid, userid, question, answer)
SELECT rn,
       userid,
       'Security question #' || rn,
       'Answer #' || rn
FROM (
  SELECT userid,
         ROW_NUMBER() OVER (ORDER BY userid) rn
  FROM userbase
)
WHERE rn <= 10;


------------------------------------------------------------
-- Question 7: Create COMMUNITYRULES table and insert sample data
------------------------------------------------------------

CREATE TABLE communityrules (
  rulenum       NUMBER(3),
  title         VARCHAR2(250),
  description   VARCHAR2(250),
  severitypoint NUMBER(4),
  CONSTRAINT communityrules_pk PRIMARY KEY (rulenum)
);

INSERT INTO communityrules (rulenum, title, description, severitypoint)
SELECT LEVEL,
       'Rule Title ' || LEVEL,
       'Rule Description ' || LEVEL,
       LEVEL * 10
FROM dual
CONNECT BY LEVEL <= 10;


------------------------------------------------------------
-- Question 8: Create INFRACTIONS table and insert sample data
------------------------------------------------------------

CREATE TABLE infractions (
  infractionid NUMBER,
  userid       NUMBER(3),
  rulenum      NUMBER(3),
  dateassigned DATE,
  penalty      VARCHAR2(250),
  CONSTRAINT infractions_pk PRIMARY KEY (infractionid),
  CONSTRAINT infractions_user_fk FOREIGN KEY (userid)
    REFERENCES userbase(userid),
  CONSTRAINT infractions_rule_fk FOREIGN KEY (rulenum)
    REFERENCES communityrules(rulenum)
);

INSERT INTO infractions (infractionid, userid, rulenum, dateassigned, penalty)
SELECT rn,
       u.userid,
       rn,
       SYSDATE - rn,
       'Penalty for infraction #' || rn
FROM (
  SELECT userid,
         ROW_NUMBER() OVER (ORDER BY userid) rn
  FROM userbase
) u
WHERE rn <= 10;


------------------------------------------------------------
-- Question 9: Create USERSUPPORT table and insert sample data
------------------------------------------------------------

CREATE TABLE usersupport (
  ticketid      NUMBER,
  email         VARCHAR2(250),
  issue         VARCHAR2(250),
  datesubmitted DATE,
  dateupdated   DATE,
  status        VARCHAR2(250),
  CONSTRAINT usersupport_pk PRIMARY KEY (ticketid)
);

INSERT INTO usersupport
SELECT LEVEL,
       'user' || LEVEL || '@example.com',
       'Support issue #' || LEVEL,
       SYSDATE - (LEVEL + 10),
       SYSDATE - LEVEL,
       CASE
         WHEN MOD(LEVEL,3)=1 THEN 'NEW'
         WHEN MOD(LEVEL,3)=2 THEN 'IN PROGRESS'
         ELSE 'CLOSED'
       END
FROM dual
CONNECT BY LEVEL <= 10;


------------------------------------------------------------
-- Question 10: Create required views
------------------------------------------------------------

-- View showing unique security questions
CREATE OR REPLACE VIEW vw_unique_security_questions AS
SELECT DISTINCT question
FROM securityquestion;

-- View showing open/in-progress support tickets sorted by DATEUPDATED
CREATE OR REPLACE VIEW vw_open_support_tickets AS
SELECT
  ticketid,
  email,
  issue,
  dateupdated
FROM usersupport
WHERE status IN ('NEW','IN PROGRESS')
ORDER BY dateupdated ASC;