packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "packer-ami" {
    ami_name = "packer-ami-${local.timestamp}"
    source_ami_filter {
      filters = {
       name                = "amzn2-ami-kernel-5.10-hvm-2.*.0-x86_64-gp2"
       root-device-type    = "ebs"
       virtualization-type = "hvm"
      }
      most_recent = true
      owners      = ["137112412989"]
  } 
    instance_type = "t2.micro"
    region = "us-east-1"
    ssh_username  = "ec2-user"

}

build {
    sources = [
        "source.amazon-ebs.packer-ami"
    ]

    provisioner "file" {
        source = "../demo-project/exchange-22a-ubuntu.zip"
        destination = "/home/ec2-user/exchange-22a-ubuntu.zip"
    }
   
    provisioner "file" {
        source = "../demo-project/api.service"
        destination = "/tmp/api.service"
    }
   
    provisioner "shell" {
        script = "./api.sh"

    }
    
   
}

