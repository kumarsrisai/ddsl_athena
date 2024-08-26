provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "athena_bucket" {
    bucket = "athena-dummybucket-25"
}

resource "aws_s3_bucket" "destination_bucket" {
    bucket = "athena-destinationbucket"
}


resource "aws_athena_database" "athena_db"{
    name = "athena_dummy_dbb"
}

resource "aws_athena_workgroup" "athena_workgroup" {
  name = "athena_dummy_workgroup"
  configuration {
    result_configuration {
      output_location = "s3://${aws_s3_bucket.athena_bucket.bucket}/output/"
    }
  }
}

resource "aws_athena_named_query" "athena_query" {
    name = "create data table"
    database = aws_athena_database.athena_db.name
    query = <<EOT
    CREATE EXTERNAL TABLE IF NOT EXISTS example_table (
      id int,
      name string
    )
    ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
    WITH SERDEPROPERTIES (
      'serialization.format' = '1'
    )
    LOCATION 's3://${aws_s3_bucket.destination_bucket.bucket}/output/'
    TBLPROPERTIES ('has_encrypted_data'='false');
    EOT
    workgroup = aws_athena_workgroup.athena_workgroup.name
}
  