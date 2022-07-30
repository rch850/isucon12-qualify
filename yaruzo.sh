#!/bin/bash

LOG_PREFIX=b$(date '+%H%M')-$(git rev-parse --short HEAD) || exit 1

mkdir ~/logs
echo 'Truncate logs'
sudo truncate /var/log/nginx/access.log --size 0
sudo truncate /var/log/mysql/mysql-slow.log --size 0

echo '[READY FOR BENCHMARK] Run monitors like htop.'
read -p 'Please run benchmark. Press enter key when finished.'

sudo cat /var/log/nginx/access.log > ~/logs/${LOG_PREFIX}-access.log
sudo cat /var/log/mysql/mysql-slow.log > /tmp/${LOG_PREFIX}-mysql-slow.log
alp ltsv --file ~/logs/${LOG_PREFIX}-access.log --reverse --sort=avg -m '/api/player/player/,/api/player/competition/,/api/organizer/player/,/api/organizer/competition/' > ~/logs/${LOG_PREFIX}-alp.log
pt-query-digest /tmp/${LOG_PREFIX}-mysql-slow.log > ~/logs/${LOG_PREFIX}-ptq.log

