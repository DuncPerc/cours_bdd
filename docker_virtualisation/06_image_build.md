## 6. Créer une image Docker pour interroger PostgreSQL
### 1. Préparer le dossier de travail
```bash
mkdir my_postgres_image
cd my_postgres_image
```

### 2. Créer le script Python
Dans le fichier query.py :

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

cur = conn.cursor()
cur.execute("SELECT * FROM clients;")
rows = cur.fetchall()

for row in rows:
    print(row)

cur.close()
conn.close()
```

### 3. Écrire le Dockerfile
Dans le tableau suivant, vous trouverez des informations sur les principales commandes qui peuvent être utilisées dans un dockerfile.

|Mot-clef|Utilisation|
|--------|-----------|
|FROM image_name:tag	|pour choisir l'image de base|
|RUN bash_ command	|pour exécuter une commande bash|
|ADD path_to_local_file path_to_file_in_the_image	|pour copier un fichier depuis la machine hôte vers l'image
|WORKDIR path_in_the_image	|pour changer le dossier courant|
|EXPOSE port	|pour exposer un port du container|
|CMD	|pour choisir la commande utilisé au démarrage|
|ENTRYPOINT bash_command	|pour choisir les modes d'entrée dans le container|
|ENV variable value	|pour définir des variables d'environnement|
|VOLUME [mounting_point]	|pour créer des points de monture|
|LABEL	|pour ajouter des métadonnées à l'image|

On utilise alpine pour une image légère, et on installe psycopg2-binary :
```bash
vim Dockerfile
```

puis écrire dedans:
```dockerfile
FROM python:3.11-alpine

# Installer psycopg2
RUN pip install psycopg2-binary

# Copier le script dans l'image
WORKDIR /app
COPY query.py /app/query.py

# Définir la commande de démarrage
CMD ["python3", "query.py"]
```

### 4. Construire l’image
```bash
docker image build . -t my_postgres_query:latest
```

### 5. Lancer le container
Attention : le container doit pouvoir accéder à ta base PostgreSQL.

Si PostgreSQL tourne sur ta machine hôte, il faut utiliser l’option --network host (Linux uniquement) ou bien créer un réseau Docker et y connecter le container. Exemple :

```bash
docker run --rm --network host my_postgres_query:latest
```

### 6. Résultat attendu
Le container exécute query.py au démarrage et affiche toutes les lignes de la table clients.

## À retenir
Le Dockerfile définit l’image (base Alpine + Python + psycopg2).

Le script Python est copié dans l’image et exécuté automatiquement.

La communication avec PostgreSQL nécessite que le container soit sur le bon réseau (--network host ou réseau Docker partagé).
