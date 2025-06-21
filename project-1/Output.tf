output "instance_public_ip" {
  value = aws_instance.dev.public_ip

}

output "instance_id" {
  value = aws_instance.dev.id
}
