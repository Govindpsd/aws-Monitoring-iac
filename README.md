# 🧠 Monitoring-IaC: Automated Monitoring Stack on AWS (Terraform + Ansible)

This project automates the provisioning and configuration of a **complete monitoring stack** on AWS using **Terraform** and **Ansible**.

It sets up a production-grade environment with:

- **Prometheus** — metrics collection and storage  
- **Node Exporter** — system metrics from EC2 instances  
- **Alertmanager** — automated alerting and notifications  
- **Grafana** — visualization and dashboarding  

All components are fully automated — from AWS provisioning to Grafana dashboards — using Infrastructure-as-Code (IaC).

---

## 🏗️ Architecture Overview
<img width="1024" height="1536" alt="Monitoring-iac" src="https://github.com/user-attachments/assets/8464a2c5-55f4-4037-9eea-15bff4146143" />



✅ All services are deployed on AWS EC2 instances (t2.micro or t3.micro).  
✅ Networking (VPC, subnets, security groups) is fully managed by Terraform.  
✅ Each service is configured automatically via Ansible playbooks.

---

## ⚙️ Tools & Technologies

| Tool | Purpose |
|------|----------|
| **Terraform** | Infrastructure provisioning (EC2, VPC, SGs) |
| **Ansible** | Configuration management for Prometheus, Grafana, etc. |
| **AWS EC2** | Compute resources for monitoring stack |
| **Prometheus** | Metrics storage and alerting |
| **Node Exporter** | System-level metrics from each VM |
| **Alertmanager** | Email-based alert delivery |
| **Grafana** | Visualization dashboards (auto-imported) |

---

## 🚀 Features

✅ Fully automated provisioning — from infrastructure → monitoring stack  
✅ Prometheus scrapes metrics from all exporters  
✅ Grafana auto-configured with Prometheus datasource  
✅ **Preloaded dashboards** from Grafana.com:
- Node Exporter Full (ID: 1860)  
- Prometheus 2.0 Overview (ID: 3662)  
- Blackbox Exporter Overview (ID: 7587)  
- Alertmanager Overview (ID: 9578)  

✅ Alertmanager configured for email alerts  
✅ One-click redeployment using `ansible-playbook`  

---

## 📁 Repository Structure

monitoring-iac/
├── ansible/
│ ├── ansible.cfg
│ ├── inventory.ini
│ └── playbooks/
│ ├── common.yml
│ ├── prometheus.yml
│ ├── node_exporter.yml
│ ├── grafana.yml
│ └── alertmanager.yml
├── terraform/
│ ├── main.tf
│ ├── outputs.tf
│ ├── variables.tf
│ └── modules/
│ ├── compute/
│ ├── network/
│ └── security_group/
└── README.md


---

## 🧩 Setup Guide

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/Govindpsd/monitoring-iac.git
cd monitoring-iac


2️⃣ Provision Infrastructure (Terraform)
cd terraform
terraform init
terraform apply -auto-approve
This creates:

1 EC2 instance for Prometheus + Grafana

1 EC2 instance for Node Exporter

VPC, subnets, and security groups with proper rules


3️⃣ Configure Inventory for Ansible
After Terraform finishes, note the public IPs from:

terraform output -json
Then update ansible/inventory.ini:

[prometheus]
monitoring ansible_host=<prometheus_ip> ansible_user=ubuntu

[target]
node ansible_host=<node_exporter_ip> ansible_user=ubuntu


4️⃣ Run Ansible Playbooks
Common setup (updates system packages)

ansible-playbook playbooks/common.yml
Install Node Exporter

ansible-playbook playbooks/node_exporter.yml
Install Prometheus

ansible-playbook playbooks/prometheus.yml
Install Alertmanager

ansible-playbook playbooks/alertmanager.yml
Install Grafana + Import Dashboards

ansible-playbook playbooks/grafana.yml



5️⃣ Access Services
Service	URL	Default Port
Prometheus	http://<monitoring-ip>:9090	9090
Grafana	http://<monitoring-ip>:3000	3000
Alertmanager	http://<monitoring-ip>:9093	9093
Node Exporter	http://<target-ip>:9100	9100

Grafana Login:

Username: admin
Password: Govind@1602
⚡ Example Dashboards
🖥️ Node Exporter Full (1860)
CPU utilization

Memory, Disk, Network I/O

System load averages

🔍 Blackbox Exporter Overview (7587)
Uptime probe success

Response time latency

HTTP/DNS probe metrics

⚙️ Prometheus 2.0 Overview (3662)
Scrape durations

Query load and storage health

📬 Alertmanager Overview (9578)
Active and firing alerts

Notification queue status

💡 #Future Enhancements

🔐 Replace admin credentials with Grafana API key automation

☁️ Add AWS CloudWatch Exporter for hybrid monitoring

📦 Deploy Prometheus & Grafana via Docker or Kubernetes

🔔 Integrate Slack/Webhook notifications for alerts

### 🚀 One-Click Deployment
You can deploy the entire monitoring stack with a single command:
```bash
curl -O https://raw.githubusercontent.com/<your-username>/monitoring-iac/main/bootstrap.sh
chmod +x bootstrap.sh
./bootstrap.sh


👨‍💻 Author
Govind Parshad
Future DevOps Engineer | Infrastructure Automation | Cloud Monitoring

🏁 Summary

This project demonstrates a complete, automated monitoring solution for AWS using Infrastructure-as-Code.
It’s designed for real-world use — scalable, reproducible, and production-ready.
