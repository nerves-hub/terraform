# SES
resource "aws_ses_email_identity" "nerves_hub_send" {
  email = var.email_identity
}

resource "aws_iam_user" "ses_smtp_user" {
  name = var.user
  tags = var.tags
}

resource "aws_iam_group" "ses_sendmail" {
  name = var.group_name
}

resource "aws_iam_user_group_membership" "ses_sendmail" {
  groups = [aws_iam_group.ses_sendmail.name]
  user   = aws_iam_user.ses_smtp_user.name
}

resource "aws_iam_group_policy_attachment" "ses_sendmail" {
  group      = aws_iam_group.ses_sendmail.name
  policy_arn = aws_iam_policy.SendRawEmail.arn
}

resource "aws_iam_policy" "SendRawEmail" {
  name   = var.policy_name
  policy = data.aws_iam_policy_document.ses_sendmail.json
}

data "aws_iam_policy_document" "ses_sendmail" {
  statement {
    effect = "Allow"
    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail"
    ]
    resources = [
      "*"
    ]
    condition {
      test     = "StringEquals"
      variable = "ses:FromAddress"
      values   = [var.email_identity]
    }
  }
}