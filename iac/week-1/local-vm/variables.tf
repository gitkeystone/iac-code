# Tencent Cloud variables.

# Change it!

variable "password" {
  default = "You vm password"
}

variable "public_ip" {
  default = "public_ip"
}

variable "private_ip" {
  default = "private_ip"
}

variable "pg_ip" {
  default = "pg_ip"
}
variable "user" {
  default = "root"
}

variable "server_name" {
  default = "CentOS7-k3s"
}

variable "prefix" {
  default = "30"
}
variable "secret_id" {
  default = "Your Access ID"
}

variable "secret_key" {
  default = "Your Access Key"
}

variable "domain" {
  default = "xxx.xxx"
}

# harbor default registry name
variable "registry" {
  default = "example"
}

variable "harbor_password" {
  default = "Harbor12345"
}

variable "pg_password" {
  default = "password123"
}

variable "example_project_name" {
  default = "camp-go-example"
}

variable "cloudflare_api_key" {
  default = "You api key"
}

variable "region" {
  description = "The location where instacne will be created"
  default     = "ap-hongkong"
}

# grafana
variable "grafana_password" {
  default = "password123"
}

# jenkins
variable "jenkins_password" {
  default = "password123"
}

# sonar
variable "sonar_password" {
  default = "password123"
}

# argocd password, do not change it!
variable "argocd_password" {
  default = "password123"
}

# cosign password, do not change it!
variable "cosign_password" {
  default = "password123"
}

# Default variables
variable "availability_zone" {
  default = "ap-hongkong-2"
}

variable "instance_charge_type" {
  type    = string
  default = "SPOTPAID"
}

variable "tags" {
  description = "A map of the tags to use for the resources that are deployed"
  type        = map(string)

  default = {
    # This value will be the tage text.
    web = "tf-web"
    dev = "tf-dev"
  }
}
# VPC Info
variable "short_name" {
  default = "tf-vpc"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

# VSwitch Info
variable "web_cidr" {
  default = "10.0.1.0/24"
}

# ECS insance variables 
variable "image_id" {
  default = ""
}

variable "instance_type" {
  default = ""
}

variable "instance_name" {
  default = "terraform-iac-k3s"
}

