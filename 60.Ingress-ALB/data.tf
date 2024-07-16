data "aws_ssm_parameter" "subnet_public" {
  name = "/${var.project_name}/${var.environment}/public_subnet_ids"
}

data "aws_ssm_parameter" "sg_id_ingress" {
  name = "/${var.project_name}/${var.environment}/sg_id_ingress"
}

data "aws_ssm_parameter" "acm_certificate_arn" {
  name = "/${var.project_name}/${var.environment}/acm_certificate_arn"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/VPC_ID"
}




