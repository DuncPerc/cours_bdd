# Les jointures en SQL
## 1. Principe
Une jointure permet de combiner des données provenant de plusieurs tables en fonction d’une relation logique (clé primaire ↔ clé étrangère). Dans ton schéma, les relations sont :

clients.client_id ↔ commandes.client_id
commandes.commande_id ↔ lignes_commandes.commande_id
produits.produit_id ↔ lignes_commandes.produit_id

## 2. Les principaux types de jointures
|Type de jointure|Syntaxe de base|Résultat|
|----------------|---------------|--------|
|INNER JOIN	|SELECT ... FROM A INNER JOIN B ON A.id = B.id;|	Retourne uniquement les lignes qui ont une correspondance dans les deux tables|
|LEFT JOIN	|SELECT ... FROM A LEFT JOIN B ON A.id = B.id;|	Retourne toutes les lignes de la table de gauche, même si pas de correspondance dans la table de droite|
|RIGHT JOIN	|SELECT ... FROM A RIGHT JOIN B ON A.id = B.id;|	Retourne toutes les lignes de la table de droite, même si pas de correspondance dans la table de gauche|
|FULL OUTER JOIN	|SELECT ... FROM A FULL OUTER JOIN B ON A.id = B.id;|	Retourne toutes les lignes des deux tables, avec NULL si pas de correspondance|
|CROSS JOIN	|SELECT ... FROM A CROSS JOIN B;|	Produit le produit cartésien (chaque ligne de A combinée avec chaque ligne de B)|

<img src="images/jointures_sql.png" alt="Jointures" width="400" style="max-width:100%;height:auto;"> 


## 3. Exemples pratiques sur le schéma e‑commerce
### a) INNER JOIN : clients et commandes
```sql
SELECT c.nom, c.email, co.commande_id, co.date_commande
FROM clients c
INNER JOIN commandes co ON c.client_id = co.client_id;
```
-> Affiche uniquement les clients qui ont passé au moins une commande.

### b) LEFT JOIN : tous les clients, même sans commande
```sql
SELECT c.nom, c.email, co.commande_id
FROM clients c
LEFT JOIN commandes co ON c.client_id = co.client_id;
```
-> Affiche tous les clients, avec NULL pour ceux qui n’ont pas encore passé de commande.

### c) Jointure multiple : commandes et produits
```sql
SELECT co.commande_id, c.nom AS client, p.nom AS produit, lc.quantite
FROM commandes co
INNER JOIN clients c ON co.client_id = c.client_id
INNER JOIN lignes_commandes lc ON co.commande_id = lc.commande_id
INNER JOIN produits p ON lc.produit_id = p.produit_id;
```
-> Affiche les commandes avec le nom du client et les produits commandés.

### d) FULL OUTER JOIN : clients et commandes
```sql
SELECT c.nom, co.commande_id
FROM clients c
FULL OUTER JOIN commandes co ON c.client_id = co.client_id;
```
-> Affiche tous les clients et toutes les commandes, même si certains n’ont pas de correspondance.

### e) CROSS JOIN : produit cartésien
```sql
SELECT c.nom, p.nom
FROM clients c
CROSS JOIN produits p;
```
-> Chaque client est associé à chaque produit (utile pour tester toutes les combinaisons possibles).

## 4. Exercices pratiques
 - Affiche la liste des clients avec leurs commandes (même ceux qui n’ont pas de commande).
 - Affiche toutes les commandes avec le nom du client et leur statut.
 - Affiche les produits commandés par "Alice Dupont".
 - Affiche les clients qui n’ont jamais passé de commande.
 - Affiche toutes les commandes avec les produits associés et la quantité commandée.
 - Affiche les clients et les produits qu’ils ont commandés, en utilisant une jointure multiple.
 - Affiche toutes les commandes, même celles sans client (test avec FULL OUTER JOIN).
 - Affiche toutes les combinaisons possibles entre clients et produits (CROSS JOIN).
 - Affiche les clients qui ont commandé au moins deux produits différents.
 - Affiche les produits qui n’ont jamais été commandés.
