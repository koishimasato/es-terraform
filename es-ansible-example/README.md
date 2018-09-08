
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



