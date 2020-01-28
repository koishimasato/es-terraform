
# usage

## validate search api response
```bash
while :; do curl -X GET http://localhost:9200/test/_search?pretty -s -o /dev/null -w "\ncode:%{http_code}, size:%{size_download}"; sleep 5; done
```

# commands:
## health
$ curl localhost:9200/_cluster/health?pretty

## node
$  curl localhost:9200/_cat/nodes?v

## mapping
$  curl localhost:9200/_mappings


