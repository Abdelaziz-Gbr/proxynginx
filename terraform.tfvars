public_subnet_cidr       = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
vpc_cidr                 = "10.0.0.0/16"
internet_gw_name         = "main-igw"
route_table_name         = "main-rt"
instance_type            = "t2.micro"
key_name                 = "aws-key"
private_instance         = ["no", "no", "yes", "yes"]
availability_zones       = ["us-east-1a", "us-east-1b", "us-east-1a", "us-east-1b"]