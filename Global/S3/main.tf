provider "aws" {
	region = "eu-west-3"
}

resource "aws_s3_bucket" "terraform_state" {
	bucket = "terraform-bucket-state-staging-cpo"
	
	versioning {
	enabled = true
	}

}

terraform {
  backend "s3" {
    bucket = "terraform-bucket-state-staging-cpo"
    key = "global/s3/terraform.tfstate"
    region = "eu-west-3"
    encrypt = "true"
  }
}

