terraform{
  backend "s3"{
    bucket= "stackbuckstatemohamed1"
    key = "terraform.tfstate"
    region="us-east-1"
    dynamodb_table="statelock-tf"
  }
}