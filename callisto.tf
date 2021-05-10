provider "aws" {
  region = "us-west-2"

}





## Create VPC ## 

resource "aws_vpc" "callisto_vpc" {

  cidr_block = "172.16.0.0/16"

  enable_dns_hostnames = true

  tags = {

    Name = "callisto-demo-vpc"

  }

}





output "aws_vpc_id" {

  value = aws_vpc.callisto_vpc.id

}





## Create Subnets ## 

resource "aws_subnet" "callisto-subnet_1" {

  vpc_id = aws_vpc.callisto_vpc.id

  cidr_block = "172.16.10.0/24"

  availability_zone = "us-west-2a"





  tags = {

    Name = "callisto-subnet_1"

  }

}





output "aws_subnet_subnet_1" {

  value = aws_subnet.callisto-subnet_1.id

}





## Security Group## 

resource "aws_security_group" "callisto_private_sg" {

  description = "Allow limited inbound external traffic"

  vpc_id = aws_vpc.callisto_vpc.id

  name = "terraform_ec2_private_sg"





  ingress {

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

    from_port = 22

    to_port = 22

  }





  ingress {

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

    from_port = 8080

    to_port = 8080

  }





  ingress {

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

    from_port = 443

    to_port = 443

  }





  egress {

    protocol = -1

    cidr_blocks = ["0.0.0.0/0"]

    from_port = 0

    to_port = 0

  }





  tags = {

    Name = "ec2-private-sg"

  }

}





output "aws_security_gr_id" {

  value = aws_security_group.callisto_private_sg.id

}





resource "aws_instance" "callisto-ec2" {

  ami = "ami-0cf6f5c8a62fa5da6"

  instance_type = "t2.micro"

  vpc_security_group_ids = ["${aws_security_group.callisto_private_sg.id}"]

  subnet_id = aws_subnet.callisto-subnet_1.id

  key_name = "callisto"

  count = 1

  associate_public_ip_address = true

  tags = {

    Name = "callisto_ec2"

    Environment = "development"

  }

}





output "instance_id_list" {
  value = ["${aws_instance.callisto-ec2[0].id}"]
}






