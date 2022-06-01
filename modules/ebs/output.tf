# Le output me permettra de mettre l'objet ou le resource en contact des autres
output "output_id_volume" {
  value = aws_ebs_volume.volume_ebs.id
}
