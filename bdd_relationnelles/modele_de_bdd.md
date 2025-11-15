# Modèles de Bases de Données

### Définitions clés

- Base de données (DB) : Collection organisée d'informations.
- Système de gestion de base de données (SGBD / DBMS) : Logiciel permettant de créer, gérer et interagir avec une base de données.

### Le SGBD fournit :
- Une interface pour les utilisateurs.
- Des outils pour organiser et superviser les données.

---

## Types de modèles

### 1. Modèle relationnel
- Structure en tables avec des relations entre elles.
- Utilise le langage SQL pour interroger et manipuler les données.
- Exemples de SGBD : PostgreSQL, MySQL, Oracle Database.

### 2. Modèle non relationnel (NoSQL)
- Structure plus flexible, adaptée aux données non tabulaires.
- Types principaux :
  - Magasins de documents (ex : MongoDB)
  - Bases orientées colonnes (ex : Cassandra)
  - Magasins clé-valeur (ex : Redis)
  - Bases de graphes (ex : Neo4j)

### 3. Modèle multi-modèle
- Combine plusieurs types de structures (relationnel + NoSQL).


---

## À retenir

- Il n’existe pas de modèle universel : le choix dépend du type de données et des besoins du projet.
- Les bases relationnelles sont idéales pour des données bien structurées.
- Les bases NoSQL sont plus adaptées aux données volumineuses ou non structurées.


# Base de données (BD) : ensemble organisé d’informations stockées et accessibles.  
Système de gestion de base de données (SGBD) : logiciel qui crée, lit, met à jour et supprime les données, et fournit des mécanismes d’accès, de sécurité et d’administration.

---

## Principaux types de modèles

- Relationnel  
  - Données organisées en tables (lignes/colonnes)  
  - Relations exprimées par clés et jointures  
  - Convient aux schémas structurés, intégrité référentielle et requêtes SQL

- NoSQL non relationnel  
  Regroupe plusieurs modèles optimisés pour la flexibilité et la scalabilité horizontale :  
  - Document : enregistrements stockés sous forme de documents (souvent JSON) ; schéma flexible  
  - Clé‑valeur : paires clé → valeur simples ; accès très rapide  
  - Colonnes larges : familles de colonnes, lignes dynamiques ; adapté au big data  
  - Graphe : nœuds et arêtes avec propriétés ; optimisé pour parcours relationnels

---

## Exemple conceptuel étudiant

- Relationnel : table student (id, name, surname, age) ; relations via clés étrangères  
- Document : collection students ; chaque document JSON contient id, name, surname, age et champs imbriqués (adresses, groupes)  
- Clé‑valeur : clé student:123 → valeur = sérialisation de l’étudiant  
- Colonne large : ligne identifiée par id avec colonnes dynamiques pour attributs et historiques  
- Graphe : nœud Student lié à nœuds Course, Group par arêtes

---

## Comparatif par type avec exemples

| Type | Structure | Cas d’usage typiques | Exemples |
|---|---:|---|---|
| Relationnel | Tables relationnelles; schéma fixe | Transactions ACID*, reporting, ERP** | PostgreSQL; MySQL; Oracle Database; SQL Server |
| Document | Documents JSON/BSON dans des collections | API backends, données semi-structurées | MongoDB; CouchDB; Couchbase |
| Clé‑valeur | Paires clé → valeur | Caches, sessions, configuration | Redis; Amazon DynamoDB |
| Colonnes larges | Familles de colonnes; lignes dynamiques | Ingestion massive, séries temporelles | Apache Cassandra; HBase |
| Graphe | Nœuds et arêtes avec propriétés | Réseaux sociaux, recommandations | Neo4j; JanusGraph |

> Remarque : certains SGBD sont multi‑modèles et combinent paradigmes (ex. ArangoDB, Couchbase, Oracle).  
*:Atomicité, Cohérence, Isolation, Durabilité  
**:Enterprise Resource Planning

---

## Rappel

- Aucun modèle n’est universel ; le choix dépend des besoins métier, de la cohérence requise et de la scalabilité souhaitée.  
- Relationnel = contraintes fortes et requêtes SQL complexes.  
- NoSQL = flexibilité et optimisation selon le modèle choisi.

---

## Exemple JSON pour illustrer une base document

```json
{
  "id": "student-123",
  "name": "Aïcha",
  "surname": "Diop",
  "age": 24,
  "email": "aicha.diop@example.com",
  "addresses": [
    {
      "type": "home",
      "street": "12 rue des Fleurs",
      "city": "Paris",
      "postal_code": "75001"
    }
  ],
  "groups": [
    {
      "group_id": "BG1",
      "role": "member"
    }
  ],
  "enrollments": [
    {
      "course_id": "CS101",
      "year": 2025,
      "grade": "A"
    }
  ],
  "metadata": {
    "created_at": "2025-11-09T15:47:00Z",
    "last_updated": "2025-11-01T09:30:00Z"
  }
}
```

