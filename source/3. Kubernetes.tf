// 삭제해야할 인스턴스, eip를 정의
// 당일 사용 완료 시, 모두 주석처리 후 apply
// eip master_node 갯수만큼 생성 및 master_node 인스턴스에만 부착하는 조건문 만들기
// TODO: 인스턴스 생성되어 의존성 있을 때, init > apply하면 VPC 새로 생성되는지 test

# resource "aws_eip" "kjh-eip" {
#  for_each = {
#     for name, value in var.kubernetes : name => value
#     if value.used_eip
#   }
#     tags = each.value["tags"]
# }

# resource "aws_eip_association" "kjh-eip-kub-m" {
#   for_each = {
#     for name, value in var.kubernetes : name => value
#     if value.used_eip
#   }
#   instance_id = aws_instance.kjh-terr-kub[each.key].id 
#   allocation_id = aws_eip.kjh-eip[each.key].id
# }

# resource "aws_instance" "kjh-terr-kub" {
#   for_each = var.kubernetes
#   tags = each.value["tags"]
#   ami                    = "ami-0462a914135d20297" //최신 AWS ami받아오는 코드 찾아보기
#   instance_type          = "t2.micro"
#   key_name               = "kjh-key"
#   //subnet_id              = aws_subnet.kjh-subnet-test1.id //네트워크인터페이스 지정 시, 사용 불가
#   //vpc_security_group_ids = [aws_security_group.kjh-sg.id]  //네트워크인터페이스 지정 시, 사용 불가
#   //count = 2

#   network_interface {
#     network_interface_id = aws_network_interface.my_net_1[each.key].id
#     device_index         = 0
#   }
#   root_block_device {
#     volume_type           = "gp2"
#     volume_size           = 30
#     delete_on_termination = true
#     tags = {
#       Name = "kjh_block"
#     }
#   }
# }


