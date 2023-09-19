CREATE TABLE animals (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    date_of_birth DATE,
    escape_attempts INTEGER,
    neutered BOOLEAN,
    weight_kg DECIMAL(5,2)
);


ALTER TABLE animals
ADD COLUMN species VARCHAR(50);
