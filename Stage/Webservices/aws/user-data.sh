#!/bin/bash

sudo yum -y install httpd strace sysstat mlocate mod_ssl
		
cat > /var/www/html/index.html <<EOF
<h1>Hello, Auriel, Alexiel and Lisa</h1>
<p>DB Address : ${db_address}</p>
<p>DB Port : ${db_port}</p>
EOF

sudo systemctl start httpd
sudo systemctl enable httpd
sudo yum -y update
sudo updatedb
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;


