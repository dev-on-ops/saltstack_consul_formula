service {
  name = "example2"
  port = 9002
  token = "21afd17b-d7c0-40af-9a73-c042d023e254"
  connect {
    sidecar_service {
      proxy {
        upstreams = [
          {
            destination_name = "example1"
            local_bind_port = 5000
          }
        ]
      }
    }
  }

  check {
    id = "example2-check"
    http = "http://localhost:9002/health"
    method = "GET"
    interval = "1s"
    timeout = "1s"
  }
}
