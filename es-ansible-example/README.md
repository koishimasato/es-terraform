
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



# ansible:
docker-compose up -d
docker-compose run ansible bash


```bash
ssh target # 疎通確認
cd /var/data
ansible-playbook -i docker_hosts site.yml
```



