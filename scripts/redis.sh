#!/bin/bash

#redisurl="http://download.redis.io/redis-stable.tar.gz"
#curl -s -o redis-stable.tar.gz $redisurl

#mkdir -p /usr/local/lib/
#chmod a+w /usr/local/lib/
#tar -C /usr/local/lib/ -xzf redis-stable.tar.gz
#cd /usr/local/lib/redis-stable/
#make && make install -j4

apt-get -y install redis-server
