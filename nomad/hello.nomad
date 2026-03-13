job "hello-devops" {
  datacenters = ["dc1"]
  type = "service"

  group "web" {
    task "hello" {
      driver = "docker"

      config {
        image = "minhman2002/hello-devops:latest"
        ports = ["http"]
      }

      resources {
        cpu    = 500
        memory = 256

        network {
          port "http" {
            static = 3000
          }
        }
      }
    }
  }
}