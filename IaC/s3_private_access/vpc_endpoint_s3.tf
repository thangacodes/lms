### VPC endpoint for S3 gateway #####
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.s3_testing.id
  service_name = "com.amazonaws.ap-south-1.s3"
}

#### Associate route table with VPC endpoint
resource "aws_vpc_endpoint_route_table_association" "rt_association" {
  route_table_id  = aws_route_table.Private_RT.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}
