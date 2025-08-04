resource "aws_security_group" "pods_sg" {
  name        = "eks-auto-secondary-pods-sg"
  description = "Security group for EKS Auto Pods using secondary IP address"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name               = "eks-auto-secondary-pods-sg"
    pod_security_group = "true"
    purpose            = "SG for Pods using secondary IP address"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "100.0.0.0/8"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "100.0.0.0/8"]
  }
  ingress {
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["100.0.0.0/8"]
  }
  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["100.0.0.0/8"]
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.pods_sg.id
  description       = "Allow all outbound traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
