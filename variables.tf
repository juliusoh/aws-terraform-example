variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "aws_profile" {
  description = "AWS Profile"
  default     = "julius-tf-practice"
  type        = string
}

variable "environment" {
  default = "development"
  type    = string
}

variable "vpc" {
  default = {
    development = {
      cidr_block         = "10.123.0.0/16"
      availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
      public_cidr_blocks = ["10.123.1.0/24", "10.123.2.0/24", "10.123.3.0/24"]
    }
  }
}