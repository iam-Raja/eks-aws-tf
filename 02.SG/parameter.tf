resource "aws_ssm_parameter" "sg_id_ingress" {
  name  = "/${var.project_name}/${var.environment}/sg_id_ingress"
  type  = "String"
  value = module.ingress.sg_id
}


resource "aws_ssm_parameter" "sg_id_nodes" {
  name  = "/${var.project_name}/${var.environment}/sg_id_nodes"
  type  = "String"
  value = module.nodes.sg_id
}


resource "aws_ssm_parameter" "sg_id_db" {
  name  = "/${var.project_name}/${var.environment}/sg_id_db"
  type  = "String"
  value = module.db.sg_id
}

resource "aws_ssm_parameter" "sg_id_bastion" {
  name  = "/${var.project_name}/${var.environment}/sg_id_bastion"
  type  = "String"
  value = module.bastion.sg_id
}

resource "aws_ssm_parameter" "sg_id_cluster" {
  name  = "/${var.project_name}/${var.environment}/sg_id_cluster"
  type  = "String"
  value = module.cluster.sg_id
}