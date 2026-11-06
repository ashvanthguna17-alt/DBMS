-- ==========================================
-- CSA05 DBMS ASSIGNMENT CO1
-- MERIDIAN MUSEUM DATABASE
-- ==========================================

-- 1. CREATE DATABASE

DROP DATABASE IF EXISTS MeridianMuseum;
CREATE DATABASE MeridianMuseum;
USE MeridianMuseum;


-- 2. CREATE PERSON TABLE

CREATE TABLE PERSON (
    Person_ID INT PRIMARY KEY AUTO_INCREMENT,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE
);


-- 3. CREATE EMPLOYEE TABLE

CREATE TABLE EMPLOYEE (
    Employee_ID INT PRIMARY KEY,
    Role VARCHAR(30) NOT NULL,
    FOREIGN KEY (Employee_ID)
    REFERENCES PERSON(Person_ID)
);


-- 4. CREATE LENDER TABLE

CREATE TABLE LENDER (
    Lender_ID INT PRIMARY KEY,
    Lender_Type VARCHAR(30) NOT NULL,
    FOREIGN KEY (Lender_ID)
    REFERENCES PERSON(Person_ID)
);


-- 5. CREATE CURATOR TABLE

CREATE TABLE CURATOR (
    Curator_ID INT PRIMARY KEY,
    Department VARCHAR(50),
    FOREIGN KEY (Curator_ID)
    REFERENCES EMPLOYEE(Employee_ID)
);


-- 6. CREATE REGISTRAR TABLE

CREATE TABLE REGISTRAR (
    Registrar_ID INT PRIMARY KEY,
    FOREIGN KEY (Registrar_ID)
    REFERENCES EMPLOYEE(Employee_ID)
);


-- 7. CREATE ARTIFACT TABLE

CREATE TABLE ARTIFACT (
    Artifact_ID INT PRIMARY KEY AUTO_INCREMENT,
    Artifact_Name VARCHAR(100) NOT NULL,
    Collection_Type VARCHAR(50),
    Description VARCHAR(255)
);


-- 8. CREATE LOAN TABLE

CREATE TABLE LOAN (
    Loan_ID INT PRIMARY KEY AUTO_INCREMENT,
    Lender_ID INT NOT NULL,
    Curator_ID INT NOT NULL,
    Start_Date DATE NOT NULL,
    Expiry_Date DATE NOT NULL,
    Return_Date DATE,
    FOREIGN KEY (Lender_ID)
    REFERENCES LENDER(Lender_ID),
    FOREIGN KEY (Curator_ID)
    REFERENCES CURATOR(Curator_ID),
    CHECK (Expiry_Date >= Start_Date),
    CHECK (Return_Date IS NULL OR Return_Date >= Start_Date)
);


-- 9. CREATE LOAN_OBJECT TABLE

CREATE TABLE LOAN_OBJECT (
    Loan_ID INT,
    Artifact_ID INT,
    Loan_Value DECIMAL(12,2),
    PRIMARY KEY (Loan_ID, Artifact_ID),
    FOREIGN KEY (Loan_ID)
    REFERENCES LOAN(Loan_ID),
    FOREIGN KEY (Artifact_ID)
    REFERENCES ARTIFACT(Artifact_ID)
);


-- 10. CREATE EXHIBITION TABLE

CREATE TABLE EXHIBITION (
    Exhibition_ID INT PRIMARY KEY AUTO_INCREMENT,
    Exhibition_Name VARCHAR(100) NOT NULL,
    Start_Date DATE,
    End_Date DATE,
    CHECK (End_Date IS NULL OR End_Date >= Start_Date)
);


-- 11. CREATE DISPLAY_SLOT TABLE

CREATE TABLE DISPLAY_SLOT (
    Exhibition_ID INT,
    Slot_No INT,
    Slot_Name VARCHAR(50),
    PRIMARY KEY (Exhibition_ID, Slot_No),
    FOREIGN KEY (Exhibition_ID)
    REFERENCES EXHIBITION(Exhibition_ID)
);


