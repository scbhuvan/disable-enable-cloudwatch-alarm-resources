resource "aws_cloudwatch_event_rule" "enable_alarms" {
  name                = "enable-alarms"
  schedule_expression = "cron(45 13 ? * MON-SAT *)" // At 11 PM from Monday to Saturday
}

resource "aws_cloudwatch_event_rule" "disable_alarms" {
  name                = "disable-alarms"
  schedule_expression = "cron(37 13 ? * MON-SAT *)" // At 9 PM from Monday to Saturday
}

resource "aws_cloudwatch_event_target" "enable_target" {
  rule      = aws_cloudwatch_event_rule.enable_alarms.name
  arn       = aws_lambda_function.manage_alarms.arn
  input     = jsonencode({"action": "enable"})
}

resource "aws_cloudwatch_event_target" "disable_target" {
  rule      = aws_cloudwatch_event_rule.disable_alarms.name
  arn       = aws_lambda_function.manage_alarms.arn
  input     = jsonencode({"action": "disable"})
}
