

CREATE DATABASE bibliotheque;


DROP TABLE IF EXISTS auteur;
DROP TABLE IF EXISTS cursus;
DROP TABLE IF EXISTS etudiant;
DROP TABLE IF EXISTS emprunt;
DROP TABLE IF EXISTS livre;

-- Table auteur
CREATE TABLE auteur (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(255),
    prenom VARCHAR(255)
);


-- Table cursus
CREATE TABLE cursus (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(255)
);


-- Table livre
CREATE TABLE livre (
    id SERIAL PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    annee_publication INT,
    auteur_id INT REFERENCES auteur(id)
        ON DELETE SET NULL
);


-- Table etudiant
CREATE TABLE etudiant (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    prenom VARCHAR(255) NOT NULL,
    email VARCHAR(255) ,
    cursus_id INT REFERENCES cursus(id)
        ON DELETE SET NULL
);


-- Table emprunt
CREATE TABLE emprunt (
    id SERIAL PRIMARY KEY,
    date_emprunt DATE,
    date_retour DATE,
    livre_id INT REFERENCES livre(id),
    etudiant_id INT REFERENCES etudiant(id)
        ON DELETE SET NULL
);


