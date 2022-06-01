data "aws_ami" "my_ami_ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "myec2" {
  ami               = data.aws_ami.my_ami_ubuntu.id
  instance_type     = var.instance_type
  key_name          = var.ssh_key
  availability_zone = var.AZ
  #tags            = var.aws_commun_tag
  security_groups = ["${var.allow_ssh_http_https}"]

  tags = {
    Name = "${var.maintainer}-ec2"
  }

  # root_block_device {
  #   delete_on_termination = true
  # }

  # Je vais définir le local provisioner. C'est lui qui va nous permettre d'écrire un certain nombre de champ dans un fichier
  /* provisioner "local-exec" {
    command = "echo PUBLIC IP: ${aws_instance.myec2.public_ip} ; ID: ${aws_instance.myec2.id} ; AZ: ${aws_instance.myec2.availability_zone} >> ip_ec2.txt"
  } */

  # Je vais ajouter le remote provisioner pour installer Ngnix
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]

    connection {
      type        = "ssh"
      user        = var.user
      private_key = file("C:/Users/Anastasie THOUMINE/Documents/key_ssh/${var.ssh_key}.pem")
      host        = self.public_ip
    }
  }
}
