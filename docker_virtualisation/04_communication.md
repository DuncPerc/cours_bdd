## 4. Communication avec les containers
La virtualisation permet d’isoler des processus ou des applications de la machine hôte.  
Cette isolation n’est pas totale : il est souvent nécessaire de communiquer avec un container.  
Dans cette partie, nous allons voir comment établir cette communication via le protocole HTTP, en utilisant l’exemple d’ElasticSearch.

### Lancer ElasticSearch
Téléchargez l’image :

```bash
docker image pull elasticsearch:7.2.0
```

### Lancez un container avec les options suivantes :
 - mode détaché (-d)
 - suppression automatique à l’arrêt (--rm)
 - nom : my_es_container
 - variable d’environnement : discovery.type=single-node
 - port exposé : 9200

```bash
docker container run -d --rm \
  -e "discovery.type=single-node" \
  -p 9200:9200 \
  --name my_es_container \
  elasticsearch:7.2.0
```
ElasticSearch expose une API sur le port 9200. 
Une requête HTTP GET sur http://localhost:9200 peut échouer, car le container possède sa propre adresse IP distincte de celle de la machine hôte.

### Identifier l’adresse IP
Pour connaître l’IP attribuée au container :

```bash
docker container inspect my_es_container | grep IPAddress
```
Par défaut, la première adresse est 172.17.0.2.  

On peut alors interroger directement l’API :

```bash
curl -X GET -i http://172.17.0.2:9200
```
## Conclusion
Les containers sont reliés par défaut au réseau bridge, ce qui leur permet de communiquer entre eux via leur IP ou leur nom (préféré pour plus de lisibilité).  
On peut créer des réseaux personnalisés pour isoler certains containers.  
Depuis la machine hôte, l’accès se fait via l’adresse IP attribuée par Docker.  
Enfin, il est possible d’exposer directement les ports du container sur la machine grâce aux redirections (-p) ou en utilisant le réseau host, qui supprime l’isolation réseau.

