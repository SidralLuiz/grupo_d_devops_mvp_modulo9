output "vpc_id" {
    value = aws_vpc.grupo_d_vpc.id
}

output "sn_pub01" {
    value = aws_subnet.sn_pub01.id
}
