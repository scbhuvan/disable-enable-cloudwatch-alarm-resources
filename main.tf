provider "aws" {
  region = "eu-west-2"  # Set your desired AWS region
}

resource "aws_lambda_function" "manage_alarms" {
  function_name    = "ManageCloudWatchAlarms"
  filename         = data.archive_file.my_lambda_function.output_path
  source_code_hash = data.archive_file.my_lambda_function.output_base64sha256
  handler          = "lambda.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60
  role             = aws_iam_role.lambda_execution_role.arn

  environment {
    variables = {
      ALARM_NAMES = jsonencode(var.cloudwatch_alarm_names)
    }
  }
}

data "archive_file" "my_lambda_function" {
  source_file  = "${path.module}/functions/lambda.py"
  output_path = "${path.module}/functions/lambda.py.zip"
  type        = "zip"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_enable" {
  statement_id  = "AllowExecutionFromCloudWatch1"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.manage_alarms.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.enable_alarms.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_disable" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.manage_alarms.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.disable_alarms.arn
}



