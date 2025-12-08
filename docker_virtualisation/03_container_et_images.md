## 3. Manipuler containers et images
### 3.1 Premier container avec Docker
Lorsque Docker est installé et lancé, nous pouvons exécuter notre premier container. Traditionnellement, on utilise l’image hello-world, mais elle ne sert qu’à afficher un message. Pour un exemple plus utile et léger, nous allons utiliser BusyBox (≈1 Mo).

```bash
docker container run busybox echo "Bonjour Docker"
```
-> Ici, le container exécute la commande echo puis s’arrête immédiatement.

### 3.2 Téléchargement et exécution d’images
Comme l’image n’est pas disponible localement, Docker télécharge automatiquement l’image depuis DockerHub. Une fois téléchargée, elle est stockée en cache et peut être relancée sans nouveau téléchargement.  
Pour vérifier les images présentes sur votre machine :

```bash
docker image ls
```

Vous verrez un tableau avec :
 - REPOSITORY : nom de l’image
 - TAG : version de l’image (par défaut latest)
 - IMAGE ID : identifiant unique
 - SIZE : taille de l’image

### 3.3 Lancer un container interactif
Pour explorer un environnement minimaliste, utilisons Alpine Linux (≈5 Mo).
```bash
docker container run -it alpine sh
```
-> Vous êtes maintenant dans un shell sh à l’intérieur du container Alpine. Testez quelques commandes (ls, pwd, echo).

Ouvrez un deuxième terminal et vérifiez les containers actifs :
```bash
docker container ls
```

Pour quitter le shell :
```bash
exit
```
Le container s’arrête automatiquement.

### 3.4 Gestion des containers
Lister tous les containers (y compris arrêtés) :
```bash
docker container ls -a
```

Relancer un container arrêté :
```bash
docker container start -a <nom_ou_id>
```

Arrêter un container en cours :
```bash
docker container stop <nom_ou_id>
```

Supprimer un container arrêté :
```bash
docker container rm <nom_ou_id>
```

### 3.5 Mode détaché Exercice Pratique : Cycle de vie d'un conteneur Alpine
Dans cette section, nous allons manipuler Alpine Linux, une distribution extrêmement légère (environ 5 Mo) très prisée dans l'écosystème Docker.

L'objectif est de comprendre la distinction entre le lancement d'un conteneur en tâche de fond (mode détaché) et l'intervention manuelle à l'intérieur de celui-ci (mode interactif).  

#### Étape 1 : Le lancement en mode détaché (Detached)
Par défaut, si vous lancez une image de base comme Alpine sans commande spécifique, le conteneur démarre, ne trouve rien à faire, et s'arrête immédiatement.  
Pour le garder "en vie" en arrière-plan, nous devons ruser légèrement en lui allouant un terminal, même s'il n'est pas connecté à notre écran.  

Exécutez la commande suivante dans votre terminal :
```bash
docker run -d -t --name mon-alpiniste alpine
```
Analyse de la commande :
 - `docker run` : Crée et démarre le conteneur.
 - `-d` (Detached) : Lance le conteneur en arrière-plan. Le terminal ne "bloque" pas ; il vous rend la main immédiatement et affiche l'ID du conteneur.
 - `-t` (TTY) : Alloue un pseudo-terminal. Note importante : Pour une image comme Alpine qui n'est qu'un shell, le flag -t est nécessaire pour empêcher le conteneur de s'arrêter immédiatement (exit code 0) après le démarrage.
 - `--name mon-alpiniste` : Donne un nom facile à retenir à notre conteneur (plutôt que d'utiliser l'ID hexadécimal).
 - `alpine` : L'image utilisée.

#### Étape 2 : Vérification du statut  
Assurons-nous que notre "alpiniste" est bien en train de tourner en fond :
```bash
docker ps
```
Vous devriez voir une ligne indiquant que mon-alpiniste est Up (en cours d'exécution).

#### Étape 3 : Pénétrer dans le conteneur (Interactive)

Maintenant que le conteneur tourne, c'est comme un mini-serveur actif. Nous allons utiliser la commande exec pour ouvrir une nouvelle porte et entrer dedans.  
```bash
docker exec -it mon-alpiniste sh
```

Attention : Sur Alpine, le shell par défaut est sh. Si vous essayez de lancer bash (comme on le ferait sur Ubuntu), cela échouera car Bash n'est pas installé par défaut sur Alpine pour gagner de l'espace.
Détail des flags :
 - `exec` : Exécute une nouvelle commande dans un conteneur déjà existant.
 - `-i` (Interactive) : Garde l'entrée standard ouverte (vous permet de taper au clavier).
 - `-t` (TTY) : Alloue un terminal pour l'affichage (vous permet de voir le prompt et la sortie).
 - `sh` : Le programme (le shell) que nous voulons lancer.
 
### Étape 4 : Manipulation et Sortie
Vous remarquerez que votre invite de commande (prompt) a changé (souvent un simple #). Vous êtes maintenant dans le conteneur.  
Vérifiez l'OS :
```bash
cat /etc/os-release
```
Pour quitter le conteneur et revenir à votre machine hôte, tapez simplement :
```bash
exit
```
Point clé : Comme nous avons utilisé docker exec, le fait de taper exit ferme seulement votre session terminale actuelle. Le conteneur principal, lui, continue de tourner en arrière-plan. Vous pouvez le vérifier en refaisant un docker ps.

Résumé des commandes
CommandeAction
docker run -dt alpine
Démarre Alpine en fond et le maintient actif.
docker ps
Liste les conteneurs actifs.
docker exec -it <nom> sh
Ouvre un shell interactif dans le conteneur.



### 3.6 Options utiles:  
-it : mode interactif (console)

-d : mode détaché (arrière-plan)

--name : donner un nom au container

--rm : supprimer automatiquement le container à l’arrêt

-e : définir une variable d’environnement

Exemple avec une variable d’environnement :
```bash
docker container run -it --rm --name test_env -e "MESSAGE=Salut Docker" alpine sh
echo $MESSAGE
```

### 3.7 Exercices pratiques 
Découverte des images légères
 - Téléchargez l’image busybox et exécutez une commande simple (date, echo).
 - Comparez sa taille avec alpine.

Exploration interactive
 - Lancez un container alpine en mode interactif.
 - Créez un fichier dans /tmp puis vérifiez qu’il disparaît après l’arrêt du container.

Gestion des containers
 - Lancez deux containers alpine avec des noms différents.
 - Arrêtez l’un d’eux, relancez-le avec docker start.

Variables d’environnement
 - Lancez un container avec une variable USER_NAME="Alice".
 - À l’intérieur du container, affichez la valeur avec echo $USER_NAME.

Mode détaché
 - Lancez un container busybox en arrière-plan qui exécute sleep 30.
 - Vérifiez qu’il est actif avec docker container ls.
