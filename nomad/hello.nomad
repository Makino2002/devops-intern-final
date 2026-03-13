job "hello-devops" {
  datacenters = ["dc1"]
  type        = "service"

  group "web" {
    count = 1

    network {
      port "http" {
        static = 3000
        to     = 3000
      }
    }

    task "app" {
      driver = "docker"

      config {
        image = "minhman2002/hello-devops:latest"
        ports = ["http"]
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}