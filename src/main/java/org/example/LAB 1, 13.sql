-- lab 1

-- Insert values for entity 1 (Contract)

INSERT INTO Value (entity_id, attribute_id, value, valid_from)
VALUES
    (1, 1, '123ABC', '2024-01-01'), -- contract_number
    (1, 2, '2024-01-15', '2024-01-01'), -- date_of_conclusion
    (1, 3, '10000', '2024-01-01'), -- insurance_amount
    (1, 4, '5', '2024-01-01'), -- tariff_rate
    (1, 5, '1', '2024-01-01'), -- branch_code
    (1, 6, 'AUTO', '2024-01-01'); -- type_of_insurance_code

-- Insert a new attribute value with valid_to date
INSERT INTO Value (entity_id, attribute_id, value, valid_from, valid_to)
VALUES
    (2, 5, '2024-01-15', '2024-01-15', '2024-02-15'); -- Insert new value with valid_from and valid_to



-- Query all attribute values for entity 1 (Contract)
SELECT
    A.attribute_name,
    V.value
FROM
    Value V
        JOIN
    Attribute A ON V.attribute_id = A.attribute_id
WHERE
    V.entity_id = 1;



-- Update the insurance amount for contract '123ABC'
UPDATE Value
SET value = '15000'
WHERE entity_id = 1 -- Contract entity
  AND attribute_id = 3 -- insurance_amount attribute
  AND valid_from = '2024-01-01';



-- Delete the phone_number attribute value for branch '1'
DELETE FROM Value
WHERE entity_id = 2 -- Branch entity
  AND attribute_id = 9 -- phone_number attribute
  AND valid_from = '2024-01-01'; -- Specify the valid_from date


-- Update the valid_to date for the current attribute value
UPDATE Value
SET valid_to = '2024-01-14' -- Set to the day before the new value becomes valid
WHERE entity_id = 1 -- Specify the entity_id
  AND attribute_id = 2 -- Specify the attribute_id
  AND valid_to IS NULL; -- Update the current value where valid_to is NULL (indicating it's the current value)

-- Insert the new attribute value with valid_from and valid_to dates
INSERT INTO Value (entity_id, attribute_id, value, valid_from, valid_to)
VALUES
    (1, 2, '2024-01-15', '2024-01-15', '9999-12-31'); -- Insert new value with valid_from and valid_to indicating it's valid indefinitely



SELECT attribute_id FROM Attribute;

-------------------------------------------------------------------------------------------
-- LAB 13


CREATE TABLE ChangeLog (
                           log_id SERIAL PRIMARY KEY,
                           entity_id INT,
                           attribute_id INT,
                           old_value VARCHAR,
                           new_value VARCHAR,
                           change_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_insurance_amount_changes()
    RETURNS TRIGGER AS $$
BEGIN
    IF OLD.value <> NEW.value THEN
        INSERT INTO ChangeLog(entity_id, attribute_id, old_value, new_value)
        VALUES (NEW.entity_id, NEW.attribute_id, OLD.value, NEW.value);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insurance_amount_change_trigger
    AFTER UPDATE ON Value
    FOR EACH ROW
    WHEN (OLD.value IS DISTINCT FROM NEW.value AND NEW.attribute_id = 3)
EXECUTE FUNCTION log_insurance_amount_changes();


SELECT * FROM ChangeLog;


CREATE OR REPLACE FUNCTION log_insurance_amount_changes()
    RETURNS TRIGGER AS $$
BEGIN
    IF OLD.value <> NEW.value THEN
        INSERT INTO ChangeLog(entity_id, attribute_id, old_value, new_value)
        VALUES (NEW.entity_id, NEW.attribute_id, OLD.value, NEW.value);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


DROP TRIGGER insurance_amount_change_trigger ON Value;

CREATE TRIGGER insurance_amount_change_trigger
    AFTER UPDATE ON Value
    FOR EACH ROW
    WHEN (OLD.value IS DISTINCT FROM NEW.value AND (NEW.attribute_id = 3 OR NEW.attribute_id = 4))
EXECUTE FUNCTION log_insurance_amount_changes();


DROP TRIGGER insurance_amount_change_trigger ON Value;
DROP FUNCTION log_insurance_amount_changes();
-----------------------------------------------------------------------------
