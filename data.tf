#Variable declartion for bootstrap
data "template_file" "bootstrap"{
  template      = file(format("%s/scripts/clixx_bootstrap", path.module))
  vars          = {
  efs_id        = "${aws_efs_file_system.clixxefs.id}"
  lb_dns_name   = "${aws_lb.clixx-lb.dns_name}"
  db_username   = local.wp_creds.db_username
  db_password   = local.wp_creds.db_password
  db_hostname   = local.wp_creds.db_hostname
  db_name       = local.wp_creds.db_name
  MOUNT_POINT   = "/var/www/html"
  REGION        = local.wp_creds.region
  ami           = local.wp_creds.ami
  }
}

#RDS Database Snapshot
data "aws_db_snapshot" "latestsnapshot" {
  db_snapshot_identifier = var.db_snapshot_identifier
  most_recent            = true
  # snapshot_type          = "manual"
}

data "aws_secretsmanager_secret_version" "wp_creds" {
# Fill in the name you gave to your secret
 secret_id = "clixxcreds"
}

/* data "aws_secretsmanager_secret" "clixx-cred" {
# Fill in the name you gave to your secret
 name = "clixxcreds"
 arn = "arn:aws:secretsmanager:us-east-1:597529641504:secret:clixxcreds-rwnBCK"
} */


locals {
  /* current_account_id = data.aws_caller_identity.current.account_id
  launch_template_name = local.current_account_id == local.clixx_creds.auto_account_number ? "multi-az-clixx-auto" : "unknown" */

  clixx_creds = jsondecode(
    data.aws_secretsmanager_secret_version.clixxcreds.secret_string
  )

  aws_provider_config = {
    region     = local.clixx_creds.AWS_REGION
    access_key = local.clixx_creds.AWS_ACCESS_KEY
    secret_key = local.clixx_creds.AWS_SECRET_KEY
  }
}