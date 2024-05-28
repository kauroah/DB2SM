
--LAB 12
CREATE TABLE CompanyNameHistory (
                                    entity_id INT,
                                    old_company_name VARCHAR(255),
                                    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE OR REPLACE FUNCTION log_company_name_changes()
    RETURNS TRIGGER AS $$
BEGIN
    IF OLD.value <> NEW.value THEN
        INSERT INTO CompanyNameHistory (entity_id, old_company_name, change_date)
        VALUES (NEW.entity_id, OLD.value, CURRENT_TIMESTAMP);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER company_name_change_trigger
    AFTER UPDATE ON Value
    FOR EACH ROW
    WHEN (OLD.value IS DISTINCT FROM NEW.value AND NEW.attribute_id = 7)
EXECUTE FUNCTION log_company_name_changes();


SELECT
    V.value AS current_company_name,
    H.old_company_name,
    H.change_date
FROM
    Value V
        LEFT JOIN
    CompanyNameHistory H ON V.entity_id = H.entity_id
WHERE
    V.entity_id = 1 AND
    (H.change_date IS NULL OR H.change_date <= '2024-05-28')
ORDER BY
    H.change_date DESC
LIMIT 1;


-- Create person table
CREATE TABLE person (
                        person_id SERIAL PRIMARY KEY,
                        name VARCHAR(255) NOT NULL
);

-- Create person_info table
CREATE TABLE person_info (
                             person_info_id SERIAL PRIMARY KEY,
                             person_id INT NOT NULL,
                             info_type_id INT NOT NULL,
                             value VARCHAR(255),
                             FOREIGN KEY (person_id) REFERENCES person(person_id)
);




-- Insert sample data into person table
INSERT INTO person (name) VALUES
                              ('John Doe'),
                              ('Jane Smith');

-- Insert sample data into person_info table
INSERT INTO person_info (person_id, info_type_id, value) VALUES
                                                             (1, 21, '1980-05-15'),
                                                             (1, 23, '2020-10-10'),
                                                             (2, 21, '1990-07-20');



CREATE OR REPLACE FUNCTION calculate_actor_age(actor_name VARCHAR)
    RETURNS INT AS $$
DECLARE
    birth_date DATE;
    death_date DATE;
    age INT;
BEGIN
    -- Get the birth date
    SELECT value::DATE
    INTO birth_date
    FROM person_info
    WHERE person_id = (
        SELECT person_id
        FROM person
        WHERE name = actor_name
    ) AND info_type_id = 21;

    -- Get the death date, if available
    SELECT value::DATE
    INTO death_date
    FROM person_info
    WHERE person_id = (
        SELECT person_id
        FROM person
        WHERE name = actor_name
    ) AND info_type_id = 23;

    -- Check if birth date was found
    IF birth_date IS NULL THEN
        RETURN 0;
    END IF;

    -- Calculate age
    IF death_date IS NULL THEN
        age := EXTRACT(YEAR FROM age(birth_date));
    ELSE
        age := EXTRACT(YEAR FROM age(birth_date, death_date));
    END IF;

    RETURN age;
END;
$$ LANGUAGE plpgsql;





CREATE OR REPLACE PROCEDURE log_actor_details(actor_name VARCHAR)
    LANGUAGE plpgsql
AS $$
DECLARE
    actor_id INT;
    age INT;
    first_film TEXT;
    first_film_year INT;
    nicknames TEXT;
BEGIN
    -- Get actor ID
    SELECT person_id INTO actor_id
    FROM person
    WHERE name = actor_name;

    IF actor_id IS NULL THEN
        RAISE EXCEPTION 'Invalid data: Actor not found';
    END IF;

    -- Get age using the function
    age := calculate_actor_age(actor_name);
    IF age = 0 THEN
        RAISE EXCEPTION 'Invalid data: Birth date not found';
    END IF;

    -- Get nicknames (assuming info_type_id = 30 represents nicknames)
    SELECT STRING_AGG(value, ', ') INTO nicknames
    FROM person_info
    WHERE person_id = actor_id AND info_type_id = 30;

    -- Get first film and year (assuming info_type_id = 40 represents films and their release years)
    SELECT value INTO first_film
    FROM person_info
    WHERE person_id = actor_id AND info_type_id = 40
    ORDER BY value ASC
    LIMIT 1;

    -- Log the details
    IF nicknames IS NOT NULL THEN
        RAISE NOTICE 'Name: %', actor_name;
        RAISE NOTICE 'Nicknames: %', nicknames;
        RAISE NOTICE 'Age: %', age;
        RAISE NOTICE 'First appear: %', first_film;
    ELSE
        RAISE NOTICE 'Name: %', actor_name;
        RAISE NOTICE 'Age: %', age;
        RAISE NOTICE 'First appear: %', first_film;
    END IF;
END;
$$;



-- Create history table
CREATE TABLE CompanyNameHistory (
                                    entity_id INT,
                                    old_company_name VARCHAR(255),
                                    change_date DATE
);

-- Create trigger function
CREATE OR REPLACE FUNCTION log_company_name_changes()
    RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO CompanyNameHistory (entity_id, old_company_name, change_date)
    VALUES (OLD.entity_id, OLD.value, CURRENT_DATE);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION calculate_actor_age(actor_name VARCHAR)
    RETURNS INT AS $$
DECLARE
    birth_date DATE;
    death_date DATE;
    age INT;
BEGIN
    -- Get the birth date
    SELECT value::DATE
    INTO birth_date
    FROM person_info
    WHERE person_id = (
        SELECT person_id
        FROM person
        WHERE name = actor_name
    ) AND info_type_id = 21;

    -- Get the death date, if available
    SELECT value::DATE
    INTO death_date
    FROM person_info
    WHERE person_id = (
        SELECT person_id
        FROM person
        WHERE name = actor_name
    ) AND info_type_id = 23;

    -- Check if birth date was found
    IF birth_date IS NULL THEN
        RETURN 0;
    END IF;

    -- Calculate age
    IF death_date IS NULL THEN
        age := EXTRACT(YEAR FROM age(birth_date));
    ELSE
        age := EXTRACT(YEAR FROM age(birth_date, death_date));
    END IF;

    RETURN age;
END;
$$ LANGUAGE plpgsql;





CREATE OR REPLACE PROCEDURE log_actor_details(actor_name VARCHAR)
    LANGUAGE plpgsql
AS $$
DECLARE
    actor_id INT;
    age INT;
    first_film TEXT;
    first_film_year INT;
    nicknames TEXT;
BEGIN
    -- Get actor ID
    SELECT person_id INTO actor_id
    FROM person
    WHERE name = actor_name;

    IF actor_id IS NULL THEN
        RAISE EXCEPTION 'Invalid data: Actor not found';
    END IF;

    -- Get age using the function
    age := calculate_actor_age(actor_name);
    IF age = 0 THEN
        RAISE EXCEPTION 'Invalid data: Birth date not found';
    END IF;

    -- Get nicknames (assuming info_type_id = 30 represents nicknames)
    SELECT STRING_AGG(value, ', ') INTO nicknames
    FROM person_info
    WHERE person_id = actor_id AND info_type_id = 30;

    -- Get first film and year (assuming info_type_id = 40 represents films and their release years)
    SELECT value INTO first_film
    FROM person_info
    WHERE person_id = actor_id AND info_type_id = 40
    ORDER BY value ASC
    LIMIT 1;

    -- Log the details
    IF nicknames IS NOT NULL THEN
        RAISE NOTICE 'Name: %', actor_name;
        RAISE NOTICE 'Nicknames: %', nicknames;
        RAISE NOTICE 'Age: %', age;
        RAISE NOTICE 'First appear: %', first_film;
    ELSE
        RAISE NOTICE 'Name: %', actor_name;
        RAISE NOTICE 'Age: %', age;
        RAISE NOTICE 'First appear: %', first_film;
    END IF;
END;
$$;