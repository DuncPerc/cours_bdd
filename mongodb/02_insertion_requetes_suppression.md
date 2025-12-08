# Insertion, filtres et suppression

## 1. Insérer des documents
Concepts clés :  
 - insertOne() ajoute un document ;
 - insertMany() ajoute plusieurs documents en une seule opération. MongoDB génère automatiquement _id si vous ne le fournissez pas.

Exemples mongosh
```js
use demoDB
db.etudiants.insertOne({ nom: "Roger", age: 51, interets: ["sport", "cuisine"] })

db.etudiants.insertMany([
  { nom: "Bob", age: 22, interets: ["sport", "cinéma"] },
  { nom: "Claire", age: 24, interets: ["lecture", "dessin"] },
  { nom: "David", age: 27, interets: ["voyage", "programmation"] },
  { nom: "Emma", age: 21, interets: ["danse", "musique"] },
  { nom: "Farid", age: 23, interets: ["football", "cuisine"] },
  { nom: "Giulia", age: 26, interets: ["mode", "voyage"] },
  { nom: "Hugo", age: 20, interets: ["gaming", "musique"] },
  { nom: "Isabelle", age: 28, interets: ["yoga", "lecture"] },
  { nom: "Jonas", age: 22, interets: ["programmation", "voyage"] },
  { nom: "Khadija", age: 25, interets: ["cuisine", "cinéma"] },
  { nom: "Louis", age: 23, interets: ["sport", "voyage"] },
  { nom: "Maria", age: 24, interets: ["musique", "peinture"] },
  { nom: "Nicolas", age: 27, interets: ["lecture", "randonnée"] },
  { nom: "Olivia", age: 22, interets: ["danse", "mode"] },
  { nom: "Pierre", age: 26, interets: ["programmation", "gaming"] },
  { nom: "Quentin", age: 21, interets: ["voyage", "musique"] },
  { nom: "Rania", age: 23, interets: ["lecture", "cuisine"] },
  { nom: "Sophie", age: 25, interets: ["cinéma", "voyage"] },
  { nom: "Thomas", age: 24, interets: ["sport", "musique"] }
])
```
Vérification : la commande retourne `acknowledged: true` et `insertedId(s)` pour confirmer l’insertion.

## 2. Requêter et sélectionner
lister les databases et les collections (équivalent à une table en sql)
```js
db.adminCommand({listDatabases: 1})  // liste les databases

db.getCollectionNames()              // liste les noms de collections d'une database
db.getCollectionInfos()              // liste détaillée des collections
db.runCommand({listCollections: 1})  // liste détaillee des collections
```

find() est la méthode de base pour lire des documents. Vous pouvez combiner filtre, projection, tri, pagination.

Syntaxe de base
```js
db.etudiants.find({ nom: "Giulia" })                   // filtre
db.etudiants.find({}, { nom: 1, interets: 1, _id: 0 }) // projection
db.etudiants.find().sort({ age: -1 })                  // tri décroissant
db.etudiants.find().skip(10).limit(5)                  // pagination
```
Important : les filtres utilisent la même syntaxe que pour les suppressions et peuvent inclure opérateurs ($gt, $lt, $in, $regex, etc.). Pour trier, 1 = croissant, -1 = décroissant.

## 3. Filtrer avancé
Comparaisons : `{ age: { $gte: 25 } }`
```js
db.etudiants.find({ age: { $gte: 25 } })
```

Combinaisons : `{ $and: [ { a: 1 }, { b: 2 } ] }` ou `{ $or: [...] }`
```js
db.etudiants.find({ $and: [ { age: { $gte: 21 } }, { age: { $lt: 25 } } ] })
db.etudiants.find({ $and: [ { age: { $gte: 21 } },
                            { interets: {$all ["programmation","voyage"]} }
                          ] })

db.etudiants.find({ $or: [ { age: { $gte: 31 } }, { interets: "programmation" } ] },{ _id: 0 })
```

Recherche textuelle (necessite un index textuel sur les champs interrogés): index textuel + `{ $text: { $search: "mot" } }` 
```js
db.etudiants.createIndex({ nom: "text", interets: "text" })  //création d'un index sur nom et interets
```
```js
db.etudiants.find( { $text: { $search: "programmation" } } )
```
Astuce : indexez les champs fréquemment filtrés pour accélérer les requêtes.

## 4. Recapitulatif des opérateurs
| Opérateur | Fonction                          | Exemple de requête                                      |
|-----------|-----------------------------------|---------------------------------------------------------|
| $eq       | Égal à                           | db.etudiants.find({ age: { $eq: 25 } })                 |
| $ne       | Différent de                     | db.etudiants.find({ age: { $ne: 25 } })                 |
| $lt       | Strictement inférieur à          | db.etudiants.find({ age: { $lt: 25 } })                 |
| $lte      | Inférieur ou égal à              | db.etudiants.find({ age: { $lte: 25 } })                |
| $gt       | Strictement supérieur à          | db.etudiants.find({ age: { $gt: 25 } })                 |
| $gte      | Supérieur ou égal à              | db.etudiants.find({ age: { $gte: 25 } })                |
| $in       | Appartient à une liste de valeurs| db.etudiants.find({ age: { $in: [20, 22, 25] } })       |
| $nin      | N’appartient pas à une liste     | db.etudiants.find({ age: { $nin: [20, 22, 25] } })      |
| $and      | Combiner plusieurs conditions ET | db.etudiants.find({ $and: [ { age: { $lt: 25 } }, { interets: "musique" } ] }) |
| $or       | Combiner plusieurs conditions OU | db.etudiants.find({ $or: [ { age: { $lt: 23 } }, { interets: "voyage" } ] })   |
| $all      | Tous les éléments dans un tableau| db.etudiants.find({ interets: { $all: ["programmation", "voyage"] } })         |
| $exists   | Vérifie si un champ existe       | db.etudiants.find({ email: { $exists: true } })         |
| $regex    | Correspondance avec une regex    | db.etudiants.find({ nom: { $regex: /^A/ } })            |


## 5. Supprimer des documents
Méthodes : `deleteOne(filter)` supprime au plus un document ; `deleteMany(filter)` supprime tous les documents correspondant au filtre ; `deleteMany({})` supprime toute la collection (attention).

Exemples
```js
db.etudiants.deleteOne({ nom: "Pierre" })
db.etudiants.deleteMany({ age: { $lt: 20 } })
db.etudiants.deleteMany({})   // supprime tous les documents
```
Retour : MongoDB renvoie un document de statut indiquant le nombre supprimé et si l’opération a été reconnue.

Risques, limitations et bonnes pratiques
Risque de suppression accidentelle : évitez deleteMany({}) en production ; testez d’abord avec find() pour vérifier le filtre.

Performance : sans index, les filtres et tris peuvent provoquer des scans complets ; créez des index adaptés au modèle d’accès.

## 6. Exercices 
 - Afficher tous les étudiants de la collection etudiants.
 - Lister les étudiants de moins de 23 ans.
 - Trouver les étudiants qui ont "musique" dans leurs intérêts.
 - Afficher uniquement le nom et l’age des étudiants.
 - Lister les étudiants triés par âge croissant.
