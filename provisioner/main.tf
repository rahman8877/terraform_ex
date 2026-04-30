# 1. Provider Configuration
provider "aws" {
  region = "eu-north-1"
}

# 2. VPC Creation
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
}

# 3. Subnet Creation
resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true
}

# 4. Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

# 5. Route Table
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# 6. Route Table Association
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

# 7. Key Pair using your SSH key
resource "aws_key_pair" "rahman_key" {
  key_name   = "rahman-full-project-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# 8. Security Group
resource "aws_security_group" "webSg" {
  name   = "web-sg-full"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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

# 9. EC2 Instance (The final resource)
resource "aws_instance" "server" {
  ami                    = "ami-080254318c2d8932f" # Your AMI
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.rahman_key.key_name
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.sub1.id

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "app.py"
    destination = "/home/ubuntu/app.py"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Server is starting...'",
      "sudo apt update -y",
      "sudo apt install -y python3-pip python3-flask",
      "cd /home/ubuntu",
      "sudo nohup python3 app.py > /dev/null 2>&1 &",
      "sleep 5"
    ]
  }
}

output "public_ip" {
  value = aws_instance.server.public_ip
}