output "prometheus_ip" { 
    description = "Public IPs of monitoring instances"
    value = module.monitoring.public_ips[0]
    }
output "target_ip" { 
    description = "Public IPs of target instances"
    value = module.target.public_ips [0]
    }
output "security_group_id" { value = module.sg.sg_id }
output "vpc_id" { value = module.network.vpc_id }
