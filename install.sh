#!/bin/bash
yum install git wget -y
##MYSQL
##--------------------------
yum localinstall http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm -y
yum install mysql-community-server -y
service mysqld start
chkconfig --levels 235 mysqld on

## You should run this at some point prior to production
#----------------------------
#/usr/bin/mysql_secure_installation

##PHP
##--------------------------
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

yum --enablerepo=remi,remi-php55 install php-fpm php-common -y
yum --enablerepo=remi,remi-php55 install php-opcache php-pecl-apcu php-cli php-pear php-pdo php-mysqlnd php-pgsql php-pecl-mongo php-pecl-sqlite php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml -y


##Nginx
##--------------------------
rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
yum install nginx16 -y

##Varnish
##--------------------------
rpm --nosignature -i https://repo.varnish-cache.org/redhat/varnish-3.0.el6.rpm
yum install varnish -y



##Install Drush
whoami
##--------------------------
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
ln -s /usr/local/bin/composer /usr/bin/composer
composer global require drush/drush:7.*


##add to .bashrc
##--------------------------
echo export EDITOR=nano >> $HOME/.bashrc
echo PATH='$HOME/.composer/vendor/bin:$PATH' >> $HOME/.bashrc
echo PATH='$PATH:/usr/local/bin/wrk' >> $HOME/.bashrc
echo export PATH >> $HOME/.bashrc
source $HOME/.bashrc

##source .bashrc
echo source $HOME/.bashrc >> $HOME/.bash_profile

rm /etc/nginx/ -rf
git clone https://github.com/perusio/drupal-with-nginx.git /etc/nginx
cd /etc/nginx
git checkout D7

cat /vagrant/nginx.conf.txt > /etc/nginx/nginx.conf
cat /vagrant/php-fpm.conf.txt > /etc/php-fpm.conf
cat /vagrant/www.conf.txt > /etc/php-fpm.d/www.conf
cat /vagrant/drupal.conf.txt > /etc/nginx/apps/drupal/drupal.conf
cat /vagrant/example.conf.text > /etc/nginx/sites-available/test.com.conf
cat /vagrant/varnish.txt > /etc/sysconfig/varnish
cat /vagrant/default.vcl.txt > /etc/varnish/default.vcl
mv /vagrant/wrk/ /usr/local/bin

mkdir -p /etc/nginx/sites-enabled
cd /etc/nginx/sites-enabled/
ln -s /etc/nginx/sites-available/test.com.conf /etc/nginx/sites-enabled/test

mkdir /var/www/html/test
touch /var/www/html/test/index.php

cat << EOF > /var/www/html/test/index.php
<?php 
phpinfo();
?>
EOF

#in case you would like to do microcaching.
mkdir -p /var/cache/nginx/microcache

##Turn On - Stay On
##--------------------------
service nginx start
service php-fpm start
service varnish start

chkconfig --add nginx
chkconfig --levels 235 nginx on
chkconfig --add php-fpm
chkconfig --levels 235 php-fpm on
chkconfig --add varnish
chkconfig --levels 235 varnish on

## WIPE ALLL CONFIG
service nginx restart
service php-fpm restart
service varnish restart
chmod 700 /usr/local/bin/wrk/wrk
