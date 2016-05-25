# -*- mode: ruby -*-
# vi: set ft=ruby :

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
  config.vm.provision "shell",
    inline: "sed -ri 's/127\.0\.0\.1\s.*/127.0.0.1 localhost localhost.localdomain/' /etc/hosts"

  config.vm.define "cobalt" do |cobalt|
    cobalt.vm.network "private_network", ip: "192.168.33.10"
    cobalt.vm.hostname = "cobalt.ipademo.local"
    cobalt.vm.provision "shell", :path => "provision.sh", privileged: true
  end

  config.vm.define "ipsilon" do |ipsilon|
    ipsilon.vm.network "private_network", ip: "192.168.33.20"
    ipsilon.vm.hostname = "ipsilon.ipademo.local"

    ipsilon.vm.provision "shell",
      inline: 'echo "nameserver 192.168.33.10" > /etc/resolv.conf'
    ipsilon.vm.provision "shell",
      inline: 'sudo sed -i -n "/^<VirtualHost/q;p" /etc/httpd/conf.d/nss.conf'
    ipsilon.vm.provision "shell",
      inline: 'systemctl -q enable httpd && systemctl start httpd'
    ipsilon.vm.provision "shell", :path => "ipsilon.sh", privileged: true
  end

  config.vm.define "keycloak" do |keycloak|
    keycloak.vm.network "private_network", ip: "192.168.33.30"
    ipsilon.vm.provision "shell",
      inline: 'echo "nameserver 192.168.33.40" > /etc/resolv.conf'
    keycloak.vm.hostname = "keycloak.ipademo.local"
    keycloak.vm.provision "shell", :path => "keycloak.sh"
    keycloak.vm.provision "file", source: "keycloak-server/", destination: "/home/vagrant/"
    keycloak.vm.network "forwarded_port", guest: 9080, host: 9080
    keycloak.vm.provision "up", type: "shell", run: "always", inline: '$JBOSS_HOME/bin/standalone.sh -b 0.0.0.0 -Djboss.http.port=9080 -Dkeycloak.import=/home/vagrant/keycloak-server/freeipa-realm.json &'
  end

  config.vm.define "arsenic" do |arsenic|
    arsenic.vm.network "private_network", ip: "192.168.33.40"
    arsenic.vm.hostname = "arsenic.ipademo.local"
    arsenic.vm.provision "shell", :path => "arsenic.sh"
  end
end