-- 12. CREATE PLACEMENT TABLE

CREATE TABLE PLACEMENT (
    Loan_ID INT,
    Artifact_ID INT,
    Exhibition_ID INT,
    Slot_No INT,
    Display_Start DATE NOT NULL,
    Display_End DATE,
    PRIMARY KEY (
        Loan_ID, Artifact_ID,
        Exhibition_ID, Slot_No
    ),
    FOREIGN KEY (Loan_ID, Artifact_ID)
    REFERENCES LOAN_OBJECT(Loan_ID, Artifact_ID),
    FOREIGN KEY (Exhibition_ID, Slot_No)
    REFERENCES DISPLAY_SLOT(Exhibition_ID, Slot_No),
    CHECK (
        Display_End IS NULL
        OR Display_End >= Display_Start
    )
);


-- 13. CREATE CONDITION_REPORT TABLE

CREATE TABLE CONDITION_REPORT (
    Report_ID INT PRIMARY KEY AUTO_INCREMENT,
    Loan_ID INT NOT NULL,
    Artifact_ID INT NOT NULL,
    Report_Date DATE NOT NULL,
    Condition_Status VARCHAR(50),
    Remarks VARCHAR(255),
    FOREIGN KEY (Loan_ID, Artifact_ID)
    REFERENCES LOAN_OBJECT(Loan_ID, Artifact_ID)
);


-- 14. CREATE ARTIFACT_OWNER TABLE

CREATE TABLE ARTIFACT_OWNER (
    Artifact_ID INT,
    Owner_ID INT,
    Ownership_Share DECIMAL(5,2) NOT NULL,
    Valid_From DATE NOT NULL,
    Valid_To DATE,
    PRIMARY KEY (Artifact_ID, Owner_ID, Valid_From),
    FOREIGN KEY (Artifact_ID)
    REFERENCES ARTIFACT(Artifact_ID),
    FOREIGN KEY (Owner_ID)
    REFERENCES LENDER(Lender_ID),
    CHECK (
        Ownership_Share > 0
        AND Ownership_Share <= 100
    ),
    CHECK (
        Valid_To IS NULL
        OR Valid_To >= Valid_From
    )
);


-- 15. CREATE LENDER_CONTACT TABLE

CREATE TABLE LENDER_CONTACT (
    Contact_ID INT PRIMARY KEY AUTO_INCREMENT,
    Lender_ID INT NOT NULL,
    Phone_Number VARCHAR(20),
    FOREIGN KEY (Lender_ID)
    REFERENCES LENDER(Lender_ID)
);


-- ==========================================
-- INSERT SAMPLE RECORDS
-- ==========================================

-- PERSON

INSERT INTO PERSON VALUES
(1,'Arun','Kumar','arun@gmail.com'),
(2,'Ravi','Raj','ravi@gmail.com'),
(3,'Ashok','Kumar','ashok@gmail.com'),
(4,'Vijay','Kumar','vijay@gmail.com'),
(5,'Mani','Raja','mani@gmail.com');


-- EMPLOYEE

INSERT INTO EMPLOYEE VALUES
(1,'Curator'),
(2,'Registrar');


-- LENDER

INSERT INTO LENDER VALUES
(3,'Individual'),
(4,'Individual'),
(5,'Individual');


-- CURATOR

INSERT INTO CURATOR VALUES
(1,'History');


-- REGISTRAR

INSERT INTO REGISTRAR VALUES
(2);


-- ARTIFACT

INSERT INTO ARTIFACT
(Artifact_Name,Collection_Type,Description)
VALUES
('Ancient Coin','Metal','Old gold coin'),
('Stone Statue','Sculpture','Historical statue'),
('Old Painting','Painting','Traditional painting'),
('Bronze Pot','Metal','Ancient bronze pot'),
('Wooden Box','Wood','Historical wooden box');


