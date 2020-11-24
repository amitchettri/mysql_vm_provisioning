# MYSQL VM Provisioning on AWS

## Contents

1. [Introduction](#introduction)
2. [Terraform](#terraform)
3. [Chef](#chef)
4. [Author Information](#author)

## <a name="introduction">1. Introduction
This repository is used to implement usecase on MYSQL VM Provisioing on AWS.
To implement this use case, terraform is used for VM provisioning and chef cookbook is used for installing and configuring mysql server

## <a name="terraform">2. Terraform
Terraform templates with "aws" provider is used

## Run terraform command with var-file

```bash
$ cat ./terraform.tfvars

aws_access_key = "<aws-access-key>"
aws_secret_key = "<aws-secret-key>"
key_name = "<keypair-name>"
private_key_path = "<keypair-path>"
hostname = "<hostname>"
automation_list = ["mysql"]

$ terraform init
$ terraform plan -var-file=./terraform.tfvars
$ terraform apply -var-file=./terraform.tfvars
```

Update terraform template with aws provider parameters and instance details

```
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

```

## <a name="chef">3. Chef

Once the VM is successfully is created, chef-client will be installed and bootstrapped.
chef cookbook execution will be triggered based on the automation list defined in terraform.tfvars file (automation_list = ["mysql"])

```
  provisioner "chef" {
    environment     = "_default"
    client_options  = ["chef_license 'accept'"]
    run_list        = var.automation_list
    node_name       = var.hostname
    #secret_key     = "${file("../encrypted_data_bag_secret")}"
    server_url      = "https://api.chef.io/organizations/cloudapp"
    recreate_client = true
    user_name       = "<username>"
    user_key        = file("./conf_files/<username>.pem")
    version         = "16.4.41"
    # If you have a self signed cert on your chef server change this to :verify_none
    ssl_verify_mode = ":verify_none"
```

once the chef cookbook is successfully executed, mysql will be installed and configured on the new VM.

MYSQL is running on port 3300
```
$ netstat -nltp | grep mysql
tcp6       0      0 :::3300                 :::*                    LISTEN      1765/mysqld
```

mysqld service is successfully running
```
$ systemctl status mysqld
● mysqld.service - MySQL Server
   Loaded: loaded (/usr/lib/systemd/system/mysqld.service; enabled; vendor preset: disabled)
   Active: active (running) since Sun 2020-11-22 11:02:27 UTC; 29min ago
     Docs: man:mysqld(8)
           http://dev.mysql.com/doc/refman/en/using-systemd.html
  Process: 1762 ExecStart=/usr/sbin/mysqld --daemonize --pid-file=/var/run/mysqld/mysqld.pid $MYSQLD_OPTS (code=exited, status=0/SUCCESS)
  Process: 1740 ExecStartPre=/usr/bin/mysqld_pre_systemd (code=exited, status=0/SUCCESS)
 Main PID: 1765 (mysqld)
   CGroup: /system.slice/mysqld.service
           └─1765 /usr/sbin/mysqld --daemonize --pid-file=/var/run/mysqld/mysqld.pid

Nov 22 11:02:26 ip-172-31-25-205.us-east-2.compute.internal systemd[1]: Stopped MySQL Server.
Nov 22 11:02:26 ip-172-31-25-205.us-east-2.compute.internal systemd[1]: Starting MySQL Server...
Nov 22 11:02:27 ip-172-31-25-205.us-east-2.compute.internal systemd[1]: Started MySQL Server.
```


## <a name="author">4. Author Information
Version | Name | Email | Date 
--------|------|-------|------
1.0 | Rakesh Korukonda | rakesh.korukonda2412@gamil.com | 22/11/2020 

