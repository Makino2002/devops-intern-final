# #!/bin/bash
# set -e
# export DEBIAN_FRONTEND=noninteractive

# # -------------------------------
# # Function: retry download
# # -------------------------------
# retry_download() {
#   local url=$1
#   local dest=$2
#   local max_attempts=5
#   local attempt=1

#   until curl -fsSL "$url" -o "$dest"; do
#     if [ $attempt -ge $max_attempts ]; then
#       echo "Failed to download $url after $attempt attempts"
#       exit 1
#     fi
#     echo "Download failed, retrying ($attempt/$max_attempts)..."
#     attempt=$((attempt+1))
#     sleep 5
#   done
# }

# # -------------------------------
# # 0/4 - Install prerequisites
# # -------------------------------
# echo '>>> [0/4] Installing prerequisites...'
# sudo apt-get update -qq
# sudo apt-get install -y ca-certificates curl gnupg lsb-release wget apt-transport-https software-properties-common

# # -------------------------------
# # 1/4 - Install Docker
# # -------------------------------
# echo '>>> [1/4] Installing Docker...'

# sudo mkdir -p /etc/apt/keyrings

# retry_download "https://download.docker.com/linux/ubuntu/gpg" "/tmp/docker.gpg.asc"
# gpg --dearmor -o /etc/apt/keyrings/docker.gpg < /tmp/docker.gpg.asc
# chmod a+r /etc/apt/keyrings/docker.gpg
# rm /tmp/docker.gpg.asc

# echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
#   | tee /etc/apt/sources.list.d/docker.list > /dev/null

# sudo apt-get update -qq
# sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# groupadd -f docker
# usermod -aG docker vagrant

# # -------------------------------
# # 2/4 - Install Nomad
# # -------------------------------
# echo '>>> [2/4] Installing Nomad...'

# retry_download "https://apt.releases.hashicorp.com/gpg" "/tmp/hashicorp.gpg.asc"
# gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg < /tmp/hashicorp.gpg.asc
# rm /tmp/hashicorp.gpg.asc

# echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
#   | tee /etc/apt/sources.list.d/hashicorp.list > /dev/null

# sudo apt-get update -qq
# sudo apt-get install -y nomad

# # -------------------------------
# # 3/4 - Install cloudflared
# # -------------------------------
# echo '>>> [3/4] Installing cloudflared...'

# retry_download "https://pkg.cloudflare.com/cloudflare-main.gpg" "/tmp/cloudflare.gpg"
# gpg --dearmor -o /usr/share/keyrings/cloudflare-main.gpg < /tmp/cloudflare.gpg 2>/dev/null \
#   || cp /tmp/cloudflare.gpg /usr/share/keyrings/cloudflare-main.gpg
# rm /tmp/cloudflare.gpg

# echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared $(lsb_release -cs) main" \
#   | tee /etc/apt/sources.list.d/cloudflared.list > /dev/null

# sudo apt-get update -qq
# sudo apt-get install -y cloudflared

# -------------------------------
# 3/4 - Install actions-runner
# -------------------------------
echo '>>> [4/4] Installing GitHub Actions Runner...'
sudo mkdir -p /opt/actions-runner
cd /opt/actions-runner
sudo chown vagrant:vagrant /opt/actions-runner
# curl -o actions-runner-linux-x64-2.332.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.332.0/actions-runner-linux-x64-2.332.0.tar.gz
# echo "f2094522a6b9afeab07ffb586d1eb3f190b6457074282796c497ce7dce9e0f2a  actions-runner-linux-x64-2.332.0.tar.gz" | shasum -a 256 -c
# tar xzf ./actions-runner-linux-x64-2.332.0.tar.gz
# ./config.sh --url https://github.com/Makino2002/devops-intern-final --token BHEFDJNJJ7DT625NRXAOXUTJWKE54
sudo -u vagrant bash <<'EOF'
cd /opt/actions-runner
curl -o actions-runner-linux-x64-2.332.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.332.0/actions-runner-linux-x64-2.332.0.tar.gz
echo "f2094522a6b9afeab07ffb586d1eb3f190b6457074282796c497ce7dce9e0f2a  actions-runner-linux-x64-2.332.0.tar.gz" | shasum -a 256 -c
tar xzf ./actions-runner-linux-x64-2.332.0.tar.gz

./config.sh --unattended \
  --url https://github.com/Makino2002/devops-intern-final \
  --token BHEFDJJ46AYKJSZOAQWEBFLJWOWOI \
  --name devops-vm \
  --labels self-hosted,Linux,X64 \
  --replace
EOF
cd /opt/actions-runner
./svc.sh install
./svc.sh start

./svc.sh status
# sudo ./svc.sh stop
# -------------------------------
# Done
# -------------------------------
echo '>>> Provision complete!'
echo '================================='