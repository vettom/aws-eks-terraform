
# Role allowing Karpenter to spin up nodes
data "aws_iam_policy_document" "karpenter_node_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_eks_access_entry" "this" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.karpenter_node_role.arn
  type          = "EC2_LINUX"
}

resource "aws_iam_role" "karpenter_node_role" {
  assume_role_policy = data.aws_iam_policy_document.karpenter_node_role_policy.json
  name               = "karpenter-node-eks-demo"
}

resource "aws_iam_role_policy_attachment" "karpenter_workernode" {
  role       = aws_iam_role.karpenter_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "karpenter_cni" {
  role       = aws_iam_role.karpenter_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "karpenter_ecr" {
  role       = aws_iam_role.karpenter_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "karpenter_ssm" {
  role       = aws_iam_role.karpenter_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "karpenter_instance_profile" {
  name = "karpenter-instance-profile-eks-demo"
  role = aws_iam_role.karpenter_node_role.name
}
