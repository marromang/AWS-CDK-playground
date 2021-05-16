#Create the aws provide code. Find help at - https://registry.terraform.io/providers/hashicorp/aws/latest/docs
provider "aws" {
    region = "eu-west-1"
}

#Create the EC2 instance resource code. Find help at - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "terraform_101" {
    ami = "ami-063d4ab14480ac177"
    instance_type = "t2.micro"
    tags  = {
        Name = "terraform_101"
        environment = "dev"
        course = "Terraform 101"
    }
}
resource "aws_ebs_volume" "terraform_101" {
    availability_zone = "eu-west-1"
    size = 8
}

resource "aws_volume_attachment" "ebs_att" {
    device_name  = "/dev/sdh"
    volume_id = aws_ebs_volume.terraform_101.id
    instance_id = aws_instance.terraform_101.id
}

# terraform init
# terraform validate
# terraform plan
# terraform apply
# terraform destroy