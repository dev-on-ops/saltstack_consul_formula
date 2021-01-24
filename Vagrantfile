vagrant_nodes = [
  {
    :node       => "consulmgmt01",
    :ip         => "192.168.255.11",
    :os         => "hashicorp/bionic64",
    :cpu        => "2",
    :memory_mb  => "2048",
    :salt_type  => "master"
  },
  {
    :node       => "consulserver01",
    :ip         => "192.168.255.21",
    :os         => "hashicorp/bionic64",
    :cpu        => "1",
    :memory_mb  => "2048",
    :salt_type  => "minion"
  },
  {
    :node       => "consulserver02",
    :ip         => "192.168.255.22",
    :os         => "hashicorp/bionic64",
    :cpu        => "1",
    :memory_mb  => "2048",
    :salt_type  => "minion"
  },
  {
    :node       => "consulserver03",
    :ip         => "192.168.255.23",
    :os         => "hashicorp/bionic64",
    :cpu        => "1",
    :memory_mb  => "2048",
    :salt_type  => "minion"
  },
  {
    :node       => "consulclient01",
    :ip         => "192.168.255.31",
    :os         => "hashicorp/bionic64",
    :cpu        => "1",
    :memory_mb  => "2048",
    :salt_type  => "minion"
  },
  {
    :node       => "consulclient02",
    :ip         => "192.168.255.32",
    :os         => "hashicorp/bionic64",
    :cpu        => "1",
    :memory_mb  => "2048",
    :salt_type  => "minion"
  },
  {
    :node       => "testclient01",
    :ip         => "192.168.255.41",
    :os         => "hashicorp/bionic64",
    :cpu        => "1",
    :memory_mb  => "2048",
    :salt_type  => "minion"
  }
]

minion_keys_list = {
#  "consulserver01" => "saltstack/keys/master_minion.pub"
  "consulserver01" => "saltstack/keys/consulserver01.pub",
  "consulserver02" => "saltstack/keys/consulserver02.pub",
  "consulserver03" => "saltstack/keys/consulserver03.pub",
  "consulclient01" => "saltstack/keys/consulclient01.pub",
  "consulclient02" => "saltstack/keys/consulclient02.pub",
  "testclient01" => "saltstack/keys/testclient01.pub"
 }

Vagrant.configure("2") do |config|
  vagrant_nodes.each do |vagrant_node|
    if vagrant_node[:salt_type] == "master"
      config.vm.define vagrant_node[:node] do |instance|
        # VM Configs
        instance.ssh.insert_key = false
        instance.vm.box = vagrant_node[:os]
        instance.vm.hostname = vagrant_node[:node]
        instance.vm.network "private_network", ip: vagrant_node[:ip]
        instance.vm.provider :virtualbox do |v|
          v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
          v.customize ["modifyvm", :id, "--cpus", vagrant_node[:cpu]]
          v.customize ["modifyvm", :id, "--memory", vagrant_node[:memory_mb]]
          v.customize ["modifyvm", :id, "--name", vagrant_node[:node]]
        end
        # Salt Configs
        instance.vm.synced_folder "saltstack/salt/", "/srv/salt"
        instance.vm.synced_folder "saltstack/pillar/", "/srv/pillar"
        instance.vm.provision :salt do |salt|
          salt.master_config = "saltstack/etc/master"
          salt.master_key = "saltstack/keys/master_minion.pem"
          salt.master_pub = "saltstack/keys/master_minion.pub"
          salt.minion_key = "saltstack/keys/master_minion.pem"
          salt.minion_pub = "saltstack/keys/master_minion.pub"
          salt.seed_master = minion_keys_list
          salt.install_type = "stable"
          salt.install_master = true
          salt.no_minion = true
          salt.verbose = true
          salt.colorize = true
          salt.bootstrap_options = "-P -c /tmp -x python3"
        end
      end
    end
    if vagrant_node[:salt_type] == "minion"
      config.vm.define vagrant_node[:node] do |instance|
        instance.ssh.insert_key = false
        instance.vm.box = vagrant_node[:os]
        instance.vm.hostname = vagrant_node[:node]
        instance.vm.network "private_network", ip: vagrant_node[:ip]
        instance.vm.provider :virtualbox do |v|
          v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
          v.customize ["modifyvm", :id, "--cpus", vagrant_node[:cpu]]
          v.customize ["modifyvm", :id, "--memory", vagrant_node[:memory_mb]]
          v.customize ["modifyvm", :id, "--name", vagrant_node[:node]]
        end
        instance.vm.provision :salt do |salt|
          salt.minion_config = "saltstack/etc/minion"
          salt.minion_key = "saltstack/keys/#{ vagrant_node[:node]}.pem"
          salt.minion_pub = "saltstack/keys/#{ vagrant_node[:node]}.pub"
          salt.install_type = "stable"
          salt.verbose = true
          salt.colorize = true
          salt.bootstrap_options = "-P -c /tmp -x python3"
        end
      end
    end
  end
end