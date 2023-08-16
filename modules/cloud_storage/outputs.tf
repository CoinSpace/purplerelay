output "bucket_name" {
    value = "${var.project}-${var.region}-bucket-${var.environment}"
}