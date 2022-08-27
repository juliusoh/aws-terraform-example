locals {
  vpc = lookup(var.vpc, var.environment)
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-julius"
  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform-state-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
resource "aws_vpc" "vpc" {
  cidr_block           = local.vpc.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = var.environment
    Name        = "vpc-${var.environment}"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(local.vpc.public_cidr_blocks)
  availability_zone = element(local.vpc.availability_zones, count.index)
  cidr_block        = element(local.vpc.public_cidr_blocks, count.index)

  tags = {
    Environment = var.environment
    Name        = "public-subnet-${var.environment}-${element(local.vpc.availability_zones, count.index)}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Environment = var.environment
    Name        = "igw-${var.environment}"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Environment = var.environment
    Name        = "public-rt-${var.environment}"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}