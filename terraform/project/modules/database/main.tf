data "aws_ami" "imagem_ec2" {
    most_recent = true
    owners = [ "amazon" ]
    filter {
      name = "name"
      values = [ "al2023-ami-2023.*-x86_64" ]
    }
}

resource "aws_security_group" "database_sg" {
    vpc_id = var.vpc_id
    name = "database_sg"
    tags = {
      Name = "database_sg"
    }
}

resource "aws_vpc_security_group_egress_rule" "egress_sg_rule" {
  security_group_id = aws_security_group.database_sg.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
} 

resource "aws_vpc_security_group_ingress_rule" "ingress_80_sg_rule" {
  security_group_id = aws_security_group.database_sg.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 5000
  to_port     = 5000
}
resource "aws_vpc_security_group_ingress_rule" "ingress_22_sg_rule" {
  security_group_id = aws_security_group.database_sg.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
}

resource "aws_instance" "backend_ec2" {
  instance_type = "t3.micro"
  ami = data.aws_ami.imagem_ec2.id
  subnet_id = var.sn_pub01
  vpc_security_group_ids = [ aws_security_group.database_sg.id ]
  key_name =  data.aws_key_pair.lb_ssh_key_pair_grupo_d.key_name

  associate_public_ip_address = true
  tags = {
    Name = "grupo_d-database"
  }
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install python3 python3-pip git -y
    sudo systemctl enable rc-local
    mkdir /proway
    echo '#!/bin/bash' > /opt/rc.proway
    echo "cd /proway" >> /opt/rc.proway
    echo "git init" >> /opt/rc.proway
    echo "git config core.sparseCheckout true" >> /opt/rc.proway
    echo "git checkout main && git pull origin main" >> /opt/rc.proway
    reboot
  EOF
}

# Criacao da chave SSH que sera usada para conexao na instancia
#resource "tls_private_key" "lb_ssh_key_grupo_d" {
#  algorithm = "RSA"
#  rsa_bits  = 4096
#

data "aws_key_pair" "lb_ssh_key_pair_grupo_d" {
  key_name   = "grupo_d_key_pare"
 # public_key = tls_private_key.lb_ssh_key_grupo_d.public_key_openssh
}
