### variables definition
variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "private_key_path" {}

variable "key_name" {default = "rakesh-new-key"}

variable "network_address_space" {
  default = "10.1.0.0/16"
}

variable "subnet1_address_space" {
  default = "10.1.1.0/24"
}

variable "subnet2_address_space" {
  default = "10.1.2.0/24"
}

variable "instance_ips" {
  default = {
    "0" = "10.1.1.10"
    "1" = "10.1.1.11"
    "2" = "10.1.1.12"
  }
}

variable "automation_list" {
  type    = list
  default = ["mysql"]
}

variable "hostname" {
  type    = string
  default = "default"
}