-- LOAN

INSERT INTO LOAN
(Lender_ID,Curator_ID,Start_Date,Expiry_Date,Return_Date)
VALUES
(3,1,'2026-01-01','2026-12-01',NULL),
(4,1,'2026-02-01','2026-10-01',NULL),
(5,1,'2026-03-01','2026-09-01','2026-08-20');


-- LOAN_OBJECT

INSERT INTO LOAN_OBJECT VALUES
(1,1,50000),
(1,2,75000),
(2,3,60000),
(2,4,45000),
(3,5,30000);


-- EXHIBITION

INSERT INTO EXHIBITION
(Exhibition_Name,Start_Date,End_Date)
VALUES
('History Exhibition','2026-02-01','2026-11-30'),
('Art Exhibition','2026-03-01','2026-12-15');


-- DISPLAY_SLOT

INSERT INTO DISPLAY_SLOT VALUES
(1,1,'Main Hall'),
(1,2,'Special Gallery'),
(2,1,'Art Hall'),
(2,2,'Painting Room');


-- PLACEMENT

INSERT INTO PLACEMENT VALUES
(1,1,1,1,'2026-02-01','2026-11-30'),
(1,2,1,2,'2026-02-01','2026-11-30'),
(2,3,2,1,'2026-03-01','2026-10-01');


-- CONDITION_REPORT

INSERT INTO CONDITION_REPORT
(Loan_ID,Artifact_ID,Report_Date,Condition_Status,Remarks)
VALUES
(1,1,'2026-01-01','Good','No damage'),
(1,2,'2026-01-01','Fair','Minor scratches'),
(2,3,'2026-02-01','Excellent','Good condition'),
(3,5,'2026-03-01','Good','No damage');


-- ARTIFACT_OWNER

INSERT INTO ARTIFACT_OWNER VALUES
(1,3,100,'2025-01-01',NULL),
(2,3,100,'2025-01-01',NULL),
(3,4,100,'2025-01-01',NULL),
(4,4,100,'2025-01-01',NULL),
(5,5,100,'2025-01-01',NULL);


-- LENDER_CONTACT

INSERT INTO LENDER_CONTACT
(Lender_ID,Phone_Number)
VALUES
(3,'9876543210'),
(3,'9876501234'),
(4,'9876512345'),
(5,'9876523456');


-- ==========================================
-- 8 IMPORTANT SELECT QUERIES
-- ==========================================

-- QUERY 1: DISPLAY ALL ARTIFACTS

SELECT * FROM ARTIFACT;


-- QUERY 2: DISPLAY LOAN AND LENDER DETAILS

SELECT
L.Loan_ID,
P.First_Name,
P.Last_Name,
L.Start_Date,
L.Expiry_Date
FROM LOAN L
JOIN LENDER LE
ON L.Lender_ID = LE.Lender_ID
JOIN PERSON P
ON LE.Lender_ID = P.Person_ID;


-- QUERY 3: FIND OVERDUE LOANS STILL OPEN

SELECT *
FROM LOAN
WHERE Expiry_Date < CURDATE()
AND Return_Date IS NULL;


-- QUERY 4: FIND ARTIFACTS WITHOUT CONDITION REPORTS

SELECT
A.Artifact_ID,
A.Artifact_Name
FROM ARTIFACT A
LEFT JOIN CONDITION_REPORT C
ON A.Artifact_ID = C.Artifact_ID
WHERE C.Report_ID IS NULL;


-- QUERY 5: DISPLAY ARTIFACTS UNDER EACH LOAN

SELECT
L.Loan_ID,
A.Artifact_Name,
LO.Loan_Value
FROM LOAN_OBJECT LO
JOIN LOAN L
ON LO.Loan_ID = L.Loan_ID
JOIN ARTIFACT A
ON LO.Artifact_ID = A.Artifact_ID;


