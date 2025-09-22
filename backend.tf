terraform {
  backend "s3" {
    bucket       = "my-terraform-state-bucket-300301"
    key          = "lock"
    use_lockfile = true
    region       = "us-east-1"
    encrypt      = true
  }
}
