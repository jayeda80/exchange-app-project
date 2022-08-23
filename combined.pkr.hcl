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

source "amazon-ebs" "packer-ami-web" {
    ami_name = "packer-ami-web${local.timestamp}"
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
    name = "packer-ami-web"
    sources = [
        "source.amazon-ebs.packer-ami-web"
    ]

    provisioner "file" {
        source = "../web/exchange-22a-ubuntu.zip"
        destination = "/home/ec2-user/exchange-22a-ubuntu.zip"
    }

 provisioner "file" {
        source = "../web/web.service"
        destination = "/tmp/web.service"
    }

    provisioner "shell" {
        script = "./web.sh"

    }

source "amazon-ebs" "packer-ami-api" {
    ami_name = "packer-ami-api${local.timestamp}"
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
    name = "packer-ami-api"
    sources = [
        "source.amazon-ebs.packer-ami-api"
    ]

    provisioner "file" {
        source = "../api/exchange-22a-ubuntu.zip"
        destination = "/home/ec2-user/exchange-22a-ubuntu.zip"
    }
   
    provisioner "file" {
        source = "../api/api.service"
        destination = "/tmp/api.service"
    }
   
    provisioner "shell" {
        script = "./api.sh"

    }
    
   
}
