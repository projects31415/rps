output "tf_state_lock_endpoint" {
  value = resource.yandex_ydb_database_serverless.database_tf_state_lock.document_api_endpoint
}
