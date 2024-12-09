-- Création de la table Etudiant
CREATE TABLE Etudiant
(
    id_etudiant INT PRIMARY KEY,
    nom         VARCHAR(50),
    prenom      VARCHAR(50)
);

INSERT INTO Etudiant (id_etudiant, nom, prenom)
VALUES (1, 'Dupont', 'Jean'),
       (2, 'Martin', 'Sarah'),
       (3, 'Leroy', 'Paul');

-- Création de la table Cours
CREATE TABLE Cours
(
    id_cours  INT PRIMARY KEY,
    nom_cours VARCHAR(50)
);

INSERT INTO Cours (id_cours, nom_cours)
VALUES (1, 'Mathématiques'),
       (2, 'Informatique'),
       (3, 'Anglais');
