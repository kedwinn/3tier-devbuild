#!bin bash
yum update -y
yum install -y http.x86_64
systemctl start http.service 
systemctl enable hhtpd.service
