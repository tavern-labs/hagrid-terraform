terraform {
  backend "s3" {
    bucket       = "tfstate-tavernlabs-03711579496081468369"
    key          = "okta/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true 
  }
}