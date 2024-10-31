resource "aws_iam_role" "lambda_role" {
  name_prefix        = "role-currency-lambdas-"
  assume_role_policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "sts:AssumeRole"
                ],
                "Principal": {
                    "Service": [
                        "lambda.amazonaws.com"
                    ]
                }
            }
        ]
    }
    EOF
}

data "aws_iam_policy_document" "s3_document" {
  statement {

    actions = ["s3:PutObject"]

    resources = [
      "${aws_s3_bucket.data_bucket.arn}/*",
    ]
  }
}

data "aws_iam_policy_document" "cw_document" {
  statement {

    actions = ["logs:CreateLogGroup"]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
    ]
  }

  statement {

    actions = ["logs:CreateLogStream", "logs:PutLogEvents"]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:*:*"
    ]
  }
}

resource "aws_iam_policy" "s3_policy" {
  name_prefix = "s3-policy-currency-lambda-"
  policy      = data.aws_iam_policy_document.s3_document.json
}


resource "aws_iam_policy" "cw_policy" {
  name_prefix = "cw-policy-currency-lambda-"
  policy      = data.aws_iam_policy_document.cw_document.json
}

resource "aws_iam_role_policy_attachment" "lambda_s3_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_cw_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.cw_policy.arn
}

/*
IAM for State Machine
*/

data "aws_iam_policy_document" "state_machine_role_policy_doc" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "state_machine_role" {
  name               = "${var.state_machine_name}-role"
  assume_role_policy = data.aws_iam_policy_document.state_machine_role_policy_doc.json
}


data "aws_iam_policy_document" "state_machine_lambda_policy_doc" {
  statement {
    effect = "Allow"

    actions = ["lambda:InvokeFunction"]

    resources = ["arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${var.transform_lambda}:*",
      "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${var.extract_lambda}:*",
      "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${var.load_lambda}:*",
      "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${var.transform_lambda}",
      "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${var.extract_lambda}",
    "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${var.load_lambda}"]
  }
}

resource "aws_iam_policy" "state_machine_lambda_policy" {
  name_prefix = "${var.state_machine_name}-lambda-policy"
  policy      = data.aws_iam_policy_document.state_machine_lambda_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "state_machine_lambda_policy_attachment" {
  role       = aws_iam_role.state_machine_role.name
  policy_arn = aws_iam_policy.state_machine_lambda_policy.arn
}

/*
IAM for EventBridge
*/

data "aws_iam_policy_document" "eventbridge_role_policy_doc" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eventbridge_role" {
  name               = "${aws_cloudwatch_event_rule.scheduler.name}-role"
  assume_role_policy = data.aws_iam_policy_document.eventbridge_role_policy_doc.json
}


data "aws_iam_policy_document" "eventbridge_state_machine_policy_doc" {
  statement {
    effect = "Allow"

    actions = ["states:StartExecution"]

    resources = ["arn:aws:states:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:stateMachine:${var.state_machine_name}"]
  }
}

resource "aws_iam_policy" "eventbridge_state_machine_policy" {
  name_prefix = "${aws_cloudwatch_event_rule.scheduler.name}-state-machine-policy"
  policy      = data.aws_iam_policy_document.state_machine_lambda_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "eventbridge_state_machine_policy_attachment" {
  role       = aws_iam_role.eventbridge_role.name
  policy_arn = aws_iam_policy.eventbridge_state_machine_policy.arn
}
