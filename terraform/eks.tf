module "eks" {

  source = "terraform-aws-modules/eks/aws"

  version = "~> 20.0"

  cluster_name = var.cluster_name

  cluster_version = "1.31"
  enable_irsa     = true
  subnet_ids      = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      most_recent = true

      service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
    }
  }

  eks_managed_node_groups = {
    main = {

      instance_types = [var.node_instance_type]

      min_size     = var.min_size
      max_size     = var.max_size
      desired_size = var.desired_size
    }
  }
}