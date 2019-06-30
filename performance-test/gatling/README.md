# Run

```bash
> gatling:testOnly elasticsearch.ElasticsearchSimulation
```

# 負荷試験をする際の要件
ref: [fio(1): flexible I/O tester - Linux man page](https://linux.die.net/man/1/fio)

- request valiation
  - input path (ex: csv file path)
  - recursive
  - ramdom distribution (uniform, zipf, pareto)
- runtime
- warmuptime
- iodepth(== number of users)
- waittime (== thinktime)
- multiple scenario (group, job file)
- number of threads
- number of server
- output path

# nginx access log format:
[NGINX Docs | Configuring Logging](https://docs.nginx.com/nginx/admin-guide/monitoring/logging/)

