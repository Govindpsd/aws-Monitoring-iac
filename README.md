# Monitoring-IaC

This project automates the setup of a complete monitoring stack on AWS using **Terraform + Ansible**:

- **Terraform**: provisions EC2 instances, VPC, Security Groups, and networking.
- **Ansible**: installs and configures Prometheus, Node Exporter, Alertmanager, and Grafana.
- **Grafana**: auto-imports key dashboards (Node Exporter, Blackbox, Alertmanager, Prometheus).

## Usage
1. Run `terraform apply` to provision infrastructure.
2. Run `ansible-playbook playbooks/common.yml` to set up prerequisites.
3. Run `ansible-playbook playbooks/grafana.yml` to install Grafana and dashboards.

