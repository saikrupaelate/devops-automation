provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "apache" {
  count         = 2
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t3.micro"
  key_name      = "krupa_keypair"

  tags = {
    Name = "apache-${count.index}"
  }
}

resource "aws_instance" "nginx" {
  count         = 2
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t3.micro"
  key_name      = "krupa_keypair"

  tags = {
    Name = "nginx-${count.index}"
  }
}

# ✅ FIXED: Correct output syntax (no nested .value[])
output "apache_ips" {
  value = aws_instance.apache[*].public_ip
}

output "nginx_ips" {
  value = aws_instance.nginx[*].public_ip
}