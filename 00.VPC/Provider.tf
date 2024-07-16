terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.50.0"
    }
  }
     backend "s3" {
       bucket = "raja-peta-cloud" #bucket name it should be crated maually before
        key    = "raja-eks-module-vpc"
        region = "us-east-1"
        dynamodb_table = "vpc-locking" #locking
  } 
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}