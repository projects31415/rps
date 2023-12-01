resource "grafana_folder" "folder" {
  for_each = { for folder in var.folders : keys(folder)[0] => values(folder)[0] }

  title                        = each.value.title
  org_id                       = each.value.org_id
  prevent_destroy_if_not_empty = each.value.prevent_destroy_if_not_empty
  uid                          = each.value.uid
}
