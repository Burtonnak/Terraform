 
 provider "aws" {
 region = "eu-west-3"
}
output "elb_dns_name" {
	value = "${aws_elb.example.dns_name}"
	}

data "aws_availability_zones" "all" {}

#Simple Definition Resources with some package and a started apache

#resource "aws_instance" "Test" {
#	
#	instance_type 			= "t2.micro"
#	availability_zone 		= "eu-west-3a"
#	ami 					= "ami-5026902d"
#	key_name 				= "Sillage-Test"
#	vpc_security_group_ids 	= ["${aws_security_group.WEBSGTR.id}"]	
#
#	user_data = <<-EOF
#		#!/bin/bash
#		sudo yum -y install httpd strace sysstat mlocate
#		sudo echo "Hello Auriel, Alexiel and Lisa..." >> /var/www/html/index.html
#		sudo apachectl start
#		sudo yum -y update
#		sudo updatedb
#		EOF
#
#	
#	tags {
#		Name = "Terraform-Test	"
#	}	
#
#}


#Define an elactis Load Balancer AWS
resource "aws_elb" "example" {
	name 				= "terraform-elb-example"
	availability_zones 	= ["${data.aws_availability_zones.all.names}"]
	security_groups = ["${aws_security_group.WEBSGTR.id}"]	

	listener {
		lb_port				= "${var.HTTP_PORT}"
		lb_protocol			= "HTTP"
		instance_port 		= "${var.HTTP_PORT}"
		instance_protocol 	= "HTTP"
	}

	health_check {

		healthy_threshold	= 2
		unhealthy_threshold	= 2
		timeout				= 3
		interval 			= 30
		target				= "HTTP:${var.HTTP_PORT}/"			
	}


}


#Simple Elastic Cluster based on the simple server
resource "aws_launch_configuration" "Test_ASG" {

	name 			= "Redhat_7.5-test-launch-config"
	instance_type 	= "t2.micro"
	image_id 		= "ami-5026902d"
	key_name 		= "Sillage-Test"
	security_groups = ["${aws_security_group.WEBSGTR.id}"]


	user_data = <<-EOF
		#!/bin/bash
		sudo yum -y install httpd strace sysstat mlocate
		sudo echo "Hello Auriel, Alexiel and Lisa..." >> /var/www/html/index.html
		sudo apachectl start
		sudo yum -y update
		sudo updatedb
		EOF

	lifecycle {
		create_before_destroy = true
	}


}

resource "aws_autoscaling_group" "Test_ASG" {
	launch_configuration 	= "${aws_launch_configuration.Test_ASG.id}"
	availability_zones 		= ["${data.aws_availability_zones.all.names}"]

	load_balancers 		= ["${aws_elb.example.name}"]
	health_check_type 	= "ELB"

	min_size = 2
	max_size = 3



tag {
	key 				= "Name"
	value 				= "Terraform_asg_Test"
	propagate_at_launch = true
}
	
}

#Security part use for both scaling and mono configuration
resource "aws_security_group" "WEBSGTR" {

		

		ingress {

			from_port 	= "${var.HTTP_PORT}"
			to_port 	= "${var.HTTP_PORT}"
			protocol 	= "TCP"
			cidr_blocks = ["0.0.0.0/0"]

		}	

		ingress {

			from_port 	= "${var.SSH_PORT}"
			to_port 	= "${var.SSH_PORT}"
			protocol 	= "TCP"
			cidr_blocks = ["${var.MY_IP}"]

		}

		egress {

			from_port 	= 0 
			to_port 	= 0
			protocol 	= "-1"
			cidr_blocks = ["0.0.0.0/0"]
		}

		lifecycle {
			create_before_destroy = true
		}

		tags {
			Name = "WEBSGTR"
	}	
	}		
