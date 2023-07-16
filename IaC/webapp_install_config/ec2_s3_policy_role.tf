#Create an IAM Policy
resource "aws_iam_policy" "demo_s3_policy" {
  name        = "tf_s3_Bucket_Access_Policy"
  description = "Provides permission to access S3"

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
  name = "tf_ec2_role_to_s3_bucket"

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
  name       = "tf_ec2_attachment"
  roles      = [aws_iam_role.demo_role.name]
  policy_arn = aws_iam_policy.demo_s3_policy.arn
}

### Instance profile creation
resource "aws_iam_instance_profile" "demo_profile" {
  name = "tf_ec2_s3_profile"
  role = aws_iam_role.demo_role.name
}
