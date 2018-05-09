# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "aws_region" {
  description = "The AWS region to deploy into (e.g. us-east-1)."
}

variable "bucket_name" {
  description = "The AWS bucket name where we are going to read/write files."
}

variable "bucket_file_suffix" {
  description = "The suffix of the file that triggers the lambda function execution."
}

variable "lambda_exec_role_name" {
  description = "The name of the exec role for the lambda function."
}

variable "lambda_name" {
  description = "The name of the lambda function."
}

variable "lambda_handler" {
  description = "The name of the handler function or entry point for the lambda function."
}

variable "lambda_file" {
  description = "The name of the zip file containing the lamda function and its runtime."
}

variable "lambda_timeout" {
  description = "The number of seconds lambda function allowed to run before timeout."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
