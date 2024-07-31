provider "aws" {
region = "us-east-1"
}
variable "keyname1" {
type = string
}
terraform {

 backend "s3" {
   region = "us-east-1"
   bucket = "tfstatents26"
    dynamodb_table = "tflocknts26"  
     key = "tfec2.tfstate"
     }
     }
resource "tls_private_key" "rsa26" {
algorithm = "RSA"
rsa_bits = 4096

}
resource "aws_key_pair" "tfec2-key-pair" {
key_name = var.keyname1
public_key = tls_private_key.rsa.public_key_openssh
}
resource "local_file" "tfec2-key" {

content = tls_private_key.rsa.private_key_pem

filename = var.keyname

}

resource "aws_instance" "web-server26" {
 ami      = "ami-0a0e5d9c7acc336f1"
 instance_type = "t2.micro"
 key_name   = var.keyname1
 provisioner "remote-exec" {

   inline = [
  "sudo apt-get update",
		"sudo apt-get update",
		"sudo apt install -y apache2",
		"sudo chmod -R 777 /var/lib/www/html/" 
  ]

  }
 provisioner "file" {
  source   = "index.html"
  destination = "/var/lib/www/html/index.html"
 }
 connection {
  user    = "ubuntu"
  private_key = "${file(local_file.tf-key.filename)}"
  host = "${aws_instance.web-server.public_ip}"
 }
}

