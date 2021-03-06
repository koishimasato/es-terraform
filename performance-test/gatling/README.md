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

# gatling sample:
[gatling/HttpCompileTest.scala at 8c9ff719abb7dec50bddccc7456e4b4e7571fe72 · gatling/gatling](https://github.com/gatling/gatling/blob/8c9ff719abb7dec50bddccc7456e4b4e7571fe72/gatling-http/src/test/scala/io/gatling/http/HttpCompileTest.scala)


# 一定ユーザー数
```
setUp(scn.inject(rampUsers(420) over(60 seconds))).protocols(httpConf)
```
[How to set max constant number of active users? - Google グループ](https://groups.google.com/forum/#!topic/gatling/L96mIvr59IM)

