# Le output me permettra de mettre l'objet ou le resource en contact des autres
output "output_ec2_id" {
  value = aws_instance.myec2.id
}

output "output_ec2_aAZ" {
  value = aws_instance.myec2.availability_zone
}
