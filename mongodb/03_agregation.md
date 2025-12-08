# Chapitre : Agrégations simples dans MongoDB
## 1. Introduction
MongoDB propose un pipeline d’agrégation (aggregate) qui permet de réaliser des calculs statistiques sur les documents d’une collection. Les étapes du pipeline sont des opérateurs comme `$match`, `$group`, `$sort`, etc.

## 2. Exemple : Moyenne de l’âge des étudiants
```javascript
db.etudiants.aggregate([
  {
    $group: {
      _id: null,              // pas de regroupement par champ, on calcule sur tous les documents
      moyenneAge: { $avg: "$age" }
    }
  }
])
```

### Explications
`$group` → regroupe les documents selon un critère.

`_id: null` → signifie qu’on ne fait pas de regroupement par valeur, mais sur l’ensemble de la collection.

`$avg: "$age"` → calcule la moyenne du champ age.

Résultat attendu :
```json
{ "_id": null, "moyenneAge": 23.5 }
```

3. Moyenne par groupe
Exemple : Moyenne d’âge par intérêt
```javascript
db.etudiants.aggregate([
  { $unwind: "$interets" },   // éclate le tableau interets
  {
    $group: {
      _id: "$interets",       // regroupe par chaque intérêt
      moyenneAge: { $avg: "$age" }
    }
  }
])
```
-> Cela calcule la moyenne d’âge des étudiants pour chaque intérêt (musique, voyage, programmation…).

## 4. Autres agrégations simples
Somme des âges :
```javascript
db.etudiants.aggregate([
  { $group: { _id: null, sommeAge: { $sum: "$age" } } }
])
```

Nombre d’étudiants :
```javascript
db.etudiants.aggregate([
  { $group: { _id: null, total: { $count: {} } } }
])
```
ou plus classique :
```javascript
db.etudiants.countDocuments()
```

Âge minimum et maximum :
```javascript
db.etudiants.aggregate([
  { $group: { _id: null, minAge: { $min: "$age" }, maxAge: { $max: "$age" } } }
])
```

## 5. Recap
| Opérateur | Fonction                          | Exemple de requête                                      |
|-----------|-----------------------------------|---------------------------------------------------------|
| $avg      | Calcule la moyenne d’un champ     | db.etudiants.aggregate([ { $group: { _id: null, moyenneAge: { $avg: "$age" } } } ]) |
| $sum      | Calcule la somme d’un champ       | db.etudiants.aggregate([ { $group: { _id: null, sommeAge: { $sum: "$age" } } } ])   |
| $min      | Donne la valeur minimale          | db.etudiants.aggregate([ { $group: { _id: null, minAge: { $min: "$age" } } } ])     |
| $max      | Donne la valeur maximale          | db.etudiants.aggregate([ { $group: { _id: null, maxAge: { $max: "$age" } } } ])     |
| $count    | Compte le nombre de documents     | db.etudiants.aggregate([ { $count: "totalEtudiants" } ])                            |


## 6. Bonnes pratiques
Utiliser `$match` avant `$group` pour filtrer les documents et réduire le volume de calcul.
```js
db.etudiants.aggregate([
  { 
    $match: { interets: "programmation" }   // Étape 1 : filtrer uniquement les étudiants intéressés par la programmation
  },
  { 
    $group: { 
      _id: null, 
      moyenneAge: { $avg: "$age" }          // Étape 2 : calculer la moyenne d’âge sur ce sous-ensemble
    } 
  }
])
```

Moyenne d’âge par intérêt, mais seulement pour les étudiants de moins de 25 ans:
```js
db.etudiants.aggregate([
  { 
    $match: { age: { $lt: 25 } }            // Étape 1 : filtrer les étudiants de moins de 25 ans
  },
  { 
    $unwind: "$interets"                    // Étape 2 : éclater le tableau interets
  },
  { 
    $group: { 
      _id: "$interets", 
      moyenneAge: { $avg: "$age" }          // Étape 3 : calculer la moyenne par intérêt
    } 
  }
])
```


Toujours nommer les champs calculés (moyenneAge, sommeAge) pour rendre les résultats lisibles.

Tester avec des petits ensembles de données avant d’appliquer sur des collections volumineuses.

## 7. Exercice
 - Calcule la moyenne d’âge des étudiants pour chaque intérêt.
 - Compter combien d’étudiants ont chaque intérêt.
 - Compter les étudiants de moins de 25 ans.
