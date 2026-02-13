provider "aws" {
  region = "us-east-1" 
}

resource "aws_security_group" "devops_sg" {
  name        = "devops-one-click-sg"
  description = "Inbound rules for DevOps Stack"

  # SSH, Jenkins, Kubernetes API, Prometheus, Grafana
  dynamic "ingress" {
    for_each = [22, 8080, 6443, 9090, 3000]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "devops_node" {
  ami           = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS
  instance_type = "t3.large" 
  key_name      = "your-key-pair-name" # <--- CHANGE THIS
  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  tags = { Name = "DevOps-Master-Node" }
}

output "instance_ip" {
  value = aws_instance.devops_node.public_ip
}
