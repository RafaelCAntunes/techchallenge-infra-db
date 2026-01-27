provider "aws" {
  region = var.aws_region
}

# Puxando outputs do workspace infra-k8s
data "terraform_remote_state" "eks" {
  backend = "remote"

  config = {
    organization = "techchallenge-lanchonete"
    workspaces = {
      name = "techchallenge-infra-k8s"
    }
  }
}

# Security Group do RDS
resource "aws_security_group" "rds_sg" {
  name        = "techchallenge-rds-sg"
  description = "Allow EKS cluster access to RDS"
  vpc_id      = data.terraform_remote_state.eks.outputs.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.eks.outputs.security_groups]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "techchallenge-rds-sg"
  }
}

resource "aws_security_group_rule" "allow_eks_nodes_to_rds" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"

  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = var.eks_node_group_sg_id
}

resource "aws_security_group_rule" "allow_eks_nodes_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"

  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = data.terraform_remote_state.eks.outputs.security_groups
}

# Subnet group do RDS (usando subnets privadas do EKS)
resource "aws_db_subnet_group" "rds_subnets" {
  name       = "techchallenge-db-subnets"
  subnet_ids = data.terraform_remote_state.eks.outputs.subnet_ids

  tags = {
    Name = "techchallenge-db-subnets"
  }
}

# Instância RDS MySQL
resource "aws_db_instance" "mysql" {
  identifier              = "techchallenge-mysql"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.rds_subnets.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = false
  backup_retention_period = 0

  tags = {
    Name = "techchallenge-mysql"
  }
}
