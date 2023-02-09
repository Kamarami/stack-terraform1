#!/bin/bash

#Mount EBS Volumes
sudo su

EBS_VOLUMES="/dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf" #USE FOR EACH, REFERENCE LIST
LOGICAL_VOLUME_NAME=ebs_volume

for volume in $EBS_VOLUMES; do
   (
     echo n
     echo p
     echo 1
     echo
     echo
     echo w
   ) | fdisk "$volume"
 done

pvcreate  /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1

#Create EBS volume group
vgcreate stack_vg /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1


#Create LUNs
lvcreate -L 5G -n Lv_u01 stack_vg
lvcreate -L 5G -n Lv_u02 stack_vg
lvcreate -L 5G -n Lv_u03 stack_vg
lvcreate -L 5G -n Lv_u04 stack_vg
lvcreate -L 5G -n Lv_u05 stack_vg

mkfs.ext4 /dev/stack_vg/Lv_u01
mkfs.ext4 /dev/stack_vg/Lv_u02
mkfs.ext4 /dev/stack_vg/Lv_u03
mkfs.ext4 /dev/stack_vg/Lv_u04
mkfs.ext4 /dev/stack_vg/Lv_u05

#Create LUN mount points
mkdir /u01
mkdir /u02
mkdir /u03
mkdir /u04
mkdir /backups

mount /dev/stack_vg/Lv_u01 /u01
mount /dev/stack_vg/Lv_u02 /u02
mount /dev/stack_vg/Lv_u03 /u03
mount /dev/stack_vg/Lv_u04 /u04
mount /dev/stack_vg/Lv_u05 /backups


#Extend LUNs
lvextend -L +3G /dev/mapper/stack_vg-Lv_u01

#Resize filesystem
resize2fs /dev/mapper/stack_vg-Lv_u01

#Check /etc/fstab file
cat /etc/fstab

#Add mount points to /etc/fstab file
echo "/dev/stack_vg/Lv_u01     /u01           ext4    defaults,noatime  0   0" >> /etc/fstab
echo "/dev/stack_vg/Lv_u02     /u02           ext4    defaults,noatime  0   0" >> /etc/fstab
echo "/dev/stack_vg/Lv_u03     /u03           ext4    defaults,noatime  0   0" >> /etc/fstab
echo "/dev/stack_vg/Lv_u04     /u04           ext4    defaults,noatime  0   0" >> /etc/fstab
echo "/dev/stack_vg/Lv_u05     /backups       ext4    defaults,noatime  0   0" >> /etc/fstab

#Mount EBS volumes
mount -a

#Mount EFS
yum install -y nfs-utils
mkdir -p ${MOUNT_POINT}
chown ec2-user:ec2-user ${MOUNT_POINT}
echo ${efs_id}.efs.${REGION}.amazonaws.com:/ ${MOUNT_POINT} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0 >> /etc/fstab
mount -a -t nfs4
chmod -R 755 ${MOUNT_POINT}

sudo yum update -y
sudo yum install git -y
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo yum install -y httpd mariadb-server
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl is-enabled httpd

sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
cd /var/www/html || exit

dir_path=/var/www/html/CliXX_Retail_Repository

#if-then to copy Clixx repo into /var/www/html
if [[ -d $dir_path ]]
then
 	echo "path already exists" >> /var/www/html/path_output.txt
 else
 	git clone https://github.com/stackitgit/CliXX_Retail_Repository.git
 	cp -r CliXX_Retail_Repository/* /var/www/html

 	sudo sed -i '151s/None/All/' /etc/httpd/conf/httpd.conf
  #CHANGE THIS - USE SAMPLE FILE AND REPLACE DB USERNAME PASSWORD HOST 
 	sed -i "s/'wordpress-db.cc5iigzknvxd.us-east-1.rds.amazonaws.com'/'${db_hostname}'/g" /var/www/html/wp-config.php	 
fi

#Connect to database and run query
output=$(mysql -u ${db_username} --password=${db_password} -h ${db_hostname} -D wordpressdb -e "Select option_value from wp_options where option_value LIKE 'http%';")

#Save output to file
echo "$output" >> /var/www/html/output.txt

dns="${lb_dns_name}"

match=$(sed -n 2p /var/www/html/output.txt)

if [ "$match" == "$dns" ]
 then
     echo "LB DNS already configured" >> /var/www/html/path_output.txt
 else
     mysql -u ${db_username} --password=${db_password} -h ${db_hostname} -D wordpressdb<<EOF
     UPDATE wp_options SET option_value = "http://${lb_dns_name}" WHERE option_value LIKE 'http%';
     exit
EOF
fi        

sudo chown -R apache /var/www

sudo chgrp -R apache /var/www

sudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;

sudo find /var/www -type f -exec sudo chmod 0664 {} \;

sudo systemctl restart httpd
sudo service httpd restart

sudo systemctl enable httpd 
sudo /sbin/sysctl -w net.ipv4.tcp_keepalive_time=200 net.ipv4.tcp_keepalive_intvl=200 net.ipv4.tcp_keepalive_probes=5