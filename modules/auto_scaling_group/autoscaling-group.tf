

data "aws_subnet" "example1" {
  vpc_id = var.my_vpc
  availability_zone = "us-east-1a"
}

data "aws_subnet" "example2" {
  vpc_id = var.my_vpc
  availability_zone = "us-east-1b"
}


resource "aws_autoscaling_group" "bar" {
  name                      = var.auto-scaling-group-name
  max_size                  = var.max-size
  min_size                  = var.min-size
  health_check_grace_period = 300
##  health_check_type         = "ELB"
  desired_capacity          = 4
  force_delete              = true
 ## placement_group           = aws_placement_group.test.id
 ## launch_configuration      = aws_launch_template.my-auto-scaling-template.name
  vpc_zone_identifier       = [data.aws_subnet.example1.id, data.aws_subnet.example2.id]
  launch_template {
    id = aws_launch_template.my-auto-scaling-template.id
    version = aws_launch_template.my-auto-scaling-template.latest_version
  }



  tag {
    key                 = "name"
    value               = "my-auto-scaling-group"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "lorem"
    value               = "ipsum"
    propagate_at_launch = false
  }
}