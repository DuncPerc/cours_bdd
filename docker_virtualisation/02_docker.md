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
Un container peut exécuter un entraînement de modèle de Machine Learning en :
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
