job "hello-devops" {
  datacenters = ["dc1"]
  type = "service"

  group "web" {
    task "hello" {
      driver = "docker"

      config {
        image = "minhman2002/hello-devops:latest"
        port_map {
          http = 3000
        }
      }

      resources {
        cpu    = 500
        memory = 256

        network {
          mbits = 10
          port "http" {
            static = 3000
          }
        }
      }
    }
  }
}