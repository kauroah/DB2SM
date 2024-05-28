-- Create tables
CREATE TABLE Students (
                          StudentID INT PRIMARY KEY,
                          StudentName VARCHAR(50),
                          GroupID INT
);

CREATE TABLE Exams (
                       ExamID INT PRIMARY KEY,
                       SubjectID INT,
                       StudentID INT,
                       ExamScore INT
);

CREATE TABLE Employees (
                           EmployeeID INT PRIMARY KEY,
                           EmployeeName VARCHAR(50),
                           Salary DECIMAL(10, 2)
);

CREATE TABLE Sales (
                       SaleID INT PRIMARY KEY,
                       ProductID INT,
                       SaleDate DATE,
                       SaleAmount DECIMAL(10, 2)
);

CREATE TABLE Orders (
                        OrderID INT PRIMARY KEY,
                        CustomerID INT,
                        OrderDate DATE,
                        OrderAmount DECIMAL(10, 2)
);

CREATE TABLE StockPrices (
                             StockID INT PRIMARY KEY,
                             Date DATE,
                             StockPrice DECIMAL(10, 2)
);

-- Insert sample data
INSERT INTO Students (StudentID, StudentName, GroupID) VALUES
                                                           (1, 'John Doe', 1),
                                                           (2, 'Jane Smith', 1),
                                                           (3, 'Michael Johnson', 2);

INSERT INTO Exams (ExamID, SubjectID, StudentID, ExamScore) VALUES
                                                                (1, 101, 1, 85),
                                                                (2, 101, 2, 90),
                                                                (3, 102, 1, 75),
                                                                (4, 102, 2, 80),
                                                                (5, 101, 3, 88),
                                                                (6, 102, 3, 82);

INSERT INTO Employees (EmployeeID, EmployeeName, Salary) VALUES
                                                             (1, 'Alice', 50000),
                                                             (2, 'Bob', 60000),
                                                             (3, 'Carol', 55000);

INSERT INTO Sales (SaleID, ProductID, SaleDate, SaleAmount) VALUES
                                                                (1, 101, '2023-01-01', 1000),
                                                                (2, 102, '2023-01-01', 1500),
                                                                (3, 101, '2023-01-02', 1200),
                                                                (4, 102, '2023-01-02', 1600),
                                                                (5, 101, '2023-01-03', 1100);

INSERT INTO Orders (OrderID, CustomerID, OrderDate, OrderAmount) VALUES
                                                                     (1, 1, '2023-01-01', 500),
                                                                     (2, 2, '2023-01-01', 600),
                                                                     (3, 1, '2023-01-02', 700),
                                                                     (4, 2, '2023-01-02', 800),
                                                                     (5, 3, '2023-01-03', 900);

INSERT INTO StockPrices (StockID, Date, StockPrice) VALUES
                                                        (1, '2023-01-01', 50.00),
                                                        (2, '2023-01-02', 52.50),
                                                        (3, '2023-01-03', 55.00);



SELECT StudentID, ExamScore,
       ROW_NUMBER() OVER (PARTITION BY GroupID ORDER BY ExamScore DESC) AS Rank
FROM Exams;

