locals {
  /* current_account_id = data.aws_caller_identity.current.account_id
  launch_template_name = local.current_account_id == local.clixx_creds.auto_account_number ? "multi-az-clixx-auto" : "unknown" */

  wp_creds = jsondecode(
    data.aws_secretsmanager_secret_version.wp_creds.secret_string
  )

  aws_provider_config = {
    region     = local.wp_creds.AWS_REGION
    access_key = local.wp_creds.AWS_ACCESS_KEY
    secret_key = local.wp_creds.AWS_SECRET_KEY
  }
}

#Variable declartion for bootstrap
data "template_file" "bootstrap"{
  template      = file(format("%s/scripts/clixx_bootstrap", path.module))
  vars          = {
  efs_id        = "${aws_efs_file_system.clixxefs.id}"
  lb_dns_name   = "${aws_lb.clixx-lb.dns_name}"
  db_username   = "${local.wp_creds.db_username}"
  db_password   = "${local.wp_creds.db_password}"
  db_hostname   = "${local.wp_creds.db_hostname}"
  db_name       = "${local.wp_creds.db_name}"
  MOUNT_POINT   = "/var/www/html"
  REGION        = "${local.wp_creds.AWS_REGION}"
  ami           = "${local.wp_creds.ami}"
  }
}


#RDS Database Snapshot
data "aws_db_snapshot" "latestsnapshot" {
  db_snapshot_identifier = local.wp_creds.database-snapshot-identifier
  most_recent            = true
  snapshot_type          = "manual"
}

data "aws_secretsmanager_secret_version" "wp_creds" {
#secret name
 secret_id = "clixxcreds"
}

data "aws_instances" "asg_instances" {
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = [aws_autoscaling_group.clixx-bastion-asg.name]
  }
}

data "aws_ami" "stack" {
  owners     = ["self"]
  name_regex = "^"

  filter {
    name   = "name"
    values = ["ami-stack-51"]
  }
}