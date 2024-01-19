#!/bin/bash

apt -y update
DEBIAN_FRONTEND=nointeractive apt -y upgrade

apt install bind9 -y

cp -v /vagrant/archivos/named /etc/default/named

if [ $(cat /etc/hostname) == 'tierra' ]
then
    cp -v /vagrant/archivos/master/named.conf.options /etc/bind/named.conf.options
    cp -v /vagrant/archivos/master/named.conf.local /etc/bind/named.conf.local
    cp -v /vagrant/archivos/master/tierra.sistema.sol /var/lib/bind/tierra.sistema.sol
    cp -v /vagrant/archivos/master/tierra.192.168.57 /var/lib/bind/tierra.192.168.57
else
    cp -v /vagrant/archivos/slave/named.conf.options /etc/bind/named.conf.options
    cp -v /vagrant/archivos/slave/named.conf.local /etc/bind/named.conf.local
fi

systemctl restart bind9