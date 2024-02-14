## Usage

Sample usage of this module is as shown below. For detailed info, look at inputs and outputs.

### Step 1

Create a `terraform.tfvars` file and update with:

```hcl
linode_token = "<linode-token>"

linode_count = 4
linode_label = "test"

linode_config = {
    email = "<linode-email>"
    region = "<linode-region>"
    type = "<linode-type>"
    image = "linode/ubuntu22.04"
    tags = [ "quickstart", "terraform" ]

    domain = "<linode-domain>"
    domain_ttl = 60

}

cloud_init_secrets = {
    ubuntu_advantage_token = "<ubuntu-advantage-token>"
    github_username = "<github-username>"
}

```

### Step 2

Verify your settings using the following command:

```bash
terraform init
terraform plan
```

### Step 3

Apply the changes

```bash
terraform apply
```

You will see a list of outputs similar to:

```bash
Apply complete! Resources: 13 added, 0 changed, 0 destroyed.

Outputs:

instance_ips = [
  "ssh://acc-user@test-0.fr-par.acc.domain.cloud",
  "ssh://acc-user@test-1.fr-par.acc.domain.cloud",
  "ssh://acc-user@test-2.fr-par.acc.domain.cloud",
  "ssh://acc-user@test-3.fr-par.acc.domain.cloud",
]
```

### Step 4

To clean up simply run:

`terraform destroy`

And confirm to remove all created resources.
