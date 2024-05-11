

resource "aws_launch_template" "launch_template" {
  name_prefix   = var.launch_template_name_prefix
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data              = filebase64("${path.module}/setupAgent.sh")
  vpc_security_group_ids = [var.security_group_id]
  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_autoscaling_group" "asg" {
  name              = var.asg_name
  desired_capacity  = var.desired_capacity
  max_size          = var.max_size
  min_size          = var.min_size
  health_check_type = var.health_check_type

  vpc_zone_identifier = var.private_subnets
  depends_on          = [aws_launch_template.launch_template]
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
}


resource "aws_instance" "jumb-server" {
  
  ami                    = var.jumb_server_ami_id
  instance_type          = var.jumb_server_instance_type
  iam_instance_profile   = var.ec2_instance_profile
  subnet_id              = var.jumb_server_subnet_id
  vpc_security_group_ids = [var.security_group_id]
  tags = {
    Name = "${var.jumb_server_name}"
  }
} 


