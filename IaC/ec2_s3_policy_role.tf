## Create an IAM Policy

resource "aws_iam_policy" "demo_s3_policy" {
  name        = "Ondot-S3-Bucket-Access-Policy"
  description = "Provides permission to access S3"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::gitops-demo-bucket-tf"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject"
        ],
        "Resource" : [
          "arn:aws:s3:::gitops-demo-bucket-tf/*"
        ]
      }
    ]
  })
}

#Create an IAM Role

resource "aws_iam_role" "demo_role" {
  name = "ondot_ec2_role_to_s3_bucket"

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

resource "aws_iam_policy_attachment" "demo_attach" {
  name       = "ec2-attachment"
  roles      = [aws_iam_role.demo_role.name]
  policy_arn = aws_iam_policy.demo_s3_policy.arn
}

### Instance profile creation

resource "aws_iam_instance_profile" "demo_profile" {
  name = "ec2_s3_profile"
  role = aws_iam_role.demo_role.name
}
