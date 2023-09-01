/*
resource "aws_key_pair" "kjh-test-key" {
  key_name = "kjh-test-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCCgP0uJk7oPboQvcybRb2d3b7Ow+VQxxZeN+jdhQda/pSTKWQR4VHDwXQYBj61v9bt6/FhvYBxgejxit7uBa3CaBQqNj2cfcquWRFtoFZmzzXW2c5i2WVuIG6CeU8HUdc+f5SDxnYzzXrpBY9saiKGIqoOpiDwXloLF5206m5PnmRrZrk8W5FWYpte6syfs/rFhZFrq3mw+81o7nIgxG3rmJhiquJALKxflytBJuam8MOt2zo9sacmWbhhStzgngkwhla5bjnaNT19utzeILtmbddda9Foopnqrd/ICn69aOvxMykta58vThdQujyqaCDlfnuiocqBcUrswz1WKT6l kjh-key"
}
*/

/*
data "aws_vpc" "target" {
  count = length(data.aws_vpcs.vpcs.ids)
  id    = tolist(data.aws_vpcs.vpcs.ids)[count.index]
}

# sample code using vpc_id
resource "aws_lb_target_group" "sample_resource" {
  count = length(data.aws_vpcs.vpcs.ids)
  # Skip Config
  vpc_id      = data.aws_vpc.target[count.index].id
}
*/

# VPC / Subnet / SG 등 리소스 별로 .tf 파일 구분
# 인스턴스처럼 비용나오는 서비스만 주석처리 후 apply

resource "aws_vpc" "kjh-vpc-terr" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "kjh-terr-vpc"
  }
}
resource "aws_subnet" "kjh-subnet-test1" {
  vpc_id            = aws_vpc.kjh-vpc-terr.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "kjh-terr-public"
  }
}
resource "aws_security_group" "kjh-sg" {
  name        = "kjh-sg"
  description = "kjh-sg"
  tags = {
    Name = "kjh-terr-sg"
  }
  vpc_id      = aws_vpc.kjh-vpc-terr.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// NIC for each로 각각 생성 할수있나?
resource "aws_network_interface" "my_net_1" {
  for_each        = var.kubernetes
  subnet_id       = aws_subnet.kjh-subnet-test1.id
  private_ips     = [each.value["ips"]]
  security_groups = [aws_security_group.kjh-sg.id]
  tags            = each.value["tags"]
}

resource "aws_internet_gateway" "kjh-igw" {
  vpc_id = aws_vpc.kjh-vpc-terr.id
  tags = {
    Name = "kjh-ig-test"
  }
}

resource "aws_route_table" "route_table_public_1" {
  vpc_id = aws_vpc.kjh-vpc-terr.id
  tags = {
    Name = "main-public-1"
  }
}

resource "aws_route" "mydefaultroute" {
  route_table_id         = aws_route_table.route_table_public_1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.kjh-igw.id
}

resource "aws_route_table_association" "route_table_association_1" {
  subnet_id      = aws_subnet.kjh-subnet-test1.id
  route_table_id = aws_route_table.route_table_public_1.id
}

//인스턴스

# resource "aws_instance" "kjh-terr" {
#   tags = {
#     Name = "kjh-terr"
#   }
#   ami                    = "ami-0462a914135d20297" //최신 AWS ami받아오는 코드 찾아보기
#   instance_type          = "t2.micro"
#   key_name               = "kjh-key"
#   //subnet_id              = aws_subnet.kjh-subnet-test1.id //네트워크인터페이스 지정 시, 사용 불가
#   //vpc_security_group_ids = [aws_security_group.kjh-sg.id]  //네트워크인터페이스 지정 시, 사용 불가
#   //count = 2
#   network_interface {
#     network_interface_id = aws_network_interface.my_net.id
#     device_index         = 0
#   }
#   root_block_device {
#     volume_type           = "gp2"
#     volume_size           = 10
#     delete_on_termination = true
#     tags = {
#       Name = "kjh_block"
#     }
#   }
# }