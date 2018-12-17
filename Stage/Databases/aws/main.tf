 provider "aws" {
 region = "eu-west-3"
}

resource "aws_db_instance" "myslq_aws" {
	engine 				= "mysql"
	allocated_storage 	= 10
	instance_class		= "db.t2.micro"
	username			= "admin"
	password			= "${var.db_password}"
  skip_final_snapshot       = true

}

terraform {
  backend "s3" {
    bucket = "terraform-bucket-state-staging-cpo"
    key = "Stage/Databases/aws/terraform.tf.state"
    region = "eu-west-3"
    encrypt = "true"
  }
}




