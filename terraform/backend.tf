terraform {
  backend "s3" {
    bucket       = "shubham-terraform-state-cloud"
    key          = "portfolio-rag-assistant/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
