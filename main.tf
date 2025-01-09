resource "aws_iam_role" "firehose_role" {
  name = "firehose_delivery_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "firehose.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "firehose_s3_full_access" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
resource "aws_iam_role_policy_attachment" "firehose_firehose_full_access" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFirehoseFullAccess"
}
resource "aws_iam_role_policy_attachment" "firehose_kinesis_full_access" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFullAccess"
}

resource "aws_kinesis_stream" "stream" {
  name = "data-stream-client-info"
  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }
}

resource "aws_kinesis_firehose_delivery_stream" "name" {
  name = "data-stream-client-info"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn = aws_iam_role.firehose_role.arn
    bucket_arn = "arn:aws:s3:::client-data-1245129587481585"

    prefix = "logs/"
    error_output_prefix = "error/"

    processing_configuration {
      enabled = "true"
      processors {
        type = "AppendDelimiterToRecord"
        
      }
    }
  }

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.stream.arn
    role_arn = aws_iam_role.firehose_role.arn
  }
}

resource "aws_glue_crawler" "crawler" {
  database_name = "client-actions-db"
  name = "client-crawler"
  role = "arn:aws:iam::585768182923:role/glue-crawler-role"
  s3_target {
    path = "s3://client-data-1245129587481585/"
  }
}
