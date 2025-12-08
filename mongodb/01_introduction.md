# Introduction à MongoDB avec Docker
## 1. Introduction
MongoDB est une base de données NoSQL orientée documents, très utilisée pour les applications modernes (web, mobile, big data).

Stocke les données sous forme de documents JSON.

Flexible, scalable et adapté aux environnements distribués.

Idéal pour les projets étudiants et professionnels.

-> Objectif du cours : apprendre à installer MongoDB avec Docker, puis explorer ses concepts fondamentaux.

## 2. Installation de MongoDB via Docker

### Étape 1 : Télécharger l’image officielle
MongoDB dispose d’une image officielle sur Docker Hub :

```bash
docker pull mongo:latest
```

### Étape 2 : Lancer un conteneur MongoDB
Créez et démarrez un conteneur :

```bash
docker run -d \
  --name mongo-demo \
  --rm \
  -p 27017:27017 \
  -v ~/mongo-data:/data/db \
  mongo:latest
```
-d : mode détaché (en arrière-plan).

--name : nom du conteneur.

-p 27017:27017 : expose le port MongoDB.

-v ~/mongo-data:/data/db : volume pour persister les données.

### Étape 3 : Vérifier le conteneur
```bash
docker ps
```
Vous devriez voir mongo-demo en cours d’exécution.

## 3. Connexion à MongoDB
Option 1 : Utiliser le shell Mongo
```bash
docker exec -it mongo-demo mongosh
```
Cela ouvre le shell interactif de MongoDB.

Option 2 : Utiliser un client graphique
MongoDB Compass (officiel).

VS Code extension MongoDB.

Connexion via mongodb://localhost:27017.

## 4. Concepts fondamentaux de MongoDB
Base de données : ensemble de collections.

Collection : équivalent d’une table SQL.

Document : équivalent d’une ligne, mais en JSON.

Exemple de document :

```json
{
  "nom": "Alice",
  "age": 25,
  "interets": ["musique", "voyage"]
}
```

## 5. Premières commandes
Dans mongosh :

```javascript
use demoDB              // créer/choisir une base
db.createCollection("etudiants")
db.etudiants.insertOne({nom: "Alice", age: 25, interets: ["musique", "voyage"]})
db.etudiants.find()
```
