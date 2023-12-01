
resource "yandex_ydb_database_serverless" "database_tf_state_lock" {
  name      = var.tf_state_lock_database_name
  folder_id = var.folder_id

  deletion_protection = true
}
