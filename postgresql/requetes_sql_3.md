# Les fonctions d’agrégation en SQL
## 1. Définition
Les fonctions d’agrégation permettent de réaliser des calculs sur un ensemble de lignes et de retourner une seule valeur. Elles sont souvent utilisées avec GROUP BY.

## 2. Principales fonctions
|Fonction|Description|Exemple|
|--------|-----------|-------|
|COUNT|	Compte le nombre de lignes	|SELECT COUNT(*) FROM clients;|
|MAX|	Retourne la valeur maximale	|SELECT MAX(prix) FROM produits;|
|MIN|	Retourne la valeur minimale	|SELECT MIN(stock) FROM produits;|
|AVG|	Calcule la moyenne	|SELECT AVG(prix) FROM produits;|
|STDDEV|	Calcule l’écart-type	|SELECT STDDEV(prix) FROM produits;|
|SUM|	Calcule la somme	|SELECT SUM(quantite) FROM lignes_commandes;|

## 3. Exemples pratiques sur ton schéma
### a) Nombre total de clients
```sql
SELECT COUNT(*) AS nb_clients FROM clients;
```
### b) Prix maximum et minimum des produits
```sql
SELECT MAX(prix) AS prix_max, MIN(prix) AS prix_min FROM produits;
```
### c) Moyenne du prix des produits
```sql
SELECT AVG(prix) AS prix_moyen FROM produits;
```
### d) Somme des quantités commandées
```sql
SELECT SUM(quantite) AS total_quantites FROM lignes_commandes;
```
### e) Écart-type du prix des produits
```sql
SELECT STDDEV(prix) AS dispersion_prix FROM produits;
```
### f) Agrégation avec GROUP BY : total par client
```sql
SELECT c.nom, COUNT(co.commande_id) AS nb_commandes
FROM clients c
LEFT JOIN commandes co ON c.client_id = co.client_id
GROUP BY c.nom;
```
-> Affiche le nombre de commandes par client.

# Les calculs arithmétiques en SQL
## 1. Opérateurs
|Opérateur|	Description|	Exemple|
|---------|------------|---------|
|+	|Addition	|SELECT prix + 10 FROM produits;|
|-	|Soustraction	|SELECT prix - 5 FROM produits;|
|*	|Multiplication	|SELECT prix * quantite FROM lignes_commandes;|
|/	|Division	|SELECT prix / 2 FROM produits;|
|%	|Modulo (reste d’une division entière)	|SELECT 10 % 3;|

## 2. Exemples pratiques
### a) Calculer le montant total d’une ligne de commande
```sql
SELECT ligne_id, quantite * prix_unitaire AS montant_total
FROM lignes_commandes;
```
### b) Augmenter tous les prix de 5%
```sql
SELECT produit_id, nom, prix, prix * 1.05 AS prix_augmenté
FROM produits;
```
### c) Calculer le nombre de commandes par année
```sql
SELECT EXTRACT(YEAR FROM date_commande) AS annee,
       COUNT(*) AS nb_commandes
FROM commandes
GROUP BY annee;
```
# Exercices pratiques
 - Compter le nombre de produits disponibles dans la table produits.
 - Afficher le prix moyen des produits par catégorie (GROUP BY categorie).
 - Calculer le montant total de chaque commande (somme des quantite * prix_unitaire).
 - Afficher le client qui a passé le plus de commandes.
 - Calculer la somme des stocks disponibles par famille de produits.
 - Afficher l’écart-type des prix des produits pour analyser la dispersion.
 - Calculer le montant total des ventes par client.
 - Afficher les commandes passées en 2025 et leur nombre.
 - Calculer le prix minimum, maximum et moyen des categories commandés.
 - Afficher les produits dont le stock est un multiple de 5 (utiliser %).

## Filtrer les Groupes avec HAVING
La clause `HAVING` est l'un des concepts les plus subtils du SQL et est souvent confondue avec `WHERE`.  
Il est crucial de comprendre que `HAVING` est utilisée pour filtrer les RESULTATS des fonctions d'agrégation (comme COUNT, SUM, AVG, etc.), tandis que `WHERE` filtre les lignes AVANT que l'agrégation ne se produise.

### 1. Le rôle de HAVING
HAVING filtre les groupes générés par la clause GROUP BY.

 - `WHERE` -> Filtre les lignes individuelles avant le groupement.
 - `GROUP BY` -> Aggrège les lignes restantes en groupes.
 - `HAVING` -> Filtre les groupes en fonction d'un critère d'agrégation.

### 2. Syntaxe et Ordre d'exécution
La clause `HAVING` doit toujours suivre la clause `GROUP BY` dans la requête.
```SQL
SELECT
    colonne_groupe,
    fonction_aggregation(colonne)
FROM
    nom_table
WHERE
    condition_sur_lignes -- (Optionnel)
GROUP BY
    colonne_groupe
HAVING
    condition_sur_groupes; -- (Obligatoire pour filtrer les agrégats)
 ```
### 3. Exemple Pratique : Les Commandes Rares
Supposons que nous ayons une table Commandes et que nous voulions identifier uniquement les clients ayant effectué moins de 3 commandes au total.

Pour trouver les clients avec moins de 3 commandes :
```SQL
SELECT
    id_client,
    COUNT(id_client) AS nombre_commandes
FROM
    Commandes
GROUP BY
    id_client
HAVING
    COUNT(id_client) < 3;

```
 - `GROUP BY id_client` : Crée des groupes par client.
 - `COUNT(id_client)` : Calcule le nombre de commandes pour chaque groupe.
 - `HAVING COUNT(id_client) < 3`: Filtre les groupes où le décompte est inférieur à 3.

# Exercices pratiques
   1. Afficher les catégories de produits dont le prix moyen est supérieur à 800
   2. Afficher les commandes dont le montant total (somme des quantités × prix unitaire) dépasse 1000.
   3. Afficher les familles de produits dont le stock cumulé est inférieur à 50.
