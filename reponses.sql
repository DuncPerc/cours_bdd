--------------  REQUETES 1 SQL  --------------

-- Affiche tous les clients inscrits en 2025.
SELECT * FROM clients WHERE date_inscription BETWEEN '2025-01-01' and '2025-12-31'

-- Affiche uniquement les noms et emails des clients dont le nom contient la lettre "e".
SELECT * FROM clients WHERE nom  LIKE '%e%' AND email  LIKE '%e%';

-- Affiche les clients dont l’email est nul.
SELECT * FROM clients WHERE email IS NULL;

-- Affiche les clients dont l’id est compris entre 5 et 10.
SELECT * FROM clients WHERE client_id BETWEEN 5 AND 10;

-- Affiche les clients dont le champ nom ne commence pas par "M".
SELECT * FROM clients WHERE nom NOT LIKE 'M%';

-- Affiche les clients inscrits avant 2023 ou dont le nom contient "ad".
SELECT * FROM clients WHERE date_inscription < '2023-01-01' OR nom LIKE '%ad%';

-- Affiche les clients dont l’email appartient à une liste donnée (IN).
SELECT * FROM clients WHERE email IN ('francois.petit@gmail.com', 'claire.leroy@yahoo.com');

-- Affiche les clients dont la date d’inscription est comprise entre janvier et mars 2024.
SELECT * FROM clients WHERE date_inscription BETWEEN '2024-01-01' AND '2024-03-31';

-- Affiche les clients dont le nom est différent de "Dupont".
SELECT * FROM clients WHERE nom NOT LIKE '%Dupont%';


--------------  REQUETES 2 SQL  --------------

-- Affiche la liste des clients avec leurs commandes (même ceux qui n’ont pas de commande).
SELECT * FROM clients c LEFT JOIN commandes co ON c.client_id = co.client_id;

-- Affiche toutes les commandes avec le nom du client et leur statut.
SELECT co.commande_id, c.nom, co.statut FROM clients c RIGHT JOIN commandes co ON c.client_id = co.client_id;

-- Affiche les produits commandés par "Alice Dupont".
SELECT DISTINCT(p.nom) FROM produits p
INNER JOIN lignes_commandes lc ON lc.produit_id = p.produit_id
INNER JOIN commandes co ON co.commande_id = lc.commande_id
INNER JOIN clients c ON co.client_id = c.client_id
WHERE c.nom LIKE 'Alice Dupont'

-- Affiche les clients qui n’ont jamais passé de commande.
SELECT nom FROM clients
WHERE client_id NOT IN (
    SELECT c.client_id 
    FROM clients c
    INNER JOIN commandes co ON c.client_id = co.client_id);

-- Affiche toutes les commandes avec les produits associés et la quantité commandée.
SELECT co.commande_id, p.nom, lc.quantite FROM commandes co
INNER JOIN lignes_commandes lc ON co.commande_id = lc.commande_id
INNER JOIN produits p ON lc.produit_id = p.produit_id

-- Affiche les clients et les produits qu’ils ont commandés, en utilisant une jointure multiple.
SELECT co.commande_id, c.nom AS client, p.nom AS produit, lc.quantite
FROM commandes co
INNER JOIN clients c ON co.client_id = c.client_id
INNER JOIN lignes_commandes lc ON co.commande_id = lc.commande_id
INNER JOIN produits p ON lc.produit_id = p.produit_id;

-- Affiche toutes les commandes, même celles sans client (test avec FULL OUTER JOIN).
SELECT c.nom, co.commande_id
FROM clients c
FULL OUTER JOIN commandes co ON c.client_id = co.client_id;

-- Affiche toutes les combinaisons possibles entre clients et produits (CROSS JOIN).
SELECT c.nom, p.nom
FROM clients c
CROSS JOIN produits p;


--------------  REQUETES 3 SQL  --------------







--------------  REQUETES 4 SQL  --------------