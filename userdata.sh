#!/bin/bash
# Update System
sudo yum update
# Install Docker
sudo yum install docker git -y
sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
# Install Minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo chmod +x minikube
sudo mv minikube /usr/local/bin/
# Start Minikube
sudo su - ec2-user -c "minikube start  2>&1 | tee SomeFile.txt"
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin/
git clone https://github.com/ArieL19999/job-project.git
sudo su - ec2-user -c "kubectl apply -f /job-project/deployment.yml"
sudo su - ec2-user -c "kubectl apply -f /job-project/service.yml"
SSH_KEY_PATH="/home/ec2-user/.minikube/machines/minikube/id_rsa"
MINIKUBE_IP=$(sudo su - ec2-user -c "minikube ip")
sudo ssh -o StrictHostKeyChecking=no -i "$SSH_KEY_PATH" docker@"$MINIKUBE_IP" -L *:80:0.0.0.0:32321 -N &
