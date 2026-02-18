terraform {
  backend "s3" {
    bucket         = "vinay-terraform-state"
    key            = "three-tier-app/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
