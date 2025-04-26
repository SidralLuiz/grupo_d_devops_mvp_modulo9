data "aws_ami" "imagem_ec2" {
    most_recent = true
    owners = [ "amazon" ]
    filter {
      name = "name"
      values = [ "al2023-ami-2023.*-x86_64" ]
    }
}

data "aws_security_group" "grupo_d_sg" {
    id = sg-09a850394829737a4
}

resource "aws_instance" "backend_ec2" {
  instance_type = "t3.micro"
  ami = data.aws_ami.imagem_ec2.id
  subnet_id = var.sn_pub01
  vpc_security_group_ids = [ aws_security_group.grupo_d_backend_sg.id ]
  key_name = data.aws_key_pair.lb_ssh_key_pair_grupo_d.key_name
  associate_public_ip_address = true
  tags = {
    Name = "back-end_grupo-d"
  }
  
}

# Criacao da chave SSH que sera usada para conexao na instancia
#resource "tls_private_key" "lb_ssh_key_grupo_d" {
#  algorithm = "RSA"
#  rsa_bits  = 2048
#}
data "aws_key_pair" "lb_ssh_key_pair_grupo_d" {
  key_name   = "grupo_d_key_pare"
 # public_key = tls_private_key.lb_ssh_key_grupo_d.public_key_openssh
}
