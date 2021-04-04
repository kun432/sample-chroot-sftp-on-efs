terraform {
  backend "s3" {
    bucket = "scp-chroot-example-tfstate"
    key    = "terraform.tfstate"
    region = "ap-northeast-1"
  }
}