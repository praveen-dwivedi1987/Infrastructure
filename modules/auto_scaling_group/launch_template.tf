resource "aws_key_pair" "my-ssh-key" {
  key_name   = "my-ssh-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC5eTeRvsXyCyEjiij4KLvSOqp52JduEmgtaa4COJ0XeSayQoR8bQO/BWO6fBhVe2qshogEJ2LgL/LTxJ7sP8xBMyQX0iC2eKHcZLU119AlbAMHXtX8GH1FJ6GPfOSos+WfNjrjl/fRTvvSdmSZByIp3UX7MS3KWP2jpixAooPfVz5wyIZF8sxAYDxNzjjZISaJprk8iXpq0Co3BH6o10Dzh/7LpWOZee4HGPCkeSJHau3YWIWCgqw+U8JkzmFysA8r98bQA2aK38MLgjqn9+Fm4FEoi1OSyp+LkErbO4w+3a8I4GRNDnBP4rC3IZ68c9epme1J2BZBDStE38NhZf4VLvnd2tpJ3+8lnObfcC/QFATI8GWC6R/66Okxw/H9CHohyMcCB4kz0h1tXEtvqcDde7iQUrPSTuA9ANXkVTwCqYpEUBZnjbGhpPfuy+myEqqGI8kIPqKWs0OLb4Ny/q8e51775qPfOx+nfD6XYh6Z88Xz7ESsoTKvy9AuYuyJadE= praveen@EPINGUGW00C4"
}

resource "aws_launch_template" "my-auto-scaling-template" {
  name = var.auto-scaling-template-name

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  
  disable_api_stop        = true
  disable_api_termination = true

  ##ebs_optimized = true


  image_id = var.image-id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = var.instance-type

  key_name = aws_key_pair.my-ssh-key.key_name

  vpc_security_group_ids = [var.sg-id]

  
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
  }



  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test"
    }
  }

  user_data = filebase64("${path.module}/setup.sh")
}