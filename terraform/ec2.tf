resource "aws_key_pair" "ansible-terra-key"{
    key_name = "ansible-terra-key"
    public_key = file("ansible-terra-key.pub")
}

resource "aws_default_vpc" "vpc" {
  
}

resource "aws_security_group" "ansible-sg" {
  name = "ansible-sg"
  vpc_id = aws_default_vpc.vpc.id
  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress{
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress{
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ansible-ec2" {
  key_name = aws_key_pair.ansible-terra-key.key_name
  for_each = {
    master= "ami-0198cdf7458a7a932" #Ubuntu
    worker1= "ami-0198cdf7458a7a932" #Ubuntu 
    worker2 = "ami-0b0b78dcacbab728f"
  }
  ami = each.value
  vpc_security_group_ids = [aws_security_group.ansible-sg.id]
  depends_on = [ aws_security_group.ansible-sg, aws_default_vpc.vpc, aws_key_pair.ansible-terra-key ]
  instance_type = "t3.micro"
  root_block_device {
    volume_size = 25
    volume_type = "gp3"
  }
}