resource "aws_security_group" "allow_tls" {
  name        = var.sg_name
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

dynamic ingress  {
    for_each = var.ingress
    content {
    description      = "TLS from VPC"
    from_port        = ingress.value.app_port
    to_port          = ingress.value.app_port
    protocol         = "tcp"
    cidr_blocks      = ingress.value.cidr_block
    }

}
  
  /*
  ingress {
    description      = "TLS from VPC"
    from_port        = var.app_port
    to_port          = var.app_port
    protocol         = "tcp"
    cidr_blocks      = var.cidr_block
  }
  */

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = local.tags
}

locals {
  tags = {
    Name = "allow_tls"
  }
}

output id {
    value = aws_security_group.allow_tls.id
}

output name {
    value = aws_security_group.allow_tls.name
}

