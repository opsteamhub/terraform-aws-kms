output "kms_key" {
  value = aws_kms_key.k
}

output "kms_replica_key" {
  value = try(aws_kms_replica_key.k_replica, null)
}
