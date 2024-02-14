# output.tf

output "instances" {
  value = [
    for i in linode_domain_record.a_record : 
        "acc-user@${i.name}.${var.linode_config.domain} --> ${i.target}"
    ]
  description = "Created instances"
}

# Get SSH host keys and add them to known_hosts (remove if using Terraform Cloud)
# resource "null_resource" "get_ssh_host_keys" {
#   depends_on = [ linode_firewall.firewall, linode_domain_record.a_record, linode_instance.instance ]
#   triggers = {
#     always_run = "${timestamp()}"
#   }

#   provisioner "local-exec" {
#     command = join("\n", [for i in linode_domain_record.a_record : "ssh-keyscan -H ${i.name}.${var.linode_config.domain} >> ~/.ssh/known_hosts"])
#     interpreter = ["bash", "-c"]
#   }
# }
