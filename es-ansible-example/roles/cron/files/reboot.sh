#!/bin/bash

sleep 10
sudo service elasticsearch restart
date=$(date)
echo "$date cron: elasticsearch restart"  > /home/ec2-user/restart.log
