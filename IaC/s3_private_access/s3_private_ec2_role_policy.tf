#Create an IAM Policy
resource "aws_iam_policy" "s3_private_bucket_policy" {
  name        = "s3_private_bucket_access_policy"
  description = "Accessing S3 bucket from an ec2 which doesn't have an internet connection"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        "Resource" : [
          "arn:aws:s3:::*",
          "arn:aws:s3:::gitops-demo-bucket-tf"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "arn:aws:s3:::*",
          "arn:aws:s3:::gitops-demo-bucket-tf/*"
        ]
      }
    ]
  })
}

#Create an IAM Role
resource "aws_iam_role" "demo_role" {
  name = "s3_bucket_private_access_ec2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "RoleForEC2"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

### Policy attachment
resource "aws_iam_policy_attachment" "s3_ec2_bucket_attach" {
  name       = "s3_bucket_ec2_private_access"
  roles      = [aws_iam_role.demo_role.name]
  policy_arn = aws_iam_policy.s3_private_bucket_policy.arn
}

### Instance profile creation
resource "aws_iam_instance_profile" "demo_profile" {
  name = "tf_ec2_s3_profile"
  role = aws_iam_role.demo_role.name
}
