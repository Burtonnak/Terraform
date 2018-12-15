#All Variable are in this file, easy to check, easy to find

variable "HTTP_PORT" {

		description = "The port use be http server by default"
		type 		= "string"
		default 	= "80"
}

variable "SSH_PORT" {

		description = "The port use be SSH server by default"
		type 		= "string"
		default 	= "22"
}

variable "MY_IP" {
	
	description = "My Private IP Address"
	type 		= "string"
	default 	= "194.182.125.248/32"
}