# DevOps Intern Final Assessment

**Name:** Nguyễn Minh Mẫn  
**Date:** 11 March 2026  
**Repo:** https://github.com/minhman2002/devops-intern-final

---

## Project Description

A complete DevOps pipeline built for the DevOps Intern Final Assessment.

```
Git → Docker → CI/CD (GitHub Actions) → Nomad → Monitoring (Grafana Loki)
```

Enhanced with Vagrant VM for local environment and Cloudflare Tunnel for public access.

---

## Quick Start

**Run locally:**

```bash
python hello.py
# Open: http://localhost:3000
```

**Run with Docker:**

```bash
docker build -t hello-devops .
docker run --rm -p 3000:3000 hello-devops
# Open: http://localhost:3000
```

---

## CI/CD Pipeline

| Step | Tool               | Description                          |
| ---- | ------------------ | ------------------------------------ |
| 1    | GitHub Actions     | Run tests, build & push Docker image |
| 2    | self-hosted runner | Trigger CD on Vagrant VM             |
| 3    | Nomad              | Pull image & run container           |
| 4    | Grafana Loki       | Collect & view logs                  |

---

## How to Run Full Pipeline

**Step 1 — Start Vagrant VM:**

```bash
vagrant up --provision
```

**Step 2 — First PR (CI only):**

- Create a Pull Request → CI runs (CD may fail if VM not ready yet)

**Step 3 — Second PR (CI + CD):**

- Create a new PR after VM is ready → CI and CD both pass

**Step 4 — View Nomad UI:**

```bash
vagrant ssh
# Nomad UI available at: http://localhost:4646
```

**Step 5 — Start Loki:**

```bash
docker run -d --name=loki -p 3100:3100 grafana/loki:2.8.2
curl http://localhost:3100/ready
# Expected: ready
```

---

## Monitoring (Grafana Loki)

Loki runs inside Vagrant VM, accessible at `http://localhost:3100`.

**View logs:**

```bash
# Docker container logs
docker logs --timestamps <container_id>

# Follow logs real-time
docker logs --timestamps --follow <container_id>

# Nomad job logs
nomad alloc logs <alloc_id>
# Get alloc_id from: nomad job status hello-devops
```

**Stop Loki:**

```bash
docker stop loki && docker rm loki
```
