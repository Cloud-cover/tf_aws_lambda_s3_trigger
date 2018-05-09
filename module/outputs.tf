output "s3_name" {
  value = "${var.bucket_name}"
}

output "s3_id" {
  value = "${aws_s3_bucket.b.id}"
}

output "s3_arn" {
  value = "${aws_s3_bucket.b.arn}"
}

output "lambda_exec_role_arn" {
  value = "${aws_iam_role.lambda_exec_role.arn}"
}

output "lambda_iam_role_policy_id" {
  value = "${aws_iam_role_policy.iam_lambda_policy.id}"
}

output "lambda_function_arn" {
  value = "${aws_lambda_function.l.arn}"
}
