SELECT * FROM animals WHERE name LIKE '%mon';

SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;

SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');

SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

SELECT * FROM animals WHERE neutered = true;

SELECT * FROM animals WHERE name != 'Gabumon';

SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;


BEGIN;

UPDATE animals
SET species = 'Unspecified';

ROLLBACK;

SELECT * FROM animals;


BEGIN;

UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';

UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;

SELECT * FROM animals;

COMMIT;

SELECT * FROM animals;


BEGIN;

DELETE FROM animals;

SELECT * FROM animals;

ROLLBACK;

SELECT * FROM animals;


BEGIN;

DELETE FROM animals
WHERE date_of_birth > '2022-01-01';

SAVEPOINT my_savepoint;

UPDATE animals
SET weight_kg = weight_kg * -1;

ROLLBACK TO my_savepoint;

UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;

COMMIT;

SELECT * FROM animals;


--update table
-- Query
-- 1. How many animals are there?
SELECT COUNT(*) AS total_animals FROM animals;

-- 2. How many animals have never tried to escape?
SELECT COUNT(*) AS never_tried_to_escape
FROM animals
WHERE escape_attempts = 0;

-- 3. What is the average weight of animals?
SELECT AVG(weight_kg) AS average_weight
FROM animals;

-- 4. Who escapes the most, neutered or not neutered animals?
SELECT neutered, MAX(escape_attempts) AS max_escape_attempts
FROM animals
GROUP BY neutered;

-- 5. What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg) AS min_weight, MAX(weight_kg) AS max_weight
FROM animals
GROUP BY species;

-- 6. What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts) AS avg_escape_attempts
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;


-- multiple table

-- Remove column species
ALTER TABLE animals
DROP COLUMN species;

-- Add column species_id as a foreign key referencing species table
ALTER TABLE animals
ADD COLUMN species_id INTEGER REFERENCES species(id);

-- Add column owner_id as a foreign key referencing owners table
ALTER TABLE animals
ADD COLUMN owner_id INTEGER REFERENCES owners(id);


-- Query 1: What animals belong to Melody Pond?
SELECT a.name
FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Melody Pond';

-- Query 2: List of all animals that are Pokemon (their type is Pokemon).
SELECT a.name
FROM animals a
JOIN species s ON a.species_id = s.id
WHERE s.name = 'Pokemon';

-- Query 3: List all owners and their animals, including those who don't own any animal.
SELECT o.full_name, COALESCE(array_agg(a.name), '{}'::VARCHAR[]) AS owned_animals
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id
GROUP BY o.full_name;

-- Query 4: How many animals are there per species?
SELECT s.name AS species_name, COUNT(a.id) AS total_animals
FROM species s
LEFT JOIN animals a ON s.id = a.species_id
GROUP BY s.name;

-- Query 5: List all Digimon owned by Jennifer Orwell.
SELECT a.name
FROM animals a
JOIN species s ON a.species_id = s.id
JOIN owners o ON a.owner_id = o.id
WHERE s.name = 'Digimon' AND o.full_name = 'Jennifer Orwell';

-- Query 6: List all animals owned by Dean Winchester that haven't tried to escape.
SELECT a.name
FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Dean Winchester' AND a.escape_attempts = 0;

-- Query 7: Who owns the most animals?
SELECT o.full_name, COUNT(a.id) AS total_owned
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id
GROUP BY o.full_name
ORDER BY total_owned DESC
LIMIT 1;


-- add 'join table' for visits:
-- Query:

-- Query:
-- 1- Who was the last animal seen by William Tatcher?
SELECT a.name AS last_animal_seen
FROM visits v
JOIN animals a ON v.animal_id = a.id
JOIN vets vt ON v.vet_id = vt.id
WHERE vt.name = 'Vet William Tatcher'
ORDER BY v.visit_date DESC
LIMIT 1;

-- 2- How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT v.animal_id) AS total_animals_seen
FROM visits v
JOIN vets vt ON v.vet_id = vt.id
WHERE vt.name = 'Vet Stephanie Mendez';

-- 3- List all vets and their specialties, including vets with no specialties.
SELECT v.name AS vet_name, COALESCE(specialty, 'No Specialty') AS specialty
FROM vets v
LEFT JOIN (
    SELECT vet_id, STRING_AGG(species.name, ', ') AS specialty
    FROM specializations
    JOIN species ON specializations.species_id = species.id
    GROUP BY vet_id
) s ON v.id = s.vet_id
ORDER BY vet_name, specialty;

-- 4- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT a.name AS animal_name, v.visit_date
FROM visits v
JOIN animals a ON v.animal_id = a.id
WHERE v.vet_id = 3
  AND v.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

-- 5- What animal has the most visits to vets?
SELECT a.name AS animal_name, COUNT(*) AS visit_count
FROM visits v
JOIN animals a ON v.animal_id = a.id
GROUP BY a.name
ORDER BY visit_count DESC
LIMIT 1;

-- 6- Who was Maisy Smith's first visit?
SELECT vet.name AS vet_name, MIN(v.visit_date) AS first_visit_date
FROM visits v
JOIN vets vet ON v.vet_id = vet.id
JOIN animals a ON v.animal_id = a.id
WHERE a.owner_id = (SELECT id FROM owners WHERE full_name = 'Maisy Smith')
GROUP BY vet.name
ORDER BY first_visit_date
LIMIT 1;


-- 7- Details for most recent visit: animal information, vet information, and date of visit.
SELECT a.name AS animal_name, vet.name AS vet_name, v.visit_date
FROM visits v
JOIN animals a ON v.animal_id = a.id
JOIN vets vet ON v.vet_id = vet.id
ORDER BY v.visit_date DESC
LIMIT 1;

-- 8- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*) AS mismatched_specialty_visits
FROM visits v
JOIN animals a ON v.animal_id = a.id
JOIN vets vet ON v.vet_id = vet.id
LEFT JOIN specializations s ON vet.id = s.vet_id AND a.species_id = s.species_id
WHERE s.vet_id IS NULL;

-- 9- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT s.name AS specialty, COUNT(*) AS visit_count
FROM visits v
JOIN animals a ON v.animal_id = a.id
JOIN specializations sp ON a.species_id = sp.species_id
JOIN species s ON sp.species_id = s.id
WHERE a.owner_id = (SELECT id FROM owners WHERE full_name = 'Maisy Smith')
GROUP BY s.name
ORDER BY visit_count DESC
LIMIT 1;

