# -*- mode: ruby -*-
# vi: set ft=ruby :
$setup = <<SCRIPT
    echo "System updates..."
    sudo dnf update -y && sudo dnf upgrade -y
    echo "----------------------------------------------------------------------------"
    echo "Cleaning up..."
    yes | sudo ipa-server-install --uninstall
    echo "----------------------------------------------------------------------------"
    echo "Provisioning..."
    sed -ri 's/127\.0\.0\.1\s.*/127.0.0.1 localhost localhost.localdomain/' /etc/hosts
    yes | sudo ipa-server-install --no-host-dns --mkhomedir --setup-dns --hostname=server.ipademo.local -n ipademo.local -r IPADEMO.LOCAL -p password -a password --no-forwarders --reverse-zone=33.168.192.in-addr.arpa.
    echo "password" | kinit admin
SCRIPT

Vagrant.configure(2) do |config|

  config.vm.box = "ftweedal/freeipa-workshop"

  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider :libvirt do |libvirt|
    libvirt.memory = 1024
  end

  # Vagrant's "change host name" sets the short host name.  Before
  # we repair /etc/hosts (see below) let's reset /etc/hostname to
  # the *full* host name
  #
  config.vm.provision "shell",
    inline: "hostname --fqdn > /etc/hostname && hostname -F /etc/hostname"

  # Vagrant's "change host name" capability for Fedora maps hostname
  # to loopback.  We must repair /etc/hosts
  #
  config.vm.provision "shell", inline: $setup

  config.vm.define "server" do |server|
    server.vm.network "private_network", ip: "192.168.33.10"
    server.vm.hostname = "server.ipademo.local"
  end

#  config.vm.define "replica" do |replica|
#    replica.vm.network "private_network", ip: "192.168.33.11"
#    replica.vm.hostname = "replica.ipademo.local"
#
#    replica.vm.provision "shell",
#      inline: 'echo "nameserver 192.168.33.10" > /etc/resolv.conf'
#  end

#  config.vm.define "client" do |client|
#    client.vm.network "private_network", ip: "192.168.33.20"
#    client.vm.hostname = "client.ipademo.local"
#
#    client.vm.provision "shell",
#      inline: 'echo "nameserver 192.168.33.10" > /etc/resolv.conf'
#    client.vm.provision "shell",
#      inline: 'sudo sed -i -n "/^<VirtualHost/q;p" /etc/httpd/conf.d/nss.conf'
#    client.vm.provision "shell",
#      inline: 'systemctl -q enable httpd && systemctl start httpd'
#  end

end
