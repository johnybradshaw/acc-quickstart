# # dns.tf

# Convert the instances to a map
locals {
  instance_info = { for i in range(length(linode_instance.instance)) : i => {
    label = linode_instance.instance[i].label
    ipv4 = linode_instance.instance[i].ip_address # this may change to ipv4
    ipv6 = split("/", linode_instance.instance[i].ipv6)[0] # Removes the subnet mask
  }}
}

resource "linode_domain_record" "a_record" {
  for_each      = local.instance_info

  domain_id     = data.linode_domain.domain.id
  name          = "${each.value.label}.${var.linode_config.region}"
  record_type   = "A"
  target        = "${each.value.ipv4}" 
  ttl_sec       =   var.linode_config.domain_ttl
}


resource "linode_domain_record" "aaaa_record" {
    for_each      = local.instance_info

    domain_id     = data.linode_domain.domain.id
    name          = "${each.value.label}.${var.linode_config.region}"
    record_type   = "AAAA"
    target        = "${each.value.ipv6}"
    ttl_sec       =   var.linode_config.domain_ttl

}

data "linode_domain" "domain" {
    domain = var.linode_config.domain
}

# # resource "linode_domain" "domain" {
# #   domain    = var.domain
# #   type      = "master"
# #   soa_email = "admin@example.com" # Replace with your email
# # }