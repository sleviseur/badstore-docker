#!/bin/sh

apt-get update && apt-get install -y \
    apache2 \
    libclass-dbi-mysql-perl
apt-get clean && rm -r /var/lib/apt/lists/*

# Setup Apache
cp apache2/conf/badstore.conf /etc/apache2/sites-available/
a2enmod ssl \
	    cgid \
            rewrite
a2dissite 000-default
a2ensite badstore

mkdir -p /data/apache2/log
mkdir -p /data/apache2/htdocs
touch /data/apache2/log/access.log
touch /data/apache2/log/error.log

cp -R apache2/htdocs/* /data/apache2/htdocs/
cp -R apache2/icons/ /data/apache2/htdocs/icons/
chown -R www-data:www-data /data/apache2

cp -R apache2/cgi-bin /data/apache2/cgi-bin/
cp -R apache2/data/ /data/apache2/data/
cp -R apache2/htdocs/* /data/apache2/htdocs/
cp -R apache2/icons/ /data/apache2/htdocs/icons/
chmod 755 /data/apache2/cgi-bin/*
ls -la /data/apache2/htdocs/*

service apache2 restart

# clean packages
apt-get clean
rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*
