#!/bin/bash

sudo yum -y install httpd strace sysstat mlocate
		
cat > index.html <<EOF
<h1>Hello, Auriel, Alexiel and Lisa</h1>
<p>DB Address : ${db_address}</p>
<p>DB Port : ${db_port}</p>
EOF

sudo apachectl start
sudo yum -y update
sudo updatedb

