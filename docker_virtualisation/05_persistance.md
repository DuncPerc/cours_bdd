## 5. Persistance des données
Par défaut, Docker ne conserve pas les données créées dans un container : elles disparaissent lorsque celui-ci est arrêté.

### Exemple sans persistance
Lançons un container basé sur une image légère (alpine:latest) :

```bash
docker container run --rm --name my_alpine -it alpine:latest
```
À l’intérieur du container, créons un fichier :

```bash
echo "hello world from Docker" > /home/test.txt
cat /home/test.txt
```
Après avoir quitté (exit) puis relancé un nouveau container Alpine, le fichier n’existe plus : les données ne sont pas persistantes.

### Exemple avec persistance
Pour conserver les données, on utilise les volumes.

Créez un volume :

```bash
docker volume create --name my_volume
docker volume ls
docker volume inspect my_volume
```

Montez ce volume dans un container Alpine :

```bash
docker container run -it --name my_alpine \
  --mount type=volume,src=my_volume,dst=/home/my_folder \
  --rm alpine:latest sh
```
### Décomposition de --mount type=volume,src=my_volume,dst=/home/my_folder
#### type=volume: 
Indique que la source est un volume Docker géré par le daemon. Les volumes sont stockés dans l’espace Docker (généralement sous /var/lib/docker/volumes) et sont indépendants du cycle de vie des containers.

#### src=my_volume: 
Spécifie le nom du volume à monter.  
 - Volume nommé: my_volume doit exister (créé via docker volume create my_volume), ou Docker peut le créer automatiquement s’il est référencé et introuvable.  
 - Volume anonyme: si src est omis avec type=volume, Docker crée un volume anonyme (peu pratique pour la gestion).

#### dst=/home/my_folder: 
Chemin cible dans le système de fichiers du container où le volume sera monté.  
 - Écrasement du contenu: si le container a déjà des fichiers à cet emplacement, le montage masque le contenu au profit du volume monté tant que le container tourne.  
 - Création du dossier: si le chemin n’existe pas, Docker le crée dans le container (selon l’image et les permissions).

#### Équivalent fonctionnel:

```Code
-v my_volume:/home/my_folder
```
fait la même chose que `--mount type=volume,src=my_volume,dst=/home/my_folder`.


À l’intérieur du container, créez un fichier :

```bash
echo "hello world from Docker" > /home/my_folder/test.txt
```

Vérifiez depuis la machine hôte :

```bash
sudo ls /var/lib/docker/volumes/my_volume/_data
sudo cat /var/lib/docker/volumes/my_volume/_data/test.txt
```

Le fichier est bien conservé dans le volume, même après arrêt du container.

### Partage entre containers
Un même volume peut être monté dans plusieurs containers :

```bash
docker container run -it --name my_alpine1 \
  --mount type=volume,src=my_volume,dst=/home/my_folder1 \
  --rm alpine:latest sh


docker container run -it --name my_alpine2 \
  --mount type=volume,src=my_volume,dst=/home/my_folder2 \
  --rm alpine:latest sh
```
Les fichiers créés dans /home/my_folder1 ou /home/my_folder2 sont visibles depuis les deux containers : le volume agit comme un espace de stockage partagé.

### Montage d’un dossier hôte
On peut aussi relier directement un dossier de la machine hôte à un container :

```bash
docker container run -it --name my_alpine \
  --volume $HOME:/home/my_folder \
  --rm alpine:latest sh
```
Le contenu du dossier $HOME est alors accessible dans /home/my_folder à l’intérieur du container. Cette méthode est pratique pour échanger des fichiers, mais elle réduit l’isolation et la sécurité.

## En résumé : 
sans volume, les données disparaissent à l’arrêt du container.  

Les volumes permettent de conserver et partager des fichiers entre containers, tandis que le montage de dossiers hôte facilite les échanges mais avec moins de sécurité.
