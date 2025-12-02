# Docker
## 1. Isolation et virtualisation
### 1.1 Principe de l’isolation
L’isolation est un pilier des architectures modernes, notamment dans les micro‑services. Elle consiste à séparer les processus entre eux et/ou de la machine hôte afin d’éviter les conflits et de garantir un fonctionnement stable.

Exemple concret : Une entreprise déploie ses applications sur un serveur de production (dans le cloud ou sur site). Les développeurs et Data Scientists créent ces applications dans leurs environnements locaux. Deux problèmes apparaissent rapidement :

Problème de cohérence entre environnements : une application peut fonctionner sur l’ordinateur du développeur mais échouer en production si les versions des librairies ou des outils diffèrent. Il faut donc embarquer l’environnement complet avec l’application.

Problème de compatibilité entre applications : sur un même serveur, deux applications peuvent avoir des besoins contradictoires. Par exemple, l’une exige numpy 1.16.1 tandis qu’une autre requiert une version plus récente. Ces conflits rendent la maintenance complexe.

-> La solution est d’isoler chaque application dans sa propre « boîte », contenant toutes les ressources nécessaires. Cette isolation n’est pas forcément hermétique : les applications peuvent communiquer entre elles, mais de manière contrôlée.

### 1.2 Isolation par virtualisation
Pour isoler des processus, la technique la plus répandue est la virtualisation. Elle consiste à créer un environnement qui masque les ressources réelles de la machine hôte et fournit à l’application un espace dédié.

Du point de vue de l’application, elle croit disposer de son propre système : mémoire, CPU, disque, outils… Elle fonctionne comme si elle était seule sur la machine.

Les principales formes de virtualisation :

### Machines virtuelles (VM)

Une VM est une émulation complète d’un ordinateur, avec son propre système d’exploitation et ses ressources allouées.  
Exemple : sur un PC Windows, on peut créer une VM Ubuntu. Les applications dans cette VM fonctionnent comme si elles étaient sur une machine Ubuntu réelle.  
Les fournisseurs cloud proposent des modèles prédéfinis (Ubuntu, Windows, etc.), facilitant la création d’environnements homogènes.  
Limite : les VM consomment beaucoup de ressources car elles embarquent un système d’exploitation complet.

### Conteneurs

Similaires aux VM mais plus légers : ils n’embarquent pas de système d’exploitation complet.  
Les conteneurs partagent le noyau de la machine hôte tout en restant isolés.  
Résultat : moins de consommation de ressources et des images plus petites.  
Dans ce cours, nous étudierons les conteneurs Docker.

### Environnements virtuels (Python)

Spécifiques à Python, ils permettent de gérer différentes versions de librairies sur une même machine.  
Chaque environnement virtuel contient un interpréteur Python et un répertoire dédié aux librairies.  
Exemple : deux projets peuvent utiliser des versions différentes de pandas ou numpy sans conflit.

### 1.3 Virtualisation et reproductibilité
Toutes ces technologies reposent sur le principe d’images reproductibles :

Les fournisseurs cloud proposent des Virtual Machine standardisé.

Docker utilise des images et des Dockerfiles.

Python s’appuie sur des fichiers requirements.txt.

-> L’avantage est de pouvoir instancier rapidement des environnements identiques, garantissant la reproductibilité et la portabilité des applications.
