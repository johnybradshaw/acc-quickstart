# firewall.tf
# Get the current user's IP address
data "external" "current_ip" {
  program = ["bash", "-c", "curl -s 'https://api.ipify.org?format=json'"]
}

resource "linode_firewall" "firewall" {
    label = var.linode_label
    tags = var.linode_config.tags

    # Inbound rules
    inbound {
        label    = "allow-inbound-ssh"
        action   = "ACCEPT"
        protocol = "TCP"
        ports    = "22"
        ipv4     = ["${data.external.current_ip.result.ip}/32"]
        #ipv6     = ["::/0"]
    }
    inbound {
        label    = "allow-inbound-mosh"
        action   = "ACCEPT"
        protocol = "UDP"
        ports    = "60000-61000"
        ipv4     = ["${data.external.current_ip.result.ip}/32"]
        #ipv6     = ["::/0"]
    }
    inbound {
        label    = "allow-inbound-webmin"
        action   = "ACCEPT"
        protocol = "TCP"
        ports    = "10000"
        ipv4     = ["${data.external.current_ip.result.ip}/32"]
        #ipv6     = ["::/0"]
    }
    inbound {
        label    = "allow-inbound-certbot-http"
        action   = "ACCEPT"
        protocol = "TCP"
        ports    = "80"
        ipv4     = ["0.0.0.0/0"]
        #ipv6     = ["::/0"]
    }

    inbound_policy = "DROP"

    #Outbound rules
    outbound_policy = "ACCEPT"

    linodes = linode_instance.instance.*.id
}