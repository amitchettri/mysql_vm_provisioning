
### providers definition
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = "us-east-2"
}

resource "aws_instance" "db" {
  ami = "ami-00f8e2c955f7ffa9b"
  instance_type = "t2.micro"
  key_name = var.key_name
  vpc_security_group_ids = ["sg-0f13a1c94e61fd2e3"]

  connection {
    type        = "ssh"
    user        = "centos"
    private_key = file("./conf_files/rakesh-new-key.pem")
    host        = self.public_dns
  }

  provisioner "chef" {
    environment     = "_default"
    client_options  = ["chef_license 'accept'"]
    run_list        = var.automation_list
    node_name       = var.hostname
    #secret_key     = "${file("../encrypted_data_bag_secret")}"
    server_url      = "https://api.chef.io/organizations/cloudapp"
    recreate_client = true
    user_name       = "rakesh2412"
    user_key        = file("./conf_files/rakesh2412.pem")
    version         = "16.4.41"
    # If you have a self signed cert on your chef server change this to :verify_none
    ssl_verify_mode = ":verify_none"
  }
}

#elastic_ip
resource "aws_eip" "ip"{
  instance = aws_instance.db.id
}

