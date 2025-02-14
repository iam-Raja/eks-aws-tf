data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/VPC_ID"
}

data "aws_ssm_parameter" "cluster_sg_id" {
  name = "/${var.project_name}/${var.environment}/sg_id_cluster"
}

data "aws_ssm_parameter" "node_sg_id" {
  name = "/${var.project_name}/${var.environment}/sg_id_nodes"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/private_subnet_ids"
}



data "aws_vpc" "default" {
  default = true
}