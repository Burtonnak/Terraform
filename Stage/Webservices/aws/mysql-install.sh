#!/bin/bash

sudo yum -y install mariadb-server strace sysstat mlocate

sudo systemctl start mariadb
sudo systemctl enable mariadb