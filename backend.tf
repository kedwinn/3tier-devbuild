terraform {
  backend "s3" {
    bucket = "terraform-state-files-jjtech"
    key = "jjtech-modules.tfstate"
    region = "us-west-2"
    profile = "default"
    dynamodb_table = "jjtechtfstatetable"
  }
}