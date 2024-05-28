CREATE TABLE Orders (
                        OrderNumber INTEGER PRIMARY KEY,
                        Model VARCHAR(50),
                        Color VARCHAR(50),
                        Transmission VARCHAR(50),
                        Trim VARCHAR(50),
                        Upholstery VARCHAR(50),
                        Price INTEGER,
                        LastName VARCHAR(50),
                        FirstName VARCHAR(50),
                        MiddleName VARCHAR(50),
                        Phone VARCHAR(50),
                        OrderDate DATE
);


INSERT INTO Orders (OrderNumber, Model, Color, Transmission, Trim, Upholstery, Price, LastName, FirstName, MiddleName, Phone, OrderDate)
VALUES
    (123, '12579', 'Classic', 'liftback', 'XL', 'Красный', 35700, 'Иванов', 'Федор', 'Степанович', '2859655', '1997-08-03'),
    (133, '12651', 'Classic', 'Compact', 'XL', 'Антрацит', 41100, 'Сидоров', 'Николай', 'Сергеевич', '342679', '1997-12-25'),
    (135, '12653', 'Classic', 'Compact', 'GT', 'Черный', 37900, 'Бендер', 'Остап', 'Ибрагимович', '56438', '1998-01-05'),
    (138, '12410', 'Classic', 'Combi', NULL, 'Антрацит', 46200, 'Иванов', 'Сергей', 'Сергеевич', '2859655', '1998-02-20'),
    (140, '12653', 'Classic', 'Compact', 'GT', 'Черный', 37900, 'Петров', 'Юрий', 'Андреевич', '3856743', '1998-06-30'),
    (145, '12410', 'Classic', 'Combi', NULL, 'Антрацит', 46200, 'Сидоров', 'Борис', 'Борисович', '342679', '1998-08-25'),
    (160, '12580', 'Classic', 'liftback', 'GT', 'Черный', 39200, 'Дубов', 'Дмитрий', 'Иванович', '4356723', '1998-09-17'),
    (165, '12410', 'Classic', 'Combi', NULL, 'Антрацит', 46200, 'Сухов', 'Алексей', 'Олегович', '9439965', '1998-10-20'),
    (166, '12653', 'Classic', 'Compact', 'GT', 'Черный', 37900, 'Сахаров', 'Игорь', 'Игоревич', '234567', '1998-12-25');





CREATE TABLE Customer (
                          CustomerID INTEGER PRIMARY KEY,
                          LastName VARCHAR(50),
                          FirstName VARCHAR(50),
                          MiddleName VARCHAR(50),
                          Phone VARCHAR(50)
);

CREATE TABLE Orders_3FR(
                        OrderNumber INTEGER PRIMARY KEY,
                        Model VARCHAR(50),
                        Color VARCHAR(50),
                        Transmission VARCHAR(50),
                        Trim VARCHAR(50),
                        Upholstery VARCHAR(50),
                        Price INTEGER,
                        CustomerID INTEGER,
                        OrderDate DATE,
                        FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

INSERT INTO Customer (CustomerID, LastName, FirstName, MiddleName, Phone)
VALUES
    (1, 'Иванов', 'Федор', 'Степанович', '2859655'),
    (2, 'Сидоров', 'Николай', 'Сергеевич', '342679'),
    (3, 'Бендер', 'Остап', 'Ибрагимович', '56438'),
    (4, 'Петров', 'Юрий', 'Андреевич', '3856743'),
    (5, 'Сухов', 'Алексей', 'Олегович', '9439965'),
    (6, 'Сахаров', 'Игорь', 'Игоревич', '234567'),
    (7, 'Дубов', 'Дмитрий', 'Иванович', '4356723');


INSERT INTO Orders_3FR (OrderNumber, Model, Color, Transmission, Trim, Upholstery, Price, CustomerID, OrderDate)
VALUES
    (123, '12579', 'Classic', 'liftback', 'XL', 'Красный', 35700, 1, '1997-08-03'),
    (133, '12651', 'Classic', 'Compact', 'XL', 'Антрацит', 41100, 2, '1997-12-25'),
    (135, '12653', 'Classic', 'Compact', 'GT', 'Черный', 37900, 3, '1998-01-05'),
    (138, '12410', 'Classic', 'Combi', NULL, 'Антрацит', 46200, 1, '1998-02-20'),
    (140, '12653', 'Classic', 'Compact', 'GT', 'Черный', 37900, 4, '1998-06-30'),
    (145, '12410', 'Classic', 'Combi', NULL, 'Антрацит', 46200, 2, '1998-08-25'),
    (160, '12580', 'Classic', 'liftback', 'GT', 'Черный', 39200, 7, '1998-09-17'),
    (165, '12410', 'Classic', 'Combi', NULL, 'Антрацит', 46200, 5, '1998-10-20'),
    (166, '12653', 'Classic', 'Compact', 'GT', 'Черный', 37900, 6, '1998-12-25');


SELECT LastName, FirstName, MiddleName, Phone, COUNT(*)
FROM Customer
GROUP BY LastName, FirstName, MiddleName, Phone
HAVING COUNT(*) > 1;


ALTER TABLE Orders_3FR
    ADD CONSTRAINT FK_CustomerID
        FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
            ON DELETE CASCADE
            ON UPDATE CASCADE;


SELECT LastName, Phone
FROM Orders;

SELECT c.LastName, c.Phone
FROM Orders_3FR o
         JOIN Customer c ON o.CustomerID = c.CustomerID;


SELECT *
FROM Orders_3FR
WHERE Model = '12653';


