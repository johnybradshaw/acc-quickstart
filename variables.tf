# variables.tf

variable "linode_token" {
    description = "Linode API token"
    type = string
    sensitive = true
}

variable "linode_count" {
    description = "Number of Linode instances"
    type = number
}

variable "linode_label" {
    description = "Linode instance label"
    type = string
}

variable "linode_config" {
    description = "Configuration for Linode services."
    type = object({
        # Linode account configuration
        email        = string // Linode email address

        # Linode instance configuration
        region           = string // Linode region
        type             = string // Linode instance type
        image            = string // Linode image
        tags             = list(string) // Linode tags
        boot_size        = number // Linode boot disk size

        # Linode domain configuration
        domain           = string // Linode domain
        domain_ttl       = number // Linode domain TTL
    })
    sensitive            = false
}

variable "cloud_init_secrets" {
    description = "Cloud-init secrets"

    type = object({
        ubuntu_advantage_token = string # Ubuntu Advantage token
        github_username = string # GitHub username for ssh_import_id
        nextdns_config_id = string # NextDNS config ID
        nordvpn_token = string # NordVPN token
    })

    sensitive = true
  
}

variable "cis_benchmark_level" {
  description = "The CIS benchmark level to apply"
  type        = string
  default     = "cis_level1_server" # Default value; can be overridden e.g. cis_level2_server
}
