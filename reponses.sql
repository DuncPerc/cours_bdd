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

-- Compter le nombre de produits disponibles dans la table produits.
-- V1 : comptage du nombre total de produits disponibles (stock total)
SELECT SUM(STOCK) FROM produits 
-- V2 : comptage du nombre de type de produits disponibles
SELECT COUNT(*) FROM produits WHERE stock > 0

-- Afficher le prix moyen des produits par catégorie (GROUP BY categorie).
SELECT categorie, ROUND(AVG(prix),2) AS prix_moyen FROM produits GROUP BY categorie;

-- Calculer le montant total de chaque commande (somme des quantite * prix_unitaire).
SELECT commande_id, SUM(quantite*prix_unitaire) AS montant_total FROM lignes_commandes GROUP BY commande_id

-- Afficher le client qui a passé le plus de commandes.
-- Remarque : ici ce n'est pas le nom du client mais le nombre maximum de commandes passées par un client
SELECT MAX(nb_commandes) AS nb_commandes_max 
FROM (
    SELECT c.nom, COUNT(co.commande_id) AS nb_commandes FROM commandes co, clients c
    WHERE co.client_id = c.client_id
    GROUP BY co.client_id, c.nom) AS comptage_commandes

-- Calculer la somme des stocks disponibles par famille de produits.
SELECT famille, SUM(stock) AS stocks FROM produits GROUP BY famille

-- Afficher l’écart-type des prix des catégories des produits pour analyser la dispersion.
SELECT categorie, STDDEV(prix) AS dispersion_prix FROM produits GROUP BY categorie;

-- Calculer le montant total des ventes par client.
SELECT client_id, SUM(lc.quantite*lc.prix_unitaire) AS montant_total FROM commandes co
INNER JOIN lignes_commandes lc ON co.commande_id = lc.commande_id
GROUP BY client_id
ORDER BY montant_total DESC

-- Afficher les commandes passées en 2025 et leur nombre.
SELECT EXTRACT(YEAR FROM date_commande) AS annee, COUNT(*) AS nb_commandes
FROM commandes
GROUP BY annee

-- Calculer le prix minimum, maximum et moyen des catégories de produits commandés.
SELECT categorie, MAX(prix), MIN(prix), ROUND(AVG(prix),2) AS prix_moyen FROM produits GROUP BY categorie

-- Afficher les produits dont le stock est un multiple de 5 (utiliser %).
SELECT * FROM produits WHERE stock % 5 = 0;


-- Afficher les catégories de produits dont le prix moyen est supérieur à 800
SELECT categorie, ROUND(AVG(prix),2) AS prix_moyen FROM produits GROUP BY categorie HAVING AVG(prix) > 800

-- Afficher les commandes dont le montant total (somme des quantités × prix unitaire) dépasse 1000.
SELECT commande_id, SUM(quantite*prix_unitaire) AS montant_total 
FROM lignes_commandes 
GROUP BY commande_id 
HAVING SUM(quantite*prix_unitaire)>1000
ORDER BY montant_total DESC

-- Afficher les familles de produits dont le stock cumulé est inférieur à 50.
SELECT famille, SUM(stock) as stocks 
FROM produits 
GROUP BY famille 
HAVING SUM(stock)<50
ORDER BY stocks ASC


--------------  REQUETES 4 SQL  --------------

-- Afficher les produits dont le prix est supérieur au prix moyen (sous‑requête).
SELECT * 
FROM produits
WHERE prix > (SELECT AVG(prix) FROM produits)

-- Afficher les clients qui ont passé au moins deux commandes (sous‑requête avec COUNT).
-- ne fonctionne pas
SELECT *
FROM (
    SELECT client_id, COUNT(DISTINCT(commande_id)) AS nb_commandes
    FROM commandes 
    GROUP BY client_id) AS tab
WHERE nb_commandes > 2

-- Afficher les commandes avec une colonne supplémentaire indiquant si elles sont "récentes" (après 2025‑01‑01) ou "anciennes" (avant).
SELECT commande_id, statut, date_commande,
       CASE
           WHEN date_commande > '2025-01-01' THEN 'récentes'
           ELSE 'anciennes'
       END AS etat
FROM commandes;

-- Catégoriser les produits en trois classes de prix : bas, moyen, élevé (avec CASE).
SELECT nom,
       prix,
       CASE
           WHEN prix < 200 THEN 'Bas'
           WHEN prix BETWEEN 200 AND 1000 THEN 'Moyen'
           ELSE 'Cher'
       END AS categorie_prix
FROM produits;

-- Afficher les clients avec une colonne indiquant "nouveau" si inscrits après 2024, sinon "ancien".
SELECT *,
    CASE
        WHEN EXTRACT(YEAR FROM date_inscription)  > 2024 THEN 'nouveau'
        ELSE 'ancien'
    END AS statut_client
FROM clients

-- Afficher les produits commandés et ajouter une colonne "stock critique" si le stock est inférieur à 5.
SELECT *,
    CASE
        WHEN stock < 5 THEN 'stock critique'
        ELSE ''
    END AS etat_stock
FROM produits

-- Utiliser une sous‑requête pour afficher le produit le plus cher commandé par chaque client.
SELECT c.nom, p.nom, p.prix
FROM clients c
INNER JOIN commandes co ON c.client_id = co.client_id
INNER JOIN lignes_commandes lc on co.commande_id = co.client_id
INNER JOIN produits p ON lc.produit_id = p.produit_id;
WHERE () -- A finir

-- Afficher les commandes avec une colonne "statut détaillé" traduite en français (avec CASE).
SELECT commande_id,
       statut,
       CASE statut
           WHEN 'en cours' THEN 'Commande en préparation'
           WHEN 'expédiée' THEN 'Commande en route'
           WHEN 'livrée' THEN 'Commande terminée'
           WHEN 'annulée' THEN 'Commande annulée'
           ELSE 'Statut inconnu'
       END AS statut_detail
FROM commandes;

-- Afficher les clients qui n’ont jamais passé de commande (sous‑requête avec NOT IN).
SELECT * 
FROM clients
WHERE client_id NOT IN (
    SELECT c.client_id 
    FROM clients c
    INNER JOIN commandes co ON c.client_id = co.client_id);

-- Afficher les lignes de commande avec une colonne calculée "montant_total" et une classification : "petite commande" (<50), "moyenne" (50‑200), "grande" (>200)
SELECT *,
    CASE
        WHEN montant_total < 500 THEN 'petite commande'
        WHEN montant_total BETWEEN 500 AND 2000 THEN 'moyenne commande'
        ELSE 'grande commande'
    END AS classe_commande
FROM (SELECT commande_id, SUM(quantite*prix_unitaire) AS montant_total FROM lignes_commandes GROUP BY commande_id) AS tab
ORDER BY commande_id ASC