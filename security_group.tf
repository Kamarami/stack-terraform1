# resource "aws_security_group" "lb-sg" {
#   vpc_id            = aws_vpc.clixxvpc.id
#   name              = "loadbalancer-sg"
#   description       = "Load balancer security group"
# }
# #HTTP rule for load balancer
# resource "aws_security_group_rule" "lb-http" {
#   security_group_id = aws_security_group.lb-sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 80
#   to_port           = 80
#   cidr_blocks       = ["0.0.0.0/0"]
# }
# #HTTPS rule for load balancer
# resource "aws_security_group_rule" "lb-https" {
#   security_group_id = aws_security_group.lb-sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 443
#   to_port           = 443
#   cidr_blocks       = ["0.0.0.0/0"]
# }
# #Outbound rule for load balancer
# resource "aws_security_group_rule" "lb-egress-rule" {
#   security_group_id = aws_security_group.lb-sg.id
#   type              = "egress"
#   protocol          = "-1"
#   from_port         = 0
#   to_port           = 0
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# #Launch template security group
# resource "aws_security_group" "lt-sg" {
#   vpc_id            = aws_vpc.clixxvpc.id
#   name              = "launch-template-sg"
#   description       = "Launch template security group"
# }

# resource "aws_security_group_rule" "lt-ssh" {
#   security_group_id = aws_security_group.lt-sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 22
#   to_port           = 22
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "lt-http" {
#   security_group_id = aws_security_group.lt-sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 80
#   to_port           = 80
#   source_security_group_id = aws_security_group.lb-sg.id
#   # cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "lt-https" {
#   security_group_id = aws_security_group.lt-sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 443
#   to_port           = 443
#   source_security_group_id = aws_security_group.lb-sg.id
#   # cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "ltegress-rule" {
#   security_group_id = aws_security_group.lt-sg.id
#   type              = "egress"
#   protocol          = "-1"
#   from_port         = 0
#   to_port           = 0
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# #EFS security group

# resource "aws_security_group" "efs-sg" {
#   vpc_id            = aws_vpc.clixxvpc.id
#   name              = "efs-sg"
#   description       = "EFS security group"
# }

# resource "aws_security_group_rule" "efs-nfs" {
#   security_group_id = aws_security_group.efs-sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 2049
#   to_port           = 2049
#   source_security_group_id = aws_security_group.lt-sg.id
#   # cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "efs-egress-rule" {
#   security_group_id = aws_security_group.efs-sg.id
#   type              = "egress"
#   protocol          = "-1"
#   from_port         = 0
#   to_port           = 0
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# #Bastion server security group
# resource "aws_security_group" "bastion-sg" {
#   vpc_id            = aws_vpc.clixxvpc.id
#   name              = "bastion-sg"
#   description       = "Bastion server security group"
# }

# resource "aws_security_group_rule" "bastion-ssh" {
#   security_group_id = aws_security_group.bastion-sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 22
#   to_port           = 22
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "bastion-http" {
#   security_group_id = aws_security_group.bastion-sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 80
#   to_port           = 80
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "bastion-https" {
#   security_group_id = aws_security_group.bastion-sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 443
#   to_port           = 443
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "bastion-egress-rule" {
#   security_group_id = aws_security_group.bastion-sg.id
#   type              = "egress"
#   protocol          = "-1"
#   from_port         = 0
#   to_port           = 0
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# #Security group for RDS
# resource "aws_security_group" "rds-sg" {
#   vpc_id            = aws_vpc.clixxvpc.id
#   name              = "rds-sg"
#   description       = "RDS security group"
# }

# resource "aws_security_group_rule" "rds-oracle" {
#   security_group_id = aws_security_group.rds-sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 1506
#   to_port           = 1506
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "rds-lt-mysql" {
#   security_group_id = aws_security_group.rds-sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 3306
#   to_port           = 3306
#   source_security_group_id = aws_security_group.lt-sg.id
#   # cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "rds-bastion-mysql" {
#   security_group_id = aws_security_group.rds-sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 3306
#   to_port           = 3306
#   source_security_group_id = aws_security_group.bastion-sg.id
#   # cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "rds-egress-rule" {
#   security_group_id = aws_security_group.bastion-sg.id
#   type              = "egress"
#   protocol          = "-1"
#   from_port         = 0
#   to_port           = 0
#   cidr_blocks       = ["0.0.0.0/0"]
# }





#Load Balancer security group


resource "aws_security_group" "lb-sg" {
  vpc_id      = aws_vpc.clixxvpc.id
  name        = "loadbalancer-sg"
  description = "Load Balancer Security Group"
}

resource "aws_security_group_rule" "lb-http-rule" {
  security_group_id = aws_security_group.lb-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "lb-http-tcp-rule" {
  security_group_id = aws_security_group.lb-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8080
  to_port           = 8080
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "lb-https-rule" {
  security_group_id = aws_security_group.lb-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "lb-egress-rule" {
  security_group_id = aws_security_group.lb-sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}
##################################################################

#Launch Template security group

resource "aws_security_group" "lt-sg" {
  vpc_id      = aws_vpc.clixxvpc.id
  name        = "launchtemplate-sg"
  description = "Launch Template Security Group"
}

resource "aws_security_group_rule" "lt-ssh-rule" {
  security_group_id = aws_security_group.lt-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  # cidr_blocks       = ["0.0.0.0/0"]
  source_security_group_id = aws_security_group.bastion-sg.id

}

resource "aws_security_group_rule" "lt-http-rule" {
  security_group_id = aws_security_group.lt-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80

  source_security_group_id = aws_security_group.lb-sg.id
}

resource "aws_security_group_rule" "lt-http-tcp-rule" {
  security_group_id = aws_security_group.lt-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8080
  to_port           = 8080

  source_security_group_id = aws_security_group.lb-sg.id
}

resource "aws_security_group_rule" "lt-https-rule" {
  security_group_id        = aws_security_group.lt-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  source_security_group_id = aws_security_group.lb-sg.id
}

resource "aws_security_group_rule" "lt-nfs-rule" {
  security_group_id        = aws_security_group.lt-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 2049
  to_port                  = 2049
  source_security_group_id = aws_security_group.efs-sg.id
}

resource "aws_security_group_rule" "lt-rds-rule" {
  security_group_id = aws_security_group.lt-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3306
  to_port           = 3306

  source_security_group_id = aws_security_group.lb-sg.id
}

resource "aws_security_group_rule" "lt-egress-rule" {
  security_group_id = aws_security_group.lt-sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}


##################################################################
#EFS security group

resource "aws_security_group" "efs-sg" {
  vpc_id      = aws_vpc.clixxvpc.id
  name        = "EFS-sg"
  description = "EFS Security Group"
}

resource "aws_security_group_rule" "efs-nfs-rule" {
  security_group_id        = aws_security_group.efs-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 2049
  to_port                  = 2049
  source_security_group_id = aws_security_group.lt-sg.id
}

resource "aws_security_group_rule" "efs-egress-rule" {
  security_group_id = aws_security_group.efs-sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

###################################################################
#Bastion Server security group
resource "aws_security_group" "bastion-sg" {
  vpc_id      = aws_vpc.clixxvpc.id
  name        = "bastion-sg"
  description = "Bastion server Security Group"
}

resource "aws_security_group_rule" "bastion-http-rule" {
  security_group_id = aws_security_group.bastion-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "bastion-https-rule" {
  security_group_id = aws_security_group.bastion-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "bastion-ssh-rule" {
  security_group_id = aws_security_group.bastion-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]

}


resource "aws_security_group_rule" "bastion-egress-rule" {
  security_group_id = aws_security_group.bastion-sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

#############################################################

#RDS Security Group
resource "aws_security_group" "rds-sg" {
  vpc_id      = aws_vpc.clixxvpc.id
  name        = "RDS-sg"
  description = "RDS Security Group"
}

resource "aws_security_group_rule" "lt-mysql-rule" {
  security_group_id        = aws_security_group.rds-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.lt-sg.id
}

resource "aws_security_group_rule" "bastion-mysql-rule" {
  security_group_id        = aws_security_group.rds-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.bastion-sg.id
}

resource "aws_security_group_rule" "rds-egress-rule" {
  security_group_id = aws_security_group.rds-sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}