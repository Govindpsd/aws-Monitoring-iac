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

 ┌──────────────────────────────┐
                 │          Grafana             │
                 │  (Dashboards & Visualization)│
                 │      Port: 3000              │
                 └────────────┬─────────────────┘
                              │
               Prometheus Data Source (Port 9090)
                              │
         ┌────────────────────┴────────────────────┐
         │                                         │
┌────────────────────┐ ┌──────────────────────┐
│ Node Exporter │ │ Blackbox Exporter │
│ (VM Metrics: CPU, │ │ (Uptime, HTTP Probe) │
│ Memory, Disk, etc.) │ │ Port: 9115 │
│ Port: 9100 │ └──────────────────────┘
└────────────────────┘
│
│ (All metrics scraped by Prometheus)
│
┌──────────────────────────────┐
│ Prometheus │
│ (Metrics DB + Alert Rules) │
│ Port: 9090 │
└────────────┬─────────────────┘
│
┌──────┴──────┐
│ Alertmanager │
│ (Email/Slack │
│ Notifications)│
│ Port: 9093 │
└───────────────┘

yaml
Copy code

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

yaml
Copy code

---

## 🧩 Setup Guide

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/<your-username>/monitoring-iac.git
cd monitoring-iac
2️⃣ Provision Infrastructure (Terraform)
bash
Copy code
cd terraform
terraform init
terraform apply -auto-approve
This creates:

1 EC2 instance for Prometheus + Grafana

1 EC2 instance for Node Exporter

VPC, subnets, and security groups with proper rules

3️⃣ Configure Inventory for Ansible
After Terraform finishes, note the public IPs from:

bash
Copy code
terraform output -json
Then update ansible/inventory.ini:

ini
Copy code
[prometheus]
monitoring ansible_host=<prometheus_ip> ansible_user=ubuntu

[target]
node ansible_host=<node_exporter_ip> ansible_user=ubuntu
4️⃣ Run Ansible Playbooks
Common setup (updates system packages)
bash
Copy code
ansible-playbook playbooks/common.yml
Install Node Exporter
bash
Copy code
ansible-playbook playbooks/node_exporter.yml
Install Prometheus
bash
Copy code
ansible-playbook playbooks/prometheus.yml
Install Alertmanager
bash
Copy code
ansible-playbook playbooks/alertmanager.yml
Install Grafana + Import Dashboards
bash
Copy code
ansible-playbook playbooks/grafana.yml
5️⃣ Access Services
Service	URL	Default Port
Prometheus	http://<monitoring-ip>:9090	9090
Grafana	http://<monitoring-ip>:3000	3000
Alertmanager	http://<monitoring-ip>:9093	9093
Node Exporter	http://<target-ip>:9100	9100

Grafana Login:

pgsql
Copy code
Username: admin
Password: admin
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

💡 Future Enhancements
🔐 Replace admin credentials with Grafana API key automation

☁️ Add AWS CloudWatch Exporter for hybrid monitoring

📦 Deploy Prometheus & Grafana via Docker or Kubernetes

🔔 Integrate Slack/Webhook notifications for alerts

👨‍💻 Author
Your Name
DevOps Engineer | Infrastructure Automation | Cloud Monitoring
LinkedIn • GitHub
🏁 Summary

This project demonstrates a complete, automated monitoring solution for AWS using Infrastructure-as-Code.
It’s designed for real-world use — scalable, reproducible, and production-ready.
