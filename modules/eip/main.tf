resource "aws_eip" "my_eip" {
  # instance = aws_instance.myec2.id
  vpc = true

  # Je vais définir le local provisioner. C'est lui qui va nous permettre d'écrire un certain nombre de champ dans un fichier
  provisioner "local-exec" {
    command = "echo PUBLIC IP: ${aws_eip.my_eip.public_ip} >> ip_ec2.txt"
  }

  tags = {
    Name = "${var.maintainer}-eip"
  }
}
