#GENERATING and server keys
on your local offline Certification authority server. (for testing purposes you can do it just on your local)
1. Allocate two pendirves and mark it as N1 and N2
2. Using N1: copy folder openvpn from repo to /etc/openvpn on offline machine. cd /etc/openvpn
3. Using N1: mkdir keys if it does not exist and copy there extensions .ext from the repo  
4. run 
./generate_ca_and_server.sh
5. Using N1: DO NOT COPY CA.PEM. Only Copy server.key and cert to pendrive,ca.crt,dh.pem as well to N1 and deliver it via SSM/Ansible to the server. Remove this files safely from the pendrive upon deliver to the server.
6. Using pendrive N2 : copy ca.pem to pendrive and lock it in safe.
#. optionally you can skip Pendrive N1 if you can share folder between isolated VM and host machine with Internet.


#GENERATING CLIENT KEY
on your local offline Certification authority server. (for testing purposes you can do it just on your local)
1. copy folder openvpn to /etc/. if it does not exist yet.
2. if you don't want to run anything as root, make sure that fodler permissions meet your user. 
you can do that chown -R $user:$user /etc/openvpn
3. cd /etc/openvpn
4. generate_user.sh $username
5. you will see $username.ovpn file in your current folder.
6. Using pendrive N1: Copy $username.ovpn to pendrive for safe distribution for users.
7. On the administrators machine: In the repo Apply server changes related to OTP in ovpn.yml. Add $username. Example:

- hosts: 34.245.54.24
  gather_facts: true
  become: true
  roles:
          - {role: openvpn, node: master, users: [$username],
                        openvpn_port: 4300, openvpn_revoke_these_certs: []}
- hosts: 18.202.17.211
  gather_facts: true
  become: true
  roles:
          - {role: openvpn, node: slave, users: [$username],
                        openvpn_port: 4300, openvpn_revoke_these_certs: []}


8. Apply changes to servers using two methods:
- launch:
ansible-playbook -i hosts ovpn.yml
#
- upload archive with changes to S3 and launch State Manager via Systems Manager.

8. On the administrator machine: copy /tmp/certs/$username.2FA to pendrive N1 for further distribution.
if you distribute it from admin machine, then you have to send $username.ovpn file and this 2FA file for user via secured channel. 

6. Ready to connect. To connect do under root:
openvpn $username

or use vpn client:
Windows:
Openvpn
Mac:
best option: Viscosity (paid ~10$)
free option: tunnelblick
