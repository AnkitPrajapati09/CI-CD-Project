terraform {
  backend "s3" {
    bucket       = "terraform-state-file-ci-cd-project"
    key          = "terraform/backend"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
