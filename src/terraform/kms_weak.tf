# Intentionally vulnerable: AWS infra with crypto that fails CNSA 2.0 / NIST SP 800-131A.

resource "aws_kms_key" "weak_key" {
  description              = "RSA-2048 — fails CNSA 2.0 (requires >= 3072)"
  customer_master_key_spec = "RSA_2048"
  key_usage                = "ENCRYPT_DECRYPT"
}

resource "aws_kms_key" "compliant_key" {
  description              = "RSA-4096 — review against CNSA 2.0 + quantum readiness"
  customer_master_key_spec = "RSA_4096"
  key_usage                = "ENCRYPT_DECRYPT"
}

resource "tls_private_key" "rsa_2048" {
  algorithm = "RSA"
  rsa_bits  = 2048    # below CNSA 2.0 minimum
}

resource "tls_private_key" "ecdsa_p256" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"    # CNSA 2.0 requires P-384
}

# Deprecated TLS policy
resource "aws_lb_listener" "tls_listener" {
  load_balancer_arn = "arn:aws:elasticloadbalancing:us-east-1:123:loadbalancer/app/example/abc"
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
}

# RSA-2048 ACM certificate
resource "aws_acm_certificate" "weak_cert" {
  domain_name       = "example.com"
  validation_method = "DNS"
  key_algorithm     = "RSA_2048"
}

# CloudFront still allowing TLS 1.1
resource "aws_cloudfront_distribution" "legacy" {
  viewer_certificate {
    minimum_protocol_version = "TLSv1.1_2016"
  }
}

# IAM server certificate upload — content unknown to terraform
resource "aws_iam_server_certificate" "uploaded" {
  name             = "uploaded-cert"
  certificate_body = file("cert.pem")
  private_key      = file("key.pem")
}
