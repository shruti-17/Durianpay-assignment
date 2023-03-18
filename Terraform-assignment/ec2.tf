resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # Change this to the ID of the AMI you want to use
  instance_type = "t2.medium"
  subnet_id     = "${aws_subnet.private.id}" 
  key_name      = "example-key" 

  tags = {
    Name = "example"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = "${aws_vpc.example.id}" 
  cidr_block = "10.0.1.0/24" # Change this to the CIDR block you want to use for your subnet
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16" 
}
