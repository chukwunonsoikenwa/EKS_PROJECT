#!/bin/bash
set -e

############################################
# System Prep
############################################
sudo apt update -y
sudo apt install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  unzip \
  fontconfig

############################################
# Install Java 17 (Jenkins supported)
############################################
sudo apt install -y openjdk-17-jdk
java -version

############################################
# Install Jenkins (LATEST LTS via .deb)
############################################
JENKINS_VERSION="2.479.1"

wget https://pkg.jenkins.io/debian-stable/binary/jenkins_${JENKINS_VERSION}_all.deb
sudo dpkg -i jenkins_${JENKINS_VERSION}_all.deb || sudo apt -f install -y

sudo systemctl enable jenkins
sudo systemctl start jenkins

############################################
# Install Docker
############################################
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

# Add users to docker group (NO chmod 777)
sudo usermod -aG docker ubuntu
sudo usermod -aG docker jenkins

############################################
# Install Terraform (official HashiCorp repo)
############################################
curl -fsSL https://apt.releases.hashicorp.com/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com jammy main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update
sudo apt install -y terraform
terraform version

############################################
# Install kubectl (stable)
############################################
KUBECTL_VERSION="v1.29.4"

curl -LO https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

############################################
# Install AWS CLI v2
############################################
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
unzip -q awscliv2.zip
sudo ./aws/install
aws --version

############################################
# Install Trivy
############################################
curl -fsSL https://aquasecurity.github.io/trivy-repo/deb/public.key | \
  sudo gpg --dearmor -o /usr/share/keyrings/trivy.gpg

echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] \
https://aquasecurity.github.io/trivy-repo/deb generic main" | \
sudo tee /etc/apt/sources.list.d/trivy.list

sudo apt update
sudo apt install -y trivy
trivy --version

############################################
# Run SonarQube (Docker)
############################################
docker run -d \
  --name sonarqube \
  -p 9000:9000 \
  sonarqube:community
