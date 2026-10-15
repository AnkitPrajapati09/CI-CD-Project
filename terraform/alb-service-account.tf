resource "kubernetes_service_account" "aws_load_balancer_controller" {

  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"

    annotations = {
      "eks.amazonaws.com/role-arn" = module.alb_controller_irsa_role.iam_role_arn
    }
  }
}