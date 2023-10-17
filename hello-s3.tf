# A simple "Hello world" example for using deploying IONOS S3 with Terraform.

# you will need to export the secret values in your shell before running this
# script
# export TF_VAR_s3_access_key=xxx
# export TF_VAR_s3_secret_key=xxx
variable "s3_access_key" {}
variable "s3_secret_key" {}

# IONOS does not provide a ionos cloud specific s3 provider. We use the aws s3
# provider with IONOS s3. The best practice is to use a specific known to work
# version of the aws provider. The aws provider is updated very often and this
# configuration may not work out-of-the-box with the latest providers
terraform {
  required_providers {
    ionoscloud = {
      source = "ionos-cloud/ionoscloud"
      version = "= 6.4.9" 
    }

    # define the aws provider source and version.
    aws = {
      source  = "hashicorp/aws"
      version = "5.21.0"  # Replace with your desired version or use version constraints
    }
  }
}

# Configure the AWS Provider for IONOS S3
provider "aws" {
  # region needs to be "de" for frankfurt and "eu-central-2" for Berlin
  region                      = "de"
  # see above how to set these in the shell
  access_key                  = var.s3_access_key
  secret_key                  = var.s3_secret_key
  skip_region_validation      = true
  skip_metadata_api_check     = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    # 1 = Frankfurt, 2 Berlin
    s3       = "https://s3-eu-central-1.ionoscloud.com"
  }
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "mybucket-1947438"
}

resource "aws_s3_object" "myobject" {
  bucket = aws_s3_bucket.mybucket.bucket
  # key is the name of the object in the S3 storage
  key    = "testfile.txt"
  source = "/home/mnylund/testfile.txt"
}

