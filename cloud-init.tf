# cloud-init.tf

data "cloudinit_config" "instances" {
    #gzip          = true # cloud-init has become too large, so gzip it
    base64_encode = true

    # base cloud-config
    part {
      content_type = "text/cloud-config"
      content = file("${path.module}/cloud-init/cloud-init.yaml")
    }

    # Conditional block for ubuntu
    dynamic "part" {
      for_each = var.linode_config.image == "linode/ubuntu22.04" ? [1] : []
      content {
        
        content_type = "text/cloud-config"
        content = templatefile("${path.module}/cloud-init/blocks/ubuntu.yaml", {
          ubuntu_advantage_token: var.cloud_init_secrets.ubuntu_advantage_token
        })
      }
    }

    # write files
    part {
      content_type = "text/cloud-config"
      content = templatefile("${path.module}/cloud-init/blocks/write-files.yaml", {

        # scripts
        update_rkhunter_conf: base64encode(file("${path.module}/cloud-init/scripts/update-rkhunter-conf.sh")),
        set_hostname: base64encode(file("${path.module}/cloud-init/scripts/acc-set-hostname.sh")),
        autologout_tty: base64encode(file("${path.module}/cloud-init/scripts/autologout-tty.sh")),
        aliases: base64encode(file("${path.module}/cloud-init/scripts/aliases.sh")),
        tmux: base64encode(file("${path.module}/cloud-init/scripts/tmux.sh")),

        # configs
        aide_conf: base64encode(file("${path.module}/cloud-init/configs/aide.conf")),
        netcfg: base64encode(file("${path.module}/cloud-init/configs/01-netcfg.yaml")),
        eth0_network: base64encode(file("${path.module}/cloud-init/configs/eth0.network")),

        # secrets
        nextdns: var.cloud_init_secrets.nextdns_config_id
        })
    }

    # packages
    part {
        content_type = "text/cloud-config"
        content = file("${path.module}/cloud-init/blocks/packages.yaml")
    }
    
    # users
    part {
        content_type = "text/cloud-config"
        content = templatefile("${path.module}/cloud-init/blocks/users.yaml", {
          ssh_public_keys: indent(6,yamlencode(data.linode_profile.me.authorized_keys)), # indent to match cloud-init
          github_username: var.cloud_init_secrets.github_username
        })
    }

    # groups
    part {
        content_type = "text/cloud-config"
        content = file("${path.module}/cloud-init/blocks/groups.yaml")
    }

    # puppet
    part {
        content_type = "text/cloud-config"
        content = file("${path.module}/cloud-init/blocks/puppet.yaml")
    }

    # ssh
    part {
        content_type = "text/cloud-config"
        content = file("${path.module}/cloud-init/blocks/ssh.yaml")
    }

    # runcmd
    part {
        content_type = "text/cloud-config"
        content = templatefile("${path.module}/cloud-init/blocks/runcmd.yaml", {
          # Apply CIS Benchmark to Ubuntu
          ubuntu_usg_install: indent(2, yamlencode(
            var.linode_config.image == "linode/ubuntu22.04" ? [
              "apt install usg -y"
            ] : [ # If not running Ubuntu
              "echo 'Not running Ubuntu - No Install Necessary'"
            ]
          )),

          # Fix CIS Benchmark
          ubuntu_usg_fix: indent(2, yamlencode(
          var.linode_config.image == "linode/ubuntu22.04" ? [
            "usg fix ${var.cis_benchmark_level}"
          ] : [ # If not running Ubuntu
            "echo 'Not running Ubuntu - No Fix Necessary'"
          ]
        )),

          nextdns_config_id: var.cloud_init_secrets.nextdns_config_id,
          nordvpn_token: var.cloud_init_secrets.nordvpn_token
        })
    }
}