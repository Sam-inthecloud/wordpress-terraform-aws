# Variables
variable "ami_id" {
  description = "The ID of the AMI for the EC2 instance"
  default     = "ami-0a0edaad9092f8016"  # Specify the default AMI ID
}

variable "key_name" {
  description = "The name of the EC2 key pair"
  default     = "wordpress-key-pair"  # Specify the default key pair name
}

variable "db_username" {
  description = "The username for the MySQL database"
  default     = "admin"  # Specify the default database username
}

variable "db_password" {
  description = "The password for the MySQL database"
  default     = "testrundb"  # Specify the default database password
}