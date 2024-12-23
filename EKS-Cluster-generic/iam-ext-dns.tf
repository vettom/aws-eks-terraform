resource "aws_iam_role" "externaldns_iam_role" {
  name               = "external-dns-controller"
  assume_role_policy = data.aws_iam_policy_document.podidentity.json
}

resource "aws_eks_pod_identity_association" "externaldns" {
  cluster_name    = module.eks.cluster_name
  namespace       = "external-dns"
  service_account = "external-dns-controller"
  role_arn        = aws_iam_role.externaldns_iam_role.arn
}

resource "aws_iam_policy" "external_dns_iam_policy" {
  name = "ExternalDNSControllerIAMPolicy"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "route53:ChangeResourceRecordSets"
          ],
          "Resource" : [
            "arn:aws:route53:::hostedzone/*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "route53:ListHostedZones",
            "route53:ListResourceRecordSets"
          ],
          "Resource" : [
            "*"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "externaldns_policy_attachement" {
  role       = aws_iam_role.externaldns_iam_role.name
  policy_arn = aws_iam_policy.external_dns_iam_policy.arn
}