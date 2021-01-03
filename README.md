#PCIDSS_compliant MFA(google-auth) openvpn installation using:
packer,
terraform,
aws systems amanger (ansible playbook)

#1. GENERATING offline CA and server keys
on your local offline Certification authority server. (for testing purposes you can do it just on your local)
1. Allocate two pendirves and mark it as N1 and N2
2. Using N1: copy folder openvpn-offline-ca from repo to /etc/openvpn on offline machine. cd /etc/openvpn
3. run
./generate_ca_and_server.sh
4. Using N1:  Copy all files from to_deploy folder to pendrive. Deliver it to the server. Remove this files safely from the pendrive upon deliving to the server. on the depoyment machine with terraform this files should be is in the ovpn/roles/openvpn/files folder. (overwrite if you had previous data)
6. Using pendrive N2 : copy ca.pem to pendrive and lock it in safe.
#. optionally you can skip Pendrive N1 if you can share temporary folder (and work with that folder like it's a pendrive, don't share keys folder!) between isolated VM and host machine with Internet.

#2. GENERATING CLIENT KEYs
on your local offline Certification authority server. (for testing purposes you can do it just on your local)
1. cd /etc/openvpn
2. generate_user.sh $username
3. you will see $username.ovpn file in your current folder.
4. Using pendrive N1: Copy $username.ovpn to pendrive for safe distribution for users.
5. On the administrator's machine: copy s3://companypci-vpn-access/$username.2FA to pendrive N1 for further distribution. if you distribute it from admin machine, then you have to send $username.ovpn file and this $username.2FA file for user via secured channel.
6. On the user side. To connect do under root:
openvpn $username
if you are not using linux please use vpn client:
Windows:
Openvpn
Mac:
maybe best option: Viscosity (paid ~10$)
free option: tunnelblick

#3. Deploy infrastructure
```
$ terraform init # first run only
$ terraform plan
$ terraform apply
```
#4. Add users to the server (please make sure that vpn servers are up and initialized).
./apply_new_users.sh $username

#please use this command again if you need to add more users.
