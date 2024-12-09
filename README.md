![separe](https://github.com/studoo-app/.github/blob/main/profile/studoo-banner-logo.png)
# TD 3 - Les jointures en SQL
[![Version](https://img.shields.io/badge/Version-2024-blue)]()

## Objectifs

- Comprendre le concept de clé étrangère et sa relation avec les clés primaires.
- Maîtriser la syntaxe des jointures SQL (INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL OUTER JOIN).
- Écrire des requêtes SQL intégrant des jointures pour extraire des informations pertinentes.

## Démarrage des services
- `docker compose up -d` pour démarrer les services
- `docker compose down` pour arrêter les services
- Accéder à PHPMYADMIN via `http://localhost:8080`

## Définition : Créer la relation entre deux tables avec la clé étrangère

Une clé étrangère (FOREIGN KEY) établit un lien entre deux tables. Elle correspond à une colonne
(ou un ensemble de colonnes) dans une table qui fait référence à une clé primaire d'une autre table.

### Exemple
```sql
CREATE TABLE Inscription (
    id_inscription INT PRIMARY KEY,
    id_etudiant INT,
    id_cours INT,
    FOREIGN KEY (id_etudiant) REFERENCES Etudiant(id_etudiant)
);
```

Ici, id_etudiant de la table Inscription est une clé étrangère qui fait référence à id_etudiant de la table Etudiant.


## Utilisation de la relation entre deux tables avec les jointures

Les jointures SQL permettent de lier les données de plusieurs tables sur la base d'une relation commune
(souvent une clé étrangère).

### Les types de jointures :

- **INNER JOIN** : Ne conserve que les correspondances entre les deux tables.
- **LEFT JOIN** : Conserve toutes les lignes de la table de gauche, même si elles n'ont pas de correspondance.
- **RIGHT JOIN** : Conserve toutes les lignes de la table de droite, même si elles n'ont pas de correspondance.

### Mise en application

#### **Exercice 1 : Les jointures simples**

- Affichez la liste des étudiants et les cours auxquels ils sont inscrits. (INNER JOIN)
- Affichez la liste de tous les étudiants, y compris ceux qui ne sont pas inscrits à des cours. (LEFT JOIN)
- Affichez la liste de tous les cours, y compris ceux auxquels aucun étudiant n'est inscrit. (RIGHT JOIN)
- Affichez la liste complète de tous les étudiants et de tous les cours, qu'il y ait correspondance ou non. (FULL OUTER JOIN)

#### **Exercice 2 : Les jointures simples**

- Quels sont les étudiants qui ne sont inscrits à aucun cours ?
- Quels sont les cours qui n’ont aucun étudiant inscrit ?
- Affichez la liste des étudiants avec leurs cours. Indiquez "Non inscrit" si l'étudiant n'est inscrit à aucun cours.

#### **Exercice 3 : Modification des Données**

- Insérez un nouvel étudiant nommé "Bernard Simon".
- Inscrivez "Bernard Simon" au cours "Anglais".
- Supprimez l'inscription de Paul Leroy au cours de Mathématiques.

#### **Exercice 4 : Verification de l'intégrité**

- Essayez de supprimer un étudiant qui est encore inscrit à un cours.
- Essayez d’insérer un enregistrement dans la table `Inscription` avec un `id_etudiant` ou un `id_cours` qui n'existe pas.

#### **Exercice 5 : Création d'une Requête Complexe**

- Affichez la liste des étudiants, le nombre total de cours auxquels ils sont inscrits et la liste de ces cours sous forme de texte.

