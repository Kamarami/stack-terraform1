#tfvars variables are referenced here as empty strings
/* variable "AWS_ACCESS_KEY" {}

variable "AWS_SECRET_KEY" {}

variable "AWS_REGION" {
  default = "us-east-1"
} */

variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "private_keypair.pub"
}

variable "AMIS" {
  type = map(string)
  default = {
    #us-east-1 = "ami-13be557e"
    us-east-1 = "ami-08f3d892de259504d"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-844e0bf7"
  }
}

variable "subnets" {
  type = list(string)
  default = [
    "subnet-e7ed77b8",
    "subnet-2c2e0761",
    "subnet-979f32a6",
    "subnet-9625bbf0",
    "subnet-37a4c016",
    "subnet-6102516f"
  ]
}

variable "RDS_PASSWORD" {
  default = "Ofthesoul25"
}

variable "INSTANCE_USERNAME" {
  default = "mohamedxkamara@gmail.com"
}

variable "vpc_id" {
  default = "vpc-c15cf6bc"
}

variable "instance_type" {
  default = "t2.micro"
}

/* variable "ami" {
  default = "ami-0b5eea76982371e91"
} */

variable "ebs_volume_count" {
  default = 4
}

/* variable "db_name" {}

variable "db_hostname" {}

variable "db_username" {}

variable "db_password" {} */

# variable "database-instance-identifier" {
#   default = "database name"

# }
variable "db_snapshot_identifier" {
  # default = "arn:snapshot:wordpressdbclixx"
  default = "wpclixxdatabasemohamed"
  type    = string
}
variable "rdsname" {
  default = "clixxrds"
  type    = string
}

# variable "accounts"{
# type = map
# default {
#   dev="*account number*"
# }