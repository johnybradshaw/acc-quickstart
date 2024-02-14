# main.tf

# Get the users profile
data "linode_profile" "me" {}

# Create the instances
resource "linode_instance" "instance" {
    count = var.linode_count // Number of Linode instances
    depends_on = [ data.cloudinit_config.instances ]

    label      = "${var.linode_label}-${count.index}"
    tags       = concat(var.linode_config.tags, ["tld: ${var.linode_config.domain}"])
    region     = var.linode_config.region
    type       = var.linode_config.type
    
    metadata {
        user_data = data.cloudinit_config.instances.rendered
    }

    authorized_users = [ data.linode_profile.me.username ]
    root_pass = random_password.root_pass.result
}

resource "linode_instance_config" "instance" {
    count = var.linode_count // Number of Linode instances
    depends_on = [ linode_instance.instance ]
    linode_id = linode_instance.instance[count.index].id
    label = "${var.linode_label}-${count.index}"

    device {
        device_name = "sda"
        disk_id     = linode_instance_disk.boot_disk[count.index].id
    }

    # Configure the helpers
    helpers {
        updatedb_disabled = false # Disable the updatedb helper
        network = false # Disable the network helper
    }

    booted = true # Boot the instance using this config
    root_device = "/dev/sda" # Root device
    kernel      = "linode/latest-64bit" # Use the latest 64-bit kernel
}

resource "linode_instance_disk" "boot_disk" {
    count       = var.linode_count // Number of Linode instances
    depends_on  = [ linode_instance.instance ]
    linode_id   = linode_instance.instance[count.index].id
    label       = "boot ${var.linode_label}-${count.index}" # Disk label

    size        = var.linode_config.boot_size # Disk size
    image       = var.linode_config.image # Disk image
}