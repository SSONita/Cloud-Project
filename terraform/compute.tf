data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_launch_template" "app_template" {
  name_prefix   = "auth-app-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install -y git

curl -sL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

cd /home/ec2-user
git clone https://github.com/SSONita/Cloud-Project.git

cd /home/ec2-user/Cloud-Project/app/server
npm install

nohup npm start > /home/ec2-user/output.log 2>&1 &
EOF
  )

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }
}