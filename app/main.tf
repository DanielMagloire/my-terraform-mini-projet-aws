provider "aws" {
  region     = "us-east-1"
  access_key = "PASTE_YOUR_ACCESS_KEY_HERE"
  secret_key = "PASTE_YOUR_SECRET_KEY_HERE"
}

terraform {
  backend "s3" {
    bucket     = "terraform-backend-daniel"
    key        = "daniel-Bucket.tfstate"
    region     = "us-east-1"
    access_key = "PASTE_YOUR_ACCESS_KEY_HERE"
    secret_key = "PASTE_YOUR_SECRET_KEY_HERE"
  }
}

# Appel des modules pour les création et déploiement des resources sur aws

# Création SG
module "sg" {
  source = "../modules/sg"
}

# Création du volume ebs
module "ebs" {
  source    = "../modules/ebs"
  disk_size = 10
}

#Création de l'eip
module "eip" {
  source = "../modules/eip"
}

# Création de l'ec2
module "ec2" {
  source               = "../modules/ec2"
  instance_type        = "t2.micro"
  public_ip            = module.eip.output_eip
  allow_ssh_http_https = module.sg.output_allow_ssh_http_https
}

# Création des associations qui nous serons nécessaires
resource "aws_eip_association" "eip_assoc" {
  instance_id   = module.ec2.output_ec2_id
  allocation_id = module.eip.output_eip_id
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = module.ebs.output_id_volume
  instance_id = module.ec2.output_ec2_id
}
