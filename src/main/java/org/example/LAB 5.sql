CREATE TABLE products (
                          id serial PRIMARY KEY,
                          name VARCHAR(255),
                          description TEXT
);

INSERT INTO products (name, description) VALUES
                                             ('PostgreSQL Database Server', 'An open-source relational database management system (RDBMS) known for its reliability and robust features.'),
                                             ('PostgreSQL Administration Guide', 'A comprehensive guide for administrators to manage PostgreSQL databases effectively.'),
                                             ('Using PostgreSQL with Python', 'Learn how to interact with PostgreSQL databases using Python programming language.'),
                                             ('PostgreSQL Data Modeling', 'Best practices and techniques for designing and modeling databases with PostgreSQL.');

SELECT * FROM products WHERE name LIKE '%PostgreSQL%';

SELECT * FROM products WHERE name ILIKE '%postgresql%';

SELECT * FROM products WHERE to_tsvector('english', name) @@ to_tsquery('english', 'PostgreSQL');

SELECT id, name, ts_rank(to_tsvector('english', name), to_tsquery('english', 'PostgreSQL')) AS rank
FROM products

WHERE to_tsvector('english', name) @@ to_tsquery('english', 'PostgreSQL')
ORDER BY rank DESC;

