# Public Subnet에 부여할 CIDR 목록을 변수bool로 생성
variable "kubernetes" {
  type = map(object({
    ips  = string
    tags = map(string)
    used_eip = bool
  }))
  default = {
    "master1" = {
      ips = "10.0.0.10"
      tags = {
        "Name" = "kjh-kub-Master"
      }
      used_eip = true
    }
    "worker1" = {
      ips = "10.0.0.20"
      tags = {
        "Name" = "kjh-kub-Worker1"
      }
      used_eip = false
    }
    "worker2" = {
      ips = "10.0.0.30"
      tags = {
        "Name" = "kjh-kub-Worker2"
      }
      used_eip = false
    }
    "worker3" = {
      ips = "10.0.0.40"
      tags = {
        "Name" = "kjh-kub-Worker3"
      }
      used_eip = false
    }
  }
}

# resource "aws_iam_user" "for_each_set" {
#   for_each = toset(var.user_names)
#   name = each.key # each.key == each.value
# }
