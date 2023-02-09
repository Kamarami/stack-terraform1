# locals {
# clixx_creds = jsondecode(
# data.aws_secretsmanager_secret_version.clixxcreds.secret_string
# )
# }

#Keypair for access
resource "aws_key_pair" "private_keypair" {
  key_name   = "private_keypair.pub"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

# #Create Bastion server
# resource "aws_instance" "clixx-bastion" {
#    ami                         = var.ami
#    instance_type               = var.instance_type
#    vpc_security_group_ids      = [aws_security_group.bastion-sg.id]
#    subnet_id                   = [aws_subnet.pubsub1.id, aws_subnet.pubsub2.id]
#    user_data                   = data.template_file.bootstrap.rendered
#    key_name                    = aws_key_pair.private_keypair.key_name
#    root_block_device {
#      volume_type               = "gp2"
#      volume_size               = 20
#      delete_on_termination     = true
#      encrypted= "false"
#    }
#    tags                        = {
#    Name                        = "clixx-bastion"
#    Backup                      = "Yes"
#    OwnerEmail                  = "mohamedxkamara@gmail.com"
#    Schedule                    = "A"
#    Stackteam                   = "stackcloud9"
#  }
# }

#Create Bastion server launch template
resource "aws_launch_template" "clixx-bastion-lt" {
  name          = "clixx-bastion-lt"
  image_id      = local.wp_creds.ami
  instance_type = "t2.micro"
  key_name      = aws_key_pair.private_keypair.key_name

  network_interfaces {
    associate_public_ip_address = true
    device_index                = 0
    security_groups             = [aws_security_group.bastion-sg.id]
  }

  tags = {
    Name       = "clixx-bastion"
    OwnerEmail = "mohamedxkamara@gmail.com"
    StackTeam  = "Stackcloud9"
    Schedule   = "A"
    Backup     = "Yes"
  }
}

#Create Bastion server Autoscaling Group
resource "aws_autoscaling_group" "clixx-bastion-asg" {
  name                      = "clixx-bastion"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "EC2"
  desired_capacity          = 1
  launch_template {
    name    = aws_launch_template.clixx-bastion-lt.name
    version = "$Latest"
  }
  vpc_zone_identifier = [aws_subnet.pubsub1.id, aws_subnet.pubsub2.id]

  tag {
    key                 = "Name"
    value               = "clixx-bastion"
    propagate_at_launch = true
  }
}

#Wake up copy of Clixx Database Snapshot
resource "aws_db_instance" "wpclixxdatabasemohamed" {
  instance_class         = "db.t3.micro"
  skip_final_snapshot    = true
  identifier             = var.rdsname
  snapshot_identifier    = "wpclixxdatabasemohamed"
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.clixx-subnets.name
}

resource "aws_db_subnet_group" "clixx-subnets" {
  name       = "clixx-rds-subnet"
  subnet_ids = [aws_subnet.privsub3.id, aws_subnet.privsub4.id]

  tags = {
    Name = "RDS subnet group"
  }
}

#Create load balancer 
resource "aws_lb" "clixx-lb" {
  name               = "clixx-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
  //FOR EACH FOR THIS LIST
  subnets = [aws_subnet.pubsub1.id, aws_subnet.pubsub2.id]
}

#Create launch template
resource "aws_launch_template" "clixx-lt1" {
  name = "clixx-lt1"
  // CREATE A LIST AND USE FOR EACH TO LOOP THROUGH AND CREATE THESE
  block_device_mappings {
    device_name = "/dev/sdb"
    ebs {
      volume_size = 8
    }
  }
  block_device_mappings {
    device_name = "/dev/sdc"
    ebs {
      volume_size = 8
    }
  }
  block_device_mappings {
    device_name = "/dev/sdd"
    ebs {
      volume_size = 8
    }
  }
  block_device_mappings {
    device_name = "/dev/sde"
    ebs {
      volume_size = 8
    }
  }
  block_device_mappings {
    device_name = "/dev/sdf"
    ebs {
      volume_size = 8
    }
  }

  credit_specification {
    cpu_credits = "standard"
  }

  image_id = local.wp_creds.ami

  instance_type = "t2.micro"

  key_name = aws_key_pair.private_keypair.key_name

  vpc_security_group_ids = [aws_security_group.lt-sg.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name       = "stackinst"
      OwnerEmail = "mohamedxkamara@gmail.com"
      Backup     = "yes"
      Schedule   = "A"
      Stackteam  = "stackcloud9"
    }
  }

  user_data = base64encode(data.clixx_bootstrap.rendered)
}

