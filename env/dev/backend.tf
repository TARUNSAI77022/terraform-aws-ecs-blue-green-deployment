terraform {
  backend "s3" {
    bucket         = "terraform-state-inti-ruchi"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
