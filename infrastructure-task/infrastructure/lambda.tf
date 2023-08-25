// Zip up the lambda function source code
data "archive_file" "lambda" {
  type             = "zip"
  output_file_mode = "0444"
  source_file      = "viewer-request-lambda/index.js"
  output_path      = "viewer-request-lambda/deploy.zip"
}

// Create the lambda function using the code in the zip-file
resource "aws_lambda_function" "viewer_request_lambda" {
  filename         = "viewer-request-lambda/deploy.zip"
  function_name    = "viewer-request"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = "nodejs18.x"
  publish          = true
}

// The role that will be used to run our lambda function
resource "aws_iam_role" "lambda_role" {
  name               = "viewer-request-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_edge_runner.json
}

// Allows AWS the use the role on our behalf
// - in the test UI (lambda.amazonaws.com)
// - as a Lambda@Edge function in CloudFront (edgelambda.amazonaws.com)
data "aws_iam_policy_document" "lambda_edge_runner" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
    }
  }
}

// Allows the role to create and write to logs
data "aws_iam_policy_document" "lambda_log" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}

resource "aws_iam_policy" "lambda_log_policy" {
  name   = "viewer-request-lambda-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.lambda_log.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_log_policy.arn
}
