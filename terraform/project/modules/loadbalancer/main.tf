data "aws_ami" "imagem_ec2" {
    most_recent = true
    owners = [ "amazon" ]
    filter {
      name = "name"
      values = [ "al2023-ami-2023.*-x86_64" ]
    }
}


resource "aws_security_group" "grupo_d_nginx_sg" {
    vpc_id = var.vpc_id
    name = "grupo_d_nginx_sg"
    tags = {
      Name = "grupo_d-nginx_sg"
    }
}

resource "aws_vpc_security_group_egress_rule" "grupo_d_egress_sg_rule" {
  security_group_id = aws_security_group.grupo_d_nginx_sg.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
} 

resource "aws_vpc_security_group_ingress_rule" "grupo_d_ingress_80_sg_rule" {
  security_group_id = aws_security_group.grupo_d_nginx_sg.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
}
resource "aws_vpc_security_group_ingress_rule" "grupo_d_ingress_22_sg_rule" {
  security_group_id = aws_security_group.grupo_d_nginx_sg.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
}

resource "aws_network_interface" "grupo_d_nginx_ei" {
  subnet_id = var.sn_pub01
  tags = {
    Name = "grupo_d_nginx_pub"
  }
}

resource "aws_instance" "grupo_d_nginx_ec2" {
  instance_type = "t3.micro"
  ami = data.aws_ami.imagem_ec2.id
  subnet_id = var.sn_pub01
  vpc_security_group_ids = [ aws_security_group.grupo_d_nginx_sg.id ]
  key_name =  data.aws_key_pair.lb_ssh_key_pair_grupo_d.key_name
  associate_public_ip_address = true
  tags = {
    Name = "grupo_d-nginx_ec2"
  }

}

# Criacao da chave SSH que sera usada para conexao na instancia
#resource "tls_private_key" "lb_ssh_key" {
#  algorithm = "RSA"
#  rsa_bits  = 2048
#}
data "aws_key_pair" "lb_ssh_key_pair_grupo_d" {
  key_name   = "grupo_d_key_pare"
 # public_key = tls_private_key.lb_ssh_key.public_key_openssh
}
