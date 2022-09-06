
module "project1-ec2" {
  source = "../modules/ec2"
  ami_id=var.p1_ami_id
  instance_type=var.p1_instance_type
  ec2_name=var.p1_ec2_name
}

