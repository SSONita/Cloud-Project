data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}
resource "aws_launch_template" "app_template" {
  name_prefix   = "auth-app-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = base64encode(<<EOF
#!/bin/bash
set -xe

dnf update -y
dnf install -y git nodejs npm

cd /home/ec2-user

if [ ! -d "Cloud-Project" ]; then
  git clone https://github.com/SSONita/Cloud-Project.git
fi

cd /home/ec2-user/Cloud-Project/app/server

cat > .env <<EOT
PORT=3000
JWT_SECRET=supersecret
DB_HOST=${aws_db_instance.auth_db.address}
DB_PORT=${var.db_port}
DB_USER=${var.db_username}
DB_PASSWORD=${var.db_password}
DB_NAME=${var.db_name}
AWS_REGION=${var.region}
S3_BUCKET=${aws_s3_bucket.profile_bucket.bucket}
EOT

npm install
nohup npm start > /home/ec2-user/output.log 2>&1 &
EOF
  )

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }
}