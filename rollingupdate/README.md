
# usage

## validate search api response
```bash
while :; do curl -X GET http://localhost:9200/test/_search?pretty -s -o /dev/null -w "\ncode:%{http_code}, size:%{size_download}"; sleep 5; done
```

## rolling update
https://www.elastic.co/guide/en/elasticsearch/reference/6.5/rolling-upgrades.html

1. Disable shard allocation.
$ curl -XPUT http://localhost:9200/_cluster/settings -d '{ "persistent": {  "cluster.routing.allocation.enable": "none" }}'
1. Stop non-essential indexing and perform a synced flush. (Optional) ( curl -XPOST http://localhost:9200/_flush/synced)
1. Change es6x-1 cluster name  to docker-cluster-old

```bash
$ vi docker-compose.yml
```

to:
```yaml
cluster.name: "docker-cluster-old"
discovery.zen.ping.unicast.hosts: es5x-1
```

1. Recreate es6x-1 (docker-compose up -d)
1. Wait for the node join to cluster
1. Reenable shard allocation

curl -XPUT http://localhost:9200/_cluster/settings -d '{  "persistent": {    "cluster.routing.allocation.enable": null  }}'
1. Wait for the node to recover.


# references

docker compose with multi node cluster
[Install Elasticsearch with Docker | Elasticsearch Reference [6.2] | Elastic](https://www.elastic.co/guide/en/elasticsearch/reference/6.2/docker.html)

docker compose and create test data
[docker-composeでElasticSearch6.2を構築してECSにデプロイするまで(前編) - Qiita](https://qiita.com/yasumon/items/2ee09bde35c19e29495b)


## xpack
[X-Packを無効化したElasticsearch 5とKibanaをDocker Composeで起動する - Qiita](https://qiita.com/ganta/items/90fb0e754f8722bb6adb)


# force reassign shardas

```
curl -XPOST 'localhost:9200/_cluster/reroute' -d '{
    "commands": [{
        "allocate": {
            "index": "test",
            "shard": 4,
            "node": "search03",
            "allow_primary": 0
        }
    }]
}'
```

```
curl -XPOST 'localhost:9200/_cluster/reroute' -d '{
    "commands": [{
        "allocate_replica": {
            "index": "test",
            "shard": 0,
            "node": "0Eq9mx9"
        }
    }]
}'


```
