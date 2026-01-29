#!/bin/bash

# Colors for pretty output
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}[1/3] Provisioning Infrastructure with Terraform...${NC}"
cd terraform
terraform init
terraform apply -auto-approve

echo -e "${GREEN}[2/3] Configuring Servers with Ansible...${NC}"
cd ../ansible
# Using the environment variable to safely skip host checking for local docker containers
ansible-playbook playbook.yml

echo -e "${GREEN}[3/3] Deployment Complete! Verifying Health...${NC}"
echo "---------------------------------------------------"
for i in {1..10}; do curl -s http://localhost:8080 | grep "web"; echo ""; done
echo "---------------------------------------------------"
echo -e "${GREEN}Success! Access your dashboard at http://localhost:8080${NC}"