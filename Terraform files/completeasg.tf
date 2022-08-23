
data "aws_ami" "packer-ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["packer-ami-20220817161845"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["648746753468"] # Canonical
}

resource "aws_security_group" "sg-for-lb" {
  name = "final-project-lb"
  description = "security group for alb"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg-for-lb"
  }
}

resource "aws_launch_configuration" "final-project" {
  name_prefix     = "final-project-lc"
  image_id        = data.aws_ami.packer-ami.id
  instance_type   = "t2.micro"
  #user_data       = file("user-data.sh")      #what is this?
  security_groups = [aws_security_group.final-project-sg.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "final-project" {
  name = "final-project-asg"
  min_size             = 2
  max_size             = 5
  desired_capacity     = 2
  health_check_grace_period = 300
  health_check_type = "EC2"
  launch_configuration = aws_launch_configuration.final-project.name
  vpc_zone_identifier  = [aws_subnet.public_subnet.id]
}

resource "aws_autoscaling_attachment" "final-project" {
  autoscaling_group_name = aws_autoscaling_group.final-project.id
  lb_target_group_arn   = aws_lb_target_group.final-project-tg.arn
}

resource "aws_subnet" "lb_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.lb_subnet1
  map_public_ip_on_launch = "true" 
  availability_zone = var.AZ-1

}

resource "aws_lb" "final-project-alb" {
  name               = "asg-final-project-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.sg-for-lb.id}"]
  #subnets            = aws_subnet.lb_subnet.*.id
  subnet_mapping {
    subnet_id     = aws_subnet.lb_subnet.id
  }
  subnet_mapping {
    subnet_id     = aws_subnet.public_subnet.id
  }

}

resource "aws_lb_target_group" "final-project-tg" {
  name     = "final-project-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "final-project" {
  load_balancer_arn = aws_lb.final-project-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.final-project-tg.arn
  }
}




