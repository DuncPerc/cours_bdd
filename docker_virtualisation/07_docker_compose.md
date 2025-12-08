## 7. Docker Compose
### Introduction
Docker Compose est un outil qui permet de lancer plusieurs containers en une seule commande. C’est particulièrement utile pour mettre en place des environnements complets de test ou de développement. Contrairement à Kubernetes, Docker Compose ne gère pas plusieurs machines : il orchestre uniquement des containers sur une même machine hôte.

### Exemple : PostgreSQL + pgAdmin

retourne dans le dossier postgresql
#### 1. Créer le fichier docker-compose.yml
```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15
    container_name: codespace-postgres
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: ecommerce
    ports:
      - "5432:5432"
    volumes:
      - ./schema:/docker-entrypoint-initdb.d
    networks:
      - my_network

  pgadmin:
    image: dpage/pgadmin4:latest
    container_name: codespace-pgadmin
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@example.com
      PGADMIN_DEFAULT_PASSWORD: admin
      PGADMIN_CONFIG_PROXY_X_HOST_COUNT: 1
      PGADMIN_CONFIG_PROXY_X_PREFIX_COUNT: 1
    ports:
      - "8081:80"   # pgAdmin accessible via Codespaces port forwarding
    networks:
      - my_network
    volumes:
      - pgadmin_data:/var/lib/pgadmin

volumes:
  pgadmin_data:

networks:
  my_network:

```

#### 2. Lancer les services
```bash
docker-compose -f ./docker-compose2.yml up
```
→ Cela démarre deux containers :

 - PostgreSQL accessible sur localhost:5432
 - pgAdmin accessible via un navigateur sur http://localhost:8080

#### 3. Vérifier les containers en cours
Dans une autre console :

```bash
docker ps
```
→ Vous verrez my_postgres et my_pgadmin en fonctionnement.

#### 4. Acceder à l'interface de pgadmin

Dans l’interface GitHub Codespaces, ouvre le menu Ports (souvent en bas ou dans la barre latérale).  
<img src="image/codespace_ports.png" alt="Ports" width="800" style="max-width:100%;height:auto;"> 


Tu verras la liste des ports exposés par tes containers (ici 8081).

Clique sur ce port et choisis Open in Browser.
Codespaces génère une URL publique du type :

```Code
https://<ton-codespace>-8080.preview.app.github.dev
```

#### Onglet Connection dans pg admin
<img src="image/pg_server.png" alt="Pg_server" width="800" style="max-width:100%;height:auto;"> 

Host name/address : `postgres` -> C’est le nom du service défini dans ton `docker-compose.yml`.  
Comme pgAdmin et Postgres partagent le même réseau Docker, tu n’utilises pas `localhost` mais le nom du service.

Port : `5432`

Maintenance database : `ecommerce` -> C’est la base créée automatiquement par Postgres grâce à `POSTGRES_DB`.

Username : `postgres`

Password : `postgres` -> Ceux définis dans POSTGRES_USER et POSTGRES_PASSWORD


#### 5. Arrêter les services
Avec Ctrl + C dans la console où docker-compose up tourne.
Ou dans une autre console :

```bash
docker-compose -f ./docker-compose2.yml down
```
Options supplémentaires
Volumes pour persistance des données :

```yaml
volumes:
  - pg_data:/var/lib/postgresql/data
```
Cela conserve les données même si le container est supprimé.

Connexion réseau : Les deux services sont placés sur le même réseau my_network. Ainsi, pgAdmin peut se connecter à PostgreSQL en utilisant le nom du service postgres comme hôte.

Personnalisation : Vous pouvez changer les ports exposés, les mots de passe, ou ajouter d’autres services (par exemple un script Python qui interroge la base).



## Conclusion
Avec Docker Compose, on peut déployer rapidement un environnement complet : ici une base PostgreSQL et son interface graphique pgAdmin.  
Les services partagent un réseau interne, peuvent être configurés via des variables d’environnement, et les données peuvent être persistées grâce aux volumes.
