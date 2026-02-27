path "otus/data/cred/*" {
  capabilities = ["read"]
}

# Доступ к метаданным (чтобы работал список/list)
path "otus/metadata/cred/*" {
  capabilities = ["list"]
}