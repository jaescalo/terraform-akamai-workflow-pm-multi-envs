terraform {
  required_providers {
    akamai = {
      source  = "akamai/akamai"
      version = "~>10.0"
    }
    linode = {
      source  = "linode/linode"
      version = "= 2.23.0"
    }
  }
  required_version = "~> 1.12"
  # Linode S3 is our remote backend and we'll pass the configuration parameters with 
  # the TF "-backend-config" flag as this block doesn't allow the use of variables. 
  # See the ./github/workflows/akamai_pm.yaml.
  backend "s3" {}
}