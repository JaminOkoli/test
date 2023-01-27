# resource "aws_default_subnet" "metabase_subnet_a" {
#   availability_zone = "us-east-1a"
# }

# resource "aws_default_subnet" "metabase_subnet_b" {
#   availability_zone = "us-east-1b"
# }

# resource "aws_default_subnet" "metabase_subnet_c" {
#   availability_zone = "us-east-1c"
# }

resource "aws_subnet" "metabase_subnet_a" {
  vpc_id                  = aws_vpc.metabase_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "metabase_subnet_b" {
  vpc_id                  = aws_vpc.metabase_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}
