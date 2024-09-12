terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "stg/tokyo/terraform.tfstate"
    region = "ap-northeast-1"
  }
}