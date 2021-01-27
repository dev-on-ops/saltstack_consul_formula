# /etc/nomad.d/server.hcl

# data_dir tends to be environment specific.
data_dir = "/opt/nomad/data"

server {
  enabled          = true
  bootstrap_expect = 3
}

consul {
  token = "d88198c0-8e39-e271-0f47-cf525bc7c866"
}

server_join {
  retry_join = ["192.168.255.61:4648","192.168.255.62:4648","192.168.255.63:4648"]
}

bind_addr = "192.168.255.61"

advertise {
  http = "192.168.255.61"
  rpc  = "192.168.255.61"
  serf = "192.168.255.61"
}

client {
  enabled           = true
  network_interface = "eth1"
  servers           = ["192.168.255.61", "192.168.255.62", "192.168.255.63"]
}