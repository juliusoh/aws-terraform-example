terraform {
  backend "s3" {
    bucket         = "terraform-state-julius"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}