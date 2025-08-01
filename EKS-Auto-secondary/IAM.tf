
resource "aws_iam_role" "node" {
  name = "AmazonEKSAutoNodeRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sts:TagSession", "sts:AssumeRole"]
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodeMinimalPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodeMinimalPolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryPullOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
  role       = aws_iam_role.node.name
}

resource "aws_eks_access_entry" "eks_auto_node" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.node.arn
  type          = "EC2"
}

resource "aws_eks_access_policy_association" "eks_auto_node_policy" {
  cluster_name  = module.eks.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAutoNodePolicy"
  principal_arn = aws_iam_role.node.arn
  access_scope {
    type = "cluster"
  }
}
