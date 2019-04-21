
# Vagrant上の確認方法
elasticsearch起動:

```shell
vagrant up
```

エラーチェック:

```shell
sudo tail -f  /var/log/elasticsearch/test-cluster.log
```

更新後:

```shell
vagrant provision
```


# Docker上のAmazonLinuxを構築する
[ローカル環境でAnsibleの動作をDockerを使って検証する - Qiita](https://qiita.com/nijibox_tech/items/3cf6e9229d969e16e031)

```bash
ansible 
```

# Error:
"Failed to get D-Bus connection: Operation not permitted

[Dockerで立ち上げたCentOSでsystemctlを使うとFailed to get D-Bus connection: Operation not permittedと出る - 塩焼きブログ](https://blog.sioyaki.com/entry/2016/06/18/214055)

--privilegedなどがいいらしい
[Docker - docker run で/sbin/init を起動時に与えるコマンドとする設定の意味｜teratail](https://teratail.com/questions/83479)
[Cannot run container with systemd in it on macOS · Issue #30723 · moby/moby](https://github.com/moby/moby/issues/30723)
[AmazonLinux2のイメージを/sbin/initで起こせない!!【oci runtime error】 - Qiita](https://qiita.com/harukisan/items/6910684bbf2043a29812)

/sbin/initとは
[Docker - docker run で/sbin/init を起動時に与えるコマンドとする設定の意味｜teratail](https://teratail.com/questions/83479#reply-131141)

## 2
[1] bootstrap checks failed
[1]: memory locking requested for elasticsearch process but memory is not locked

[Elasticsearch is not starting when bootstrap.memory_lock is set to true - Elasticsearch - Discuss the Elastic Stack](https://discuss.elastic.co/t/elasticsearch-is-not-starting-when-bootstrap-memory-lock-is-set-to-true/120962/10)
[Configuring system settings | Elasticsearch Reference [5.6] | Elastic](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/setting-system-settings.html#systemd)
[Disable swapping | Elasticsearch Reference [5.3] | Elastic](https://www.elastic.co/guide/en/elasticsearch/reference/5.3/setup-configuration-memory.html)


# ansible:
docker-compose up -d
docker-compose run ansible bash


```bash
ssh target # 疎通確認
cd /var/data
ansible-playbook -i docker_hosts site.yml
```

# unicastでの動的追加
[How to set up autosearch nodes in Elasticsearch 6.1 - Stack Overflow](https://stackoverflow.com/questions/48147659/how-to-set-up-autosearch-nodes-in-elasticsearch-6-1)
必ず存在するmaster node 1台をdiscovery.zen.ping.unicast.hostsに追加する
実運用なら２台は書きたい。


[localhost上にDockerでコンテナ化したElasticsearchクラスタを立てて自分用コマンド検索エンジンを作る – PSYENCE:MEDIA](https://tech.recruit-mp.co.jp/infrastructure/docker-elasticsearch/)
こちらのhostのhostname指定ではうまくいかない

