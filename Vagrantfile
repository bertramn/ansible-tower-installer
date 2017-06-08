# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.8.1"

# use dns manager
$windows = (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil

# start VM configuration
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # base DNS settings for fake dns resolver
  tld = ENV['TLD'] || 'local'

  # we typically engage hostname managers on either platform
  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true
    # need to add all dns names of started nodes into below list on windoze
    #config.hostmanager.aliases = %w(other.vagrant.v8)
  end

  if Vagrant.has_plugin?("landrush")
    config.landrush.enabled = true
    config.landrush.tld = tld
  end

  # pesky proxy can be driven by envirnonment
  if Vagrant.has_plugin?("vagrant-proxyconf")
    if ENV['PROXY_ENABLED'] == 'true'
      config.proxy.enabled = { apt: false, chef: false, docker: false, git: true, npm: false, pear: false, svn: false}
      config.proxy.http     = "#{ENV['http_proxy']}"
      config.proxy.https    = "#{ENV['https_proxy']}"
      config.proxy.no_proxy = "#{ENV['no_proxy']}"
    else
      # need to set to empty to clear
      config.proxy.enabled = true
      config.proxy.http     = ""
      config.proxy.https    = ""
      config.proxy.no_proxy = ""
    end
  end

  if Vagrant.has_plugin?("vagrant-vbguest")
    # we are using https://github.com/dotless-de/vagrant-vbguest
    # disable autoupdate of the VB guest
    config.vbguest.auto_update = false
  end

  config.vm.define "tower" do |tower|
    tower.vm.box      = "boxcutter/centos72"
    tower.vm.hostname = "tower.vagrant.#{tld}"
    tower.vm.network "private_network", ip: "192.168.33.93"

    # virtualbox image configuration
    tower.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.name = "ansible-tower-custom"
      vb.memory = 3096
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on", "--vrde", "off", "--vram", 10]
    end

    # provisioning ansible
    tower.vm.provision "ansible" do |ansible|
      ansible.playbook = "site.yml"
      ansible.verbose = "v"
      ansible.limit = "tower"
      ansible.inventory_path = "./inventory"
      ansible.sudo = true
    end
  end

end
