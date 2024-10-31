resource "aws_cloudwatch_event_rule" "scheduler" {
  name                = "currency-exchange-scheduler"
  description         = "Trigger the currency exchange state machine every 3 minutes"
  schedule_expression = "rate(3 minutes)"
}

resource "aws_cloudwatch_event_target" "target_state_machine" {
  rule      = aws_cloudwatch_event_rule.scheduler.name
  target_id = "CurrencyExchangeStateMachine"
  arn       = aws_sfn_state_machine.currency_exchange_state_machine.arn
  role_arn  = aws_iam_role.state_machine_role.arn
}
