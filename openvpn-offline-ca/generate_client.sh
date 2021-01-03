#!/bin/bash

item=$1
openvpn_rsa_bits=2048
openvpn_auth_alg=SHA256
openvpn_cipher=AES-256-CBC
openvpn_proto=udp
openvpn_server_hostname=vpn.staging.companyapp.io
openvpn_port=4300
#MYVARS='$openvpn_rsa_bits:$openvpn_auth_alg:$openvpn_cipher:$openvpn_proto:$openvpn_server_hostname:$openvpn_port'

cd keys

#generate client key
openssl req -nodes -newkey rsa:$openvpn_rsa_bits -keyout $item.key -out $item.csr -days 3650 -subj /CN=VPN-$inventory_hostname-$item/

#protect client keys
chmod 0400 $item.key

#sign client key
openssl x509 -req -in $item.csr -out $item.crt -CA ca.crt -CAkey ca-key.pem -sha256 -days 3650 -extfile openssl-client.ext

#generate client config
openvpn_proto=$openvpn_proto openvpn_rsa_bits=$openvpn_rsa_bits openvpn_auth_alg=$openvpn_auth_alg openvpn_cipher=$openvpn_cipher openvpn_server_hostname=$openvpn_server_hostname openvpn_port=$openvpn_port envsubst  < client.template > ../$1.ovpn

echo "<ca>" >> ../$1.ovpn
cat ca.crt >> ../$1.ovpn
echo "</ca>" >> ../$1.ovpn

echo "<tls-auth>" >> ../$1.ovpn
cat ta.key >> ../$1.ovpn
echo "</tls-auth>" >> ../$1.ovpn

echo "<cert>" >> ../$1.ovpn
cat $1.crt >> ../$1.ovpn
echo "</cert>" >> ../$1.ovpn
echo "<key>" >> ../$1.ovpn
cat $1.key >> ../$1.ovpn
echo "</key>" >> ../$1.ovpn
