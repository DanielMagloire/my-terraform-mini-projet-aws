resource "aws_ebs_volume" "volume_ebs" {
  availability_zone = var.AZ
  size              = var.disk_size

  tags = {
    Name = "${var.maintainer}-ebs"
  }
}
