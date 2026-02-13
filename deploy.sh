#!/bin/bash
set -e # Stop on error

echo "🛠️ Step 1: Provisioning AWS Infrastructure..."
terraform init
terraform apply -auto-approve

IP=$(terraform output -raw instance_ip)

echo "🛠️ Step 2: Creating Dynamic Inventory..."
echo "[devops_nodes]" > inventory.ini
echo "$IP ansible_ssh_private_key_file=~/path/to/your-key.pem" >> inventory.ini # <--- CHANGE THIS PATH

echo "⏳ Step 3: Waiting 60 seconds for Instance to initialize..."
sleep 60

echo "🛠️ Step 4: Running Ansible Playbook to install tools..."
ansible-playbook -i inventory.ini ansible_playbook.yml

echo "------------------------------------------------"
echo "✅ DEPLOYMENT COMPLETE!"
echo "Jenkins: http://$IP:8080"
echo "Grafana: http://$IP:3000 (Default login: admin / prom-operator)"
echo "Prometheus: http://$IP:9090"
echo "------------------------------------------------"
