## 2. Docker en théorie
Docker est aujourd’hui l’un des outils les plus populaires pour la containerisation, utilisé aussi bien en développement qu’en production.

### 2.1 Technologie de containerisation
Un conteneur regroupe une application, ses librairies et ses exécutables nécessaires à son fonctionnement. Contrairement à une machine virtuelle qui simule un matériel complet via un hyperviseur et embarque son propre système d’exploitation, un conteneur s’appuie directement sur le système d’exploitation de la machine hôte.

Métaphore du container  
Le terme est bien choisi : comme un container de transport maritime, il s’agit d’une boîte isolée.  
De l’extérieur : on ne sait pas ce qu’elle contient, on gère simplement la boîte.  
De l’intérieur : le processus ne sait pas sur quel support il est exécuté ni ce que contiennent les autres containers.

Techniquement, un container repose sur :
cgroups : qui limitent l’accès aux ressources (CPU, mémoire, disque).  
namespaces : qui isolent utilisateurs, réseau et processus.  
-> Lorsqu’un container démarre, il lance un processus. Quand ce processus s’arrête, le container disparaît.

Exemple sous Linux  
Un container peut, par exemple, exécuter un entraînement de modèle de Machine Learning en :
 - attribuant des ressources spécifiques,
 - isolant le processus du système de fichiers hôte,
 - lui donnant son propre adressage réseau.

Avantages  
 - Légèreté : pas de système d’exploitation embarqué, donc moins de consommation de ressources.  
 - Rapidité : contrairement aux VM qui nécessitent un hyperviseur, les containers exploitent directement les fonctionnalités du noyau Linux.  
 - Portabilité : grâce aux images, qui servent de modèles reproductibles.

Images de containers  
Les images fonctionnent comme des classes en programmation orientée objet :
 - L’image est le modèle.
 - Le container est l’instance.
 - Les images sont construites en couches (arborescence). Exemple : une image de base Ubuntu, sur laquelle on ajoute des librairies et des logiciels. Les couches communes sont mutualisées, évitant les duplications.

Écosystème
Plusieurs technologies existent : runC, containerd, cri-o… La Linux Foundation pilote l’Open Container Initiative pour normaliser ces solutions.

### 2.2 Docker
Docker est un outil basé sur containerd qui simplifie la création et la gestion de containers.

Origine : projet interne de l’entreprise française dotCloud, devenu open source en 2013.

Impact : Docker a démocratisé l’usage des containers grâce à sa simplicité et sa communauté.

Forces de Docker  
 - Prise en main rapide : déploiement simple et sécurisé.
 - DockerHub : répertoire public avec plus de 5 millions d’images, dont des images officielles (MySQL, MongoDB, Spark, Hadoop, Jupyter…).
 - Création et partage d’images : via les Dockerfiles, on peut construire une image en quelques minutes et la publier sur DockerHub.
 - Support Cloud : la plupart des fournisseurs proposent des solutions PaaS permettant de déployer directement des images Docker sans gérer l’infrastructure sous-jacente.
 - Communauté
    - Docker compte aujourd’hui environ 7 millions d’utilisateurs.
    - Édition communautaire (CE) : gratuite, utilisée dans ce cours.
    - Édition entreprise (EE) : avec automatisation avancée et sécurité renforcée.

### 2.3 Fonctionnement de Docker
Docker repose sur une architecture client-serveur :
 - Client (docker-cli) : interface en ligne de commande.
 - Docker daemon : service qui exécute les tâches (construction d’images, lancement de containers) via une API REST.

Registries
Les Docker registries sont des répertoires d’images consultés par le daemon :
DockerHub : registre public par défaut.
Trusted registries : registres privés, souvent utilisés en entreprise.

-> Le fonctionnement des containers est assuré par le système Linux de la machine hôte (ou par une VM Linux si l’on travaille sous Windows).

### 2.4 Objets principaux de Docker
Les commandes Docker s’articulent principalement autour de trois types d’objets :

Container : instance en cours d’exécution d’une image, isolant une application et ses dépendances.

Image : modèle immuable servant de base pour créer des containers, construit en couches reproductibles. Peut-être créé de zero avec un Dockerfile ou téléchargé depuis dockerhub par exemple.

Volume : espace de stockage persistant permettant de conserver et partager des données entre containers, indépendamment de leur cycle de vie.

## Schéma de création d'un conteneur de zéro
<img src="image/docker_build_run.png" alt="Buildrun" width="800" style="max-width:100%;height:auto;"> 

## Schéma d'illustration d'utilisation d'un volume
<img src="image/docker_volume.webp" alt="Volume" width="800" style="max-width:100%;height:auto;"> 

## À retenir
Les conteneurs permettent d’isoler une application avec ses dépendances en s’appuyant directement sur le système de la machine hôte, ce qui les rend plus légers et rapides que les machines virtuelles.  

Les images Docker, construites en couches, servent de modèles reproductibles à partir desquels sont instanciés les containers.  

Docker, a popularisé la containerisation grâce à sa simplicité, son écosystème (DockerHub, Dockerfiles, support cloud) et sa large communauté.  
Son fonctionnement repose sur une architecture client‑serveur (docker‑cli et daemon) et sur des registries publics ou privés pour stocker et partager les images.

Les commandes Docker s’articulent principalement autour de trois objets clés : **images**, **containers** et **volumes**, ces derniers assurant un stockage persistant entre les cycles de vie des containers.
