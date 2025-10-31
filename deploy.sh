#!/bin/bash
set -e

# ----------------------------------------------------------------------
#  Full Terraform + Ansible Deployment Script
#  Provisions EC2 instances and configures Prometheus monitoring stack
# ----------------------------------------------------------------------

# Always run Terraform from the directory containing this script
cd "$(dirname "$0")"

echo "🚀 Starting full monitoring stack deployment..."

# ----------------------------------------------------------------------
# Step 1. Initialize and apply Terraform
# ----------------------------------------------------------------------
echo "🧩 Applying Terraform configuration..."
terraform init -input=false
terraform apply -auto-approve

# ----------------------------------------------------------------------
# Step 2. Extract Terraform outputs (public IPs)
# ----------------------------------------------------------------------
PROMETHEUS_IP=$(terraform output -raw prometheus_ip)
TARGET_IP=$(terraform output -raw target_ip)

echo "✅ Prometheus VM IP: $PROMETHEUS_IP"
echo "✅ Node Exporter VM IP: $TARGET_IP"

# ----------------------------------------------------------------------
# Step 3. Create Ansible inventory file dynamically
# ----------------------------------------------------------------------
mkdir -p ansible

cat > ansible/inventory.ini <<EOF
[prometheus]
monitoring ansible_host=${PROMETHEUS_IP} ansible_user=ubuntu

[node_exporter]
target ansible_host=${TARGET_IP} ansible_user=ubuntu
EOF

echo "🧾 Generated inventory.ini:"
cat ansible/inventory.ini

# ----------------------------------------------------------------------
# Step 4. Run Ansible playboo

