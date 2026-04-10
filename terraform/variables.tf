// Contain all the input variables

variable "region" {
  default = "ap-southeast-1"
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_engine" {
  default = "postgres"
}

variable "db_engine_version" {
  default = "15"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "db_name" {
  default = "fullstack_app"
}
variable "db_port" {
  default = 5432
}
variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
  default     = "lab3"
}