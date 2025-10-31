#!/usr/bin/env bash
set -e
OUT_JSON=$(terraform output -json)
MON_IPS=$(echo "$OUT_JSON" | jq -r '.monitoring_public_ips.value[]?')
TARGET_IPS=$(echo "$OUT_JSON" | jq -r '.target_public_ips.value[]?')
INV_FILE="../ansible/inventory.ini"
mkdir -p ../ansible
cat > $INV_FILE <<EOT
[monitoring]
EOT
for ip in $MON_IPS; do
  echo "${ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa" >> $INV_FILE
done
echo -e "\n[target]" >> $INV_FILE
for ip in $TARGET_IPS; do
  echo "${ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa" >> $INV_FILE
done
echo "✅ Wrote $INV_FILE"
