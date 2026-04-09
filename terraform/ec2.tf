resource "aws_key_pair" "deployer" {
  key_name   = "my-key-1"
  public_key = file("my-key.pub")
}

resource "aws_instance" "web" {
  ami           = "ami-0df7a207adb9748c7"
  instance_type = "t3.micro"

  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.deployer.key_name

  associate_public_ip_address = true

  tags = {
    Name = "web-server"
  }
}