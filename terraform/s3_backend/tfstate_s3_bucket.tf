module "s3_bucket_tfstate" {
  source = "github.com/terraform-yc-modules/terraform-yc-s3.git?ref=v1.0.0"

  bucket_name   = var.bucket_name
  force_destroy = false # prevent bucket deletion if it is not empty

  versioning = {
    enabled = true
  }

  lifecycle_rule = [
    {
      enabled = true
      id      = "delete old tfstate versions after 14 days" # i.e. rule description
      prefix  = ""                                          # empty string — for all objects
      noncurrent_version_expiration = {
        days = 14
      }
    },
  ]

}
