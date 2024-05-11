data "tls_certificate" "eks" {

  url = var.tls_certificate_eks
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = var.tls_certificate_eks

}


# create oidc role for eks
data "aws_iam_policy_document" "s3_oidc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = [
        "system:serviceaccount:default:s3connector" ,
        
        ]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}


resource "aws_iam_role" "s3_oidc" {
  assume_role_policy = data.aws_iam_policy_document.s3_oidc_assume_role_policy.json
  name               = "test-oidc"
}

resource "aws_iam_policy" "s3Policy" {

  name = "s3Policy"
  lifecycle {
    
  }
  policy = jsonencode({
    Statement = [{
      Action = [
        "s3:ListAllMyBuckets",
        "s3:GetBucketLocation"
      ]
      Effect   = "Allow"
      Resource = "arn:aws:s3:::*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "test_attach" {

  role       = aws_iam_role.s3_oidc.name
  policy_arn = aws_iam_policy.s3Policy.arn
}


