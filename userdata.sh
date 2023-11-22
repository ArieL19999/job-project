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
# Clone the 'job-project' repository from GitHub
git clone https://github.com/ArieL19999/job-project.git
# Apply the Kubernetes deployment configuration from the 'deployment.yml' file
sudo su - ec2-user -c "kubectl apply -f /job-project/deployment.yml"
# Apply the Kubernetes service configuration from the 'service.yml' file
sudo su - ec2-user -c "kubectl apply -f /job-project/service.yml"
# Defining the path to the SSH key for Minikube
SSH_KEY_PATH="/home/ec2-user/.minikube/machines/minikube/id_rsa"
# the IP address of the Minikube machine
MINIKUBE_IP=$(sudo su - ec2-user -c "minikube ip")
# an SSH tunnel to forward traffic from the local machine to the Minikube instance
sudo ssh -o StrictHostKeyChecking=no -i "$SSH_KEY_PATH" docker@"$MINIKUBE_IP" -L *:80:0.0.0.0:32321 -N &
