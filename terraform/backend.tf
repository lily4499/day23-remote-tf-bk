terraform {
  backend "s3" {
    bucket         = "devops-terraform-state-liliane"
    key            = "infra/eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

