terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
      version = "~> 1.0"    # 1.81.23
    }

    null = {
      source = "hashicorp/null"
      version = "3.2.1"
    }
  }
}

# Configure the TencentCloud Provider
provider "tencentcloud" {
  region = "ap-hongkong"
}

# Get availability zones
data "tencentcloud_availability_zones_by_product" "default" {
  product = "cvm"
}

# Get availability images
data "tencentcloud_images" "default" {
  image_type = ["PUBLIC_IMAGE"]
  os_name    = "ubuntu"
}

# Get availability instance types
data "tencentcloud_instance_types" "default" {
  # 机型族
  filter {
    name   = "instance-family"
    values = ["S5"]
  }

  cpu_core_count = 2
  memory_size    = 4
}

# Create security group
resource "tencentcloud_security_group" "default" {
  name        = "webs accessibility"
  description = "make it accessible for both production and stage ports"
}

# Create security group rule allow ssh request
resource "tencentcloud_security_group_lite_rule" "default" {
  security_group_id = tencentcloud_security_group.default.id
  ingress = [
    "ACCEPT#0.0.0.0/0#22#TCP",
    "ACCEPT#0.0.0.0/0#6443#TCP",
  ]

  egress = [
    "ACCEPT#0.0.0.0/0#ALL#ALL"
  ]
}

# Create a webs server
resource tencentcloud_instance webs {
  depends_on                 = [tencentcloud_security_group_lite_rule.default]
  instance_name              = "webs server"
  availability_zone          = data.tencentcloud_availability_zones_by_product.default.zones.0.name
  image_id                   = data.tencentcloud_images.default.images.0.image_id
  instance_type              = data.tencentcloud_instance_types.default.instance_types.0.instance_type
  system_disk_type           = "CLOUD_PREMIUM"
  system_disk_size           = 50
  allocate_public_ip         = true
  internet_max_bandwidth_out = 20
  instance_charge_type       = "SPOTPAID"
  orderly_security_groups    = [tencentcloud_security_group.default.id]
  count                      = 1
  password                   = "password123"
}

variable password {
  type        = string
  default     = "password123"
  description = "description"
}


# upload script
resource null_resource webs {
  triggers = {
    webs_instance_ids = join(",", tencentcloud_instance.webs.*.id)
    script_hash       = filemd5("${path.module}/init.sh.tpl")
  }

  connection {
    host      = element(tencentcloud_instance.webs.*.public_ip, 0)
    type      = "ssh"
    user      = "ubuntu"
    password  = var.password
  }

  provisioner file {
    destination   = "/tmp/init.sh"
    content       = templatefile(
        "${path.module}/init.sh.tpl",
        {
          "WELCOME_SH": "welcome.sh"
        }
    )
  }

  provisioner remote-exec {
    inline = [
      "chmod +x /tmp/init.sh",
      "sh /tmp/init.sh",
    ]
  }

}