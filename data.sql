INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES
   ('Agumon', '2020-02-03', 0, true, 10.23),
   ('Gabumon', '2018-11-15', 2, true, 8),
   ('Pikachu', '2021-01-07', 1, false, 15.04),
   ('Devimon', '2017-05-12', 5, true, 11);


INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg, species)
VALUES
    ('Charmander', '2020-02-08', 0, FALSE, -11.0, 'Unspecified'),
    ('Plantmon', '2021-11-15', 2, TRUE, -5.7, 'Unspecified'),
    ('Squirtle', '1993-04-02', 3, FALSE, -12.13, 'Unspecified'),
    ('Angemon', '2005-06-12', 1, TRUE, -45.0, 'Unspecified'),
    ('Boarmon', '2005-06-07', 7, TRUE, 20.4, 'Unspecified'),
    ('Blossom', '1998-10-13', 3, TRUE, 17.0, 'Unspecified'),
    ('Ditto', '2022-05-14', 4, TRUE, 22.0, 'Unspecified');

-- Insert data into owners table
INSERT INTO owners (full_name, age)
VALUES
    ('Sam Smith', 34),
    ('Jennifer Orwell', 19),
    ('Bob', 45),
    ('Melody Pond', 77),
    ('Dean Winchester', 14),
    ('Jodie Whittaker', 38);

INSERT INTO species (name)
VALUES
    ('Pokemon'),
    ('Digimon');

UPDATE animals
SET
    species_id = (CASE
        WHEN name LIKE '%mon' THEN (SELECT id FROM species WHERE name = 'Digimon')
        ELSE (SELECT id FROM species WHERE name = 'Pokemon')
    END),
    owner_id = (CASE
        WHEN name = 'Agumon' THEN (SELECT id FROM owners WHERE full_name = 'Sam Smith')
        WHEN name IN ('Gabumon', 'Pikachu') THEN (SELECT id FROM owners WHERE full_name = 'Jennifer Orwell')
        WHEN name IN ('Devimon', 'Plantmon') THEN (SELECT id FROM owners WHERE full_name = 'Bob')
        WHEN name IN ('Charmander', 'Squirtle', 'Blossom') THEN (SELECT id FROM owners WHERE full_name = 'Melody Pond')
        WHEN name IN ('Angemon', 'Boarmon') THEN (SELECT id FROM owners WHERE full_name = 'Dean Winchester')
        ELSE NULL
    END);


-- add 'join table' for visits
    
INSERT INTO vets (name, age, date_of_graduation)
VALUES
    ('Vet William Tatcher', 45, '2000-04-23'),
    ('Vet Maisy Smith', 26, '2019-01-17'),
    ('Vet Stephanie Mendez', 64, '1981-05-04'),
    ('Vet Jack Harkness', 38, '2008-06-08');

INSERT INTO specializations (vet_id, species_id)
VALUES
    (1, 1), -- William Tatcher specialized in Pokemon
    (3, 2), -- Stephanie Mendez specialized in Digimon
    (3, 1), -- Stephanie Mendez also specialized in Pokemon
    (4, 2); -- Jack Harkness specialized in Digimon

INSERT INTO visits (animal_id, vet_id, visit_date)
VALUES
    (1, 1, '2020-05-24'), -- Agumon visited William Tatcher
    (1, 3, '2020-07-22'), -- Agumon also visited Stephanie Mendez
    (2, 4, '2021-02-02'), -- Gabumon visited Jack Harkness
    (3, 2, '2020-01-05'), -- Pikachu visited Maisy Smith
    (3, 2, '2020-03-08'), -- Pikachu visited Maisy Smith again
    (3, 2, '2020-05-14'), -- Pikachu visited Maisy Smith yet again
    (4, 3, '2021-05-04'), -- Devimon visited Stephanie Mendez
    (5, 4, '2021-02-24'), -- Charmander visited Jack Harkness
    (6, 2, '2019-12-21'), -- Plantmon visited Maisy Smith
    (6, 1, '2020-08-10'), -- Plantmon also visited William Tatcher
    (6, 2, '2021-04-07'), -- Plantmon visited Maisy Smith again
    (7, 3, '2019-09-29'), -- Squirtle visited Stephanie Mendez
    (8, 4, '2020-10-03'), -- Angemon visited Jack Harkness
    (8, 4, '2020-11-04'), -- Angemon visited Jack Harkness again
    (9, 2, '2019-01-24'), -- Boarmon visited Maisy Smith
    (9, 2, '2019-05-15'), -- Boarmon visited Maisy Smith again
    (9, 2, '2020-02-27'), -- Boarmon visited Maisy Smith again
    (9, 2, '2020-08-03'), -- Boarmon visited Maisy Smith again
    (10, 3, '2020-05-24'), -- Blossom visited Stephanie Mendez
    (10, 1, '2021-01-11'); -- Blossom also visited William Tatcher
