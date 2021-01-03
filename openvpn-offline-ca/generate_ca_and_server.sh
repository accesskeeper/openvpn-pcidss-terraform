#/bin/bash

#copy Extensions to pendrive N1
##in the end copy server.key and cert to pendrive,ca.crt,dh.pem as well to N1 and deliver it via SSM/Ansible to the server.
#copy client keys and certificates to pendrive for safely distribution for users. This should be Pendrive N2
#copy ca.pem to pendrive and lock it in safe. Pendrive N3
#. optionally you can skip Pendrive N1 and N2 if you can share folder between isolated VM and host machine.

#ENV
openvpn_rsa_bits=2048
inventory_hostname=vpn.staging.companyapp.io


#mkdir keys
cd keys

#Copy openssl server/ca extensions
#openssl-server.ext
#openssl-ca.ext

#generate ca  key
openssl req -nodes -newkey rsa:$openvpn_rsa_bits -keyout ca-key.pem -out ca-csr.pem -days 3650 -subj /CN=OpenVPN-CA-$inventory_hostname/

chmod 0400 ca-key.pem
#sign ca key
openssl x509 -req -in ca-csr.pem -out ca.crt -CAcreateserial -signkey ca-key.pem -sha256 -days 3650 -extfile openssl-ca.ext

#generate server key
openssl req -nodes -newkey rsa:$openvpn_rsa_bits -keyout server.key -out server.csr -days 3650 -subj /CN=OpenVPN-Server-$inventory_hostname/

chmod 0400 server.key

#sign server key
openssl x509 -req -in server.csr -out server.crt -CA ca.crt -CAkey ca-key.pem -sha256 -days 3650 -CAcreateserial -extfile openssl-server.ext

#generate DH
openssl dhparam -out dh.pem $openvpn_rsa_bits

#copy 
#ca.conf

#openssl-client.ext

#TLS AUTH
openvpn --genkey --secret ta.key

#CRL
touch index.txt
echo 00 > crl_number

chmod 750 revoke.sh
bash revoke.sh

cd ..
mkdir to_deploy
cp -p keys/ca.crt to_deploy/ca.crt
cp -p keys/ca-crl.pem to_deploy/ca-crl.pem
cp -p keys/server.key to_deploy/server.key
cp -p keys/server.crt to_deploy/server.crt
cp -p keys/ca.srl to_deploy/ca.srl
cp -p keys/dh.pem to_deploy/dh.pem
cp -p keys/ta.key to_deploy/ta.key
cp -p keys/index.txt to_deploy/index.txt
cp -p keys/crl_number to_deploy/crl_number
