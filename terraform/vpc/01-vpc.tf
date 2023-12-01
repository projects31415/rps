module "vpc" {
  source = "github.com/terraform-yc-modules/terraform-yc-vpc.git?ref=1.0.1"

  network_name  = var.network_name
  create_nat_gw = false
  create_sg     = false
  private_subnets = [
    {
      name           = "subnet-1"
      zone           = "ru-central1-a"
      v4_cidr_blocks = ["10.128.0.0/24"]
    },
    {
      name           = "subnet-2"
      zone           = "ru-central1-b"
      v4_cidr_blocks = ["10.129.0.0/24"]
    },
    {
      name           = "subnet-3"
      zone           = "ru-central1-c"
      v4_cidr_blocks = ["10.130.0.0/24"]
    }
  ]
}
