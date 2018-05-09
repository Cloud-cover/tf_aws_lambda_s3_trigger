
# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE S3 BUCKET FOR UPLOADING THE FILES
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "b" {
  bucket = "${var.bucket_name}"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE EXECUTION ROLE FOR THE LAMBDA FUNCTION
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.lambda_exec_role_name}"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_exec_role.json}"
}

data "aws_iam_policy_document" "lambda_exec_role" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# GIVE THE LAMBDA FUNCTION PERMISSIONS TO ACCESS THE S3 BUCKET
resource "aws_iam_role_policy" "iam_lambda_policy" {
  role   = "${aws_iam_role.lambda_exec_role.id}"
  policy = "${data.aws_iam_policy_document.access_s3_bucket.json}"
}

data "aws_iam_policy_document" "access_s3_bucket" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["${aws_s3_bucket.b.arn}/*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.b.arn}"]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE ACTUAL LAMBDA FUNCTION
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_lambda_function" "l" {
    function_name = "${var.lambda_name}"
    handler = "${var.lambda_handler}"
    runtime = "python2.7"
    filename = "${var.lambda_file}"
    source_code_hash = "${base64sha256(file("${var.lambda_file}"))}"
    timeout = "${var.lambda_timeout}"
    role = "${aws_iam_role.lambda_exec_role.arn}"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE MECHANISM FOR S3 TO INVOKE THE FUNCTION
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.l.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.b.arn}"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${aws_s3_bucket.b.id}"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.l.arn}"
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = "${var.bucket_file_suffix}"
  }
}
