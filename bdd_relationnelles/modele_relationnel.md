
# Introduction
Ce document presente les notions essentielles des modèles relationnels : clés (primaire / étrangère), types de relations (plusieurs-à-un, un-à-plusieurs, un-à-un, plusieurs-à-plusieurs) et les options ON DELETE pour les contraintes de clé étrangère.

---

# Clés primaire et clé étrangère
- Définitions : Une clé primaire (PK) identifie de façon unique chaque enregistrement d'une table. Une clé étrangère (FK) est une colonne qui référence la PK d'une autre table pour établir une relation entre enregistrements.  
- Usage courant : Dans une table student la colonne id est la PK ; group_id est une FK pointant vers group.id. Cette organisation facilite les opérations de jointure (JOIN) et garantit l'intégrité référentielle.

---
# Relations
## Relation Un à Un
- Concept : Chaque enregistrement d'une table correspond à au plus un enregistrement dans l'autre table. La relation repose sur une FK déclarée avec une contrainte d'unicité (unique=True) pour empêcher plusieurs références identiques.  
- Variantes : Une relation peut être obligatoire dans un sens (par exemple passeport obligatoire pour un certain type d'utilisateur) ou optionnelle dans l'autre (une personne peut exister sans passeport).  
- Implémentation : placer la FK sur l'une des deux tables et ajouter une contrainte UNIQUE ; éventuellement rendre la FK NOT NULL si la dépendance est obligatoire.

---

## De Plusieurs-à-Un et d'Un-à-Plusieurs (perspectives inverses)
- Explication : « Plusieurs-à-un » et « un-à-plusieurs » sont deux points de vue d'une même relation : d'un côté de la FK on voit plusieurs enregistrements référer à un enregistrement unique dans l'autre table ; vu du côté opposé, un enregistrement est lié à plusieurs enregistrements.  
- Cas courant : chaque student a un school_id (FK) ; plusieurs étudiants peuvent appartenir à la même école — c'est une relation many-to-one du point de vue student et one-to-many du point de vue school.  
- Anti-pattern : stocker une liste de PK dans une colonne (table avec colonne contenant plusieurs clés) est déconseillé en relationnel ; mieux vaut une table liée par FKs.

---

## Relation Plusieurs-à-Plusieurs
- Concept : Deux tables peuvent être reliées par plusieurs enregistrements de chaque côté. On introduit une table intermédiaire (table d'association) contenant au minimum : id, firsttableid, secondtableid où les deux dernières colonnes sont des FK vers leurs tables respectives.  
- Exemple : service d'autopartage avec table driver_car reliant driver.id et car.id ; plusieurs conducteurs peuvent avoir conduit plusieurs voitures et inversement.  
- Remarque de diagramme : les tables d'association sont souvent omises dans les diagrammes simplifiés, mais sont nécessaires pour la modélisation physique et les requêtes efficaces.

---



# Options ON DELETE pour les contraintes de clé étrangère
## - Rôle :
l'option ON DELETE définit le comportement lorsqu'un enregistrement référencé (la PK) est supprimé ; cette option doit être précisée à la création de la FK (par l'interface du SGBD ou explicitement en SQL).  
## - Principales actions :
  - CASCADE : suppression en cascade des enregistrements dépendants (si le groupe est supprimé, supprimer tous les étudiants liés).  
  - RESTRICT / NO ACTION : empêche la suppression tant qu'il existe des enregistrements dépendants (garantit l'intégrité).  
  - SET NULL : remplace la FK par NULL dans les enregistrements dépendants ; la colonne FK doit accepter les valeurs NULL pour être utilisable.  
  - SET DEFAULT : remplace la FK par une valeur par défaut définie au niveau de la colonne plutôt que par NULL.

---

## Exemples SQL pratiques
- Création d'une FK simple (many-to-one) :
`sql
CREATE TABLE "group" (
  id SERIAL PRIMARY KEY,
  name TEXT,
  grade TEXT
);

CREATE TABLE student (
  id SERIAL PRIMARY KEY,
  name TEXT,
  surname TEXT,
  age INT,
  group_id INT REFERENCES "group"(id) ON DELETE SET NULL
);
`
- Table d'association pour many-to-many :
`sql
CREATE TABLE driver_car (
  id SERIAL PRIMARY KEY,
  driver_id INT REFERENCES driver(id) ON DELETE CASCADE,
  car_id INT REFERENCES car(id) ON DELETE CASCADE
);
`
Ces exemples illustrent l'utilisation des PK/FK et des options ON DELETE présentées précédemment.

---

# Bonnes pratiques et conseils de conception
- Définir clairement la dépendance entre entités pour choisir la bonne option ON DELETE (ex. CASCADE quand la vie de l'enfant dépend du parent, SET NULL ou RESTRICT sinon).  
- Préférer une table d'association pour représenter les relations plusieurs-à-plusieurs plutôt que stocker des listes dans une colonne.  
- Utiliser des contraintes d'unicité sur la FK quand la relation doit être strictement un-à-un.  
- Tester les effets des options ON DELETE dans un environnement de développement avant production pour éviter suppressions involontaires.

---

# Résumé rapide
- PK = identifiant unique d'une table ; FK = référence vers une PK d'une autre table ; relations se traduisent par FKs et tables d'association pour les many-to-many.  
- Les relations plusieurs↔un sont la forme la plus courante ; un-à-un exige une contrainte UNIQUE sur la FK ; plusieurs-à-plusieurs nécessite une table intermédiaire.  
- ON DELETE contrôle le comportement lors de la suppression du parent : CASCADE, RESTRICT/NO ACTION, SET NULL, SET DEFAULT.

--- 
