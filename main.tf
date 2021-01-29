terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 2.70"
        }
    }
}

provider "aws" {
    profile = "default"
    region  = "eu-west-1"
}

/*
 * Create the keypair which will be used to connect to the EC2 instance
 */
resource "aws_key_pair" "keypair" {
    key_name    = var.keypair_name
    public_key  = var.public_key
}

/*
 * Create Subnet 1 AWS instances
 */
resource "aws_instance" "server1" {
    count               = 1
    ami                 = "ami-0aef57767f5404a3c" // Ubuntu 20.04
    instance_type       = "t2.micro"
    key_name            = var.keypair_name

    // Execute `apt update` and install nginx.
    provisioner "remote-exec" {
        inline = [
            "sudo apt update",
            "sudo apt install nginx -y",
        ]
    }

    connection {
        type        = "ssh"
        user        = "ubuntu"
        private_key = file(var.private_key)
        host        = self.public_ip
    }

    tags = {
        Name = "Server1"
    }
}