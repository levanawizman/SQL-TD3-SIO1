![separe](https://github.com/studoo-app/.github/blob/main/profile/studoo-banner-logo.png)
# TD 3 - Les jointures en SQL - Correction
[![Version](https://img.shields.io/badge/Version-2024-blue)]()

## Mise en place de la table Inscription

Une inscription représente une liaison entre un étudiant et un cours

```sql -- Création de la table Inscription 
CREATE TABLE Inscription
(
    id_inscription INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    id_etudiant    INT,
    id_cours       INT,
    FOREIGN KEY (id_etudiant) REFERENCES Etudiant (id_etudiant),
    FOREIGN KEY (id_cours) REFERENCES Cours (id_cours)
);

-- Insertion de données
INSERT INTO Inscription (id_etudiant, id_cours)
VALUES (1, 1),
       (1, 2),
       (2, 3),
       (3, 1);
```

## Exercices Pratiques

### **Exercice 1 : Les jointures simples**

Affichez la liste des étudiants et les cours auxquels ils sont inscrits. (INNER JOIN)

```sql
SELECT e.nom, e.prenom, c.nom_cours 
FROM Inscription i 
INNER JOIN Etudiant e ON i.id_etudiant = e.id_etudiant 
INNER JOIN Cours c ON i.id_cours = c.id_cours;
```

Affichez la liste de tous les étudiants, y compris ceux qui ne sont pas inscrits à des cours. (LEFT JOIN)

```sql 
SELECT e.nom, e.prenom, c.nom_cours 
FROM Etudiant e 
LEFT JOIN Inscription i ON e.id_etudiant = i.id_etudiant 
LEFT JOIN Cours c ON i.id_cours = c.id_cours;
```

Affichez la liste de tous les cours, y compris ceux auxquels aucun étudiant n'est inscrit. (RIGHT JOIN)

```sql
SELECT e.nom, e.prenom, c.nom_cours 
FROM Inscription i 
RIGHT JOIN Cours c ON i.id_cours = c.id_cours 
LEFT JOIN Etudiant e ON i.id_etudiant = e.id_etudiant;
```

### **Exercice 2 : Les jointures simples**

**Quels sont les étudiants qui ne sont inscrits à aucun cours ?**

```sql
SELECT e.nom, e.prenom  
FROM Etudiant e 
LEFT JOIN Inscription i ON e.id_etudiant = i.id_etudiant 
WHERE i.id_cours IS NULL;
```

**Explication :**
- La **LEFT JOIN** permet de lister tous les étudiants, même ceux qui ne sont pas inscrits à des cours.
- La clause `WHERE i.id_cours IS NULL` permet de filtrer uniquement les étudiants sans inscription.

**Quels sont les cours qui n’ont aucun étudiant inscrit ?**

```sql
SELECT c.nom_cours  
FROM Cours c 
LEFT JOIN Inscription i ON c.id_cours = i.id_cours 
WHERE i.id_etudiant IS NULL;
```

**Explication :**

- La **LEFT JOIN** permet de lister tous les cours, même ceux qui n’ont pas d’étudiant inscrit.
- La clause `WHERE i.id_etudiant IS NULL` permet de filtrer les cours sans inscription.

**Affichez la liste des étudiants avec leurs cours. Indiquez "Non inscrit" si l'étudiant n'est inscrit à aucun cours.**

```sql
SELECT e.nom, e.prenom,COALESCE(c.nom_cours, 'Non inscrit') AS nom_cours
FROM Etudiant e 
LEFT JOIN Inscription i ON e.id_etudiant = i.id_etudiant 
LEFT JOIN Cours c ON i.id_cours = c.id_cours;
```

**Explication :**

- La **LEFT JOIN** liste tous les étudiants, y compris ceux sans inscription.
- La fonction `COALESCE(c.nom_cours, 'Non inscrit')` remplace les valeurs NULL (absence de correspondance) par "Non inscrit".

### **Exercice 3 : Modification des Données**

- Insérez un nouvel étudiant nommé "Bernard Simon".
- Inscrivez "Bernard Simon" au cours "Anglais".
- Supprimez l'inscription de Paul Leroy au cours de Mathématiques.

```sql
-- 1. Insérer un nouvel étudiant
INSERT INTO Etudiant (id_etudiant, nom, prenom) 
VALUES (4, 'Bernard', 'Simon');

-- 2. Inscrire Bernard Simon au cours "Anglais"
INSERT INTO Inscription (id_inscription, id_etudiant, id_cours) 
VALUES (5, 4, 3);

-- 3. Supprimer l'inscription de Paul Leroy au cours de Mathématiques
DELETE FROM Inscription 
WHERE id_etudiant = 3 
  AND id_cours = 1;

```

### **Exercice 4 : Verification de l'intégrité**

##### **Essayez de supprimer un étudiant qui est encore inscrit à un cours.**

**Situation**

On va tenter de supprimer l'étudiant "Jean Dupont" de la table **Etudiant**. Jean Dupont est identifié par `id_etudiant = 1` et il est actuellement inscrit à deux cours (Mathématiques et Informatique) selon les données de la table **Inscription**.

```sql
DELETE FROM Etudiant  WHERE id_etudiant = 1;
```

**Résultat attendu**

Cette requête **échoue** et renvoie une erreur du type :

```less
ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails (`nom_base`.`Inscription`, CONSTRAINT `inscription_ibfk_1` FOREIGN KEY (`id_etudiant`) REFERENCES `Etudiant` (`id_etudiant`))
```

**Explication**

- La table **Inscription** contient une clé étrangère `id_etudiant` qui fait référence à la clé primaire `id_etudiant` de la table **Etudiant**.
- En SQL, lorsqu'une **clé étrangère** est définie avec la contrainte `FOREIGN KEY`, on empêche la suppression des enregistrements parent (ici, l'étudiant) s'il existe des enregistrements associés (les inscriptions).
- Cette règle garantit **l'intégrité référentielle** : on ne peut pas laisser des enregistrements "orphelins" dans la table **Inscription**.

**Solution possible**

Supprimer d'abord les inscriptions associées à l'étudiant avant de supprimer l'étudiant.

```sql
DELETE FROM Inscription  WHERE id_etudiant = 1;
DELETE FROM Etudiant  WHERE id_etudiant = 1;
```

##### **Essayez d’insérer un enregistrement dans la table `Inscription` avec un `id_etudiant` ou un `id_cours` qui n'existe pas.**

**Situation 1 : Insertion d'un `id_etudiant` inexistant**

On tente d'insérer une inscription avec `id_etudiant = 99`, alors que l'étudiant ayant cet identifiant **n'existe pas** dans la table **Etudiant**.

```sql
INSERT INTO Inscription (id_inscription, id_etudiant, id_cours)  VALUES (6, 99, 1);
```

**Résultat attendu**

Cette requête **échoue** et renvoie une erreur du type :

```less 
ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`nom_base`.`Inscription`, CONSTRAINT `inscription_ibfk_1` FOREIGN KEY (`id_etudiant`) REFERENCES `Etudiant` (`id_etudiant`))
```

**Explication**

- La colonne `id_etudiant` de la table **Inscription** est une **clé étrangère** qui pointe vers la colonne `id_etudiant` de la table **Etudiant**.
- On ne peut insérer que des **valeurs existantes** dans une colonne référencée par une clé étrangère.
- L'intégrité référentielle interdit l'insertion de valeurs dans **Inscription** qui ne sont pas présentes dans la table **Etudiant**.

**Solution**

Vérifier que l'étudiant existe avant l'insertion puis insérer l'étudiant avant d'insérer l'inscription.

```sql
SELECT * FROM Etudiant WHERE id_etudiant = 99;

INSERT INTO Etudiant (id_etudiant, nom, prenom) 
VALUES (99, 'NomTest', 'PrenomTest');

INSERT INTO Inscription (id_inscription, id_etudiant, id_cours) 
VALUES (6, 99, 1);
```


##### **Situation 2 : Insertion d'un `id_cours` inexistant**

On tente d'insérer une inscription avec un `id_cours = 99`, alors que le cours correspondant **n'existe pas** dans la table **Cours**.

```sql
INSERT INTO Inscription (id_inscription, id_etudiant, id_cours)  
VALUES (7, 1, 99);
```

**Résultat attendu**

Cette requête **échoue** et renvoie une erreur du type :

```less
ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`nom_base`.`Inscription`, CONSTRAINT `inscription_ibfk_2` FOREIGN KEY (`id_cours`) REFERENCES `Cours` (`id_cours`))
```

**Explication**

- La colonne `id_cours` de la table **Inscription** est une **clé étrangère** qui pointe vers la colonne `id_cours` de la table **Cours**.
- On ne peut insérer que des **valeurs existantes** dans une colonne référencée par une clé étrangère.
- L'intégrité référentielle interdit l'insertion de valeurs dans **Inscription** qui ne sont pas présentes dans la table **Cours**.

**Solution**

Vérifier que le cours existe avant l'insertion, puis insérer le cours avant de faire l'inscription.

```sql
SELECT * FROM Cours WHERE id_cours = 99;

INSERT INTO Cours (id_cours, nom_cours) 
VALUES (99, 'Cours Test');

INSERT INTO Inscription (id_inscription, id_etudiant, id_cours) 
VALUES (7, 1, 99);

```

##### **Résumé des points clés**

|**Action**|**Contrainte d'intégrité**|**Solution possible**|
|---|---|---|
|**Suppression d'un étudiant**|Clé étrangère dans la table **Inscription**|Supprimer d'abord les lignes dans **Inscription** ou utiliser `ON DELETE CASCADE`|
|**Insertion d'un id_etudiant inexistant**|Référence à **Etudiant(id_etudiant)**|Insérer l'étudiant avant l'inscription|
|**Insertion d'un id_cours inexistant**|Référence à **Cours(id_cours)**|Insérer le cours avant l'inscription|

### **Exercice 5 : Création d'une Requête Complexe**

Affichez la liste des étudiants, le nombre total de cours auxquels ils sont inscrits et la liste de ces cours sous forme de texte.

```sql
SELECT e.nom, e.prenom, COUNT(i.id_cours) AS nb_cours, 
    STRING_AGG(c.nom_cours, ', ') AS liste_cours
FROM Etudiant e
LEFT JOIN Inscription i ON e.id_etudiant = i.id_etudiant
LEFT JOIN Cours c ON i.id_cours = c.id_cours
GROUP BY e.id_etudiant, e.nom, e.prenom;

```
