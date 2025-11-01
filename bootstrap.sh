#!/bin/bash
# =====================================================================
# 🧠 Monitoring Stack Bootstrap Script
# Automates setup of Terraform + Ansible monitoring stack on a new system
# Compatible with macOS & Linux
# =====================================================================

set -e

echo "🚀 Starting Monitoring Stack Bootstrap Setup..."
sleep 1

# ---------------------------------------------------------------------
# 1️⃣ Check and Install Required Tools
# ---------------------------------------------------------------------
install_if_missing() {
  if ! command -v $1 &> /dev/null; then
    echo "🔧 Installing $1..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
      brew install $2
    else
      sudo apt-get update -y && sudo apt-get install -y $2
    fi
  else
    echo "✅ $1 already installed."
  fi
}

echo "🔍 Checking system dependencies..."
install_if_missing git git
install_if_missing terraform terraform
install_if_missing ansible ansible
install_if_missing aws awscli

# ---------------------------------------------------------------------
# 2️⃣ Clone Repo if Not Already Cloned
# ---------------------------------------------------------------------
if [ ! -d "monitoring-iac" ]; then
  echo "📦 Cloning monitoring repository..."
  git clone https://github.com/<your-username>/monitoring-iac.git
fi

cd monitoring-iac || exit

# ---------------------------------------------------------------------
# 3️⃣ Configure AWS CLI (skip if already configured)
# ---------------------------------------------------------------------
if [ ! -f ~/.aws/credentials ]; then
  echo "🔐 Configuring AWS CLI..."
  aws configure
else
  echo "✅ AWS CLI already configured."
fi

# ---------------------------------------------------------------------
# 4️⃣ Terraform Setup and Infrastructure Provisioning
# ---------------------------------------------------------------------
echo "🌍 Running Terraform..."
cd terraform || exit
terraform init -input=false
terraform apply -auto-approve

# Extract public IPs
MONITORING_IP=$(terraform output -raw monitoring_public_ips | tr -d '[]" ')
TARGET_IP=$(terraform output -raw target_public_ips | tr -d '[]" ')
cd ..

# ---------------------------------------------------------------------
# 5️⃣ Prepare Ansible Inventory
# ---------------------------------------------------------------------
echo "🧩 Creating Ansible inventory file..."
cat > ansible/inventory.ini <<EOF
[prometheus]
monitoring ansible_host=$MONITORING_IP ansible_user=ubuntu

[target]
target ansible_host=$TARGET_IP ansible_user=ubuntu
EOF

echo "✅ Inventory created with:"
echo "   - Monitoring VM: $MONITORING_IP"
echo "   - Target VM: $TARGET_IP"

# ---------------------------------------------------------------------
# 6️⃣ Verify Connectivity
# ---------------------------------------------------------------------
echo "🔍 Testing SSH connectivity via Ansible..."
cd ansible || exit
ansible all -m ping -i inventory.ini

# ---------------------------------------------------------------------
# 7️⃣ Run All Ansible Playbooks
# ---------------------------------------------------------------------
echo "⚙️ Running Ansible Playbooks..."
ansible-playbook playbooks/common.yml -i inventory.ini
ansible-playbook playbooks/node_exporter.yml -i inventory.ini
ansible-playbook playbooks/prometheus.yml -i inventory.ini
ansible-playbook playbooks/alertmanager.yml -i inventory.ini
ansible-playbook playbooks/grafana.yml -i inventory.ini

# ---------------------------------------------------------------------
# 8️⃣ Summary Output
# ---------------------------------------------------------------------
echo "✅ Monitoring stack deployed successfully!"
echo ""
echo "🌐 Access URLs:"
echo "   Prometheus:   http://$MONITORING_IP:9090"
echo "   Grafana:      http://$MONITORING_IP:3000"
echo "   Alertmanager: http://$MONITORING_IP:9093"
echo "   Node Exporter:http://$TARGET_IP:9100"
echo ""
echo "👤 Grafana Login:"
echo "   Username: admin"
echo "   Password: admin"
echo ""
echo "🎉 Setup complete! Enjoy your fully automated monitoring stack."

