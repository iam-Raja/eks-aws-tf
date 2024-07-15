module "db"{
    source="git::https://github.com/iam-Raja/terraform-module-SG-Source.git?ref=main"
    project_name=var.project_name
    environment = var.environment
    sg_name="db"
    sg_description="sg is for db"
    vpc_id=data.aws_ssm_parameter.vpc_id.value
    common_tags=var.common_tags
}

module "ingress"{
    source="git::https://github.com/iam-Raja/terraform-module-SG-Source.git?ref=main"
    project_name=var.project_name
    environment = var.environment
    sg_name="ingress"
    sg_description="sg is for ingress"
    vpc_id=data.aws_ssm_parameter.vpc_id.value
    common_tags=var.common_tags
}

module "nodes"{
    source="git::https://github.com/iam-Raja/terraform-module-SG-Source.git?ref=main"
    project_name=var.project_name
    environment = var.environment
    sg_name="inodes"
    sg_description="sg is for inodes"
    vpc_id=data.aws_ssm_parameter.vpc_id.value
    common_tags=var.common_tags
}

module "cluster"{
    source="git::https://github.com/iam-Raja/terraform-module-SG-Source.git?ref=main"
    project_name=var.project_name
    environment = var.environment
    sg_name="cluster"
    sg_description="sg is for cluster"
    vpc_id=data.aws_ssm_parameter.vpc_id.value
    common_tags=var.common_tags
}

module "bastion"{
    source="git::https://github.com/iam-Raja/terraform-module-SG-Source.git?ref=main"
    project_name=var.project_name
    environment = var.environment
    sg_name="bastion"
    sg_description="sg is for bastion"
    vpc_id=data.aws_ssm_parameter.vpc_id.value
    common_tags=var.common_tags
}

module "vpn"{
    source="git::https://github.com/iam-Raja/terraform-module-SG-Source.git?ref=main"
    project_name=var.project_name
    environment = var.environment
    sg_name="vpn"
    sg_description="sg is for vpn"
    vpc_id=data.aws_ssm_parameter.vpc_id.value
    common_tags=var.common_tags
}
# Ingress sg is accepting traffic from public

resource "aws_security_group_rule" "Ingress_public_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = module.ingress.sg_id #to sg we were creating this rule
  cidr_blocks=["0.0.0.0/0"] ##from where traffic is coming
}

resource "aws_security_group_rule" "Ingress_public_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = module.ingress.sg_id #to sg we were creating this rule
  cidr_blocks=["0.0.0.0/0"] ##from where traffic is coming
}

# bastion sg is accepting traffic from public

resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = module.bastion.sg_id #to sg we were creating this rule
  cidr_blocks=["0.0.0.0/0"] ##from where traffic is coming
}

# cluster sg is accepting traffic from 


resource "aws_security_group_rule" "cluster_bastion" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = module.cluster.sg_id #to sg we were creating this rule
  source_security_group_id=module.bastion.sg_id ##from where traffic is coming
}

resource "aws_security_group_rule" "cluster_nodes" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1" #all traffic
  security_group_id = module.cluster.sg_id #to sg we were creating this rule
  source_security_group_id=module.nodes.sg_id ##from where traffic is coming
}

# db sg is accepting traffic from 


resource "aws_security_group_rule" "db_bastion" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = module.db.sg_id #to sg we were creating this rule
  source_security_group_id=module.bastion.sg_id ##from where traffic is coming
}

resource "aws_security_group_rule" "db_nodes" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = module.db.sg_id #to sg we were creating this rule
  source_security_group_id=module.nodes.sg_id ##from where traffic is coming
}

# node sg is accepting traffic from 


resource "aws_security_group_rule" "node_ingress" {
  type              = "ingress"
  from_port         = 30000
  to_port           = 32768
  protocol          = "tcp"
  security_group_id = module.nodes.sg_id #to sg we were creating this rule
  source_security_group_id=module.ingress.sg_id ##from where traffic is coming
}

resource "aws_security_group_rule" "node_cluster" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1" # All traffic
  source_security_group_id = module.cluster.sg_id
  security_group_id = module.nodes.sg_id
}

# EKS nodes should accept all traffic from nodes with in VPC CIDR range.
resource "aws_security_group_rule" "node_vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1" # All traffic
  cidr_blocks = ["10.0.0.0/16"]
  security_group_id = module.nodes.sg_id
}



