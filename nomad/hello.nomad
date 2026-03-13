job "hello" {
  datacenters = ["dc1"]
  type        = "service"

  group "web" {
    network {
      port "http" { static = 3000 }
    }

    task "flask-app" {
      driver = "docker"

      config {
        image = "<minhman2020/hello-devops:latest"
        ports = ["http"]
      }

      resources {
        cpu    = 100   # MHz
        memory = 128   # MB
      }
    }
  }
}
