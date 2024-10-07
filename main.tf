provider "aws" {
  region = "eu-north-1"  # Change this to your preferred AWS region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# S3 bucket for Elastic Beanstalk application versions
resource "aws_s3_bucket" "beanstalk_bucket" { 
  bucket = "my-eb-app-bucketfortesting"  # Ensure this is globally unique
}

# Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "eb_app" {
    name        = "my-eb-app"  # Name of the EB application
    description = "My Elastic Beanstalk Application"
}

# Elastic Beanstalk Application Version
resource "aws_elastic_beanstalk_application_version" "app_version" {
      name = "my-eb-app"
      application   = aws_elastic_beanstalk_application.eb_app.name  # Application reference
      bucket        = aws_s3_bucket.beanstalk_bucket.bucket
      key           = "app.zip"  # Ensure that this file is uploaded to the S3 bucket

}

# Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "eb_env" {
  name                = "my-eb-env"
  application         = aws_elastic_beanstalk_application.eb_app.name  # Reference the application
  //version_label       = aws_elastic_beanstalk_application_version.app_version.version_label  # Reference the version
  solution_stack_name = "64bit Amazon Linux 2 v3.4.9 running Python 3.8"  # Ensure the correct platform

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t3.micro"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }
}
