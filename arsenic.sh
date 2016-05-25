#!/bin/bash

echo "----------------------------------------------------------------------------"
echo "Cleaning up..."
yes | ipa-server-install --uninstall
echo "----------------------------------------------------------------------------"
echo "System updates..."
echo "----------------------------------------------------------------------------"
dnf update -y && dnf upgrade -y && dnf clean all
echo "----------------------------------------------------------------------------"
echo "Provisioning..."
echo "----------------------------------------------------------------------------"
sed -ri 's/127\.0\.0\.1\s.*/127.0.0.1 localhost localhost.localdomain/' /etc/hosts
yes | sudo ipa-server-install --no-host-dns --mkhomedir --setup-dns --hostname=arsenic.ipademo.local -n ipademo.local -r IPADEMO.LOCAL -p password -a password --no-forwarders --reverse-zone=33.168.192.in-addr.arpa.
echo "password" | kinit admin