#Create target group
resource "aws_lb_target_group" "clixx-tg" {
  name     = "stack-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.clixxvpc.id
}

#Create EFS
resource "aws_efs_file_system" "clixxefs" {
  creation_token   = "my-efs"
  performance_mode = "generalPurpose"

  tags = {
    Name       = "clixxefs"
    OwnerEmail = "mohamedxkamara@gmail.com"
    Backup     = "Yes"
    Schedule   = "A"
    Stackteam  = "stackcloud9"
  }
}

#Create EFS mount targets
resource "aws_efs_mount_target" "clixx-efs-mount-target1" {
  //CHANGE THIS TO FOR EACH
  # count           = length(var.subnets)
  file_system_id  = aws_efs_file_system.clixxefs.id
  subnet_id       = aws_subnet.privsub1.id
  security_groups = [aws_security_group.efs-sg.id]
}

resource "aws_efs_mount_target" "clixx-efs-mount-target2" {
  //CHANGE THIS TO FOR EACH
  # count           = length(var.subnets)
  file_system_id  = aws_efs_file_system.clixxefs.id
  subnet_id       = aws_subnet.privsub2.id
  security_groups = [aws_security_group.efs-sg.id]
}

#Create Autoscaling group
resource "aws_autoscaling_group" "clixxasg1" {
  name                      = "clixxasg1_dev"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "EC2"
  desired_capacity          = 1
  launch_template {
    name    = aws_launch_template.clixx-lt1.name
    version = "$Latest"
  }
  vpc_zone_identifier = [aws_subnet.privsub1.id, aws_subnet.privsub2.id]

  tag {
    key                 = "Name"
    value               = "clixxasg1_dev"
    propagate_at_launch = true
  }
}

#Scale-out policy
resource "aws_autoscaling_policy" "cpu-policy-scale-out" {
  name                   = "cpu-policy-scale-out"
  autoscaling_group_name = aws_autoscaling_group.clixxasg1.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "30"
  policy_type            = "SimpleScaling"
}

#Scale-out alarm
resource "aws_cloudwatch_metric_alarm" "cpu-alarm-scale-out" {
  alarm_name          = "cpu-alarm-scale-out"
  alarm_description   = "cpu-alarm-scale-out"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "50"
  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.clixxasg1.name}"
  }
  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.cpu-policy-scale-out.arn}"]
}

#Scale-in policy
resource "aws_autoscaling_policy" "cpu-policy-scale-in" {
  name                   = "cpu-policy-scale-in"
  autoscaling_group_name = aws_autoscaling_group.clixxasg1.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "30"
  policy_type            = "SimpleScaling"
}

#Scale-in alarm
resource "aws_cloudwatch_metric_alarm" "cpu-alarm-scale-in" {
  alarm_name          = "cpu-alarm-scale-in"
  alarm_description   = "cpu-alarm-scale-in"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "5"
  dimensions = {
    "AutoScalingGroupname" = "${aws_autoscaling_group.clixxasg1.name}"
  }
  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.cpu-policy-scale-in.arn}"]
}

#Add load balancer listeners 
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.clixx-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.clixx-tg.arn
  }
}

#Create Application Load Balancer Target Group attachment
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.clixxasg1.id
  lb_target_group_arn    = aws_lb_target_group.clixx-tg.arn
}