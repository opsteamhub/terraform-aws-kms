output "kms_key" {
  description = "Primary KMS key resources keyed by kms_config key."
  value       = aws_kms_key.k
}

output "kms_replica_key" {
  description = "Replica KMS key resources keyed by kms_config key, or null when no replicas are configured."
  value       = try(aws_kms_replica_key.k_replica, null)
}