-- QUERY 6: DISPLAY EXHIBITION AND SLOT DETAILS

SELECT
E.Exhibition_Name,
D.Slot_No,
D.Slot_Name
FROM EXHIBITION E
JOIN DISPLAY_SLOT D
ON E.Exhibition_ID = D.Exhibition_ID;


-- QUERY 7: DISPLAY CONDITION REPORTS

SELECT
A.Artifact_Name,
C.Report_Date,
C.Condition_Status,
C.Remarks
FROM ARTIFACT A
JOIN CONDITION_REPORT C
ON A.Artifact_ID = C.Artifact_ID;


-- QUERY 8: DISPLAY OWNERSHIP DETAILS

SELECT
A.Artifact_Name,
P.First_Name,
P.Last_Name,
AO.Ownership_Share,
AO.Valid_From,
AO.Valid_To
FROM ARTIFACT_OWNER AO
JOIN ARTIFACT A
ON AO.Artifact_ID = A.Artifact_ID
JOIN LENDER L
ON AO.Owner_ID = L.Lender_ID
JOIN PERSON P
ON L.Lender_ID = P.Person_ID;


-- ==========================================
-- AGGREGATE FUNCTIONS
-- ==========================================

-- COUNT

SELECT COUNT(*) AS Total_Artifacts
FROM ARTIFACT;


-- SUM

SELECT SUM(Loan_Value) AS Total_Loan_Value
FROM LOAN_OBJECT;


-- AVG

SELECT AVG(Loan_Value) AS Average_Loan_Value
FROM LOAN_OBJECT;


-- MAX

SELECT MAX(Loan_Value) AS Highest_Loan_Value
FROM LOAN_OBJECT;


-- MIN

SELECT MIN(Loan_Value) AS Lowest_Loan_Value
FROM LOAN_OBJECT;


-- ==========================================
-- GROUP BY AND HAVING
-- ==========================================

SELECT
Lender_ID,
COUNT(*) AS Total_Loans
FROM LOAN
GROUP BY Lender_ID;


SELECT
Lender_ID,
COUNT(*) AS Total_Loans
FROM LOAN
GROUP BY Lender_ID
HAVING COUNT(*) > 1;


-- ==========================================
-- ORDER BY
-- ==========================================

SELECT *
FROM ARTIFACT
ORDER BY Artifact_Name ASC;


-- ==========================================
-- UPDATE COMMANDS
-- ==========================================

UPDATE ARTIFACT
SET Collection_Type = 'Antique Metal'
WHERE Artifact_ID = 1;


UPDATE CONDITION_REPORT
SET Condition_Status = 'Excellent'
WHERE Report_ID = 1;


-- ==========================================
-- DELETE COMMAND
-- ==========================================

DELETE FROM CONDITION_REPORT
WHERE Report_ID = 4;


-- ==========================================
-- SUBQUERY
-- ==========================================

SELECT *
FROM ARTIFACT
WHERE Artifact_ID IN (
    SELECT Artifact_ID
    FROM LOAN_OBJECT
    WHERE Loan_Value > 50000
);


-- ==========================================
-- INDEX
-- ==========================================

CREATE INDEX idx_loan_lender
ON LOAN(Lender_ID);

CREATE INDEX idx_condition_artifact
ON CONDITION_REPORT(Artifact_ID);


-- ==========================================
-- VIEW
-- ==========================================

CREATE VIEW LOAN_DETAILS AS
SELECT
L.Loan_ID,
P.First_Name,
P.Last_Name,
L.Start_Date,
L.Expiry_Date
FROM LOAN L
JOIN LENDER LE
ON L.Lender_ID = LE.Lender_ID
JOIN PERSON P
ON LE.Lender_ID = P.Person_ID;


-- DISPLAY VIEW

SELECT * FROM LOAN_DETAILS;


-- ==========================================
-- FINAL DATABASE DISPLAY
-- ==========================================

SHOW TABLES;
