#!/bin/bash
set -e

echo "============================================"
echo "  Shopcase - DevOps Tools Installer"
echo "============================================"

command_exists() { command -v "$1" &>/dev/null; }

install_terraform() {
  if command_exists terraform; then
    echo "[SKIP] Terraform already installed: $(terraform version | head -1)"
    return
  fi
  echo "[INFO] Installing Terraform..."
  TERRAFORM_VERSION="1.7.5"
  curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o /tmp/terraform.zip
  unzip -o /tmp/terraform.zip -d /tmp
  sudo mv /tmp/terraform /usr/local/bin/terraform
  sudo chmod +x /usr/local/bin/terraform
  rm /tmp/terraform.zip
  echo "[OK] Terraform installed."
}

install_docker() {
  if command_exists docker; then
    echo "[SKIP] Docker already installed: $(docker --version)"
    return
  fi
  echo "[INFO] Installing Docker..."
  curl -fsSL https://get.docker.com | sudo bash
  sudo usermod -aG docker "$USER"
  echo "[OK] Docker installed."
}

install_kubectl() {
  if command_exists kubectl; then
    echo "[SKIP] kubectl already installed: $(kubectl version --client --short 2>/dev/null)"
    return
  fi
  echo "[INFO] Installing kubectl..."
  KUBECTL_VERSION=$(curl -fsSL https://dl.k8s.io/release/stable.txt)
  curl -fsSL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" -o /tmp/kubectl
  sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl
  rm /tmp/kubectl
  echo "[OK] kubectl installed."
}

install_helm() {
  if command_exists helm; then
    echo "[SKIP] Helm already installed: $(helm version --short)"
    return
  fi
  echo "[INFO] Installing Helm..."
  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
  echo "[OK] Helm installed."
}

install_awscli() {
  if command_exists aws; then
    echo "[SKIP] AWS CLI already installed: $(aws --version)"
    return
  fi
  echo "[INFO] Installing AWS CLI v2..."
  curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
  unzip -o /tmp/awscliv2.zip -d /tmp
  sudo /tmp/aws/install
  rm -rf /tmp/awscliv2.zip /tmp/aws
  echo "[OK] AWS CLI installed."
}

install_terraform
install_docker
install_kubectl
install_helm
install_awscli

echo ""
echo "============================================"
echo "  All tools installed successfully!"
echo "============================================"
terraform version 2>/dev/null | head -1
docker --version 2>/dev/null
kubectl version --client --short 2>/dev/null
helm version --short 2>/dev/null
aws --version 2>/dev/null
