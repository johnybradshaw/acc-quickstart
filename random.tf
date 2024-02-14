# random.tf

resource "random_password" "root_pass" {
    length = 32
    special = true
    override_special = "!#$%&*()-_=+[]{}<>:?"
    min_lower = 1
    min_upper = 1
    min_numeric = 1
    min_special = 1
}