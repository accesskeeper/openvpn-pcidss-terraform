#!/bin/bash

master=`cat master.id`
slave=`cat slave.id`
username=$1

sed -i "s/admin/$username/g" ovpn/ovpn-master.yml
sed -i "s/admin/$username/g" ovpn/ovpn-slave.yml

zip -r ovpn.zip ovpn && aws s3 mv ovpn.zip s3://companypci-vpn/ovpn.zip

aws ssm start-associations-once --association-ids $master
sleep 10
aws ssm start-associations-once --association-ids $slave

echo $username >> vpn_users.db

sed -i "s/$username/admin/g" ovpn/ovpn-master.yml
sed -i "s/$username/admin/g" ovpn/ovpn-slave.yml
