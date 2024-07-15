terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.57.0"
    }
  }
     backend "s3" {
       bucket = "raja-peta-cloud" #bucket name it should be crated maually before
        key    = "raja-eks-module-eks"
        region = "us-east-1"
        dynamodb_table = "SG-locking" #locking
  } 
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}