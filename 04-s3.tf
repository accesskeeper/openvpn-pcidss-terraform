resource "aws_kms_key" "s3-vpn" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "companypci-vpn" {
  bucket = "companypci-vpn"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.s3-vpn.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}	


resource "aws_s3_bucket" "companypci-vpn-access" {
  bucket = "companypci-vpn-access"
  acl    = "private"
}

#  server_side_encryption_configuration {
#    rule {
#      apply_server_side_encryption_by_default {
#        kms_master_key_id = aws_kms_key.s3-vpn.arn
#        sse_algorithm     = "aws:kms"
#      }
#    }
#  }

