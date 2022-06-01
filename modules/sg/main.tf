resource "aws_security_group" "allow_ssh_http_https" {
  name        = "${var.maintainer}-sg"
  description = "allow http, https and ssh inbound traffic"
  # J'ajoute les règles entrantes (http, https, ssh)
  ingress {
    description = "https from all"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http from all"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Jajoute l'ingress pour le ssh
  ingress {
    description = "ssh from all"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # J'ajoute une règle sortante 
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.maintainer}-sg"
  }
}
