# ---------------------------------------------------------------------------------------------------------------------
# SETUP
# ---------------------------------------------------------------------------------------------------------------------
provider "aws" {
    region = "us-west-2"
}
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY


# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
# ---------------------------------------------------------------------------------------------------------------------

module "s3_lambda" {
  source = "./module"

  aws_region = "us-west-2"
  bucket_name = "6969-test-bucket"
  bucket_file_suffix = ".csv"
  lambda_exec_role_name = "lambda_exec_role"
  lambda_name = "test_lambda"
  lambda_handler = "lambda.lambda_handler"
  lambda_file = "lambda.py.zip"
  lambda_timeout = 60
}
