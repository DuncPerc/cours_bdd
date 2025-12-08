# PostgreSQL – Cours BDD
Ce dossier contient une base de données PostgreSQL prête à être utilisée dans GitHub Codespaces. Elle inclut un schéma SQL et des données d’exemple pour s’entraîner à écrire des requêtes.

## 1. Lancer Codespaces
 - Ouvre le dépôt GitHub dans ton navigateur.

 - Clique sur Code > Codespaces > Create codespace on main.

 - Attends que l’environnement se charge (quelques secondes).

## 2. Lancer PostgreSQL avec Docker Compose
Dans le terminal intégré de Codespaces :

```bash
cd postgresql/
docker-compose up -d
```

Cela démarre un conteneur PostgreSQL avec :

 - Utilisateur : `postgres`

 - Mot de passe : `postgres`

 - Base de données : `ecommerce`

Les fichiers SQL dans `schema/` sont automatiquement exécutés au premier démarrage.

## 3. Accéder à PostgreSQL en ligne de commande

```bash
psql -h localhost -U postgres -d ecommerce
```
Mot de passe : `postgres`


### Connexion depuis le container 
```bash
docker exec -it <nom_du_container> bash
```
### ou après avoir installé le client sur la machine
```bash
sudo apt install postgresql-client-16
```


### Commandes utiles
|commande|résultat|
|--------|--------|
|`\dt`|Liste les tables|
|`\d produits`|Structure de la table "produits"|
|`SELECT * FROM produits;`|Affiche le contenu de la table "produits"|


## 4. Utiliser l’extension SQLTools (interface graphique)
### Installation

Cliquer sur l’icône Extensions dans Codespaces.

Installer :

 - SQLTools

 - SQLTools PostgreSQL/Redshift Driver

### Configuration

1. Cliquer sur l’icône SQLTools dans la barre latérale.

2. Ajouter une nouvelle connexion :

|Champ|Valeur|
|-----|------|
|Nom | PostgreSQL local|
|Driver | PostgreSQL|
|Serveur | localhost|
|Port | 5432|
|Utilisateur | postgres|
|Mot de passe | postgres|
|Base | ecommerce|


3. Cliquer sur Connect.

## 5. Tester des requêtes simples
### En ligne de commande (psql)
```sql
SELECT * FROM produits;
SELECT nom FROM clients WHERE email LIKE '%example.com';
SELECT produit_id, SUM(quantite) FROM lignes_commandes GROUP BY produit_id;
```
### Dans SQLTools
1. Cliquer sur l'extension SQLTools
2. Dans "CONNECTIONS" juste à droite cliquer sur le logo "+SQL" New SQL file
3. Ecrire la commande SQL exemple:`SELECT * FROM clients;` (ne pas oublier le ";" à la fin)
4. Cliquer sur "Run on active connection" juste au dessus de la ligne de code


## 6. Utiliser python pour requeter un bdd postgresql
### Installer la librairie

```bash
pip install psycopg2-binary
```
(ou pip install psycopg[binary] pour psycopg3)

### Écrire le script Python
```bash
vim script_python.py
```

puis copier dedans:
```python
import psycopg2

# Connexion à la base
conn = psycopg2.connect(
    host="localhost",
    port=5432,
    user="postgres",
    password="postgres",
    dbname="ecommerce"
)

# Création d’un curseur
cur = conn.cursor()

# Exécution de la requête
cur.execute("SELECT * FROM clients;")

# Récupération des résultats
rows = cur.fetchall()
for row in rows:
    print(row)

# Fermeture du curseur et de la connexion
cur.close()
conn.close()
```

### Executer le script Python
```bash
python script_python.py
```

