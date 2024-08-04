resource "aws_cloudwatch_event_rule" "public_events_rule" {
  name        = "capture-aws-public-events"
  description = "Capture aws public events"

  event_pattern = jsonencode({
    source = [
      "aws.health"
    ]
    detail-type = [
      "AWS Health Event"
    ]
  })
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.public_events_rule.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.public_events_topic.arn
}

resource "aws_sns_topic" "public_events_topic" {
  name                        = "public_events"
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.public_events_topic.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.public_events_topic.arn]
  }
}

resource "aws_sns_topic_subscription" "public_events_subscription" {
  topic_arn = aws_sns_topic.public_events_topic.arn
  protocol  = "https"
  endpoint  = "https://chordsoft.org/api/push/aws"
}