
 variable "main_vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
 }

 variable "packer_ami_web" {
  type  = string
  default = "ami-050980230e7900e52"  # this is packer ami
 }

  variable "packer_ami_api" {
  type  = string
  default = "ami-050980230e7900e52"  # this is packer ami
 }

 variable "name" {
  type  = string
  description = "exchange-app-vpc"
 }
 
 variable "sg_name" {
  type  = string
  description = "final-project-sg"
 }

 variable "ec2-name-1" {
  type  = string
  description = "exchange-app-web"
 }

 variable "ec2-name-" {
  type  = string
  description = "exchange-app-api"
 }

 variable "IGW_name" {
  type = string
  description = "final-project-igw"
 }

 variable "project-route-table" {
  description = "final-project-rt"
 }
 
 variable "public_subnet" {
  description  = "final-project-subnet"
  type         = string
  default      = "10.0.21.0/24"
 }

  variable "lb_subnet" {
  description  = "final-project-subnet"
  type         = list(string)
  default      = ["10.20.0.0/24", "10.0.23.0/24"]
 }

  variable "lb_subnet1" {
  description  = "final-project-subnet"
  type         = string
  default      = "10.0.23.0/24"
 }

  variable "lb_subnet2" {
  description  = "final-project-subnet"
  type         = string
  default      = "10.20.0.0/24"
 }


variable "instance_type" {
    type  = string
    description = "EC2 instance type"
    default = "t2.micro"
}

variable "multi-az-public" {
    description = "az-for-public"
    type        = list(string)
    default     = ["us-east-1a", "us-east-1b"]
}

variable "AZ-1" {
    description = "availability-zone-1"
    type = string
    default = "us-east-1a"
}

variable "AZ-2" {
    description = "availability-zone-2"
    type = string
    default = "us-east-1b"
}
