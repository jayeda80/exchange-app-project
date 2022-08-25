# exchange-app-project

Automate deployment of Exchange app to EC2 hosts (Packer)

Purpose
•	Create deployment package to deploy Exchange app to EC2 backed hosts via Packer & Terraform
Must contain the following:
•	Must use Terraform for infrastructure setup and Packer for AMI creation using best practices
•	Must be fully deployed from the package (including autoscaling groups, security groups, appropriate rules, ELB, IAM roles as necessary)
Deliverables:
•	The exchange app is available via the Internet and responds appropriately
•	README with deployment architecture and configuration/installation instructions

Terraform - create infrastructure - contains instrastructre.tf,  variables.tvar, variables,tf, and ASG.tf
•	Created 1 VPC
•	Created 2 EC2, one for web and one for api using Packer image (both separate images)
•	Created ELB and ASG 
•	Created SG with relevant inbound rules (port 3000)
•	Created public subnet

Packer :
Packer is an open source tool allows you to creates machine images from a single source configuration and can run on many different platforms and operating systems.
Packer template: 
File with HCL or in json format. Packer understands to use either formats.  HCL is often used by Hashicorp made mostly of block and arguments.
Packer takes this code and builds custom AMI.  It uses packer {} blocks.  
•	Packer block: This block is where we specify the settings we want Packer to use.  In this case, AWS.  
•	Source block: Here, we specify which ami to use as the base and where to save the ami. Example:  Amazon Linux or Ubuntu.
•	Build block: Instructions on what/how to install, configuration, files to copy, etc.  This is where we will have instructions for shell scripts. It can be directly placed as arguments or instructions to use shell script. 
You can also create parallel builds by adding sources under same build.  You can create very similar but different AMIs. 
The issue with applications are once you exit out of applications, it will stop running.  As a result, websites may not work.  Therefore a daemon must be created so that it is always running despite exiting out of applications.
Create a separate service file with instructions placed in bash script.  Required field is the ExecStart command which instructs where to run application.  This service file should be placed in /etc/systemd/system/.service since this is where it will look for system files. 
STEPS TO BUILD IMAGE: 
Install packer :  https://learn.hashicorp.com/tutorials/packer/get-started-install-cli?in=packer/aws-get-started
packer init .
packer build <filename.pkr.hcl>  or <filename.json>

Issues/Troubleshooting
•	Using the Amazon documentation for Nodejs causes an error.  Instead of downloading files to usr/bin/node. It downloaded files under .nvm.  As a result daemon ailed to run.  
•	Although the files were downloaded successfuly and nodejs would start, I had issues with connection between api and web.