---

## Tableau illustrant un enregistrement relationnel

| id | name | surname | age | email |
|---:|---|---|---:|---|
| 123 | Aïcha | Diop | 24 | aicha.diop@example.com |

- Dans un schéma relationnel complet, des tables séparées contiendraient addresses, groups et enrollments liées par des clés étrangères (student_id) au lieu d’être imbriquées dans le même enregistrement.

---

## Base orientée colonne
### Principe
Contrairement aux bases relationnelles classiques (orientées lignes), une base orientée colonne enregistre toutes les valeurs d’une même colonne ensemble sur le disque :

Base orientée ligne : chaque ligne est stockée comme un enregistrement complet.
Base orientée colonne : chaque colonne est stockée séparément, regroupant toutes les valeurs d’un même champ.

Exemple simplifié :
|ID|Nom|Âge|
|--|---|---|
|1	|Alice	|30|
|2	|Bob	|25|
|3	|Charlie	|35|

Stockage ligne : `[1, Alice, 30], [2, Bob, 25], [3, Charlie, 35]`  
Stockage colonne : `[1, 2, 3], [Alice, Bob, Charlie], [30, 25, 35]`

### Interet
Performance analytique : lecture rapide des colonnes pertinentes sans charger les autres.
Compression efficace : les données similaires dans une colonne se compressent mieux.
Scalabilité : adapté aux architectures distribuées et aux entrepôts de données massifs.

### Inconvénients
Moins efficace pour les écritures fréquentes : insérer une ligne complète nécessite de modifier plusieurs blocs de colonnes

---

## Base clé-valeur

### Principe fondamental
Chaque élément est identifié par une clé unique, et associé à une valeur arbitraire (texte, nombre, JSON, binaire…).

Exemple :
```json
{
  "user_123": "Alice",
  "user_456": "Bob",
  "user_789": "Charlie"
}
```
-> Ici, user_123 est la clé, "Alice" est la valeur.

### Interet
Ultra rapide pour les lectures et écritures simples
Scalabilité horizontale : facile à répartir sur plusieurs serveurs
Structure flexible : pas besoin de schéma prédéfini

### Inconvénients
Pas de requêtes complexes (pas de jointures, filtres avancés)
Moins adapté aux données relationnelles ou fortement structurées

---




# Modèle Entité‑Relation — Présentation synthétique

Le modèle Entité‑Relation (ER) est la représentation graphique la plus courante pour concevoir la structure d’une base de données relationnelle ; il sert à schématiser entités, attributs et relations afin d’obtenir une structure cohérente avant implémentation.

---

## Concepts essentiels

- Entités : objets concrets ou abstraits (ex. School, Student). Représentées par un rectangle.  
- Attributs : propriétés des entités (ex. id, name, location, surname). Représentés par une ellipse.  
- Relations : liens entre entités (ex. study entre Student et School). Représentées par un losange.

---

## Exemple didactique (School — Student)

### Schéma ER simple :
```
   [School]─────(study)─────[Student]
   | id                     | id
   | name                   | name
   | location               | surname
```
Ce que cela signifie : l’entité School a des attributs id, name, location ; l’entité Student a id, name, surname ; la relation study relie Student à School.

Relation implémentée en base relationnelle (clé étrangère) :
```
Table: School
+----+------+----------+
| id | name | location |
+----+------+----------+

Table: Student
+----+------+---------+-----------+
| id | name | surname | school_id |
+----+------+---------+-----------+
```
La colonne school_id dans Student est la clé étrangère qui capture la relation study entre Student et School.

---

## Représentations graphiques courantes

### Représentation tabulaire (format compact souvent utilisé) :  
   Chaque entité devient un petit tableau à colonne unique — l’en‑tête est le nom de l’entité et chaque ligne liste un attribut.

   Exemple :
   ```
   ┌─────────┐      ┌────────────┐
   │ School    │      │  Student     │
   │ id        │      │ id           │
   │ name      │      │ name         │
   │ location. │      │ surname      │
   └─────────┘      │ school_id    │
                      └────────────┘
   ```

---

## Règles pratiques lors de la modélisation

- Identifier d’abord les entités principales et leurs attributs obligatoires.  
- Définir les relations et leur cardinalité (1‑1, 1‑n, n‑n) puis décider d’implémentation (clé étrangère ou table d’association).  

<img src="images/types_relations.png" alt="Relations" width="400" style="max-width:100%;height:auto;"> 

- Pour éviter l’encombrement visuel, utiliser la représentation tabulaire quand une entité a beaucoup d’attributs.

---

## Checklist rapide pour convertir ER → schéma relationnel

1. Pour chaque entité, créer une table avec une clé primaire.  
2. Pour chaque relation 1→n, ajouter une clé étrangère dans la table côté n.  
3. Pour chaque relation n↔n, créer une table d’association avec les deux clés étrangères.  
4. Vérifier la normalisation et retirer les redondances.

