# Ansible Tower Installation Example

Steps following the offical [documentation](https://docs.ansible.com/ansible-tower/latest/html/quickinstall/) from Ansible to install Tower.

This setup will only install the prerequisites but not tower itself. When the Vagrant provisioning script finishes there will be a message on how to kick the actual installation off.

First ensure you installed following components on your host machine:

* ansible
* VirtualBox 5.1.18 or later
* vagrant 1.8.7

Also on linux based systems install dnsmasq via package manager and then install the landrush vagrant plugin ( `vagrant plugin install landrush` ).


To run this, simply punch in `vagrant up` and then follow the prompt.

Once tower is installed, visit the tower dashbaord on https://tower.vagrant and try to add a licence file. This step will fail with some random "URL is invalid" error message.

Only workaround found so far is to use curl and the Tower API to register the product.

```sh
curl -d @tower.license.txt -f -s -k -X POST -u 'admin:secret' -H 'Content-Type: application/json' https://tower.vagrant/api/v1/config/
```
