#!/bin/bash

# Disable SELinux for testing purposes
setenforce 0
echo "----------------------------------------------------------------------------"
echo "Cleaning up..."
echo "----------------------------------------------------------------------------"
yes | ipa-client-install --uninstall

echo "System updates..."
dnf update -y && dnf upgrade -y && dnf clean all
dnf install -y ipsilon ipsilon-infosssd ipsilon-saml2 ipsilon-authgssapi ipsilon-tools-ipa
echo "----------------------------------------------------------------------------"
echo "IPA client installation..."
echo "----------------------------------------------------------------------------"
yes | ipa-client-install --mkhomedir -p admin -w password
echo "----------------------------------------------------------------------------"
echo "Ipsilon installation..."
echo "----------------------------------------------------------------------------"
echo "password" | kinit admin
ipsilon-server-install --ipa=yes --info-sssd=yes --form=yes

echo "----------------------------------------------------------------------------"
echo "Request an SSL certificate for Apache"
echo "----------------------------------------------------------------------------"
systemctl start certmonger
systemctl status certmonger
ipa-getcert request -f /etc/pki/tls/certs/server.pem -k /etc/pki/tls/private/server.key -K HTTP/`hostname`
echo "SSLCertificateFile /etc/pki/tls/certs/server.pem" >> /etc/httpd/conf.d/ssl.conf
echo "SSLCertificateKeyFile /etc/pki/tls/private/server.key" >> /etc/httpd/conf.d/ssl.conf
systemctl restart httpd
systemctl status httpd


