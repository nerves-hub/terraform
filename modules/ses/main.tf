# SES
resource "aws_ses_email_identity" "nerves_hub_send" {
  email = var.email_identity
}

resource "aws_iam_user" "ses_smtp_user" {
  name = var.user
}

resource "aws_iam_policy_attachment" "ses_sendmail" {
  name = aws_iam_user.ses_smtp_user.name
  policy_arn = aws_iam_policy.SendRawEmail.arn
}

resource "aws_iam_policy" "SendRawEmail" {
  name = var.policy_name
  policy = data.aws_iam_policy_document.ses_sendmail.json
}

data "aws_iam_policy_document" "ses_sendmail" {
  statement {
    effect = "Allow"
    actions = [
      "ses:SendRawEmail"
    ]
    resources = ["*"]
  }
}